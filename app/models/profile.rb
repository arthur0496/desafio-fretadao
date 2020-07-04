require 'open-uri'
require 'nokogiri'

class Profile < ApplicationRecord
    validates :name, :github_url, presence: true
    before_create :get_github_info

    def get_github_info
        doc = URI.open(self.github_url)
        parse_page = Nokogiri::HTML(doc)
        
        user_card = parse_page.at_css('div[class="h-card mt-4 mt-md-n5"]')
        
        self.github_username = user_card.at_css('span[class="p-nickname vcard-username d-block"]').content
        self.profile_image_url = user_card.at_css('img[class="avatar avatar-user width-full border bg-white"]')['src']
        
        self.followers = user_card.at('a:contains("followers")').at_css('span[class="text-bold text-gray-dark"]').content.to_i
        self.following = user_card.at('a:contains("following")').at_css('span[class="text-bold text-gray-dark"]').content.to_i
        self.stars = user_card.at_css('svg[class="octicon octicon-star text-gray-light"]').parent.at_css('span').content.to_i
        
        organization_icon = user_card.at_css('svg[class="octicon octicon-organization"]')
        if organization_icon
            self.organization = organization_icon.parent.at_css('span').content
        end
        
        location_icon = user_card.at_css('svg[class="octicon octicon-location"]')
        if location_icon
            self.location = location_icon.parent.at_css('span').content
            
        end    
        
        contributions_string = parse_page.at_css('div[class="js-yearly-contributions"]').at('h2:contains("contributions")').content
        self.contributions = contributions_string.split(' ').first.to_i
    end
end




      
  