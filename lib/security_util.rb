require 'openssl'
require 'base64'
require 'digest/sha1'

module SecurityUtil
  class Aes

    BASE64PASSWORD = "password64Base"
    SALTKEY = "salt"
    IVKEY = "ivFilePathofDoom"

    def encrypt(word)
      cipher = OpenSSL::Cipher::AES128.new(:CBC)
      cipher.encrypt
      cipher.key = OpenSSL::PKCS5.pbkdf2_hmac_sha1(BASE64PASSWORD, SALTKEY, 65536, cipher.key_len)
      cipher.iv = IVKEY
      cipher.update(word) << cipher.final
    end


    def decrypt(word)
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


  def self.encrypt
    word = "ThisIsATest"
    base64Password = "password64Base"
    saltKey = "salt"
    ivKey = "ivFilePathofDoom"

    cipher = OpenSSL::Cipher::AES128.new(:CBC)
    cipher.encrypt
    key_iv = OpenSSL::PKCS5.pbkdf2_hmac_sha1("password64Base", "salt", 65536, cipher.key_len)
    cipher.key = key_iv
    cipher.iv = ivKey
    encrypted_data = cipher.update(word) << cipher.final

    to_byte = encrypted_data.bytes
    digest =  Digest::SHA256.hexdigest(encrypted_data)
    p digest
    # p hash_code_array(to_byte)




    # stringer = ""
    # to_byte.each do | bit |
    #   stringer << (bit & 0xff).unpack("H*")
    # end
    #
    # p stringer


    # final_result = ""
    # (Digest::SHA256.digest encrypted_data).bytes.each do | bit |
    #   final_result << (((bit & 0xff) + 0x100).to_s(16))[1..-1]
    # end
    # p final_result

  end

  TWO_31 = 2 ** 31
  TWO_32 = 2 ** 32

  def self.hash_code(str)
    str.each_char.reduce(0) do |result, char|
      [((result << 5) - result) + char.ord].pack('L').unpack('l').first
    end
  end

  def self.hash_code_array(arry)
    arry.each.reduce(0) do | result, char |
      [((result << 5) - result) + char.ord].pack('L').unpack('l').first
    end
  end

end

