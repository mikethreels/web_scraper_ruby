# frozen_string_literal: true

# !/usr/bin/env ruby

require 'pp'
require 'nokogiri'
require 'httparty'
require 'byebug'
require_relative '../lib/process.rb'

url = 'https://www.bol.com/nl/s/?page=1&searchtext=programmeren&view=list&filter_N=7289&N=8299&rating=all'
web_data = ArticleProcess.new(url)

pp arr = web_data.next_page
