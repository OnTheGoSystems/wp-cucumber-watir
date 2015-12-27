# Page for editing a post
class PostEditScreenPage < PostEditShared
  page_url('<%=params[:home]%>/wp-admin/post.php'\
  '?post=<%=params[:post_id]%>&action=edit')
end
