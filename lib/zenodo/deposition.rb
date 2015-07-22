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
      response = client.post(collection_path, body: body)
      hash = JSON.parse(response)
      new(client, hash['id'], hash)
    end

    def self.list(client)
      client.get(collection_path)
    end

    def retrieve
      response = client.get(member_path)
      JSON.parse(response)
    end

    def update(body)
      client.put(member_path, body: body)
    end

    def delete
      client.delete(member_path)
    end

    def create_file(body)
      Zenodo::DepositionFile.create(client, self, body)
    end

    def list_files
      Zenodo::DepositionFile.list(client, self)
    end

    def file(id)
      Zenodo::DepositionFile.new(self, id)
    end

    def details
      @details ||= retrieve
    end

    def reload
      @details = retrieve
    end

    private

    def member_path
      "#{self.class.collection_path}/#{id}"
    end

    def self.collection_path
      PATH
    end

  end
end
