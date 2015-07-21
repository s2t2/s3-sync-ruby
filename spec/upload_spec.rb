require 'spec_helper'

module S3Sync
  RSpec.describe Upload do
    describe '#new' do
      context "when configured" do
        before do
          S3Sync.configure do |config|
            config.key_id = ENV["AWS_S3_KEY_ID"]
            config.key_secret = ENV["AWS_S3_KEY_SECRET"]
            config.region = ENV["AWS_S3_REGION"]
            config.bucket = ENV["AWS_S3_BUCKET"]
            config.secret_phrase = ENV["AWS_S3_ENCRYPTION_PHRASE"]
            config.files = [
              File.join(Dir.home,".bash_profile"),
              File.join(Dir.home,".gitconfig"),
              File.join(Dir.home,".ssh","config")
            ]
          end
        end

        it "uploads files to s3" do
          upload = S3Sync::Upload.new

          creds = Aws::Credentials.new(upload.key_id, upload.key_secret)
          client = Aws::S3::Client.new(:region => upload.region, :credentials => creds)

          # it creates a bucket

          bucket_names = client.list_buckets.buckets.map &:name

          expect(bucket_names.include?(upload.bucket))

          # it creates an uploads directory in the bucket

          s3_file_names = []
          s3_files = client.list_objects(:bucket => upload.bucket)
          while s3_files.last_page? == false
            s3_file_names << s3_files.contents.map{|obj| obj.key}
            s3_files = s3_files.next_page
          end
          s3_file_names.flatten!

          s3_directories = s3_file_names.map{|str| str.split("/").first}.compact.uniq

          expect(s3_directories.include?(Date.today.to_s))

          # it uploads files

          upload.files.each do |file|
            s3_file_name = File.join(Date.today.to_s, file)
            expect(s3_file_names.include?(s3_file_name))
          end
        end
      end
    end
  end
end
