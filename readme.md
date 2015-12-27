# Installation

In order to run this you need the correct ruby setup as well as an available docker daemon,
either running remotely or locally.

## Ruby

In order to install the necessary Ruby version and its dependencies use rvm.
https://rvm.io/rvm/install has all the necessary information on installing it.
Once rvm is installed simply cd into this repo and run

```bash
$ bundle install
```

It could be that your system is missing certain dependencies, rvm will instruct you as to what is missing.


## Docker

All you need here is a bare bones docker daemon. A docker daemon can be run on any Linux box that is not
completely outdated.
It should be easiest to install on Ubuntu newer than "Trusty 14.04" and Debian Stretch (Jessie needs a little fiddling at times).
Documentation on how to do so can be found on the official docker website.

# Running Tests

The default domain the tests are run against is "cleanwp.dev".
You can run the tests by simply running:
```bash
$ bundle exec rake
```

Before you are able to run the tests you will need to properly setup the config file config.yml as shown below.

## Forcing Video Output

Wanna see what actually happened even if tests passed? Just set the ENV variable FORCE_VIDEO like so:
```bash
$ bundle exec rake FORCE_VIDEO=true
```

Same goes in the other direction, actively prevent any video recording for performance reasons:
```bash
$ bundle exec rake NO_REPORT=true
```

## Forcing Site Dump Output

Wanna have a snapshot of your site from after each test? Just set the ENV variable FORCE_EXPORT like so:
```bash
$ bundle exec rake FORCE_EXPORT=true
```

# Configuration

Place a config.yml in the root of this repository to not have to set environment variables
config.yml example:
```yaml
#Mandatory parameter, the path to the WordPress plugin folder you want to test
wp_plugin_dir:
  /home/brownbear/okt/wp-dev-dockers/www/php-fpm.dev/wp-content/plugins
#If set to true this will bind the web ports 80 and 443 as well as the mysql port 3306 to the same ports on the host,
#so you can easily inspect the containers manually during or after tests
use_standard_ports:
  true
ask_finish:
  true
#If you are not running a local docker daemon on the same Linux box you are running the tests on you need to
# add a docker host as in below example
docker_host:
  tcp://123.123.244.244:2375
cached_images:
  - db
  - selenium
  - data
  - nginx
# If you set below setting to true all upstream communication between the machine the tests run on and the docker host
# will be xz compressed. A standard WordPress dev folder that has some of our plugins and all unittests installed will
# be compressed from ~300MB to less than 15MB. Be aware that this compression might take up to 2 minutes or so.
# Setting this to true only makes sense when your Docker host is located remotely. For local setups this will essentially
# always slow down test startup.
compress_streams:
  true
```

## Rebuilding otherwise cached Images/Containers

If you made changes to containers you would otherwise cache and do not want to change the config file for,
run tests once with WATIR_NO_CACHE set to true as such:
```bash
$ bundle exec rake WATIR_NO_CACHE=true
```

# Troubleshooting

In some cases it can happen that docker containers used by this test suit become stale and need to be manually removed.
In most cases it suffices to run:
```bash
$ rake clean_containers
```

which will cause all containers used by this test suit to be deleted from the Docker host.
In rare cases though it could happen that containers enter a state where this suit stop being able to find them by the
data it itself caches.
If you are completely sure that none of the containers on the docker host you are using need to be kept or running,
you can always remove all containers on the host via:

```bash
$ sudo docker rm -f $(sudo docker ps -aq)
```