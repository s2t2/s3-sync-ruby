module S3Sync
  class Upload

    # @param [Hash] options
    #   @option options [String] :key_id The "Access Key Id" for your s3 user
    #   @option options [String] :key_secret The "Access Key Secret" for your s3 user
    #   @option options [String] :region The s3 region
    #   @option options [String] :bucket The s3 bucket (top-level directory) name
    #   @option options [String] :secret_phrase The encryption phrase to use when uploading (encrypting) and downloading (decrypting) files
    #   @option options [Array] :files A list of local file paths.
    #
    # @example
    #   S3Sync::Upload.new(:key_id => "mykey123", :key_secret => "secret456", :region => "us-east-1", :bucket => "my-backups", :files => [".bash_profile",".gitconfig"], :secret_phrase => "my-s3cr3t")
    #   S3Sync::Upload.new(:files => [".bash_profile",".gitconfig"])
    def initialize(options = {})
      key_id = options[:key_id]
      key_secret = options[:key_secret]
      region = options[:region]
      bucket = options[:bucket]
      files = options[:files]
      secret_phrase = options[:secret_phrase]
      raise "check your options" unless [key_id, key_secret, region, bucket, secret_phrase].map{|s| s.class}.uniq == [String] && files.is_a?(Array)

      creds = Aws::Credentials.new(key_id, key_secret)
      resource = Aws::S3::Resource.new(:region => region, credentials: creds)
      bucket_names = resource.buckets.map{|bucket| bucket.name}
      resource.create_bucket(:bucket => bucket, :acl => "private") unless bucket_names.include?(bucket)
      client = Aws::S3::Client.new(:region => region, :credentials => creds)

      files.each do |file|
        raise "couldn't find file #{file}" unless File.exist?(file)
        encrypted_file_contents = Encryptor.encrypt(File.read(file), :key => secret_phrase)
        s3_file = File.join(Date.today.to_s, file)
        client.put_object(:bucket => bucket, :key => s3_file, :body => encrypted_file_contents)
        puts "uploaded encrypted contents of #{file} to #{bucket}/#{s3_file}"
      end
    end
  end
end
