#!/bin/bash
# Copyright (c) 2022-2025, AllWorldIT.
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


# shellcheck disable=SC2034
CELERY_APP=tasks
CELERY_LOG_LEVEL=debug


cat <<EOF > /app/requirements.txt
celery[redis]
EOF

python -m venv /app/.venv
(
    # shellcheck disable=SC1091
    . /app/.venv/bin/activate

    pip install -r /app/requirements.txt
)

# Add redis and start it along with supervisord, just for a easy test environment
apk add --no-cache redis
cat <<EOF > /etc/supervisor/conf.d/redis.conf
[program:redis]
command=/usr/bin/redis-server

stderr_logfile=/dev/stderr
stderr_logfile_maxbytes=0

stdout_logfile=/dev/stdout
stdout_logfile_maxbytes=0
EOF


cat <<EOF > /app/tasks.py
from celery import Celery

app = Celery(__name__)
app.conf.broker_url = "redis://localhost"
app.conf.result_backend = "redis://localhost"
app.conf.task_track_started = True

@app.task
def add(s):
    return s
EOF


cat <<EOF > /app/test.py
from celery.backends.base import ResultBase
from tasks import add
import sys

task = add.delay("TEST SUCCESS")
task_result = task.get()

if task_result == "TEST SUCCESS":
    sys.exit(0)

sys.exit(1)
EOF
