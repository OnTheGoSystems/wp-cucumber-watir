When(/^you add a new user\((.+)\)$/) do |login_name_ph|
  user = {}
  visit_on_blog(NewUserScreenPage) do |new_user_page|
    user = new_user_page.add_new_subscriber_user
  end
  instance_variable_set("@#{login_name_ph}", user)
  puts(
    "Created user #{user[:login_name]} with"\
    " password #{user[:password]} and email #{user[:email]}")
end

And(/you login as (.+)$/) do |login_name_ph|
  user = instance_variable_get("@#{login_name_ph}")
  login_to_wp user[:login_name], user[:password]
  expect(@browser.title).to match(/^Profile/) unless login_name_ph == 'admin'
end