# Admin post list for trashed posts
class PostTrashPage < PostListPage
  page_url('<%=params[:home]%>/wp-admin/edit.php?'\
  'post_type=<%=params[:post_type]%>'\
  '&post_status=trash')

  button(:empty_trash_all, id: 'delete_all')

  def empty_trash
    click_when_visible empty_trash_all_element
  end
end
