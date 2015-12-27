# Screen for editing a menu
class EditMenuPage < SharedMenuPage
  page_url '<%=params[:home]%>/wp-admin/nav-menus.php'\
  '?action=edit&menu=<%=params[:menu_id]%>'
end
