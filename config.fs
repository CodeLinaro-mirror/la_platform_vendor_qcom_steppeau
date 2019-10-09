# Copyright (c) 2019, The Linux Foundation. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
#       copyright notice, this list of conditions and the following
#       disclaimer in the documentation and/or other materials provided
#       with the distribution.
#     * Neither the name of The Linux Foundation nor the names of its
#       contributors may be used to endorse or promote products derived
#       from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
# ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
# IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

[early_services/]
mode: 0755
user: AID_ROOT
group: AID_SHELL
caps: 0

[early_services/system/bin/]
mode: 0751
user: AID_ROOT
group: AID_SHELL
caps: 0

[early_services/vendor/bin/]
mode: 0751
user: AID_ROOT
group: AID_SHELL
caps: 0

[early_services/system/bin/*]
mode: 0755
user: AID_ROOT
group: AID_SHELL
caps: 0

[early_services/vendor/bin/*]
mode: 0755
user: AID_ROOT
group: AID_SHELL
caps: 0

[early_services/init_early]
mode: 0750
user: AID_ROOT
group: AID_SHELL
caps: 0

[earlyrootfs/]
mode: 0755
user: AID_ROOT
group: AID_SHELL
caps: 0

[earlyrootfs/system/bin/]
mode: 0751
user: AID_ROOT
group: AID_SHELL
caps: 0

[earlyrootfs/vendor/bin/]
mode: 0751
user: AID_ROOT
group: AID_SHELL
caps: 0

[earlyrootfs/system/bin/*]
mode: 0755
user: AID_ROOT
group: AID_SHELL
caps: 0

[earlyrootfs/vendor/bin/*]
mode: 0755
user: AID_ROOT
group: AID_SHELL
caps: 0

[earlyrootfs/init_early]
mode: 0750
user: AID_ROOT
group: AID_SHELL
caps: 0
