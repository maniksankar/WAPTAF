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
Author: Zilogic Systems <code@zilogic.com>
"""


from zi4pitstop.lib.bridge.database_module import DatabaseModule
from zi4pitstop.lib.bridge.platform_modules import PlatformModules
from robot.api.deco import keyword
import zi4pitstop.lib.utils.zi_logger as zi_logger

class OperatingSystem(DatabaseModule,
                      PlatformModules):
  

    ROBOT_AUTO_KEYWORDS = False
    ROBOT_LIBRARY_SCOPE = 'Global'

    
    def __init__(self):
        zi_logger.log("OperatingSystem __init__ : START")
        DatabaseModule.__init__(self)
        PlatformModules.__init__(self)
        self.db_obj = self.get_database_module_object()
        zi_logger.log(f"==== db_obj : {self.db_obj}")
        zi_logger.log("OperatingSystem __init__ : END")

    @keyword("Check OpenWrt Version")
    def check_openwrt_version(self,
                              device: str) -> str:
        """
        Get whether the wireless interface is already in monitor mode.

        - ``device`` is the name given to the sniffer as mentioned
                     in the testbed.yaml config file

        - ``Returns`` If the interface is in monitor mode, its true. Otherwise false.

        Example:
        | ${ret} | Get Monitor Mode | sniffer |
        """
        zi_logger.log(f"lib.map.operating_system.check_openwrt_version({device}")
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        platform_obj.check_openwrt_version(device)

    @keyword("Check OS Release")
    def check_os_release(self,
                         device: str):
        """
        Get the OS release information.


        - ``Returns`` The OS release information.

        Example:
        | ${ret} | Get OS Release | operating_system |
        """
        zi_logger.log(f"lib.map.operating_system.check_os_release({device}")
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        platform_obj.check_os_release(device)

    @keyword("Check Kernel Version")
    def check_kernel_version(self,
                         device: str):
        """
        Get the kernel version information.

        - ``Returns`` The kernel version information.

        Example:
        | ${ret} | Get Kernel Version | operating_system |
        """
        zi_logger.log(f"lib.map.operating_system.check_kernel_version({device}")
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        platform_obj.check_kernel_version(device)

