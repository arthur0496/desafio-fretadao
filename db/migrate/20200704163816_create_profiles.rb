class CreateProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :github_url
      t.string :github_username
      t.integer :follower
      t.integer :following
      t.integer :stars
      t.integer :contributions
      t.string :profile_image_url
      t.string :organization
      t.string :location
      t.string :email

      t.timestamps
    end
  end
end
