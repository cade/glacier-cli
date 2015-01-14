require 'optparse'
require 'fog'
require 'find'
require 'set'
require_relative "./cli/version"

module Glacier
  def self.env
    ENV['GLACIER_CLI_ENV'] || 'development'
  end

  class CLI
    CHUNK_SIZE = 1024 * 1024 * 8 # 8 MB
    LOCAL_STORE = "#{ENV['HOME']}/.glacier"

    def initialize(args)
      @files = []
      @directories = []
      parse_options args
    end

    def run
      @directories.each do |directory|
        Find.find(directory == '.' ? Dir.pwd : directory) do |path|
          dot = File.basename(path).start_with? '.'
          if FileTest.directory? path
            # completely skip 'dot' directories
            Find.prune if dot
          else
            # ignore dotfiles
            @files << path unless dot
          end
        end
      end

      @files.each do |file|
        basename = File.basename(file)
        if uploaded_files.include? basename
          puts "Skipping #{file} (already uploaded)"
        else
          vault.archives.create body: File.new(file), multipart_chunk_size: CHUNK_SIZE, description: basename
          File.write LOCAL_STORE, "#{basename}\n", mode: 'a'
          puts "Uploaded #{file}"
        end
      end
    end

    private

    def vault
      @vault ||= backend.vaults.get @vault_name
    end

    def backend
      @backend ||= Fog::AWS::Glacier.new(
        region: ENV['AWS_REGION'],
        aws_access_key_id: ENV['AWS_ACCESS_KEY'],
        aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
      )
    end

    def uploaded_files
      FileTest.exist?(LOCAL_STORE) ? File.read(LOCAL_STORE).split("\n").to_set : []
    end

    def parse_options(args)
      parser = OptionParser.new do |o|
        o.banner = 'glacier [options]'

        o.on '-v', '--vault VAULT_NAME', 'Name of vault to store archives in' do |arg|
          @vault_name = arg
        end

        o.on '-f', '--file [FILE_NAME]', 'Path of file to store' do |arg|
          @files << arg
        end

        o.on '-d', '--directory [DIRECTORY_NAME]', 'Path of directory to recursively store' do |arg|
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

      unless @vault_name && (@files || @directories)
        puts 'Must specify vault via -v argument' unless @vault_name && vault
        puts 'Must specify file or directory via -f or -d argument' unless @files || @directories
        exit false
      end
    end
  end
end
