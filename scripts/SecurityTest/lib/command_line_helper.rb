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

      opts.on('-k value', '--databasekey=value', 'The database key for the value to be decrypted') do | datebase_id |
        options[:key] = datebase_id
      end

      opts.on('-p value', '--password=value', 'The security util password') do | password |
        options[:password] = password
      end

      opts.on('-s value', '--salt=value', 'The security util salt') do | salt |
        options[:salt] = salt
      end

      opts.on('-i value', '--iv=value', 'The security util iv key') do | iv |
        options[:iv] = iv
      end

      opts.on('-e s', '--env=s', 'The environment to run the script') do |env|
        options[:env] = env
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