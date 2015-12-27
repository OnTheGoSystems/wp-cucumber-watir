And(/^you add (.+) to the (.+) location$/) do |menu_id, location|
  visit_on_blog(EditMenuPage, menu_id: menu_id_from_text(menu_id)) do |page|
    page.display_in location
  end
end