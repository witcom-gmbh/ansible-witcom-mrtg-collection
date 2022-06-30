RELEASE         ?= $(shell cat ./release.version)

all: clean build

clean:
	rm -f witcom-witcom_mrtg-*.tar.gz

update_metadata:
	@sed "s/RELEASE/${RELEASE}/g" ./galaxy.yml.in > ./galaxy.yml

build:
	ansible-lint -x yaml
	@sed "s/RELEASE/${RELEASE}/g" ./galaxy.yml.in > ./galaxy.yml
	ansible-galaxy collection build 
