require 'vcr'

VCR.config do |c|
  c.hook_into :webmock
  c.cassette_library_dir     = 'features/cassettes'
  c.default_cassette_options = { :record => :new_episodes, :match_requests_on => [:method, :uri, :body] }
end

VCR.cucumber_tags do |t|
  t.tag "@opendjrequest"
end
