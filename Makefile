service := hub

# Builds, (re)creates, starts, and attaches to containers for a service
start:
	@docker-compose up -d
	@docker-compose scale chrome=5 firefox=5
	@docker-compose ps

# Stops running containers without removing them
stop:
	@docker-compose stop

# Restarts service
restart:
	@docker-compose restart ${service}

# Removes stopped service containers
clean:
	@docker-compose rm --force

# Stops running containers with removing, removes service image
kill:
	@docker-compose stop
	@docker-compose rm --force
	@docker rmi -f seleniumgrid_hub

# Pulls latest service images.  (Note: docker-compose pull does not work
# on private repositories in Windows, hence the Perl work around that calls
# docker pull for each image referenced in docker-compose.yml.)
pull:
	@perl -ne '{ if (s/\bimage\b: (.*)/docker pull $$1/) { \
	               print "$$_\n"; \
	               system($$_); \
	               print "\n" } }' docker-compose.yml

# Lists containers and their statuses
status:
	@docker-compose ps

# Displays log output from services. Default is main service
logs:
	@docker-compose logs ${service}

.PHONY: start stop restart clean kill pull status logs