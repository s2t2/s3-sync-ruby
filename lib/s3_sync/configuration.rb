module S3Sync
  class Configuration
    attr_accessor :key_id, :key_secret, :region, :bucket, :secret_phrase

    def initialize(options = {})
      @key_id = options[:key_id] || ENV['AWS_S3_USER_ID']
      @key_secret = options[:key_secret] || ENV['AWS_S3_USER_ID']
      @secret_phrase = options[:secret_phrase] || ENV['AWS_S3_ENCRYPTION_PHRASE']
      @bucket = options[:bucket] || ENV['AWS_S3_BUCKET_NAME']
      @region = options[:region] || ENV['AWS_S3_REGION']
    end
  end
end
