require 'mongo'
require 'active_support/core_ext/object/blank'

require "#{File.dirname(__FILE__)}/config_helper"
require "#{File.dirname(__FILE__)}/../../../lib/security_util"


class MatchPropertiesMessageDao

  def initialize(db_config)
    @hosts = ConfigHelper.get_prop(db_config, 'database', 'hosts', ['127.0.0.1:27017'])
    @dbname = ConfigHelper.get_prop(db_config, 'database', 'dbname', 'match')
    @username = ConfigHelper.get_prop(db_config, 'database', 'username', nil)
    @password = ConfigHelper.get_prop(db_config, 'database', 'password', nil)
    @client = Mongo::Client.new(@hosts, :database => @dbname, :user => @username, :password => @password)
    @security = SecurityUtil::AES.new(ConfigHelper.get_prop(db_config, 'security', 'password', "password64Base"),
                                      ConfigHelper.get_prop(db_config, 'security', 'salt', "salt"),
                                      ConfigHelper.get_prop(db_config, 'security', 'ivkey', "ivFilePathofDoom"))
  end

  def get_value(prop_key)
    match_property = @client[:matchPropertiesMessage].find(:_id => prop_key).limit(1)
    match_property.each do | doc |
      value = @security.decrypt(doc[:value].as_json["$binary"])
      return value
    end
    ''
  end

  def close
    @client.close
  end

end