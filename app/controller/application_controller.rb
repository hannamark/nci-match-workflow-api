require "#{File.dirname(__FILE__)}/../util/workflow_logger"
require "#{File.dirname(__FILE__)}/../util/workflow_api_config"
require 'sinatra'
require 'mongo'
require 'sinatra/config_file'
require 'sinatra/reloader'
require 'logger'
class ApplicationController < Sinatra::Base
  register Sinatra::ConfigFile, Sinatra::Reloader

  WorkflowLogger.logger.info '========== ApplicationService | Starting Workflow API Restful Services  =========='
  WorkflowLogger.logger.info "WORKFLOW API | Running in environment: #{ENV['RACK_ENV']}"

  configure do
    enable :logging
    set :protection, :except => [:json_csrf]
    Mongo::Logger.logger = WorkflowLogger.logger
    Mongo::Logger.logger.level = WorkflowApiConfig.log_level
  end

  before do
    headers 'Access-Control-Allow-Origin' => '*'
    headers 'Access-Control-Allow-Headers' => 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    headers 'Access-Control-Allow-Methods' => 'GET, POST, OPTIONS'
    halt 200 if request.request_method == 'OPTIONS'
  end
end