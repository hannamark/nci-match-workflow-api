require "#{File.dirname(__FILE__)}/lib/command_line_helper"
require "#{File.dirname(__FILE__)}/lib/security_util"
require "#{File.dirname(__FILE__)}/lib/mongo_client"
require "#{File.dirname(__FILE__)}/lib/config_loader"

class SecurityTest

  def initialize
    @command_line_helper = CommandLineHelper.new
    @config_loader = SecurityConfigLoader.new(@command_line_helper.options[:env])
    @client = MongoClient.new(@config_loader.config)
    @security = SecurityUtil::AES.new(@command_line_helper.options[:password],
                                      @command_line_helper.options[:salt],
                                      @command_line_helper.options[:iv])
  end

  def run
    begin
      property = @client.find_match_properties(@command_line_helper.options[:key])
      @security.decrypt(property[:value].as_json["$binary"])
    rescue TypeError => error

    end
  end


end

SecurityTest.new.run




