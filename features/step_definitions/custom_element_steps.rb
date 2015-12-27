And(/^you add the (.+) cpt$/) do |cpt|
  @wp_site.add_cpt cpt
end