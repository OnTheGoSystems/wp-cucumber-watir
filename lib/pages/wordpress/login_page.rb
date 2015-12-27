# WordPress login page
class LoginPage
  include PageObject
  page_url '<%=params[:home]%>/wp-login.php'
  element(:username, :input, id: 'user_login')
  element(:password, :input, id: 'user_pass')
  button(:login, id: 'wp-submit')
  div(:login_error, id: 'login_error')

  def wp_login(user = WP_ADMIN_USERNAME, password = WP_ADMIN_PASSWORD)
    username_element.focus
    username_element.send_keys user
    password_element.focus
    password_element.send_keys password
    login
    wp_login(user, password) if login_error?
  end
end
