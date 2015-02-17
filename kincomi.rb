require 'kindlerb'
require 'yaml'
require 'date'
require 'fileutils'

processed = 0

Dir.new("#{Dir.pwd}/materials").each do |comic|
  next if comic[0] == '.'
  info = comic.scan(/\[(.+)\](.+)/)
  author, title = info[0][0], info[0][1]
  doc = YAML.load_file("#{Dir.pwd}/target_dir/_document.yml.template")
  doc['author'] = author
  doc['title'] = title
  doc['date'] = Time.now.to_date
  doc['doc_uuid'] = "#{doc['doc_uuid']}#{doc['date'].to_s}"
  doc['mobi_outfile'] = "#{comic}.mobi"
  doc['cover'] = "/"
  `mkdir target_dir/#{processed}`
  `mkdir target_dir/#{processed}/sections`
  File.open("target_dir/#{processed}/_document.yml", "w") do |f|
    f.write doc.to_yaml
  end

  Dir.new("#{Dir.pwd}/materials/#{comic}").each do |episode|
    next if episode[0] == '.'
    `mkdir target_dir/#{processed}/sections/#{episode}`
    File.open("target_dir/#{processed}/sections/#{episode}/_section.txt", "w")

    img_tags = ""
    Dir.new("#{Dir.pwd}/materials/#{comic}/#{episode}").each do |page|
      next if page[0] == '.'
      FileUtils.cp("materials/#{comic}/#{episode}/#{page}", "target_dir/#{processed}/#{episode}_#{page}")
      img_tags += "<img src=\"#{Dir.pwd}/target_dir/#{processed}/#{episode}_#{page}\" class=\"image\" />\n"
    end
    File.open("target_dir/#{processed}/sections/#{episode}/001.html", "w") do |f|
        f.write <<-HTML
          <html>
            <head>
              <title>#{comic}-#{episode}</title>
              <style type="text/css">
                .image {
                  width: 100%;
                  margin: 0em;
                  page-break-before: always;
                }
              </style>
            </head>
            <body>
              #{img_tags}
            </body>
          </html>
          HTML
      end
  end

  Kindlerb.run("target_dir/#{processed}", true)
  `mkdir -p generated`
  `mv target_dir/#{processed}/#{comic}.mobi generated/`
  `rm -r target_dir/#{processed}`
end
