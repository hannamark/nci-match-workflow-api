require "#{File.dirname(__FILE__)}/../../../app/controller/application_controller"
require "#{File.dirname(__FILE__)}/../../../app/controller/change_request_controller"
require 'rspec'
require 'sinatra'
require 'spec_helper'

# # describe 'Change Request Service Tests' do
RSpec.describe Routes::ChangeRequestController, type: :controller do

  describe 'Get version info' do
    it 'should pass, returns version' do
      get 'changerequest', {:patientID => '123re'}
      expect(last_response.status).to eq 200
    end
  end

end
