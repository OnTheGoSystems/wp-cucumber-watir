# Generic Front-End page, that can be used with every URI
class FrontPage
  include PageObject
  page_url '<%=params[:home]%>/<%=params[:uri]%>'
end
