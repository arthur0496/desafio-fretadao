module Filterable
  extend ActiveSupport::Concern

  module ClassMethods
    def filter_by(filtering_params, value)
      all_objects = self.where(nil)
      results = []
      for key in filtering_params
        if results
          results += (all_objects.send(key, value))
        else
          results = all_objects.send(key, value)
        end
      end
      results
    end
  end
end