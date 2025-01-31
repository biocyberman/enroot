#! /bin/bash

# Copyright (c) 2018-2019, NVIDIA CORPORATION. All rights reserved.
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

set -eu

if [ -z "${ENROOT_MOUNT_HOME-}" ]; then
    exit 0
fi

# shellcheck disable=SC1090
source "${ENROOT_LIBRARY_PATH}/common.sh"

common::checkcmd getent

if [ -z "${HOME-}" ]; then
    export "HOME=$(common::getpwent | cut -d ':' -f6)"
fi

if [ -n "${ENROOT_REMAP_ROOT-}" ]; then
    enroot-mount --root "${ENROOT_ROOTFS}" - <<< "${HOME} /root none x-create=dir,bind,rw,nosuid"
else
    enroot-mount --root "${ENROOT_ROOTFS}" - <<< "${HOME} ${HOME} none x-create=dir,bind,rw,nosuid"
    printf "HOME=%s\n" "${HOME}" >> "${ENROOT_ENVIRON}"
fi
