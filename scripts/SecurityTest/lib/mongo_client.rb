require 'mongo'
require "#{File.dirname(__FILE__)}/../lib/security_util"

class MongoClient

  def initialize()
    @client = Mongo::Client.new(['127.0.0.1:27017'], :database => 'match')
  end

  def find_match_properties(key)
    begin
      value = @client[:matchPropertiesMessage].find(:_id => key).first

    if !value.nil?
      return value
    else
      p 'key did not match any value in the database'
    end

    rescue ArgumentError, ThreadError => error
      ''
    end

  end

end