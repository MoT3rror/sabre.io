#!/bin/bash

DOMAIN = sabre.io
URL = http://${DOMAIN}

.PHONY: all, generate, generate-css, do-deploy, server

all: generate do-deploy

generate: generate-css
	sculpin install
	sculpin generate --env=prod --url=$url


generate-css:
	./generate_css.sh source/less/sabre.less source/css/sabre.css

deploy: 
	echo "Deploy directory does not exist!"
	exit 255

do-deploy: deploy
	cd deploy; \
	echo "Fetching latest changes"; \
	git checkout master; \
	git pull; \
	echo "Copying over the latest website version"; \
	rm -r *; \
	cp -r ../output_prod/* .; \
	touch .nojekkyl; \
	echo $(DOMAIN) > CNAME; \
	git add -A \
	git commit -m "Automatic deployment `date -u`" \
	echo "Pushing changes" \
	git push origin master \
	echo "Deploy complete"

server:
	sculpin generate --watch --server
