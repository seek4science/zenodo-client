module Zenodo
  class Deposition

    attr_reader :id

    PATH = 'deposit/depositions'

    def initialize(client, id)
      @client = client
      @id = id
    end

    def self.create(client)
      client.post(self.collection_path, body: '')
    end

    def self.list(client)
      client.get(self.collection_path)
    end

    def retrieve
      client.get(member_path)
    end

    def update
      client.put(member_path, body: '')
    end

    def delete
      client.delete(member_path)
    end

    def create_file
      Zenodo::DepositionFile.create(client, self)
    end

    def list_files
      Zenodo::DepositionFile.list(client, self)
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
