# Module for storing data in between test steps
module TestStepData
  def post_id_from_text(id_text)
    id_text = id_text.to_s
    (id_text.match(/\d+/) ? id_text : instance_variable_get("@#{id_text}")).to_i
  end

  alias_method :menu_id_from_text, :post_id_from_text

  def post_id_from_slug_ph(slug_ph)
    matches = slug_ph.match(%r{/slug_(\w+)$})
    matches ? post_id_from_text(matches[1]) : slug_ph
  end

  def slug_from_ph(slug_ph)
    post_ids = slug_ph.split('/').reject(&:empty?).map do |ph|
      post_id_from_slug_ph('/' + ph)
    end
    slugs = post_ids.map do |id|
      (id.to_s.match(/\d+/) ? WPPosts.slug(id) : id.to_s.gsub(%r{/}, ''))
    end

    '/' + slugs.join('/')
  end
end
