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
      response = client.get(collection_path)

      JSON.parse(response).map do |deposition|
        new(client, deposition['id'], deposition)
      end
    end

    def retrieve
      response = client.get(member_path)
      JSON.parse(response)
    end

    def update(body)
      response = client.put(member_path, body: body)
      @details = JSON.parse(response)

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
