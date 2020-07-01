# !/usr/bin/env ruby

require 'awesome_print'
require 'nokogiri'
require 'byebug'
require_relative '../lib/process.rb'
puts "\e[H\e[2J"
puts "This scraper will get all the new programming books from a webpage called 'Bol.com'
This might take a moment..."

url = 'https://www.bol.com/nl/s/?page=1&searchtext=programmeren&view=list&filter_N=7289&N=8299&rating=all'
web_data = ArticleProcess.new(url)
arr = web_data.next_page

puts "would you like to see:
1. only titles
2. titles and prices
3. titles and links
4. titles and availability
5. all information per book
(please use the number to select an option)?"

case web_data.process_ans(gets.chomp).to_i
when 1
  ap web_data.ans_one(arr)
when 2
  ap web_data.ans_two(arr)
when 3
  ap web_data.ans_three(arr)
when 4
  ap web_data.ans_four(arr)
else
  ap arr
end
