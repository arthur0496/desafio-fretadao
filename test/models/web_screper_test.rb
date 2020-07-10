require 'test_helper'
# require './lib/exceptions.rb'
require './app/models/profile'

# class that contains unit tests for WebScraper
class WebScreperTest < ActiveSupport::TestCase
  setup do
    html_path = 'test/fixtures/files/github_page_without_optionals.html'
    html = Rails.root.join(html_path)
    @web_screper = WebScreper.new(html)

    html_with_optionals_path = 'test/fixtures/files/github_page_with_optionals.html'
    html_with_optionals = Rails.root.join(html_with_optionals_path)
    @web_screper_with_optionals = WebScreper.new(html_with_optionals)
  end

  test 'raise exception when not a github user page' do
    html_path = 'test/fixtures/files/github_rep_page.html'
    html = Rails.root.join(html_path)
    assert_raise Exceptions::WebScreppingError do
      WebScreper.new(html)
    end
  end

  test 'finds github username' do
    github_username = @web_screper.find_username
    assert_instance_of String, github_username
  end

  test 'finds profile image' do
    profile_image = @web_screper.find_profile_image
    assert_instance_of String, profile_image
  end

  test 'finds followers' do
    followers = @web_screper.find_followers
    assert_instance_of Integer, followers
  end

  test 'finds followers with abreviation' do
    followers = @web_screper_with_optionals.find_followers
    assert_instance_of Integer, followers
  end

  test 'finds following' do
    following = @web_screper.find_following
    assert_instance_of Integer, following
  end

  test 'finds stars' do
    stars = @web_screper.find_stars
    assert_instance_of Integer, stars
  end

  test 'finds organization' do
    organization = @web_screper_with_optionals.find_organization
    assert_instance_of String, organization
  end

  test 'return nil when do not finds organization' do
    organization = @web_screper.find_organization
    assert_nil organization
  end

  test 'finds location' do
    location = @web_screper_with_optionals.find_location
    assert_instance_of String, location
  end

  test 'return nil when do not finds location' do
    location = @web_screper.find_location
    assert_nil location
  end

  # email tests
  # test 'finds email' do
  #     email = @web_screper_with_optionals.find_email
  #     assert_instance_of String, email
  # end

  # test 'return nil when do not finds email' do
  #     email = @web_screper.find_email
  #     assert_nil location
  # end

  test 'finds contributions' do
    contributions = @web_screper.find_contributions
    assert_instance_of Integer, contributions
  end
end
