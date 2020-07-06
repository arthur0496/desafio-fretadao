class AddShortendUrlToProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :profiles, :shortened_url, :string
  end
end
