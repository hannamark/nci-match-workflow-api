require 'mongoid'
require "#{File.dirname(__FILE__)}/../data/news_feed"

class Logging
  include Mongoid::Document
  store_in collection: 'logging'

  field :site, type: String
  field :timeStamp, type: DateTime
  field :message, type: String
  field :actor, type: String

  field :level, type: String
  field :marker, type: String
  field :logger, type: String

  # db.logging.find().sort( { "timeStamp": -1 } )
  def self.get_latest_logs(age_by_day)

    news_feed = []

    (0..10).each do |i|
      news_feed << NewsFeed.new('ECOG', Time.now, 1, 'Someone did something')
    end
    # puts "================ in get_latest_logs"
    # logs = Logging.order_by(:timeStamp => 'desc')
    #
    # puts "=========== age_by_day: #{age_by_day}"
    #
    # threshold = Time.now - 1.day
    # puts "========== threshold: #{threshold}"
    # latest_logs = []
    # count = 0
    #
    # puts "Got #{logs.count} logs"
    # logs.each do |log|
    #   puts "log: #{log.to_json}"
    #   puts log.timeStamp.to_s + '|' + log.message
    #   if (!log.timeStamp.nil? && log.timeStamp > threshold)
    #     actor = "Unknow"
    #     news_feed << NewsFeed.new(actor, log.timeStamp, 1, log.message)
    #     count += 1
    #
    #     break if (count > 10)
    #   end
    #
    # end
    #
    # puts "got this"
    puts news_feed.to_json
    news_feed
  end

end