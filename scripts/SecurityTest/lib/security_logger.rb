require 'logger'
require 'mongo'

class SecurityLogger < Logger

  def initialize(config)
    directory_name = File.dirname(config[:log_filepath])
    FileUtils.mkdir_p dirname unless File.exist?(directory_name)
    logger = Logger.new(config[:log_filepath], 3, 100 * 1024 * 1024)
    Mongo::Logger.logger = logger
    logger.level = config[:log_level]
    Mongo::Logger.logger.level = logger.level
  end

end




