require 'optparse'

class CommandLineHelper
  attr_reader :options

  def initialize
    get_options
  end

  def get_options
    @options = {}

    optparse = OptionParser.new do | opts |
      opts.banner = 'Usage: Provide options for running security_test.rb [options]'

      opts.on('-k s', '--databasekey=s', 'The database key for the value to be decrypted') do |key|
        options[:key] = key
      end

      opts.on('-p s', '--password=s', 'The security util password') do |password|
        options[:password] = password
      end

      opts.on('-s s', '--salt=s', 'The security util salt') do |salt|
        options[:salt] = salt
      end

      opts.on('-i s', '--iv=s', 'The security util iv key') do |iv|
        options[:iv] = iv
      end

    end

    begin
      optparse.parse! ARGV
    rescue OptionParser::InvalidOption => error
      p "Failed to pass command line arguements, received error: #{error.message}"
    end

  end

  private :get_options

end