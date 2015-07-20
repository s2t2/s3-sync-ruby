module S3Sync
  class Configuration
    attr_accessor :key_id, :key_secret, :region, :bucket, :secret_phrase, :downloads_dir, :files

    # @param [Hash] options
    #   @option options [String] :key_id The "Access Key Id" for your s3 user
    #   @option options [String] :key_secret The "Access Key Secret" for your s3 user
    #   @option options [String] :region The s3 region
    #   @option options [String] :bucket The s3 bucket (top-level directory) name
    #   @option options [String] :secret_phrase The encryption phrase to use when uploading (encrypting) and downloading (decrypting) files
    #   @option options [Array] :downloads_dir A staging directory to house files downloaded from s3
    #   @option options [Array] :files A list of local file paths
    #
    # @example
    #   S3Sync::Configuration.new(:key_id => "mykey123", :key_secret => "secret456", :region => "us-east-1", :bucket => "my-backups", :files => [".bash_profile",".gitconfig"], :secret_phrase => "my-s3cr3t")
    def initialize(options = {})
      @key_id = options[:key_id]
      @key_secret = options[:key_secret]
      @secret_phrase = options[:secret_phrase]
      @bucket = options[:bucket]
      @region = options[:region]
      @downloads_dir = options[:downloads_dir] || File.join(Dir.home,"Desktop","s3-downloads")
      @files = options[:files]
    end
  end
end
