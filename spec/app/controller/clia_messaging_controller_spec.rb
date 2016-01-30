require "#{File.dirname(__FILE__)}/../../../app/controller/application_controller"
require "#{File.dirname(__FILE__)}/../../../app/controller/clia_messaging_controller"
require "#{File.dirname(__FILE__)}/../../spec_helper"
require 'rack/test'
require 'sinatra'

RSpec.describe Routes::CLIAMessagingController do

  def app
    Routes::CLIAMessagingController
  end

  it 'Fails with Not Implemented status' do
    post '/ionReporterUploadFileSet'
    expect(last_response.status).to eq 501
  end

  it 'Fails with Not Implemented status' do
    post '/irUploaderHeartBeat'
    expect(last_response.status).to eq 501
  end

  it 'Fails with Not Implemented status' do
    post '/loadPositiveControls'
    expect(last_response.status).to eq 501
  end

end