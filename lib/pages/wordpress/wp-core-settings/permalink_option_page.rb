# Permalink Settings Page
class PermalinkOptionPage
  include PageObject
  include AjaxElements

  page_url '<%=params[:home]%>/wp-admin/options-permalink.php'

  radio_button(:pretty_permalinks_radio, value: '/%postname%/')
  button(:save_changes, id: 'submit')

  def use_pretty_permalinks
    click_when_visible pretty_permalinks_radio_element
    click_when_visible save_changes_element
    save_changes_element.when_visible 30
  end
end
