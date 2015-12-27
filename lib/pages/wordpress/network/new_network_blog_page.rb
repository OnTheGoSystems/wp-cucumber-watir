# Screen for creating a new Blog on a Network
class NewNetworkBlogPage
  include PageObject
  include AjaxElements

  page_url '<%=params[:home]%>/wp-admin/network/site-new.php'

  element(:subdir, :input, id: 'site-address')
  element(:site_title, :input, id: 'site-title')
  element(:site_email, :input, id: 'admin-email')
  button(:add_site, id: 'add-site')

  def new_sub_dir_site(dir, title, email)
    wait_focus_send subdir_element, dir
    wait_focus_send site_title_element, title
    wait_focus_send site_email_element, email
    add_site
  end
end
