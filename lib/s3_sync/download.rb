module S3Sync
  class Download
    attr_accessor :key_id, :key_secret, :region, :bucket, :secret_phrase, :downloads_dir, :files

    def initialize(options = S3Sync.configuration)
      @key_id = options.key_id
      @key_secret = options.key_secret
      @region = options.region
      @bucket = options.bucket
      @secret_phrase = options.secret_phrase
      @files = options.files
      @downloads_dir = options.downloads_dir
      raise "check your configuration" unless [@key_id, @key_secret, @region, @bucket, @secret_phrase, @downloads_dir].map{|s| s.class}.uniq == [String] && @files.is_a?(Array)

      creds = Aws::Credentials.new(@key_id, @key_secret)
      client = Aws::S3::Client.new(:region => @region, :credentials => creds)

      # Find latest uploads directory.

      object_keys = []
      objects = client.list_objects(:bucket => @bucket)

      if objects.next_page?
        while objects.last_page? == false
          object_keys << objects.contents.map{|obj| obj.key}
          objects = objects.next_page
        end
      else
        object_keys << objects.contents.map{|obj| obj.key}
      end

      object_directories = object_keys.flatten.map{|str| str.split("/").first}.compact.uniq
      days = object_directories.map{|str| Date.parse(str) rescue nil}.compact
      latest_day = days.max.to_s

      # Create downloads directory.

      FileUtils.mkdir_p(@downloads_dir)

      # Download files.

      files.each do |file|
        s3_file = File.join(latest_day, file)
        local_file = File.join(@downloads_dir, @bucket, file)
        FileUtils.mkdir_p(local_file.gsub(local_file.split("/").last,""))
        client.get_object({:bucket => @bucket, :key => s3_file}, target: local_file)
        decrypted_file_contents = Encryptor.decrypt(File.read(local_file), :key => secret_phrase)
        File.write(local_file, decrypted_file_contents)
        puts "downloaded and decrypted #{@bucket}/#{s3_file} to #{local_file}"
      end
    end
  end
end
