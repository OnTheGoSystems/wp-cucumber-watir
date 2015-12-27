# Screen for creating a new menu
class NewMenuPage < SharedMenuPage
  page_url '<%=params[:home]%>/wp-admin/nav-menus.php?action=edit&menu=0'

  button(:new_menu_save, id: 'save_menu_header')

  def add_menu(lang)
    wait_focus_send new_menu_name_element, random_word
    new_menu_lang_element.select_value lang
    new_menu_save

    menu_id_element.value
  end
end
