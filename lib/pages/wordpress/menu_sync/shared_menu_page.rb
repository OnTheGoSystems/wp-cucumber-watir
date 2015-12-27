# Superclass for editing and creating menus
class SharedMenuPage
  include PageObject
  include AjaxElements
  include StringModule

  element(:new_menu_name, :input, id: 'menu-name')
  element(:menu_id, :input, id: 'menu')
  button(:new_menu_save, id: 'save_menu_header')

  def display_in(location)
    location_cb = checkbox_element(id: ('locations-' + location))
    location_cb.when_visible 30
    location_cb.check

    new_menu_save
  end
end
