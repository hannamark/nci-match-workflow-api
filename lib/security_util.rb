require 'openssl'
require 'digest/sha1'

module SecurityUtil
  module AES

    BASE64PASSWORD = "password64Base"
    SALTKEY = "salt"
    IVKEY = "ivFilePathofDoom"

    def self.encrypt(word)
      begin
        cipher = OpenSSL::Cipher::AES128.new(:CBC)
        cipher.encrypt
        cipher.key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(BASE64PASSWORD, SALTKEY, 65536, cipher.key_len)
        cipher.iv = IVKEY
        cipher.update(word) << cipher.final
      rescue ArgumentError, TypeError => error
        ''
      end

    end


    def self.decrypt(word)
      begin
        cipher = OpenSSL::Cipher::AES128.new(:CBC)
        cipher.decrypt
        cipher.key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(BASE64PASSWORD, SALTKEY, 65536, cipher.key_len)
        cipher.iv = IVKEY
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

