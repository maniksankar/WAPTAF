# Copyright 2025 Zilogic Systems
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
"""
This module provides utilities for generating network traffic using SSH,
including support for TCP, UDP, and multicast traffic flows.

Author: Zilogic Systems <code@zilogic.com>
"""
# Local Libraries
from zi4pitstop.lib.generic.generic_traffic_generator import GenericTrafficGenerator
import zi4pitstop.lib.utils.zi_logger as zi_logger


class FeatureTrafficGenerator(GenericTrafficGenerator):
    """Handles basic WiFi functionality keywords for openwrt client."""
    def __init__(self):
        zi_logger.log("Openwrt.FeatureTrafficGenerator __init__ : START")
        GenericTrafficGenerator.__init__(self)
        zi_logger.log("Openwrt.FeatureTrafficGenerator __init__ : END")