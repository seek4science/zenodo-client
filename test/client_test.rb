require 'test_helper'

class ClientTest < Test::Unit::TestCase

  def setup
    @access_token = 'notarealaccesstoken'
  end

  def test_client_base_uri_defaults
    client = Zenodo::Client.new(@access_token)

    assert_equal Zenodo::Client::BASE, client.base.url
  end

  def test_client_base_uri_can_be_set
    uri = 'https://alpaca-farming-tips.golf'
    client = Zenodo::Client.new(@access_token, uri)

    assert_equal uri, client.base.url
  end

  def test_list_depositions
    client = Zenodo::Client.new(@access_token)

    VCR.use_cassette('list_depositions') do
      assert client.list_depositions.is_a?(Array)
    end
  end

  def test_create_deposition
    client = Zenodo::Client.new(@access_token)

    VCR.use_cassette('create_deposition') do
      deposition = client.create_deposition

      assert deposition.is_a?(Zenodo::Deposition)
      assert deposition.id.is_a?(Fixnum)
      assert deposition.details.is_a?(Hash)
    end
  end

  def test_fetch_deposition
    client = Zenodo::Client.new(@access_token)

    VCR.use_cassette('fetch_deposition') do
      deposition = client.deposition(38762)

      assert deposition.is_a?(Zenodo::Deposition)
      assert deposition.id.is_a?(Fixnum)
      assert deposition.details.is_a?(Hash)
    end
  end

  def test_create_deposition_file
    client = Zenodo::Client.new(@access_token)

    VCR.use_cassette('create_deposition_file') do
      deposition = client.deposition(38762)
      dummy_data = File.open(File.join('test', 'fixtures', 'dummy_data.csv'))
      deposition_file = deposition.create_file(dummy_data)

      assert deposition_file.is_a?(Zenodo::DepositionFile)
      assert !deposition_file.id.nil?
      assert deposition_file.details.is_a?(Hash)
    end
  end

  def test_list_deposition_files
    client = Zenodo::Client.new(@access_token)

    VCR.use_cassette('list_deposition_files') do
      deposition = client.deposition(38762)
      deposition_files = deposition.list_files

      assert deposition_files.is_a?(Array)
      assert_equal 1, deposition_files.size
      assert deposition_files[0].is_a?(Zenodo::DepositionFile)
    end
  end

  def test_fetch_deposition_file
    client = Zenodo::Client.new(@access_token)
    id = '2876f91e-6427-4c09-b56f-f592fa0f492a'

    VCR.use_cassette('fetch_deposition_file') do
      deposition = client.deposition(38762)
      deposition_file = deposition.file(id)

      assert deposition_file.is_a?(Zenodo::DepositionFile)
      assert_equal id, deposition_file.id
      assert deposition_file.details.is_a?(Hash)
    end
  end

end
