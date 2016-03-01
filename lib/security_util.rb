require 'openssl'
require 'digest/sha1'

module SecurityUtil
  class AES

    attr_accessor :base64_password, :salt_key, :iv_key

    def initialize(password, salt, key)
      @base64_password = password
      @salt_key = salt
      @iv_key = key
    end

    def encrypt(word)
      begin
        cipher = OpenSSL::Cipher::AES128.new(:CBC)
        cipher.encrypt
        cipher.key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(@base64_password, @salt_key, 65536, cipher.key_len)
        cipher.iv = @iv_key
        cipher.update(word) << cipher.final
      rescue ArgumentError, TypeError => error
        ''
      end

    end


    def decrypt(word)
      begin
        cipher = OpenSSL::Cipher::AES128.new(:CBC)
        cipher.decrypt
        cipher.key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(@base64_password, @salt_key, 65536, cipher.key_len)
        cipher.iv = @iv_key
        cipher.update(word) << cipher.final
      rescue ArgumentError, TypeError => error
        ''
      end
    end


  end

  module OneWayHash

    def self.sha256Digest(word)
      begin
        Digest::SHA256.hexdigest(word)
      rescue TypeError => error
        ''
      end
    end

  end

end
