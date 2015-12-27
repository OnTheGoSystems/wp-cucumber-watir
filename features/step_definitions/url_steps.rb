And(/visiting (.+) leads to (.+) and shows (.+)/) do |slug, redirect, post|
  visit_on_blog(FrontPage, uri: slug_from_ph(slug)) do |page|
    slug_redirected = slug_from_ph(redirect).gsub(%r{^/+}, '').chomp('/')
    home = @wp_site.home_url
    expect(
      @browser.url.chomp('/')).to eq(("#{home}/#{slug_redirected}").chomp('/'))
    post_content =
      if post == '404'
        '<section class="error-404 not-found">'
      else
        if post == 'home'
          WPPosts.find(1)['post_title']
        else
          WPPosts.find(post_id_from_text(post))['post_content']
        end
      end
    expect(page.html).to include(post_content)
  end
end

And(/^you set (.+) as child of (.+)$/) do |child, parent|
  edit_post(child) do |page|
    page.make_child_of post_id_from_text(parent)
  end
end