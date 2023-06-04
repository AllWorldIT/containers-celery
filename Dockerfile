# Copyright (c) 2022-2023, AllWorldIT.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.


FROM registry.conarx.tech/containers/postfix/edge

ARG VERSION_INFO=
LABEL org.opencontainers.image.authors   "Nigel Kukard <nkukard@conarx.tech>"
LABEL org.opencontainers.image.version   "edge"
LABEL org.opencontainers.image.base.name "registry.conarx.tech/containers/postfix/edge"


RUN set -eux; \
    # NK: Check if Celery is actually included in Alpine and not just edge on next release
	# true "Celery"; \
	# apk add --no-cache \
	# 	py3-celery; \
	true "Celery deps"; \
	apk add --no-cache \
		tzdata; \
	true "Celery user"; \
	addgroup -S celery 2>/dev/null; \
	adduser -S -D -H -h /app -s /sbin/nologin -G celery -g celery celery 2>/dev/null; \
	true "App"; \
	mkdir -p /app; \
	true "Celery directories"; \
	mkdir -p /etc/celery; \
	true "Cleanup"; \
	rm -f /var/cache/apk/*


# Celery
COPY etc/supervisor/conf.d/celery.conf /etc/supervisor/conf.d/celery.conf
COPY usr/local/sbin/start-celery /usr/local/sbin
COPY usr/local/share/flexible-docker-containers/init.d/44-celery.sh /usr/local/share/flexible-docker-containers/init.d
COPY usr/local/share/flexible-docker-containers/pre-init-tests.d/44-celery.sh /usr/local/share/flexible-docker-containers/pre-init-tests.d
COPY usr/local/share/flexible-docker-containers/tests.d/44-celery.sh /usr/local/share/flexible-docker-containers/tests.d
RUN set -eux; \
	true "Flexible Docker Containers"; \
	if [ -n "$VERSION_INFO" ]; then echo "$VERSION_INFO" >> /.VERSION_INFO; fi; \
	true "Permissions"; \
	chown celery:celery \
		/etc/celery; \
	chown root:root \
		/usr/local/sbin/start-celery; \
	chmod 0755 \
		/etc/celery \
		/usr/local/sbin/start-celery; \
	fdc set-perms
