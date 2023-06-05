#!/vendor/bin/sh
#
#Copyright (c) 2023 Qualcomm Innovation Center, Inc. All rights reserved.
#SPDX-License-Identifier: BSD-3-Clause-Clear
#

insmod /vendor/lib/modules/hsi2s.ko lpaif_mode=1 bit_clock_hz=65536000 data_buffer_ms=16
