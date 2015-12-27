# Theme Selection Page
class ThemesPage
  include PageObject
  include AjaxElements

  page_url '<%=params[:home]%>/wp-admin/themes.php'

  def activate_theme(theme_name)
    theme_header = h2_element(id: (theme_name + '-name'))
    theme_header.hover
    click_when_visible theme_header.parent.parent.link_element(class: 'activate')
  end
end