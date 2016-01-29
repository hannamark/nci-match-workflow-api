require "#{File.dirname(__FILE__)}/../../../app/controller/application_controller"
require "#{File.dirname(__FILE__)}/../../../app/controller/mda_messaging_controller"
require "#{File.dirname(__FILE__)}/../../spec_helper"
require 'rack/test'
require 'sinatra'

RSpec.describe Routes::MDAMessagingController do

  def app
    Routes::MDAMessagingController
  end

  it 'Fails with Not Implemented status' do
    post '/assayMessage'
    expect(last_response.status).to eq 501
  end

  it 'Fails with Not Implemented status' do
    post '/setBiopsySpecimenDetails'
    expect(last_response.status).to eq 501
  end

  it 'Fails with Not Implemented status' do
    post '/setNucleicAcidsShippingDetails'
    expect(last_response.status).to eq 501
  end

  
end
