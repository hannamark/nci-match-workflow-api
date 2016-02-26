require "#{File.dirname(__FILE__)}/../spec_helper"
require "#{File.dirname(__FILE__)}/../../lib/security_util"

require 'rspec'

include SecurityUtil

RSpec.describe SecurityUtil, '#encrypt string' do


    before {
      @password_string = 'password'
      @encrypted_string = SecurityUtil::AES.encrypt(@password_string)
      @decrypted_string = SecurityUtil::AES.decrypt(@encrypted_string)
    }

  context 'with a string it should encrypt and decrypt' do

    it 'should not return the same password string when encrypted' do
      expect(@encrypted_string).not_to eq(@password_string)
    end

    it 'should decrypt and return the original string' do
      expect(@decrypted_string).to eq(@password_string)
    end

    it 'should do nothing with an empty or nil value' do
      expect(SecurityUtil::AES.encrypt('')).to be_truthy
      expect(SecurityUtil::AES.encrypt(nil)).to be_truthy

      expect(SecurityUtil::AES.decrypt('')).to be_truthy
      expect(SecurityUtil::AES.decrypt(nil)).to be_truthy
    end

  end

  context 'with a string it should hash' do

    it 'should not return the same string' do
      expect(SecurityUtil::OneWayHash.sha256Digest('tester')).to_not eq('tester')
    end

    it 'should return a hex string' do
      expect(SecurityUtil::OneWayHash.sha256Digest('thisString')).to match(/\h/)
    end

    it 'should do nothing with an empty or nil value' do
      expect(SecurityUtil::OneWayHash.sha256Digest('')).to be_truthy
      expect(SecurityUtil::OneWayHash.sha256Digest(nil)).to be_truthy
    end

  end

end