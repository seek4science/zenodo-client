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

    def create_deposition(body = {})
      Zenodo::Deposition.create(self, body)
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

    def post(path, opts = { body: '' })
      perform(path, :post, opts)
    end

    def delete(path, opts = {})
      perform(path, :delete, opts)
    end

    private

    def perform(path, method, opts = {})
      content_type = opts.delete(:content_type) || :json
      body = opts.delete(:body)
      args = [method]
      if body
        body = body.to_json if content_type == :json
        if content_type == :multipart
          args += [body]
        else
          args += [body, content_type: content_type]
        end
      end

      response = base[access_path(path)].send(*args)

      JSON.parse(response) unless response.empty?
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
