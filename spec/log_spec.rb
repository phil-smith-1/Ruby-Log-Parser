require 'spec_helper'
require './parser'

RSpec.describe Log do
	#Set the log variable for all tests
	before(:all) do
		@log = Log.new("./webserver.log")
	end

	it "Reads the log file" do
		expect(@log.instance_variable_get(:@full_log)).not_to be_empty
	end

	it "Counts the total views of each page and orders by views descending" do
		expect(@log.all_views).not_to be_empty
		expect(@log.all_views).to have_key("/index")#Assuming /index will always be visited
		#Check that the hash is ordered correctly
		@previous_views = 0
		@log.all_views.each_pair do |page,views|
			expect(views).to be <= (@previous_views) unless @previous_views == 0
			@previous_views = views
		end
	end

	it "Counts the total unique views of each page and orders by view descending" do
		expect(@log.unique_views).not_to be_empty
		expect(@log.unique_views).to have_key("/index")
		expect(@log.unique_views.length).to eq(@log.all_views.length) #The number of unique webpages in the log should be the same regardless of if the views are unique
		expect(@log.unique_views["/index"]).not_to eq(@log.all_views["/index"]) #The number of views and unique views should be different
		#Check that the hash is ordered correctly
		@previous_views = 0
		@log.unique_views.each_pair do |page,views|
			expect(views).to be <= (@previous_views) unless @previous_views == 0
			@previous_views = views
		end
	end
end