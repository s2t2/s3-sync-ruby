# s3_sync

[![Gem Version](https://badge.fury.io/rb/s3_sync.svg)](http://badge.fury.io/rb/s3_sync)

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

## Prerequisites

Create an [AWS Identity and Access Management (IAM)](http://aws.amazon.com/iam/) user.

> Note: the s3 user's *Access Key Id* and *Secret Access Key*

Create an AWS IAM policy with the permissions:

    arn:aws:iam::aws:policy/AmazonS3FullAccess

Create an AWS IAM group, add the user to the group, and attach the policy to the group.

## Usage

### Configuring

Use the same options when uploading and downloading.

```` rb
S3Sync.configure do |config|
  config.key_id = "mykey123"
  config.key_secret = "mysecret456"
  config.region = "us-east-1"
  config.bucket = "s3-uploads"
  config.secret_phrase = "supersecret"
  config.files = [
    File.join(Dir.home,".gitconfig"),
    File.join(Dir.home,".ssh","config")
  ]
  config.downloads_dir = File.join(Dir.home,"Desktop","s3-downloads")
end
````

#### Configuration Options

attribute name | description
--- | ---
`key_id` | The s3 user's *Access Key Id*.
`key_secret` | The s3 user's *Access Key Secret*.
`region` | The s3 region.
`bucket` | The s3 bucket (top-level directory) name.
`secret_phrase` | The phrase to use when encrypting and decrypting files.
`files` | A list of local file paths to be synced.
`downloads_dir` | A staging directory to house downloaded files. Defaults to *~Desktop/s3-downloads*.

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
