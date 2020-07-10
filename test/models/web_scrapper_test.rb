require 'test_helper'
# require './lib/exceptions.rb'
require './app/models/profile'

# class that contains unit tests for WebScraper
class WebScrapperTest < ActiveSupport::TestCase
  setup do
    html_path = 'test/fixtures/files/github_page_without_optionals.html'
    html = Rails.root.join(html_path)
    @web_scrapper = WebScrapper.new(html)

    html_with_optionals_path = 'test/fixtures/files/github_page_with_optionals.html'
    html_with_optionals = Rails.root.join(html_with_optionals_path)
    @web_scrapper_with_optionals = WebScrapper.new(html_with_optionals)
  end

  test 'raise exception when not a github user page' do
    html_path = 'test/fixtures/files/github_rep_page.html'
    html = Rails.root.join(html_path)
    assert_raise Exceptions::WebScrapingError do
      WebScrapper.new(html)
    end
  end

  test 'finds github username' do
    github_username = @web_scrapper.find_username
    assert_instance_of String, github_username
  end

  test 'finds profile image' do
    profile_image = @web_scrapper.find_profile_image
    assert_instance_of String, profile_image
  end

  test 'finds followers' do
    followers = @web_scrapper.find_followers
    assert_instance_of Integer, followers
  end

  test 'finds followers with abreviation' do
    followers = @web_scrapper_with_optionals.find_followers
    assert_instance_of Integer, followers
  end

  test 'finds following' do
    following = @web_scrapper.find_following
    assert_instance_of Integer, following
  end

  test 'finds stars' do
    stars = @web_scrapper.find_stars
    assert_instance_of Integer, stars
  end

  test 'finds organization' do
    organization = @web_scrapper_with_optionals.find_organization
    assert_instance_of String, organization
  end

  test 'return nil when do not finds organization' do
    organization = @web_scrapper.find_organization
    assert_nil organization
  end

  test 'finds location' do
    location = @web_scrapper_with_optionals.find_location
    assert_instance_of String, location
  end

  test 'return nil when do not finds location' do
    location = @web_scrapper.find_location
    assert_nil location
  end

  # email tests
  # test 'finds email' do
  #     email = @web_scrapper_with_optionals.find_email
  #     assert_instance_of String, email
  # end

  # test 'return nil when do not finds email' do
  #     email = @web_scrapper.find_email
  #     assert_nil location
  # end

  test 'finds contributions' do
    contributions = @web_scrapper.find_contributions
    assert_instance_of Integer, contributions
  end
end
