open_dj_url      = ENV["OPEN_DJ_URL"]
open_dj_username = ENV["OPEN_DJ_USERNAME"]
open_dj_password = ENV["OPEN_DJ_PASSWORD"]

if Rails.env.development? or Rails.env.test?
  open_dj_url      ||= "http://iam.continuumloop.com:9080"
  open_dj_username ||= "gg_admin"
  open_dj_password ||= "abcd1234"
end

raise "You must set an Open DJ URL in ENV['OPEN_DJ_URL']" if open_dj_url.blank?
raise "You must set an Open DJ username in ENV['OPEN_DJ_USERNAME']" if open_dj_username.blank?
raise "You must set an Open DJ password in ENV['OPEN_DJ_PASSWORD']" if open_dj_password.blank?

DirectoryApi::URL      = open_dj_url
DirectoryApi::USERNAME = open_dj_username
DirectoryApi::PASSWORD = open_dj_password
