module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter_by(filtering_params, value)
      all_objects = self
      results = nil
      filtering_params.each do |key|
        if results
          results = results.or(all_objects.send(key, value))
        else
          results = all_objects.send(key, value)
        end
      end
      results
    end
  end
end
