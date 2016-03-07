require 'logger'
require 'mongo'


module RejoinLogger

  class << self
    attr_accessor :logger

    def logger
      @logger = Logger.new(STDOUT) unless !@logger.nil?
    end

    def logger=(logger)
      @logger ||= logger
      Mongo::Logger.logger = @logger
    end

    def level=(level)
      @logger.level ||= level
      Mongo::Logger.logger.level = @logger.level
    end
  end

end