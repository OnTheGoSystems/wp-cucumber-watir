# Screen for editing a user
class UserProfileScreenPage
  include PageObject
  include AjaxElements

  page_url '<%=params[:home]%>/wp-admin/profile.php'
  button(:update_profile_btn, id: 'submit')
end
