# Plugins page for a single site or an individual blog on a multi-site
class BlogPluginsPage < PluginsPage
  page_url '<%=params[:home]%>/wp-admin/plugins.php'

  private

  def top_select_activate_label
    'Activate'
  end

  def top_select_deactivate_label
    'Deactivate'
  end
end
