require_relative '../lib/process.rb'
require 'nokogiri'
require 'open-uri'

describe ArticleProcess do
  let(:url) {'https://www.bol.com/nl/s/?page=1&searchtext=programmeren&view=list&filter_N=7289&N=8299&rating=all'}
  let(:unprosessed_page) { URI.open(url) }
  let(:prosessed_page) { Nokogiri::HTML(unprosessed_page) }
  let(:prosessed_articles) { prosessed_page.css('div.product-item__content') }
  let(:web_data) { ArticleProcess.new(url) }
  let(:check_arr) { {:title=>"FRONTEND PROGRAMMEREN", :price=>"37,95", :availability=>"Op voorraad", :link=>"bol.com/nl/b/edu-actief/2959366/"} }
  
  describe '#next_page' do
    it 'check if the returned data is the right format' do
      expect(web_data.next_page).to be_an_instance_of(Array)
    end

    it 'check if the returned data contains the right information' do
      expect(web_data.next_page.first).to eql(check_arr)
    end
  end

  describe '#receive_data' do
    it 'check if the returned data is the right format' do
      expect(web_data.receive_data(prosessed_articles)).to be_an_instance_of(Array)
    end
  end
end
