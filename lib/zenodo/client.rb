require 'rest-client'

module Zenodo
  class Client
    BASE = "https://zenodo.org/api/"

    def initialize(base = BASE)
      @base = RestClient::Resource.new(base)
    end

  end
end
