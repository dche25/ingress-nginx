#!/usr/bin/env bash

# Copyright 2019 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

export KUBE_ROOT=$(dirname "${BASH_SOURCE}")/..

# Install tools we need, but only from vendor/...
cd ${KUBE_ROOT}
go install ./vendor/github.com/tallclair/mdtoc
if ! which mdtoc >/dev/null 2>&1; then
    echo "Can't find mdtoc - is your GOPATH 'bin' in your PATH?" >&2
    echo "  GOPATH: ${GOPATH}" >&2
    echo "  PATH:   ${PATH}" >&2
    exit 1
fi

# Update tables of contents if necessary.
grep --include='*.md' -rl docs/enhancements/* -e '<!-- toc -->' | xargs mdtoc --inplace
