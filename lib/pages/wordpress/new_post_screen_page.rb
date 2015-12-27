# Page for any new post
class NewPostScreenPage < PostEditShared
  page_url('<%=params[:home]%>/wp-admin/'\
  'post-new.php?post_type=<%=params[:post_type]%>')

  element(:post_id_hidden, :input, id: 'post_ID')

  def publish_with_random_content
    add_random_title
    add_n_random_words(10, false)
    unless @browser.url.match(/(post_type=)(page|product|book)/)
      add_n_tags(RANDOM_POST_TAG_COUNT)
    end
    publish_post

    post_id_hidden_element.value
  end

  def publish_title_only
    add_random_title
    publish_post

    post_id_hidden_element.value
  end

  private

  def add_random_title
    post_title_element.when_visible(30)
    post_title_element.focus
    2.times { post_title_element.send_keys random_word, :space }
  end
end
