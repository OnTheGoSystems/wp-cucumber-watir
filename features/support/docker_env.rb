unless defined? DB_BUILD_PATH
  DB_BUILD_PATH = DOCKER_RES_PATH + 'db'
  DATA_BUILD_PATH = DOCKER_RES_PATH + 'data'
  NGINX_BUILD_PATH = DOCKER_RES_PATH + 'nginx'
  PHP_BUILD_PATH = DOCKER_RES_PATH + 'php5.6'
  SELENIUM_BUILD_PATH = DOCKER_RES_PATH + 'selenium'
  DB_IMAGE = 'otgs_wp_db'
  DATA_IMAGE = 'otgs_wp_data'
  PHP_IMAGE = 'otgs_wp_php'
  NGINX_IMAGE = 'otgs_wp_nginx'
  SELENIUM_IMAGE = 'otgs_wp_selenium'
end
