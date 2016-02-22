require "#{File.dirname(__FILE__)}/../../../app/controller/application_controller"
require "#{File.dirname(__FILE__)}/../../../app/controller/change_request_controller"
require 'rspec'
require 'sinatra'
require 'spec_helper'

# # describe 'Change Request Service Tests' do
RSpec.describe Routes::ChangeRequestController, type: :controller do

  describe 'Get patient change file list' do
    it 'should fail because patient doesnt exists, returns correct status code' do
      get 'changerequest', {:patientID => '123re'}
      expect(last_response.status).to eq(404)
    end
  end

  describe 'Get specific patient change file' do
    it 'should fail because patient file doesnt exists, returns correct status code' do
      get 'changerequest', {:patientID => '123re'}, {:filename => 'text.txt'}
      expect(last_response.status).to eq(404)
      # expect(last_response.body).to eq("FAILURE")
    end
  end

end
