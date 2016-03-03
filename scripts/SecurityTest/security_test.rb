require "#{File.dirname(__FILE__)}/lib/command_line_helper"
require "#{File.dirname(__FILE__)}/lib/security_util"
require "#{File.dirname(__FILE__)}/lib/mongo_client"

class SecurityTest


  def initialize
    @command_line_helper = CommandLineHelper.new
    @client = MongoClient.new
    password = @command_line_helper.options[:password]
    salt = @command_line_helper.options[:salt]
    iv = @command_line_helper.options[:iv]
    @security = SecurityUtil::AES.new(password,salt,iv)
  end

  def run
    property = @client.find_match_properties(@command_line_helper.options[:key])

    value =  property[:value].as_json["$binary"]

    decrypted_value = @security.decrypt(value)

    return decrypted_value

  end

end

SecurityTest.new.run




