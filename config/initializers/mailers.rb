from = ENV["EMAIL_FROM"]

if Rails.env.development? or Rails.env.test?
  from ||= "noreply@masasx.herokuapp.com"
end

raise "You must set an email from address in ENV['EMAIL_FROM']" if from.blank?

ActionMailer::Base.default(from: from)
