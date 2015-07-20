require 'spec_helper'

module S3Sync
  RSpec.describe Download do
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

        it "downloads files from s3" do
          download = S3Sync::Download.new
          download.files.each do |file|
            local_file = File.join(download.downloads_dir, download.bucket, file)
            expect(File.exist?(local_file))
          end
        end
      end
    end
  end
end
