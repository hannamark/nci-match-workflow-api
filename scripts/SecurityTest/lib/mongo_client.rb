require 'mongo'
require "#{File.dirname(__FILE__)}/../lib/security_util"
require "#{File.dirname(__FILE__)}/../lib/config_helper"

class MongoClient
  include Mongo

  def initialize(db_config)
    hosts = ConfigHelper.get_prop(db_config, 'database', 'hosts', ['127.0.0.1:27017'])
    dbname = ConfigHelper.get_prop(db_config, 'database', 'dbname', 'match')
    username = ConfigHelper.get_prop(db_config, 'database', 'username', nil)
    password = ConfigHelper.get_prop(db_config, 'database', 'password', nil)

    @client = Mongo::Client.new(hosts, :database => dbname, :user => username, :password => password)
  end

  def find_match_properties(key)
    begin
      value = @client[:matchPropertiesMessage].find(:_id => key).first
      return value unless value.nil?
      p 'issue when retrieving data from DB'
    rescue ArgumentError, ThreadError => error
      ''
    end

  end

end