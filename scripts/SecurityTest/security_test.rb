require 'logger'

require "#{File.dirname(__FILE__)}/lib/command_line_helper"
require "#{File.dirname(__FILE__)}/lib/security_util"
require "#{File.dirname(__FILE__)}/lib/mongo_client"
require "#{File.dirname(__FILE__)}/lib/security_logger"

class SecurityTest

  def initialize
    @command_line_helper = CommandLineHelper.new
    @client = MongoClient.new
    password = @command_line_helper.options[:password]
    salt = @command_line_helper.options[:salt]
    iv = @command_line_helper.options[:iv]
    SecurityLogger.new({:log_filepath => "application.log", :log_level => Logger::DEBUG})
    @security = SecurityUtil::AES.new(password,salt,iv)
    @config_loader = SecurityConfigLoader.new(@command_line_helper.options[:env])
  end

  def run
    property = @client.find_match_properties(@command_line_helper.options[:key])

    value =  property[:value].as_json["$binary"]

    decrypted_value = @security.decrypt(value)

    puts decrypted_value

    return decrypted_value

  end

end

SecurityTest.new.run




