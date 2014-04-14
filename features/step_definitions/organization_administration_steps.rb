Given /^OpenDJ approves all organization requests$/ do
  Directory.stub(:add_organization).and_return(true)
end
