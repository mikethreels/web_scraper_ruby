# frozen_string_literal: false

# this file containes the class with all processes

require 'nokogiri'
require 'open-uri'

# all processes in this class will convert the html to readable string
class ArticleProcess
  attr_reader :url, :unprosessed_page, :prosessed_page, :prosessed_articles

  def initialize(url)
    @unprosessed_page = URI.open(url)
    @prosessed_page = Nokogiri::HTML(@unprosessed_page)
    @prosessed_articles = @prosessed_page.css('div.product-item__content')
    @articles_per_page = @prosessed_articles.count
    @total_articles = prosessed_page.css('p.total-results').children.text.split(' ')[0].to_i
    @number_pages = (@total_articles / @articles_per_page.to_f).ceil
  end

  def next_page
    @count = 0
    page = 1
    @all_arr = [{}]
    while page <= @number_pages
      @url = "https://www.bol.com/nl/s/?page=#{page}&searchtext=programmeren&view=list&filter_N=7289&N=8299&rating=all"
      @pre_unprosessed_page = URI.open(@url)
      @pre_prosessed_page = Nokogiri::HTML(@pre_unprosessed_page)
      receive_data
      p "retreiving page #{page}"
      page += 1
    end
    @all_arr
  end

  def receive_data
    @pre_prosessed_articles = @pre_prosessed_page.css('div.product-item__content')
    @pre_prosessed_articles.each do |book_article|
      book = {
        title: book_article.css('a.product-title').text,
        price: book_article.css('div.price-block__highlight').text.split.join(' ').gsub!(/\s/, ','),
        availability: book_article.css('div.product-delivery-highlight').text,
        link: 'bol.com' + book_article.css('a')[0].attributes['href'].value
      }

      @all_arr[@count] = book
      @count += 1
    end
  end
end
