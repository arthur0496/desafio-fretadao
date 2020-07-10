require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  setup do
    @valid_username = profiles(:one).username
    @valid_github_url = profiles(:one).github_url

  end

  test "create valid profile" do
    profile = Profile.new(username: @valid_username, github_url: @valid_github_url)
    profile.valid?
    assert_empty profile.errors
  end

  test "refuse profile without username" do
    profile = Profile.new(github_url: @valid_github_url)
    profile.valid?
    assert_not profile.errors[:username].empty?
  end

  test "refuse profile with blank username" do
    profile = Profile.new(username: ' ',github_url: @valid_github_url)
    profile.valid?
    assert_not profile.errors[:username].empty?
  end

  test "refuse profile without github_url" do
    profile = Profile.new(username: @valid_username)
    profile.valid?
    assert_not profile.errors[:github_url].empty?
  end

  test "refuse profile with blank github_url" do
    profile = Profile.new(username: @valid_username, github_url: ' ')
    profile.valid?
    assert_not profile.errors[:github_url].empty?
  end

  test "accept valid github_url with https" do
    profile = Profile.new(username: @valid_username,
      github_url: "https://github.com/arthur0496")
    profile.valid?
    assert_empty profile.errors[:github_url]
  end

  test "accept valid github_url with http" do
    profile = Profile.new(username: @valid_username, 
      github_url: "http://github.com/arthur0496")
    profile.valid?
    assert_empty profile.errors[:github_url]
  end

  test "accept valid github_url with www" do
    profile = Profile.new(username: @valid_username, 
      github_url: "https://www.github.com/arthur0496")
    profile.valid?
    assert_empty profile.errors[:github_url]
  end

  test "refuse invalid github_url without http or https" do
    profile = Profile.new(username: @valid_username, 
      github_url: "github.com/arthur0496")
    profile.valid?
    assert_not profile.errors[:github_url].empty?
  end

  test "refuse invalid github_url without user" do
    profile = Profile.new(username: @valid_username, 
      github_url: "http://github.com/")
    profile.valid?
    assert_not profile.errors[:github_url].empty?
  end

  test "refuse invalid github_url with another domain" do
    profile = Profile.new(username: @valid_username, 
      github_url: "https://www.gitlab.com/arthur0496")
    profile.valid?
    assert_not profile.errors[:github_url].empty?
  end

  test "refuse invalid github_url for repository" do
    profile = Profile.new(username: @valid_username, 
      github_url: "https://www.github.com/arthur0496/desafio-fretadao")
    profile.valid?
    assert_not profile.errors[:github_url].empty?
  end

  test "shorten_url method updates short_url" do

    mock = Minitest::Mock.new
    def mock.shorten(long_url)
      self
    end
    def mock.link; "https://bit.ly/SHORTURL"; end

    Bitly::API::Client.stub :new, mock do
      profile = profiles(:one)
      profile.shorten_url
      assert profile.short_url == "https://bit.ly/SHORTURL"
    end
  end

  test "shorten url method saves short_url" do

    mock = Minitest::Mock.new
    def mock.shorten(long_url)
      self
    end

    def mock.link; "https://bit.ly/SHORTURL"; end

    Bitly::API::Client.stub :new, mock do
      profile = profiles(:one)
      profile.shorten_url
      assert profile.short_url == "https://bit.ly/SHORTURL"
    end
  end

end