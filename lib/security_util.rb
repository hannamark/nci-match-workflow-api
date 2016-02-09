require 'openssl'
require 'digest/sha1'

module SecurityUtil
  class Aes

    BASE64PASSWORD = "password64Base"
    SALTKEY = "salt"
    IVKEY = "ivFilePathofDoom"

    def self.encrypt(word)
      cipher = OpenSSL::Cipher::AES128.new(:CBC)
      cipher.encrypt
      cipher.key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(BASE64PASSWORD, SALTKEY, 65536, cipher.key_len)
      cipher.iv = IVKEY
      cipher.update(word) << cipher.final
    end


    def self.decrypt(word)
      cipher = OpenSSL::Cipher::AES128.new(:CBC)
      cipher.decrypt
      cipher.key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(BASE64PASSWORD, SALTKEY, 65536, cipher.key_len)
      cipher.iv = IVKEY
      cipher.update(word) << cipher.final
    end


  end

  class OneWayHash

    def sha256Digest(word)
      Digest::SHA256.hexdigest(word)
    end

  end

end

