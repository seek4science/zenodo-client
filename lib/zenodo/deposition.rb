require 'json'

module Zenodo
  class Deposition

    attr_reader :id, :client

    PATH = 'deposit/depositions'

    def initialize(client, id, metadata = nil)
      @client = client
      @id = id
      @details = metadata
    end

    def self.create(client, body)
      hash = client.post(collection_path, body: body)

      new(client, hash['id'], hash)
    end

    def self.list(client)
      client.get(collection_path).map do |deposition|
        new(client, deposition['id'], deposition)
      end
    end

    def retrieve
      @details = fetch_details

      self
    end

    def update(body)
      @details = client.put(member_path, body: body)

      self
    end

    def delete
      client.delete(member_path)

      true
    end

    def create_file(file)
      Zenodo::DepositionFile.create(client, self, file)
    end

    def list_files
      Zenodo::DepositionFile.list(client, self)
    end

    def file(id)
      Zenodo::DepositionFile.new(self, id)
    end

    def sort_files(order)
      Zenodo::DepositionFile.sort(client, self, order)
    end

    def details
      @details ||= fetch_details
    end

    def publish
      @details = client.post(publish_action_path)

      true
    end

    def unlock
      @details = client.post(edit_action_path)

      true
    end

    def discard
      @details = client.post(discard_action_path)

      true
    end

    def self.collection_path
      PATH
    end

    def member_path
      "#{self.class.collection_path}/#{id}"
    end

    def publish_action_path
      "#{member_path}/actions/publish"
    end

    def edit_action_path
      "#{member_path}/actions/edit"
    end

    def discard_action_path
      "#{member_path}/actions/discard"
    end

    def published?
      details['submitted']
    end

    private

    def fetch_details
      client.get(member_path)
    end

  end
end
