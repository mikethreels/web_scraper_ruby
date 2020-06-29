# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

# all processes in this class will convert the html to readable string
class ArticleProcess
  attr_reader :url, :unprosessed_page, :prosessed_page, :prosessed_articles

  def initialize(url)
    @url = url
    @unprosessed_page = URI.open(@url)
    @prosessed_page = Nokogiri::HTML(@unprosessed_page)
    @prosessed_articles = @prosessed_page.css('div.product-item__content')
    @arr = []
  end

  def receive_data
    @prosessed_articles.each do |book_article|
      book = {
        title: book_article.css('a.product-title').text,
        price: book_article.css('div.price-block__highlight').text.split.join(' ').gsub!(/\s/, ','),
        availability: book_article.css('div.product-delivery-highlight').text,
        link: 'bol.com' + book_article.css('a')[0].attributes['href'].value
      }
      @arr << book
    end
    @arr
  end
end
