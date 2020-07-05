require 'open-uri'
require 'nokogiri'

class Profile < ApplicationRecord
    validates :name, :github_url, presence: true
    before_create :get_github_info

    def get_github_info
        doc = URI.open(self.github_url)
        parsed_page = Nokogiri::HTML(doc)

        user_card = parsed_page.at_css('div[class="h-card mt-4 mt-md-n5"]')
        
        self.github_username = find_username(user_card)

        self.profile_image_url = find_profile_image(user_card)
        
        self.followers = find_followers(user_card)

        self.following = find_following(user_card)

        self.stars = find_stars(user_card)
        
        self.organization = find_organization(user_card)
        
        self.location = find_location(user_card)

        self.email = find_email(user_card)
        
        self.contributions = find_contributions(parsed_page)
    end
end

def find_username(user_card)
    username_search_str = 'span[class="p-nickname vcard-username d-block"]'
    username_span = user_card.at_css(username_search_str)
    username = username_span.content
end

def find_profile_image(user_card)
    image_search_class = 'avatar avatar-user width-full border bg-white'
    image_search_string = "img[class=\"#{image_search_class}\"]"
    profile_image = user_card.at_css(image_search_string)['src']
end

def find_followers(user_card)
    followers_anchor = user_card.at('a:contains("followers")')
    followers_span_search_str = 'span[class="text-bold text-gray-dark"]'
    followers_span = followers_anchor.at_css(followers_span_search_str)
    followers_string = followers_span.content
    followers = convet_abbreviated_string_int(followers_string)
end

def find_following(user_card)
    following_anchor = user_card.at('a:contains("following")')
    followers_span_search_str = 'span[class="text-bold text-gray-dark"]'
    following_span = following_anchor.at_css(followers_span_search_str)
    following_string = following_span.content
    following = convet_abbreviated_string_int(following_string)
end

def find_stars(user_card)
    stars_icon_search_str = 'svg[class="octicon octicon-star text-gray-light"]'
    stars_icon = user_card.at_css(stars_icon_search_str)
    stars_span = stars_icon.parent.at_css('span')
    stars_string = stars_span.content
    stars = convet_abbreviated_string_int(stars_string)
end

def find_organization(user_card)
    organization_icon_search_str = 'svg[class="octicon octicon-organization"]'
    organization_icon = user_card.at_css(organization_icon_search_str)
    if organization_icon
        ornganization = organization_icon.parent.at_css('span').content
    end
end

def find_location(user_card)
    location_icon_seach_str = 'svg[class="octicon octicon-location"]'
    location_icon = user_card.at_css(location_icon_seach_str)
    if location_icon
        location = location_icon.parent.at_css('span').content
    end
end

# github does not show email to non signed in users
def find_email(user_card)
    mail_icon_search_str = 'svg[class="octicon octicon-mail"]'
    mail_icon = user_card.at_css(mail_icon_search_str)
    if mail_icon
        email = mail_icon.parent.at_css('a').content
    end
end


def find_contributions(parsed_page)
    contributions_div_search_str = 'div[class="js-yearly-contributions"]'
    contributions_div = parsed_page.at_css(contributions_div_search_str)
    contributions_h2 = contributions_div.at('h2:contains("contributions")')
    contributions_string = contributions_h2.content
    contributions_string = contributions_string.split(' ').first
    puts("*"*100)
    puts(contributions_string)
    puts(contributions_string.delete(','))
    contributions = contributions_string.delete(',').to_i
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


      
  