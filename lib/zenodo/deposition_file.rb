require 'forwardable'
require 'json'

module Zenodo
  class DepositionFile

    extend Forwardable

    attr_reader :id, :deposition
    def_delegators :@deposition, :client

    def initialize(deposition, id, metadata = nil)
      @deposition = deposition
      @id = id
      @details = metadata
    end

    def self.create(client, deposition, file)
      response = client.post(collection_path(deposition), body: file, content_type: 'multipart/form-data')
      hash = JSON.parse(response)
      new(deposition, hash['id'], hash)
    end

    def self.list(client, deposition)
      client.get(collection_path(deposition))
    end

    def self.sort(client, deposition, order)
      order.map! do |ob|
        ob = ob.id if ob.is_a?(Zenodo::DepositionFile)
        { id: ob.to_s }
      end

      client.put(collection_path(deposition), body: order)
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

    def metadata
      @details ||= retrieve
    end

    def reload
      @details = retrieve
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
