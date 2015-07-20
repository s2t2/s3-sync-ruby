module S3Sync
  RSpec.describe Download do
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
        it "downloads files from s3" do
          S3Sync::Download.new(options)
          local_dir = "#{Dir.home}/Desktop/s3-downloads/#{bucket}"
          options[:files].each do |file|
            local_file = File.join(local_dir, file)
            expect(File.exist?(local_file))
          end
        end
      end
    end
  end
end
