require "aws-sdk"
require "encryptor"

require "s3_sync/configuration"
require "s3_sync/download"
require "s3_sync/upload"
require "s3_sync/version"

module S3Sync
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= S3Sync::Configuration.new
  end

  def self.configure
    yield(configuration) #if block_given?
  end
end
