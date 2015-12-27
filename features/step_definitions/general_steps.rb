And(/^the error log in WP is clean$/) do
  wp_error_log = @wp_site.log_file
  puts(wp_error_log) if wp_error_log.length > 0
  expect(wp_error_log.length).to be 0
end

And(/^you manually empty the error log in WP$/) do
  @wp_site.clean_log
end

And(/^you set pretty permalinks/) do
  visit_on_blog PermalinkOptionPage, &:use_pretty_permalinks
end

And(/^you set (.+) as posts page$/) do |page_id|
  visit_on_blog(ReadingSettingsPage) do |page|
    page.as_posts_page post_id_from_text(page_id)
  end
end
