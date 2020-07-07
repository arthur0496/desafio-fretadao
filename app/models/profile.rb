require 'open-uri'
require 'nokogiri'
require './lib/exceptions.rb'

class Profile < ApplicationRecord
    include Filterable

    validates :username, :github_url, presence: true
    before_create :get_github_info
    before_save :shorten_url

    scope :github_username,   -> (github_username) { where("lower(github_username) like ?", "%#{github_username.downcase}%") }
    scope :username,   -> (username) { where("lower(username) like ?", "%#{username.downcase}%") }
    scope :organization,   -> (organization) { where("lower(organization) like ?", "%#{organization.downcase}%") }
    scope :location,   -> (location) { where("lower(location) like ?", "%#{location.downcase}%") }


    def get_github_info

        begin
            web_screper = WebScreper.new(self.github_url)

            self.github_username = web_screper.find_username
            self.profile_image_url = web_screper.find_profile_image
            self.followers = web_screper.find_followers
            self.following = web_screper.find_following
            self.stars = web_screper.find_stars
            self.organization = web_screper.find_organization
            self.location = web_screper.find_location
            # self.email = web_screper.find_email
            self.contributions = web_screper.find_contributions

        rescue Exceptions::WebScreppingError
            errors.add(:base, "Could not web scrape the page #{self.github_url}")
            throw :abort
        end
    end

    def shorten_url
        client = Bitly::API::Client.new(token: ENV['BITLY_TOKEN'])
        bitlink = client.shorten(long_url: self.github_url)
        self.short_url = bitlink.link
    end


end

class WebScreper
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
        if user_card != nil
            @user_card = user_card
        else
            raise Exceptions::WebScreppingError
        end
    end

    def find_username
        begin
            username_search_str = 'span[class="p-nickname vcard-username d-block"]'
            username_span = @user_card.at_css(username_search_str)
            username = username_span.content
            if username != nil
                username
            else
               raise
            end
        rescue
            raise Exceptions::WebScreppingError
        end
    end

    def find_profile_image
        begin
            image_search_class = 'avatar avatar-user width-full border bg-white'
            image_search_string = "img[class=\"#{image_search_class}\"]"
            profile_image = @user_card.at_css(image_search_string)['src']
            if profile_image != nil
                profile_image
            else
                raise
            end
        rescue
            raise Exceptions::WebScreppingError
        end
    end

    def find_followers
        begin
            followers_anchor = @user_card.at('a:contains("followers")')
            followers_span_search_str = 'span[class="text-bold text-gray-dark"]'
            followers_span = followers_anchor.at_css(followers_span_search_str)
            followers_string = followers_span.content
            followers = convet_abbreviated_string_int(followers_string)
            if followers != nil
                followers
            else
                raise
            end
        rescue
            raise Exceptions::WebScreppingError
        end
    end

    def find_following
        begin
            following_anchor = @user_card.at('a:contains("following")')
            followers_span_search_str = 'span[class="text-bold text-gray-dark"]'
            following_span = following_anchor.at_css(followers_span_search_str)
            following_string = following_span.content
            following = convet_abbreviated_string_int(following_string)
            if following != nil
                following
            else
                raise
            end
        rescue
            raise Exceptions::WebScreppingError
        end
    end

    def find_stars
        begin
            stars_icon_search_str = 'svg[class="octicon octicon-star text-gray-light"]'
            stars_icon = @user_card.at_css(stars_icon_search_str)
            stars_span = stars_icon.parent.at_css('span')
            stars_string = stars_span.content
            stars = convet_abbreviated_string_int(stars_string)
            if stars != nil
                stars
            else
                raise
            end
        rescue
            raise Exceptions::WebScreppingError
        end
    end

    def find_organization
        begin
            organization_icon_search_str = 'svg[class="octicon octicon-organization"]'
            organization_icon = @user_card.at_css(organization_icon_search_str)
            if organization_icon
                ornganization = organization_icon.parent.at_css('span').content
            end
        rescue
            raise Exceptions::WebScreppingError
        end
    end

    def find_location
        begin
            location_icon_seach_str = 'svg[class="octicon octicon-location"]'
            location_icon = @user_card.at_css(location_icon_seach_str)
            if location_icon
                location = location_icon.parent.at_css('span').content
            end
        rescue
            raise Exceptions::WebScreppingError
        end
    end

    # github does not show email to non signed in users
    def find_email
        begin
            mail_icon_search_str = 'svg[class="octicon octicon-mail"]'
            mail_icon = @user_card.at_css(mail_icon_search_str)
            if mail_icon
                email = mail_icon.parent.at_css('a').content
            end
        rescue
            raise Exceptions::WebScreppingError
        end
    end

    def find_contributions
        begin
            contributions_div_search_str = 'div[class="js-yearly-contributions"]'
            contributions_div = @parsed_page.at_css(contributions_div_search_str)
            contributions_h2 = contributions_div.at('h2:contains("contributions")')
            contributions_string = contributions_h2.content
            contributions_string = contributions_string.split(' ').first
            contributions = contributions_string.delete(',').to_i
            if contributions != nil
                contributions
            else
                raise
            end
        rescue
            raise Exceptions::WebScreppingError
        end
    end

    def convet_abbreviated_string_int(string_number)
        case string_number[-1]
        when 'k'
            number_float = string_number.to_f * 1000
            number_int = number_float.to_i
        else
            number_int = string_number.to_i
        end
    end
end
