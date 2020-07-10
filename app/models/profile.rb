require 'open-uri'
require './lib/exceptions.rb'

class Profile < ApplicationRecord
  include Filterable

  validates :username, :github_url, presence: true, allow_blank: false
  validates :github_url,
            format: {
              with: %r/\A((https|http):\/\/)(www\.)?github\.com\/[a-z\d](?:[a-z\d]|-(?=[a-z\d])){0,38}\/?\z/i
            },
            length: { within: 19..62 }

  validates :username, length: { within: 1..50 }

  before_create :update_github_info
  before_save :shorten_url, if: :will_save_change_to_github_url?

  scope :github_username, ->(github_username) {
    where('lower(github_username) like ?', "%#{github_username.downcase}%")
  }
  scope :username, ->(username) {
    where('lower(username) like ?', "%#{username.downcase}%")
  }
  scope :organization, ->(organization) {
    where('lower(organization) like ?', "%#{organization.downcase}%")
  }
  scope :location, ->(location) {
    where('lower(location) like ?', "%#{location.downcase}%")
  }

  def update_github_info
    web_scrapper = WebScrapper.new(github_url)

    self.github_username = web_scrapper.find_username
    self.profile_image_url = web_scrapper.find_profile_image
    self.followers = web_scrapper.find_followers
    self.following = web_scrapper.find_following
    self.stars = web_scrapper.find_stars
    self.organization = web_scrapper.find_organization
    self.location = web_scrapper.find_location
    # self.email = web_scrapper.find_email
    self.contributions = web_scrapper.find_contributions
  rescue Exceptions::WebScrapingError
    errors.add(:base, "Could not web scrape the page #{github_url}")
    throw :abort
  end

  def shorten_url
    client = Bitly::API::Client.new(token: ENV['BITLY_TOKEN'])
    bitlink = client.shorten(long_url: github_url)
    self.short_url = bitlink.link
  end
end

class WebScrapper
  def initialize(url)
    @url = url

    begin
      doc = URI.open(url)
    rescue OpenURI::HTTPError
      errors.add(:base, "Could not connect to #{url}")
      throw :abort
    end

    @parsed_page = Nokogiri::HTML(doc)
    user_card = @parsed_page.at_css('div[class="h-card mt-4 mt-md-n5"]')
    @user_card = user_card
    raise Exceptions::WebScrapingError if @user_card.nil?
  end

  def find_username
    username_search_str = 'span[class="p-nickname vcard-username d-block"]'
    username_span = @user_card.at_css(username_search_str)
    username = username_span.content
    raise Exceptions::WebScrapingError if username.nil?

    username
  rescue NoMethodError
    raise Exceptions::WebScrapingError
  end

  def find_profile_image
    image_search_class = 'avatar avatar-user width-full border bg-white'
    image_search_string = "img[class=\"#{image_search_class}\"]"
    profile_image = @user_card.at_css(image_search_string)['src']
    raise Exceptions::WebScrapingError if profile_image.nil?

    profile_image
  rescue NoMethodError
    raise Exceptions::WebScrapingError
  end

  def find_followers
    followers_anchor = @user_card.at('a:contains("followers")')
    followers_span_search_str = 'span[class="text-bold text-gray-dark"]'
    followers_span = followers_anchor.at_css(followers_span_search_str)
    followers_string = followers_span.content
    followers = convet_abbreviated_string_int(followers_string)
    raise Exceptions::WebScrapingError if followers.nil?

    followers
  rescue NoMethodError
    raise Exceptions::WebScrapingError
  end

  def find_following
    following_anchor = @user_card.at('a:contains("following")')
    followers_span_search_str = 'span[class="text-bold text-gray-dark"]'
    following_span = following_anchor.at_css(followers_span_search_str)
    following_string = following_span.content
    following = convet_abbreviated_string_int(following_string)
    raise Exceptions::WebScrapingError if following.nil?

    following
  rescue NoMethodError
    raise Exceptions::WebScrapingError
  end

  def find_stars
    stars_icon_search_str = 'svg[class="octicon octicon-star text-gray-light"]'
    stars_icon = @user_card.at_css(stars_icon_search_str)
    stars_span = stars_icon.parent.at_css('span')
    stars_string = stars_span.content
    stars = convet_abbreviated_string_int(stars_string)
    raise Exceptions::WebScrapingError if stars.nil?

    stars
  rescue NoMethodError
    raise Exceptions::WebScrapingError
  end

  def find_organization
    organization_icon_search_str = 'svg[class="octicon octicon-organization"]'
    organization_icon = @user_card.at_css(organization_icon_search_str)
    organization_icon.parent.at_css('span').content unless organization_icon.nil?
  rescue NoMethodError
    raise Exceptions::WebScrapingError
  end

  def find_location
    location_icon_seach_str = 'svg[class="octicon octicon-location"]'
    location_icon = @user_card.at_css(location_icon_seach_str)
    location_icon.parent.at_css('span').content unless location_icon.nil?
  rescue NoMethodError
    raise Exceptions::WebScrapingError
  end

  # github does not show email to non signed in users
  def find_email
    mail_icon_search_str = 'svg[class="octicon octicon-mail"]'
    mail_icon = @user_card.at_css(mail_icon_search_str)
    mail_icon.parent.at_css('a').content unless mail_icon.nil?
  rescue NoMethodError
    raise Exceptions::WebScrapingError
  end

  def find_contributions
    contributions_div_search_str = 'div[class="js-yearly-contributions"]'
    contributions_div = @parsed_page.at_css(contributions_div_search_str)
    contributions_h2 = contributions_div.at('h2:contains("contributions")')
    contributions_string = contributions_h2.content
    contributions_string = contributions_string.split(' ').first
    contributions = contributions_string.delete(',').to_i
    raise Exceptions::WebScrapingError if contributions.nil?

    contributions
  rescue NoMethodError
    raise Exceptions::WebScrapingError
  end

  def convet_abbreviated_string_int(string_number)
    case string_number[-1]
    when 'k'
      number_float = string_number.to_f * 1000
      number_float.to_i
    else
      string_number.to_i
    end
  end
end
