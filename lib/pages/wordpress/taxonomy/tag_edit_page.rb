# WordPress Core Taxonomy create and edit screen
class TagEditPage
  include PageObject
  include AjaxElements

  page_url '<%=params[:home]%>/wp-admin/edit-tags.php'\
  '?taxonomy=<%=params[:taxonomy]%>&post_type=<%=params[:post_type]%>'

  element(:new_tag_name, :input, id: 'tag-name')
  button(:submit_btn, id: 'submit')

  def add_term(value)
    wait_focus_send new_tag_name_element, value
    click_when_enabled submit_btn_element
  end
end
