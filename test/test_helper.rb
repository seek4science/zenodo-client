require 'vcr'
require 'test/unit'
require 'zenodo-client'
require 'coveralls'

Coveralls.wear!

VCR.configure do |config|
  config.cassette_library_dir = "test/cassettes"
  config.hook_into :webmock
end
