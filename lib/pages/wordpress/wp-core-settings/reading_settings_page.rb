# Settings Page for Front- and Postspage
class ReadingSettingsPage
  include PageObject
  include AjaxElements

  page_url '<%=params[:home]%>/wp-admin/options-reading.php'

  radio_button(:show_on_front,
               value: 'page',
               name: 'show_on_front',
               class: 'tog')
  select(:page_for_posts, id: 'page_for_posts')
  button(:submit_btn, id: 'submit')

  def as_posts_page(page_id)
    select_show_on_front
    page_for_posts_element.select_value page_id.to_s
    click_when_enabled submit_btn_element
  end
end
