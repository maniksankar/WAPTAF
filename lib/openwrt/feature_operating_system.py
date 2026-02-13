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


from zi4pitstop.lib.base.base_feature_operating_system import BaseFeatureOperatingSystem
from zi4pitstop.lib.bridge.database_module import DatabaseModule
from zi4pitstop.lib.bridge.connection_modules import ConnectionModules
import zi4pitstop.lib.utils.zi_logger as zi_logger

class FeatureOperatingSystem(BaseFeatureOperatingSystem,
                             DatabaseModule,
                             ConnectionModules):
    """Handles basic Os functionality keywords for Os cab."""

    def __init__(self):
        zi_logger.log("Openwrt.FeatureOpreatingSystem __init__ : START")
        DatabaseModule.__init__(self)
        ConnectionModules.__init__(self)
        self.db_obj = self.get_database_module_object()
        zi_logger.log("Openwrt.FeatureOpreatingSystem __init__ : END")

    def check_openwrt_version(self,
                        device: str) -> str:
        """
        Get the OpenWRT version from the device.
        """
        zi_logger.log(f"lib.utils.check_openwrt_version.({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        zi_logger.log(connection_obj)
        connection_obj.switch_connection(device)
        command = "cat /etc/openwrt_version"
        output, error = connection_obj.execute_command(command,
                                                       return_stdout=True,
                                                       return_stderr=True)
        zi_logger.log(f"output: {output}, error: {error}")
        if error:
            raise Exception(f"Command execution failed : {command}")
        return "output" in output.lower()


    def check_os_release(self,
                   device: str) -> str:
        """
        Get the OpenWRT version from the device.
        """
        zi_logger.log(f"lib.utils.check_os_release.({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        zi_logger.log(connection_obj)
        connection_obj.switch_connection(device)
        command = "cat /etc/os-release"
        output, error = connection_obj.execute_command(command,
                                                       return_stdout=True,
                                                       return_stderr=True)
        zi_logger.log(f"output: {output}, error: {error}")
        if error:
            raise Exception(f"Command execution failed : {command}")
        return "output" in output.lower()

    def check_kernel_version(self,
                       device: str) -> str:
        """
        Get the kernel version from the device.
        """
        zi_logger.log(f"lib.utils.check_kernel_version.({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        zi_logger.log(connection_obj)
        connection_obj.switch_connection(device)
        command = "uname -a"
        output, error = connection_obj.execute_command(command,
                                                       return_stdout=True,
                                                       return_stderr=True)
        zi_logger.log(f"output: {output}, error: {error}")
        if error:
            raise Exception(f"Command execution failed : {command}")
        return "output" in output.lower()
