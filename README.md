# s3_sync

Securely sync (upload and download) files with [Amazon Simple Storage Service (s3)](http://aws.amazon.com/s3).

Specify credentials, file names, and other options during configuration.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 's3_sync'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install s3_sync

## Usage

### Configuring

Configure the gem to use the same options when uploading and downloading.

```` rb
S3Sync.configure do |config|
  config.key_id = "mykey123"
  config.key_secret = "secret456"
  config.region = "us-east-1"
  config.bucket = "my-backups"
  config.secret_phrase = "my-s3cr3t"
  config.files = [
    File.join(Dir.home,".bash_profile"),
    File.join(Dir.home,".gitconfig"),
    File.join(Dir.home,".ssh","config")
  ]
  config.downloads_dir = File.join(Dir.home,"Desktop","my-s3-downloads")
end
````

### Uploading

Upload files from your computer to s3.

```` rb
S3Sync::Upload.new
````

 The uploads bucket gets created automatically, and can be configured with `config.bucket`.

### Downloading

Download files from s3 to your computer.

```` rb
S3Sync::Download.new
````

Files are downloaded to a staging directory, which can be configured with `config.downloads_dir`. The staging directory helps mitigate the risk of accidentally over-writing local files.

## Prerequisites

Create an [AWS Identity and Access Management (IAM)](http://aws.amazon.com/iam/) user and obtain its **Access Key Id** and **Secret Access Key**.

Create an AWS IAM group.

Create an AWS IAM policy with **arn:aws:iam::aws:policy/AmazonS3FullAccess**.

Attach the policy to the group.

Add the user to the group.

## Contributing

Browse [existing issues](https://github.com/s2t2/s3-sync-ruby/issues) or create a [new issue](https://github.com/s2t2/s3-sync-ruby/issues/new) to communicate bugs, desired features, etc.

After forking the repo and pushing your changes, create a [pull request](https://github.com/s2t2/s3-sync-ruby/pulls/new) referencing the applicable issue(s).

### Installation

Check out the repo with `git clone git@github.com:s2t2/s3-sync-ruby.git`, and `cd s3-sync-ruby`.

After checking out the repo, run `bin/setup` to install dependencies.

### Testing

Run `bundle exec rake` or `bundle exec rspec spec/` to run the tests.

You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

### Releasing

Update the version number in `version.rb`, then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
