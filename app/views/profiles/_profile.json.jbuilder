json.extract! profile, :id, :name, :github_url, :github_username, :followers, :following, :stars, :contributions, :profile_image_url, :organization, :location, :email, :created_at, :updated_at
json.url profile_url(profile, format: :json)
