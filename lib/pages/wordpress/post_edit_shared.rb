# Superclass for all post editing
class PostEditShared
  include PageObject
  include AjaxElements
  include StringModule

  element(:publish_button, :input, id: 'publish')
  in_iframe(id: 'content_ifr') do |iframe|
    element(:editor_body, :body, id: 'tinymce', frame: iframe)
  end

  div(:tag_div, id: 'post_tag')
  element(:new_tag_name, :input, id: 'new-tag-post_tag')
  element(:post_title, :input, id: 'title')
  a(:preview_btn, class: 'preview')
  button(:add_tag) do |page|
    page.tag_div_element.button_element(class: 'button tagadd', value: 'Add')
  end
  div(:tag_check_list) do |page|
    page.tag_div_element.div_element(class: 'tagchecklist')
  end

  select(:post_parent, id: 'parent_id')

  def add_n_random_words(n, save = true)
    focus_when_visible editor_body_element
    n.times { editor_body_element.send_keys random_word, :space }
    publish_post if save
  end

  def add_n_tags(n)
    n.times do
      focus_when_visible new_tag_name_element
      new_tag_name_element.send_keys random_word, :space
      add_tag_element.click
    end
  end

  def publish_post
    publish_button_element.wait_until(30) { publish_button_element.enabled? }
    click_when_enabled publish_button_element
    Watir::Wait.until do
      publish_button_element.enabled?
    end
    @browser.goto WP_DEFAULT_URL
    sleep FIREFOX_DETECT_ALERT_MAX_DELAY
    @browser.back
  rescue Selenium::WebDriver::Error::UnhandledAlertError
    @browser.alert.close
    click_when_enabled publish_button_element
  end

  def make_child_of(parent_id)
    post_parent_element.when_visible 30
    post_parent_element.select_value parent_id.to_s
    publish_post
  end
end
