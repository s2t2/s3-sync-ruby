require 'spec_helper'

describe S3Sync do
  it 'has a version number' do
    expect(S3Sync::VERSION).not_to be nil
  end
end
