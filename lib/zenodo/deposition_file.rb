require 'forwardable'

module Zenodo
  class DepositionFile

    extend Forwardable

    attr_reader :id
    def_delegators :@deposition, :client

    def initialize(deposition, id)
      @deposition = deposition
      @id = id
    end

    def self.create(client, deposition)
      client.post(self.collection_path(deposition), body: '')
    end

    def self.list(client, deposition)
      client.get(self.collection_path(deposition))
    end

    def sort
      client.put(member_path, body: '')
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

    private

    def deposition_id
      @deposition.id
    end

    def member_path
      "#{self.class.collection_path(deposition)}/#{id}"
    end

    def self.collection_path(deposition)
      "#{deposition.member_path}/files"
    end

  end
end
