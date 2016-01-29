require "#{File.dirname(__FILE__)}/../../../app/controller/application_controller"
require "#{File.dirname(__FILE__)}/../../../app/controller/clia_messaging_controller"
require "#{File.dirname(__FILE__)}/../../spec_helper"
require 'rack/test'
require 'sinatra'

RSpec.describe Routes::CLIAMessagingController do

  def app
    Routes::CLIAMessagingController
  end


  it 'Fails if MSN is not provided' do

    get '/assignmentReport?job_id=testjob1'

    expect(last_response.status).to eq 400

  end

  it 'Fail if Job_Id is not provided' do

    get '/variantReport?msn=10369_1000_N-15-00005'

    expect(last_response.status).to eq 400
  end

  it 'Fail if no patient document is found' do

    get '/assignmentReport/?msn=10368_1000_N-15-00005'

    expect(last_response.status).to eq 404
  end

  # it 'Pass if patient document is found' do
  #
  #   get '/assignmentReport?msn=10368_1000_N-15-00005&job_id=testjob1'
  #
  #   expect(last_response.status).to eq 200
  # end


  context 'Get the test message' do
    it 'should pass' do

      get '/reportTest'

      expect(last_response.status).to eq 200
      expect(last_response.body).to include('report')
    end
  end


end