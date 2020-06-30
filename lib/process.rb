require 'nokogiri'
require 'open-uri'

# all processes in this class will convert the html to readable string
class ArticleProcess
  attr_reader :unprosessed_page, :prosessed_page, :prosessed_articles

  def initialize(url)
    @unprosessed_page = URI.open(url)
    @prosessed_page = Nokogiri::HTML(@unprosessed_page)
    @prosessed_articles = @prosessed_page.css('div.product-item__content')
    @articles_per_page = @prosessed_articles.count
    @total_articles = prosessed_page.css('p.total-results').children.text.split(' ')[0].to_i
    @number_pages = (@total_articles / @articles_per_page.to_f).ceil
  end

  # this method selects the page from which the information is being pulled and calls receive data method
  def next_page
    @count = 0
    page = 1
    @all_arr = [{}]
    while page <= @number_pages
      @url = "https://www.bol.com/nl/s/?page=#{page}&searchtext=programmeren&view=list&filter_N=7289&N=8299&rating=all"
      @pre_unprosessed_page = URI.open(@url)
      @pre_prosessed_page = Nokogiri::HTML(@pre_unprosessed_page)
      @pre_prosessed_articles = @pre_prosessed_page.css('div.product-item__content')
      receive_data(@pre_prosessed_articles)
      page += 1
    end
    @all_arr
  end

  # this method pulls the information from the page
  def receive_data(pre_prosessed_articles)
    pre_prosessed_articles.each do |book_article|
      book = {
        title: book_article.css('a.product-title').text,
        price: book_article.css('div.price-block__highlight').text.split.join(' ').gsub!(/\s/, ','),
        availability: (if book_article.css('div.product-delivery-highlight').text.empty?
                         'niet op voorraad'
                       else
                         book_article.css('div.product-delivery-highlight').text
                       end),
        link: 'bol.com' + book_article.css('a')[0].attributes['href'].value
      }

      @all_arr[@count] = book
      @count += 1
    end
    @all_arr
  end

  # this method checks if the answer the user gave is between 1 and 5
  def process_ans(ans)
    until ans.to_i.between?(1, 5)
      puts 'enter a number between 1 and 5'
      ans = gets.chomp
    end
    ans
  end

  # this method checks if the answer the user gave equals 1
  def ans_one(arr)
    keys_to_extract = [:title]
    arr.map do |w|
      w.select { |k, _| keys_to_extract.include? k }
    end
  end

  # this method checks if the answer the user gave equals 2
  def ans_two(arr)
    keys_to_extract = %i[title price]
    arr.map do |w|
      w.select { |k, _| keys_to_extract.include? k }
    end
  end

  # this method checks if the answer the user gave equals 3
  def ans_three(arr)
    keys_to_extract = %i[title link]
    arr.map do |w|
      w.select { |k, _| keys_to_extract.include? k }
    end
  end

  # this method checks if the answer the user gave equals 4
  def ans_four(arr)
    keys_to_extract = %i[title availability]
    arr.map do |w|
      w.select { |k, _| keys_to_extract.include? k }
    end
  end
end
