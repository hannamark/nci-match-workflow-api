require 'mongo'
require "#{File.dirname(__FILE__)}/../lib/command_line_helper"
require "#{File.dirname(__FILE__)}/../lib/security_util"

class MongoClient

  def initialize()
    @client = Mongo::Client.new(['127.0.0.1:27017'], :database => 'match')
  end

  def find_match_properties(key)
    value = @client[:matchPropertiesMessage].find(:_id => key).first
    return value
  end

end