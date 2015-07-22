module Zenodo
  class DepositionFile

    def initialize(deposition, id)
      @deposition = deposition
      @id = id
    end

    def self.create(deposition)

    end

    def self.list(deposition)

    end

    def retrieve

    end

    def update

    end

    def delete

    end

    private

    def deposition_id
      @deposition.id
    end

  end
end
