# s3_sync

Securely upload and download development environment configuration files from [AWS s3](http://aws.amazon.com/s3).

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

Create an AWS IAM user. Note the access credentials: "Access Key Id" and "Secret Access Key".

Create an AWS IAM group.

Create an AWS IAM policy with **arn:aws:iam::aws:policy/AmazonS3FullAccess**.

Attach the policy to the group.

Add the user to the group.

## Usage

Use the same options when uploading and downloading.

### Uploading

Upload files from your computer to s3.

```` rb
S3Sync::Upload.new(
  :key_id => "mykey123",
  :key_secret => "secret456",
  :region => "us-east-1",
  :bucket => "my-backups",
  :secret_phrase => "my-s3cr3t",
  :files => [
    "#{Dir.home}/.bash_profile",
    "#{Dir.home}/.gitconfig",
    "#{Dir.home}/.ssh/id_rsa.pub"
  ]
)
````

Files are stored in the **latest backups directory** which is named after the date (*YYYY-MM-DD*) of backup.

### Downloading

Download previously-uploaded files from s3 to a staging directory on your desktop for further action. The staging directory helps mitigate the risk of accidentally over-writing your local files.

```` rb
S3Sync::Download.new(
  :key_id => "mykey123",
  :key_secret => "secret456",
  :region => "us-east-1",
  :bucket => "my-backups",
  :secret_phrase => "my-s3cr3t",
  :files => [
    "#{Dir.home}/.bash_profile",
    "#{Dir.home}/.gitconfig",
    "#{Dir.home}/.ssh/id_rsa.pub"
  ]
)
````

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
