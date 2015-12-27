CONTAINER_CACHE_DB = 'tmp/containers/sqlite_db_file'

ActiveRecord::Base.configurations['docker'] = { adapter: 'sqlite3',
                                                database: CONTAINER_CACHE_DB }
ActiveRecord::Base.establish_connection :docker
ActiveRecord::Schema.define do
  unless ActiveRecord::Base.connection.tables.include? 'docker_containers'
    create_table :docker_containers do |t|
      t.string :docker_id
      t.string :index
      t.timestamps null: false
    end
  end
end

# All docker containers created by this test
class DockerContainers < ActiveRecord::Base
  establish_connection :docker

  def self.cleanup_all_containers
    all.each do |cont|
      unless Docker::Container.all(all: true, filters: {
        id: [cont.docker_id]
      }.to_json).empty?
        Docker::Container.get(cont.docker_id).delete(force: true)
      end
      cont.destroy
    end
  end
end
