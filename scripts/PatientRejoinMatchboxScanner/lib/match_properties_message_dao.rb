require 'mongo'

require "#{File.dirname(__FILE__)}/config_helper"
require "#{File.dirname(__FILE__)}/../../../lib/security_util"


class MatchPropertiesMessageDao

  def initialize(db_config)
    @hosts = ConfigHelper.get_prop(db_config, 'database', 'hosts', ['127.0.0.1:27017'])
    @dbname = ConfigHelper.get_prop(db_config, 'database', 'dbname', 'match')
    @username = ConfigHelper.get_prop(db_config, 'database', 'username', nil)
    @password = ConfigHelper.get_prop(db_config, 'database', 'password', nil)

    @client = Mongo::Client.new(@hosts, :database => @dbname, :user => @username, :password => @password)
  end

  def get_value(prop_key)
    @client[:matchPropertiesMessage].find(:_id => prop_key).limit(1).each do | doc |
      return SecurityUtil::AES.decrypt(doc[:value].as_json["$binary"])
    end

  end

end