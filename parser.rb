require 'rubygems'
require 'sinatra/base'
require 'sinatra/contrib'

class Log
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def file
    File.open(path, "r")
  end

  def rows
    return @_rows if defined? @_rows
    @_rows = file.readlines
  end

  def parsed_log
    return @_parsed_log if defined? @_parsed_log
    @_parsed_log = begin
      parsed_log = []
      rows.each do |row|
        webpage, ip = row.match(/^([a-z0-9_\/]+) (([0-9]{3}\.){3}[0-9]{3})$/).captures
        parsed_log << {"webpage": webpage, "ip": ip}
      end
      parsed_log
    end
  end

  def all_views
    all_views = Hash.new(0)
    parsed_log.map do |entry|
      all_views[entry[:webpage]] += 1
    end
    all_views.sort_by { |page, views| views }.reverse.to_h
  end

  def unique_views
    unique_page_views = Hash.new(0)
    parsed_log.uniq.each do |entry|
      unique_page_views[entry[:webpage]] += 1
    end
    unique_page_views.sort_by { |page, views| views }.reverse.to_h
  end
end

class LogReport < Sinatra::Base
  set :bind, '0.0.0.0'
  register Sinatra::Contrib

  get '/' do
    @log = Log.new("./webserver.log")
    erb :index
  end
end