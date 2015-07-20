module S3Sync
  class Upload
    attr_accessor :key_id, :key_secret, :region, :bucket, :secret_phrase, :files

    def initialize(options = S3Sync.configuration)
      @key_id = options.key_id
      @key_secret = options.key_secret
      @region = options.region
      @bucket = options.bucket
      @secret_phrase = options.secret_phrase
      @files = options.files
      raise "check your configuration" unless [@key_id, @key_secret, @region, @bucket, @secret_phrase].map{|s| s.class}.uniq == [String] && @files.is_a?(Array)

      creds = Aws::Credentials.new(@key_id, @key_secret)

      # Create bucket.

      resource = Aws::S3::Resource.new(:region => @region, credentials: creds)
      bucket_names = resource.buckets.map{|b| b.name}
      resource.create_bucket(:bucket => @bucket, :acl => "private") unless bucket_names.include?(@bucket)

      # Upload files

      client = Aws::S3::Client.new(:region => @region, :credentials => creds)

      @files.each do |file|
        raise "couldn't find file #{file}" unless File.exist?(file)
        encrypted_file_contents = Encryptor.encrypt(File.read(file), :key => @secret_phrase)
        s3_file = File.join(Date.today.to_s, file)
        client.put_object(:bucket => @bucket, :key => s3_file, :body => encrypted_file_contents)
        puts "uploaded encrypted contents of #{file} to #{@bucket}/#{s3_file}"
      end
    end
  end
end
