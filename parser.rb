require 'rubygems'
require 'sinatra/base'
require 'sinatra/contrib'

class Log
	def initialize(path)
		file = File.open(path, "r") #Load the log file
    rows = file.readlines #Seperate each line of the log file for iteration
    @full_log = Array.new
    @all_views = Hash.new(0)
    rows.each_with_index do |row, i|
      webpage, ip = row.match(/^([a-z0-9_\/]+) (([0-9]{3}\.){3}[0-9]{3})$/).captures #Separates the page and IP address into variables
      @full_log[i+1] = {"webpage": webpage, "ip": ip} #Build array from log file
      @all_views[webpage] += 1 #Populate hash to get total view count for each page
    end
	end

  def all_views
    return @all_views.sort_by { |page, views| views }.reverse.to_h #Return an ordered hash of total views
  end

  def unique_views
    @unique_page_views = Hash.new(0)
    @full_log.uniq.each do |entry| #Dedupe and iterate through full log
      @unique_page_views[entry[:webpage]] += 1 unless entry.nil? #Populate hash to get unique views for each page
    end
    return @unique_page_views.sort_by { |page, views| views }.reverse.to_h #Return an ordered hash of unique views
  end
end

class LogReport < Sinatra::Base
  set :bind, '0.0.0.0'
  register Sinatra::Contrib

  get '/' do #Output the report to the web browser
  	@log = Log.new("./webserver.log")
    erb :index
  end

end