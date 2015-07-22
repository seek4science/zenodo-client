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
      hash = client.post(collection_path(deposition), body: file, content_type: 'multipart/form-data')

      new(deposition, hash['id'], hash)
    end

    def self.list(client, deposition)
      from_list(client.get(collection_path(deposition)))
    end

    def self.sort(client, deposition, order)
      order.map! do |ob|
        ob = ob.id if ob.is_a?(Zenodo::DepositionFile)
        { id: ob.to_s }
      end

      from_list(client.put(collection_path(deposition), body: order))
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

    def details
      @details ||= fetch_details
    end

    private

    def fetch_details
      client.get(member_path)
    end

    def deposition_id
      @deposition.id
    end

    def member_path
      "#{self.class.collection_path(deposition)}/#{id}"
    end

    def self.collection_path(deposition)
      "#{deposition.member_path}/files"
    end

    def self.from_list(list)
      list.map do |deposition_file|
        new(deposition, deposition_file['id'], deposition_file)
      end
    end

  end
end
