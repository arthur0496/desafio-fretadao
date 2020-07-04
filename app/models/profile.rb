require 'open-uri'
require 'nokogiri'

class Profile < ApplicationRecord
    validates :name, :github_url, presence: true
end
