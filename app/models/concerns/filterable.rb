module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter_by(filtering_params)
      results = self.where(nil)
      filtering_params.each do |key, value|
        results = results.send(key, value) if value
      end
      results
    end
  end
end