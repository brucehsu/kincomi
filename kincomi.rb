require 'yaml'
require 'date'
require 'fileutils'
require 'open-uri'
require 'nokogiri'

F = 50

def show_url(item_id, cat_id)
  if [1,2,4,5,6,7,9,12,17,19,21,22].include?(cat_id)
    "http://new.comicvip.com/show/cool-#{item_id}.html"
  else
    "http://new.comicvip.com/show/best-manga-#{item_id}.html"
  end
end

def str_split_digit(str, start, count)
  str = str[start...(start+count)]
  result = ""
  str.each_char do |c|
    result += c if c=~/[0-9]/
  end
  result
end

def str_split(str, start, count)
  str[start...(start+count)]
end

def create_subkey(key, ch)
  subkey = ""
  (key.size/F).times do |i|
    if str_split_digit(key, i*F, 4) == ch
      subkey = str_split(key, i*F, F)
      break
    end
  end
  subkey = str_split_digit(key, key.size-F, F) if subkey.empty?
  subkey
end

def page_count(subkey)
  str_split_digit(subkey, 7, 3)
end

def img_url(subkey, item_id, page)
  server = str_split_digit(subkey, 4, 2)
  serial = str_split_digit(subkey, 6, 1)
  serial2 = str_split_digit(subkey, 0, 4)
  padded_page = page.to_s.rjust(3, '0')
  hash = str_split(subkey, img_hash(page) + 10, 3)
  "http://img#{server}.8comic.com/#{serial}/#{item_id}/#{serial2}/#{padded_page}_#{hash}.jpg"
end

def img_hash(page)
  n = page.to_i
  (((n - 1) / 10) % 10)+(((n-1)%10)*3)
end

CALIBRE_EBOOK_CONVERT_PATH = ""

ARGV.each do |comic_id|
  doc = Nokogiri::HTML(open("http://www.comicvip.com/html/#{comic_id}.html"))
  comic = doc.css('font[color="#FF6600"]')[0].text
  author = doc.css('tr').text().scan(/作者：\r\n(.+)\r\n/).flatten[0]
  cat_id = doc.css('a.Ch')[0]['onclick'].scan(/,(\d+)\);/).flatten[0].to_i
  chapter_count = doc.css('a.Ch').size
  base_url = show_url(comic_id, cat_id)
  FileUtils.mkdir_p "materials/[#{author}]#{comic}"
  doc.css('a.Ch').each do |chapter|
    chapter = chapter['onclick'].scan(/-(\d+).html/).flatten[0]
    chapter_doc = Nokogiri::HTML(open("#{base_url}?ch=#{chapter}"))
    comic_key = chapter_doc.text.scan(/var cs='(.+)';/).flatten[0]
    subkey = create_subkey(comic_key, chapter)
    total_pages = page_count(subkey)
    FileUtils.mkdir_p "materials/[#{author}]#{comic}/#{chapter}"
    puts "Downloading: [#{author}]#{comic} Chapter #{chapter}"
    total_pages.to_i.times do |i|
      open(img_url(subkey, comic_id, i+1)) do |pic|
        File.open("materials/[#{author}]#{comic}/#{chapter}/#{(i+1).to_s.rjust(3,'0')}.jpg", 'wb') do |f|
          f.write pic.read
          puts "\tPage #{i+1} downloaded"
        end
      end
    end
  end
end