require 'rest-client'
require 'uri'

module Zenodo
  class Client
    BASE = "https://zenodo.org/api"

    attr_reader :base, :access_token

    def initialize(access_token, base = BASE)
      @access_token = access_token
      @base = RestClient::Resource.new(base)
    end

    def deposition(id)
      Zenodo::Deposition.new(self, id)
    end

    def create_deposition
      Zenodo::Deposition.create(self)
    end

    def list_depositions
      Zenodo::Deposition.list(self)
    end

    def get(path, opts = {})
      perform(path, :get, opts)
    end

    def put(path, opts = {})
      perform(path, :put, opts)
    end

    def post(path, opts = {})
      perform(path, :post, opts)
    end

    def delete(path, opts = {})
      perform(path, :delete, opts)
    end

    private

    def perform(path, method, opts = {})
      if (body = opts.delete(:body))
        base[access_path(path)].send(method, body, content_type: 'application/json')
      else
        base[access_path(path)].send(method)
      end
    end

    def access_path(path)
      uri = URI(path)
      access_token_query = "access_token=#{access_token}"
      if uri.query
        uri.query += "&#{access_token_query}"
      else
        uri.query = access_token_query
      end

      uri
    end

  end
end
