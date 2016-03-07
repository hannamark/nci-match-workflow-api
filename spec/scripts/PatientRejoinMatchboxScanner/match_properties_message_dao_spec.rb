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

    @property = MatchPropertiesMessageDao.new(config_loader.config, Logger.new(STDOUT))

    @client = Mongo::Client.new(['127.0.0.1:27017'], :database => 'match')
    @client[:matchPropertiesMessage].insert_one({_id: 'username', value: BSON::Binary.new(@encrypted_string)})
  end

  after(:each) do
    @client[:matchPropertiesMessage].delete_one(:_id => 'username')
  end

  context 'inintialize and create a db client' do

    it 'should check for successful database connection' do
      expect(@property.nil?).to eq(false)
    end

    it 'should handle null on creation' do
      expect(MatchPropertiesMessageDao.new(nil, Logger.new(STDOUT))).to be_truthy
    end

    it 'should handle an empty string on creation' do
      expect(MatchPropertiesMessageDao.new('', Logger.new(STDOUT))).to be_truthy
    end

  end


  context 'get_value should get value from db and decrypt the value correctly' do

    it 'should check for empty or null values, and do nothing' do
      expect(@property.get_value('')).to be_truthy
      expect(@property.get_value(nil)).to be_truthy

    end

    it 'should check that a document is returned from database and decrypted correctly' do
      expect(@property.get_value('username')).to eq(@password_string)
    end

  end

end
