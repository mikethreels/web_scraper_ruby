require_relative '../lib/process.rb'
require 'nokogiri'
require 'open-uri'

describe ArticleProcess do
  let(:url) { 'https://www.bol.com/nl/s/?page=1&searchtext=programmeren&view=list&filter_N=7289&N=8299&rating=all' }
  let(:unprosessed_page) { URI.open(url) }
  let(:prosessed_page) { Nokogiri::HTML(unprosessed_page) }
  let(:prosessed_articles) { prosessed_page.css('div.product-item__content') }
  let(:web_data) { ArticleProcess.new(url) }
  let(:check_arr) do
    { title: 'FRONTEND PROGRAMMEREN', price: '37,95', availability: 'Op voorraad',
      link: 'bol.com/nl/b/edu-actief/2959366/' }
  end

  describe '#next_page' do
    context 'this method selects the page from which the information is being pulled and calls #receive_data' do
      it 'check if the returned data is the right format' do
        expect(web_data.next_page).to be_an_instance_of(Array)
      end

      it 'check if the returned data contains the right information' do
        expect(web_data.next_page.first).to eql(check_arr)
      end
    end
  end

  describe '#receive_data' do
    context 'this method processes the information pulled from the page' do
      it 'check if the returned data is the right format' do
        expect(web_data.receive_data(prosessed_articles)).to be_an_instance_of(Array)
      end

      it 'check if the returned data contains the right information' do
        expect(web_data.receive_data(prosessed_articles).first).to eql(check_arr)
      end
    end
  end

  describe '#process_ans' do
    context 'this method checks if the answer the user gave is between 1 and 5' do
      it 'return when answer is between 1 and 5' do
        expect(web_data.process_ans(5)).to be_between(1, 5)
      end

      it 'keeps requesting when answer is not between 1 and 5' do
        expect(web_data.process_ans(7).to_i).to be_between(1, 5)
      end
    end
  end

  describe '#ans_one' do
    it 'returns the title of the first hash in the array of hashes' do
      expect(web_data.ans_one(web_data.next_page)[0]).to eql({ title: 'FRONTEND PROGRAMMEREN' })
    end
  end

  describe '#ans_two' do
    it 'returns the title and price of the first hash in the array of hashes' do
      expect(web_data.ans_two(web_data.next_page)[0]).to eql({ title: 'FRONTEND PROGRAMMEREN', price: '37,95' })
    end
  end

  describe '#ans_three' do
    it 'returns the title and link of the first hash in the array of hashes' do
      expect(web_data.ans_three(web_data.next_page)[0]).to eql({ title: 'FRONTEND PROGRAMMEREN',
                                                                 link: 'bol.com/nl/b/edu-actief/2959366/' })
    end
  end

  describe '#ans_four' do
    it 'returns the title and availability of the first hash in the array of hashes' do
      expect(web_data.ans_four(web_data.next_page)[0]).to eql({ title: 'FRONTEND PROGRAMMEREN',
                                                                availability: 'Op voorraad' })
    end
  end
end
