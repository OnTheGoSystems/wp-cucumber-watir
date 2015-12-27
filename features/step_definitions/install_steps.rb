Given(/^a clean WordPress installation$/) do
  create_clean_install
end

Given(/^a clean WordPress installation on a subdir multisite$/) do
  create_clean_install true
end

And(/^you go to the plugins page$/) do
  visit_on_blog(BlogPluginsPage)
end

When(/^you activate theme (.+)$/) do |theme|
  visit_on_blog ThemesPage do |page|
    page.activate_theme theme
  end
end

And(/^you go to the network-plugins page$/) do
  visit_on_blog(NetworkPluginsPage)
end

And(%r{^you switch to the blog at /(.+)$}) do |sub_dir|
  @home = WP_DEFAULT_URL + '/' + sub_dir
end

And(%r{^you add a subdir site under /(.+)$}) do |sub_dir|
  home_old = @home
  @home = WP_DEFAULT_URL
  visit_on_blog(NewNetworkBlogPage) do |page|
    page.new_sub_dir_site(
      sub_dir, sub_dir, (sub_dir + 'admin@' + USER_EMAIL_DOMAIN))
  end
  @home = home_old
end
