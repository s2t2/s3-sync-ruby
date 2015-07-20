module S3Sync
  class Download

    # @param [Hash] options
    #   @option options [String] :key_id The "Access Key Id" for your s3 user
    #   @option options [String] :key_secret The "Access Key Secret" for your s3 user
    #   @option options [String] :region The s3 region
    #   @option options [String] :bucket The s3 bucket (top-level directory) name
    #   @option options [String] :secret_phrase The encryption phrase to use when uploading (encrypting) and downloading (decrypting) files
    #   @option options [Array] :files A list of local file paths.
    #
    # @example
    #   S3Sync::Download.new(:key_id => "mykey123", :key_secret => "secret456", :region => "us-east-1", :bucket => "my-backups", :files => [".bash_profile",".gitconfig"], :secret_phrase => "my-s3cr3t")
    def initialize(options = {})
      key_id = options[:key_id]
      key_secret = options[:key_secret]
      region = options[:region]
      bucket = options[:bucket]
      files = options[:files]
      secret_phrase = options[:secret_phrase]
      raise "check your options" unless [key_id, key_secret, region, bucket, secret_phrase].map{|s| s.class}.uniq == [String] && files.is_a?(Array)

      creds = Aws::Credentials.new(key_id, key_secret)
      client = Aws::S3::Client.new(:region => region, :credentials => creds)

      object_keys = []
      objects = client.list_objects(:bucket => bucket)
      while objects.last_page? == false
        object_keys << objects.contents.map{|obj| obj.key}
        objects = objects.next_page
      end
      object_directories = object_keys.flatten.map{|str| str.split("/").first}.compact.uniq
      directory_days = object_directories.map{|str| Date.parse(str) rescue nil}.compact
      latest_directory = directory_days.max.to_s

      local_dir = "#{Dir.home}/Desktop/s3-downloads/#{bucket}"
      FileUtils.mkdir_p(local_dir)

      files.each do |file|
        s3_file = File.join(latest_directory, file)
        local_file = File.join(local_dir, file)
        FileUtils.mkdir_p(local_file.gsub(local_file.split("/").last,""))
        client.get_object({:bucket => bucket, :key => s3_file}, target: local_file)
        decrypted_file_contents = Encryptor.decrypt(File.read(local_file), :key => secret_phrase)
        File.write(local_file, decrypted_file_contents)
        puts "downloaded and decrypted #{bucket}/#{s3_file} to #{local_file}"
      end
    end
  end
end
