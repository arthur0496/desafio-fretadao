class RenameShortenedUrlToShortUrl < ActiveRecord::Migration[6.0]
  def self.up
    rename_column :profiles, :shortened_url, :short_url
  end

  def self.down
    rename_column :profiles, :short_url, :shortened_url
  end
end
