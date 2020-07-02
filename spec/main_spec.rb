require_relative '../lib/url_check.rb'
require 'nokogiri'
require 'open-uri'

describe CheckUrl do
  describe '#check_url' do
    let(:wrong_url) { 'https://www.bl.com/nl/s/?page=1&searchtext=programmeren&view=list&filter_N=7289&N=8299&rating=all' }
    let(:right_url) { 'https://www.bol.com/nl/s/?page=1&searchtext=programmeren&view=list&filter_N=7289&N=8299&rating=all' }
    let(:wrong_return) { 'Oops! wrong URL given' }
    it 'checks what to return if URL is correct' do
      expect(CheckUrl.check_url(right_url)).to eql(false)
    end
    it 'checks what to return if URL is wrong' do
      expect(CheckUrl.check_url(wrong_url)).to eql(true)
    end
  end
end
