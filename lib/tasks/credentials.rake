# frozen_string_literal: true

require 'openssl'
require 'base64'

# rubocop:disable Metrics/BlockLength
namespace :credentials do
  desc 'Decrypt config/credentials.yml.enc'
  task decrypt: :environment do
    file_path = 'config/credentials.yml'
    decrypted_credentials = Rails.application.credentials.read

    File.write(file_path, decrypted_credentials)

    puts "File decrypted: #{file_path}"
  end

  desc 'Encrypt config/credentials.yml'
  task encrypt: :environment do
    file = 'config/credentials.yml'
    key_file = 'config/master.key'

    data_bin = File.binread(file)
    key_hex = File.read(key_file)

    key = [key_hex].pack('H*')

    cipher_type =
      case key.bytes.length
      when 16
        'aes-128-gcm'
      when 32
        'aes-256-gcm'
      else
        raise "Wrong key length: #{key.bytes.length}"
      end

    cipher = OpenSSL::Cipher.new(cipher_type)
    cipher.encrypt
    cipher.key = key
    iv = cipher.random_iv
    cipher.auth_data = ''

    data = data_bin
    data = Marshal.dump(data)
    encrypted_data = cipher.update(data)
    encrypted_data << cipher.final

    write_to_file = [encrypted_data, iv, cipher.auth_tag].map { |x| Base64.strict_encode64(x) }.join('--')

    File.write("#{file}.enc", write_to_file)

    puts "File encrypted: #{file}.enc"
  end
end
# rubocop:enable Metrics/BlockLength
