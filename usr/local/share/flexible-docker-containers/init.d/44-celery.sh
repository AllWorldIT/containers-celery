#!/bin/bash
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


fdc_notice "Creating Celery directories"

# Check our run directory exists
if [ ! -d /run/celery ]; then
	fdc_info "Creating Celery runtime directory"
	mkdir /run/celery
	chown celery:celery /run/celery
	chmod 0750 /run/celery
fi


fdc_notice "Initializing Celery settings"

# Application module and callable
CELERY_APP="${CELERY_APP:-celery_app.celery_app}"

# Default instance type
CELERY_INSTANCE_TYPE="${CELERY_INSTANCE_TYPE:-worker}"
# Check the instance type is valid
if [ "$CELERY_INSTANCE_TYPE" != "worker" ] && [ "$CELERY_INSTANCE_TYPE" != "beat" ] && [ "$CELERY_INSTANCE_TYPE" != "flower" ]; then
	fdc_error "Invalid 'CELERY_INSTANCE_TYPE' environment variable, must be 'worker', 'beat' or 'flower'"
	false
fi


# Write out environment and fix perms of the config file
set | grep -E -e '^CELERY_' -e '^FLOWER_' > /etc/celery/celery.conf
chown root:celery /etc/celery/celery.conf
chmod 0640 /etc/celery/celery.conf
