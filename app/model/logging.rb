require 'mongoid'
require "#{File.dirname(__FILE__)}/../data/news_feed"
require "#{File.dirname(__FILE__)}/../util/workflow_logger"
require "#{File.dirname(__FILE__)}/../util/workflow_api_config"

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

    WorkflowLogger.logger.info "Logging | Getting logs in the past #{age_by_day} days"

    logs = Logging.where(:timeStamp.gte => (Date.today - age_by_day.to_i))
               # .order_by(:timeStamp, :desc)

    WorkflowLogger.logger.debug "Logging | Getting #{logs.count} logs meeting criteria"
    count = 0
    logs.each do |log|
      puts log.timeStamp.to_s + '|' + log.message

      age =self.calculate_age(log.timeStamp)
      news_feed << NewsFeed.new(log.site, log.timeStamp, age, log.message)
      count += 1

        # debug only
      # break if (count > 10)
    end

    news_feed
  end

  def self.calculate_age(timestamp)
    delta = (Date.today - timestamp)
    delta.to_i
  end
end