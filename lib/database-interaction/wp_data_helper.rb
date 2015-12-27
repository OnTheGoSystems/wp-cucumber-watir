# Superclass for all WordPress tables
class WpDbConnection < ActiveRecord::Base
  establish_connection :wp

  self.abstract_class = true

  def self.table_name
    'wp_' + super
  end
end

# WordPress users table
class WpUsers < WpDbConnection
  self.table_name = 'users'
end

# WordPress posts table
class WPPosts < WpDbConnection
  self.table_name = 'posts'

  def self.slug(post_id)
    find(post_id)['post_name']
  end

  def self.post_type(post_id)
    find(post_id)['post_type']
  end
end