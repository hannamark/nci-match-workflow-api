require "#{File.dirname(__FILE__)}/../../spec_helper"
require "#{File.dirname(__FILE__)}/../../../scripts/PatientRejoinMatchboxScanner/lib/match_properties_message_dao"
require "#{File.dirname(__FILE__)}/../../../scripts/PatientRejoinMatchboxScanner/lib/config_helper"
require "#{File.dirname(__FILE__)}/../../../scripts/PatientRejoinMatchboxScanner/lib/config_loader"
require 'yaml'
require 'mongo'

RSpec.describe MatchPropertiesMessageDao do

  before(:each) do
    config_loader = ConfigLoader.new('../../../spec/resource/scanner-unittest.yml', 'development')
    @password_string = 'password'
    @security = SecurityUtil::AES.new("password64Base", "salt", "ivFilePathofDoom")
    @encrypted_string = @security.encrypt(@password_string)
    @decrypted_string = @security.decrypt(@encrypted_string)

    @property = double(MatchPropertiesMessageDao)
    allow(@property).to receive(:get_value).and_return(@decrypted_string)
  end

  context 'inintialize and create a db client' do

    it 'should check for successful database connection' do
      expect(@property.nil?).to eq(false)
    end
  end

  context 'get_value should get value from db and decrypt the value correctly' do

    it 'should check that a document is returned from database and decrypted correctly' do
      expect(@property.get_value('username')).to eq(@password_string)
    end

  end

end