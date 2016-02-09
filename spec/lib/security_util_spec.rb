require "#{File.dirname(__FILE__)}/../spec_helper"
require "#{File.dirname(__FILE__)}/../../lib/security_util"
require 'rspec'

include SecurityUtil

RSpec.describe SecurityUtil, '#encrypt string' do


    before {
      @password_string = 'password'
      @encrypted_string = SecurityUtil::Aes.encrypt(@password_string)
      @decrypted_string = SecurityUtil::Aes.decrypt(@encrypted_string)
    }

  context 'with a password string' do

    it 'should not return the same password string' do
      expect @encrypted_string != @password_string
    end

    it 'should decrypt and return the original string' do
      expect @decrypted_string == @password_string
    end

  end

end