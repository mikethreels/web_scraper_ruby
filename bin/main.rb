# frozen_string_literal: true

# !/usr/bin/env ruby

require 'nokogiri'
require 'httparty'
require 'byebug'
require_relative '../lib/process.rb'

url = 'https://www.bol.com/nl/s/?page=1&searchtext=programmeren&view=list&N=8299'
web_data = ArticleProcess.new(url)

p arr = web_data.receive_data
