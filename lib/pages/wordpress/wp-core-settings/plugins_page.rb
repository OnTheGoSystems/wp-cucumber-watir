# Superclass for Network and Blog Plugins pages
class PluginsPage
  include PageObject
  include AjaxElements

  table(:plugins_table, class: 'wp-list-table')
  select(:top_select, id: 'bulk-action-selector-top')
  button(:top_apply, id: 'doaction')

  def inactive_plugins
    res = []
    plugins_table_element.each do |row|
      res.push(row.attribute('id')) if inactive_row?(row)
    end

    res
  end

  def inactive_row?(row)
    row.attribute('class').match(/\binactive\b/)
  end

  def active_row?(row)
    row.attribute('class').match(/\bactive\b/)
  end

  private

  def activate_plugins(plugin_slugs)
    change_plugin_status(
      plugin_slugs, 'inactive_row?', 'top_select_activate_label')
  end

  def deactivate_plugins(plugin_slugs)
    change_plugin_status(
      plugin_slugs, 'active_row?', 'top_select_deactivate_label')
  end

  def change_plugin_status(plugin_slugs, row_check, label_return)
    plugins_table_element.each do |row|
      cb = row.checkbox_element
      if send(row_check, row) && plugin_slugs.include?(row.attribute('id'))
        cb.check
      end
    end
    top_select_element.select(send(label_return))
    top_apply_element.focus
    top_apply_element.send_keys :return
  end
end
