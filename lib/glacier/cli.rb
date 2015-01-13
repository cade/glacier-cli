require 'optparse'
require_relative "./cli/version"

module Glacier
  def self.env
    ENV['GLACIER_CLI_ENV'] || 'development'
  end

  class CLI
    def initialize(args)
      parse_options args
    end

    def run
    end

    private

    def backend
      @backend ||= Fog::AWS::Glacier.new(
        region: ENV['AWS_REGION'],
        aws_access_key_id: ENV['AWS_ACCESS_KEY'],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
      )
    end

    def parse_options(args)
      parser = OptionParser.new do |o|
        o.banner = 'glacier [options]'

        o.on '-v', '--vault VAULT_NAME', 'Name of vault to store archives in' do |arg|
          @vault = arg
        end

        o.on '-f', '--file [FILE_NAME]', 'Name of file to store' do |arg|
          @files ||= []
          @files << arg
        end

        o.on '-d', '--directory [DIRECTORY_NAME]', 'Name of file to store' do |arg|
          @directories ||= []
          @directories << arg
        end

        o.on_tail '-h', '--help', 'Show help' do
          puts o
          exit
        end

        o.on_tail '-v', '--version', 'Show version' do
          puts "Glacier::CLI #{Glacier::CLI::VERSION}"
          exit
        end
      end
      parser.parse! args

      unless @vault && (@files || @directories)
        puts 'Must specify vault via -v argument' unless @vault
        puts 'Must specify file or directory via -f or -d argument' unless @files || @directories
        exit false
      end
    end
  end
end
