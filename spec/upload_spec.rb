require 'spec_helper'

module S3Sync
  RSpec.describe Upload do
    describe '#new' do
      context "when configured" do
        before do
          S3Sync.configure do |config|
            config.key_id = ENV["AWS_S3_KEY_ID"]
            config.key_secret => ENV["AWS_S3_KEY_SECRET"]
            config.region => ENV["AWS_S3_REGION"]
            config.bucket => ENV["AWS_S3_BUCKET"]
            config.secret_phrase => ENV["AWS_S3_ENCRYPTION_PHRASE"]
            config.files => [
              "#{Dir.home}/.bash_profile",
              "#{Dir.home}/.gitconfig",
              "#{Dir.home}/.ssh/config"
          end
        end

        it "uploads files to s3" do
          upload = S3Sync::Upload.new

          #creds = Aws::Credentials.new(key_id, key_secret)
          #client = Aws::S3::Client.new(:region => region, :credentials => creds)
          upload.files.each do |file|
            s3_file = File.join(Date.today.to_s, file)
            binding.pry
            expect(true)
          end
        end
      end
    end
  end
end
