# General WP Core settings page with Homeurl, Siteurl and such
class GeneralSettingsPage
  include PageObject
  include AjaxElements

  page_url '<%=params[:home]%>/wp-admin/options-general.php'

  select(:wp_lang, id: 'WPLANG')
  button(:submit_btn, id: 'submit')

  def switch_to_lang(lang_code)
    wp_lang_element.select_value lang_code
    click_when_enabled submit_btn_element
  end
end
