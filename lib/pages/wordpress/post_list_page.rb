# Any Admin Post List in the Backend
class PostListPage
  include PageObject
  include AjaxElements

  page_url('<%=params[:home]%>/wp-admin/edit.php?' \
   'post_type=<%=params[:post_type]%>')

  table(:main_post_list, class: 'wp-list-table widefat fixed striped')

  def get_terms(post_id, taxonomy)
    cell  = get_row_for_post(post_id).cell_element(class: taxonomy)
    terms = []
    index = 0
    while (link = cell.link_element(index: index)).exists?
      index += 1
      terms.push link.text
    end

    terms
  end

  def trash_post(post_id)
    row = get_row_for_post post_id
    row.hover
    delete_link = row.link_element(class: 'submitdelete')
    click_when_visible delete_link
  end

  private

  def get_row_for_post(post_id)
    found_row = nil
    main_post_list_element.each do |row|
      found_row = row if row.id == ('post-' + post_id.to_s)
    end

    found_row
  end
end
