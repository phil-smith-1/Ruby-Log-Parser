This is a Ruby 2.2.3 script that uses Sinatra and RSpec for testing.
When accessed in a web browser, this will parse the contents of a log file (webserver.log), echo a list of total page views and unique page views.
The Log class can be used seperately and will accept the path of a log file and will return the following:

Log.new(path).parsed_log - An array of hashes including all entries in the log file. Each entry has keys :webpage and :ip
Log.new(path).all_views - A hash of pages and their total views ordered by views descending.
Log.new(path).unique_views - A hash of pages and their unique views ordered by views descending.

The hashes are returned in the format Key:page(string) and Value:views(int)

There are RSpec unit tests which check that the data is read from the log file correctly and the hashes are ordered correctly.
The tests can be run from the command line using "rspec spec/log_spec.rb"