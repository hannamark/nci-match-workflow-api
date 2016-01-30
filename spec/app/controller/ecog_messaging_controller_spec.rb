require "#{File.dirname(__FILE__)}/../../../app/controller/ecog_messaging_controller"
require "#{File.dirname(__FILE__)}/../../spec_helper"
require 'rack/test'
require 'sinatra'

RSpec.describe Routes::ECOGMessagingController do

  def app
    Routes::ECOGMessagingController
  end

  it 'Fails with Not Implemented status' do
    post '/setPatientTrigger'
    expect(last_response.status).to eq 501
  end

  it 'Fails with Not Implemented status' do
    post '/setPatientAssignmentStatus'
    expect(last_response.status).to eq 501
  end

end