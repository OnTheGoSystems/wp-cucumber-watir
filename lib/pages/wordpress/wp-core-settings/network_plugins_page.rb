# Plugins Page in the Network Admin menus
class NetworkPluginsPage < PluginsPage
  page_url '<%=params[:home]%>/wp-admin/network/plugins.php'

  private

  def top_select_activate_label
    'Network Activate'
  end
end
