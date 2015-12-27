# Screen for creating a new user
class NewUserScreenPage
  include AjaxElements
  include StringModule
  include PageObject

  page_url '<%=params[:home]%>/wp-admin/user-new.php'

  element(:user_login, :input, id: 'user_login')
  element(:user_email, :input, id: 'email')
  button(:show_pw, class: 'wp-generate-pw')
  button(:create_user, id: 'createusersub')
  element(:password_field, :input, id: 'pass1-text')

  def add_new_subscriber_user
    login_name    = random_word
    email_address = random_word + '@' + USER_EMAIL_DOMAIN
    wait_focus_send user_login_element, login_name
    wait_focus_send user_email_element, email_address
    show_pw_element.click
    password_field_element.when_visible(30)
    password_text = password_field_element.value
    create_user

    { login_name: login_name, password: password_text, email: email_address }
  end
end
