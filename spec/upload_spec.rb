require 'spec_helper'

module S3Sync
  RSpec.describe Upload do
    describe '#new' do
      context "when configured" do
        let(:options){
          {
            :key_id => ENV["AWS_S3_KEY_ID"],
            :key_secret => ENV["AWS_S3_KEY_SECRET"],
            :region => ENV["AWS_S3_REGION"],
            :bucket => ENV["AWS_S3_BUCKET"],
            :secret_phrase => ENV["AWS_S3_ENCRYPTION_PHRASE"],
            :files => [
              "#{Dir.home}/.bash_profile",
              "#{Dir.home}/.gitconfig",
              "#{Dir.home}/.ssh/config"
            ]
          }
        }

        it "uploads files to s3" do
          S3Sync::Upload.new(options)
          options[:files].each do |file|
            s3_file = File.join(Date.today.to_s, file)
            binding.pry
            expect(true)
          end
        end
      end
    end
  end
end
