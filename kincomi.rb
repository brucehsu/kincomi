require 'kindlerb'
require 'optparse'
require 'ostruct'

class Parser
  def self.parse(options)
    args = OpenStruct.new
    options = ["--initialize"] if options.empty?

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: kincomi [options]"

      opts.on("-h", "--help", "Usage help") do
        puts opts
        exit
      end
    end

    opt_parser.parse!(options)
    return args
  end
end

options = Parser.parse ARGV
