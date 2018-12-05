require 'test_helper'

class ClientTest < Test::Unit::TestCase

  def setup
    @access_token = 'notarealaccesstoken'
    @uri = 'https://sandbox.zenodo.org/api'
    @client = Zenodo::Client.new(@access_token, @uri)
  end

  def test_client_base_uri_defaults
    custom_client = Zenodo::Client.new(@access_token)

    assert_equal Zenodo::Client::BASE, custom_client.base.url
  end

  def test_client_base_uri_can_be_set
    uri = 'https://alpaca-farming-tips.golf'
    custom_client = Zenodo::Client.new(@access_token, uri)

    assert_equal uri, custom_client.base.url
  end

  def test_list_depositions
    VCR.use_cassette('list_depositions') do
      assert @client.list_depositions.is_a?(Array)
    end
  end

  def test_create_deposition
    VCR.use_cassette('create_deposition') do
      deposition = @client.create_deposition

      assert deposition.is_a?(Zenodo::Deposition)
      assert deposition.id.is_a?(Integer)
      assert deposition.details.is_a?(Hash)
    end
  end

  def test_fetch_deposition
    VCR.use_cassette('fetch_deposition') do
      deposition = @client.deposition(38762)

      assert deposition.is_a?(Zenodo::Deposition)
      assert deposition.id.is_a?(Integer)
      assert deposition.details.is_a?(Hash)
    end
  end

  def test_create_deposition_file
    VCR.use_cassette('create_deposition_file') do
      deposition = @client.deposition(38762)
      dummy_data = File.open(File.join('test', 'fixtures', 'dummy_data.csv'))
      deposition_file = deposition.create_file(dummy_data)

      assert deposition_file.is_a?(Zenodo::DepositionFile)
      assert !deposition_file.id.nil?
      assert deposition_file.details.is_a?(Hash)
    end
  end

  def test_list_deposition_files
    VCR.use_cassette('list_deposition_files') do
      deposition = @client.deposition(38762)
      deposition_files = deposition.list_files

      assert deposition_files.is_a?(Array)
      assert_equal 1, deposition_files.size
      assert deposition_files[0].is_a?(Zenodo::DepositionFile)
    end
  end

  def test_fetch_deposition_file
    id = '2876f91e-6427-4c09-b56f-f592fa0f492a'

    VCR.use_cassette('fetch_deposition_file') do
      deposition = @client.deposition(38762)
      deposition_file = deposition.file(id)

      assert deposition_file.is_a?(Zenodo::DepositionFile)
      assert_equal id, deposition_file.id
      assert deposition_file.details.is_a?(Hash)
    end
  end

  def test_publish_deposition
    VCR.use_cassette('publish_deposition') do
      deposition = @client.deposition(1028)
      assert deposition.publish
      assert deposition.published?
    end
  end

  # TODO: Implement VCRs for the following tests
  # def test_edit_published_deposition
  #   @client = Zenodo::Client.new('JptkEVmX94gus8n1BKhfr7QcnaypcOJBFn3YCMqjggvgVZpNdqwCmLZKYkqH', 'https://sandbox.zenodo.org/api')
  #
  #   VCR.use_cassette('unlock_published_deposition') do
  #     deposition = @client.deposition(1028)
  #     assert deposition.unlock
  #
  #     puts deposition.details
  #   end
  # end
  #
  # def test_discard_published_deposition_changes
  #   @client = Zenodo::Client.new('JptkEVmX94gus8n1BKhfr7QcnaypcOJBFn3YCMqjggvgVZpNdqwCmLZKYkqH', 'https://sandbox.zenodo.org/api')
  #
  #   VCR.use_cassette('discard_deposition_changes') do
  #     deposition = @client.deposition(1028)
  #     assert deposition.discard
  #
  #     puts deposition.details
  #   end
  # end

end
