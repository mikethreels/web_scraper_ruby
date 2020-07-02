require 'nokogiri'
require 'open-uri'

module CheckUrl
  def self.check_url(url)
    test_url = url
    begin
      unprosessed_page = URI.open(test_url)
      false
    rescue StandardError => e
      puts 'Oops! wrong URL given'
      true
    end
  end
end
