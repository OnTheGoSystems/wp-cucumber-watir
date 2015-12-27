# Encapsulation for recurring WP interaction
module WpWorldHelpers
  def visit_on_blog(page_obj, args = {}, _blog_id = 1, &block)
    visit page_obj, using_params: args.merge(home: current_home), &block
  end

  # TODO: array of blogs and their home urls for network testing
  def current_home
    @home ||= @wp_site.home_url
  end

  def create_clean_install(multisite = false)
    @wp_install_helper.install_site(WP_INSTALL_PATH,
                                    WP_DEFAULT_DOMAIN,
                                    multisite)
    visit_front_page do |home_page|
      expect(home_page.title).to match(/^#{Regexp.escape(WP_DEFAULT_DOMAIN)}/)
    end
  end

  def login_to_wp(username = WP_ADMIN_USERNAME, password = WP_ADMIN_PASSWORD)
    visit_front_page
    @browser.cookies.clear
    visit_on_blog(LoginPage) do |page|
      page.wp_login username, password
    end
  end

  def text_to_uid(user_identifier)
    instance_var_name = "@#{user_identifier}"
    saved_data = if instance_variable_defined?(instance_var_name)
      instance_variable_get(instance_var_name)
    end

    WpUsers.where(user_login: ((
    if saved_data && saved_data[:login_name]
      saved_data[:login_name]
    else
      user_identifier
    end))).first.id
  end
end
