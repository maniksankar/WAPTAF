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
This module handles various client operation

Author: Zilogic Systems <code@zilogic.com>
"""
# Third-party Libraries
from robot.api.deco import keyword
from robot.api import SkipExecution

# Local Libraries
from zi4pitstop.lib.bridge.database_module import DatabaseModule
from zi4pitstop.lib.bridge.connection_modules import ConnectionModules
import zi4pitstop.lib.utils.zi_logger as zi_logger

class Connection(DatabaseModule,
                 ConnectionModules):
    """
    Provides keywords to establish connections with different devices
    which using different connection types (SSH, ADB, Serial)
    """

    ROBOT_AUTO_KEYWORDS = False
    ROBOT_LIBRARY_SCOPE = 'Global'

    def __init__(self):
        zi_logger.log("Connection __init__ : START")
        DatabaseModule.__init__(self)
        ConnectionModules.__init__(self)
        self.db_obj = self.get_database_module_object()
        zi_logger.log(f"==== db_obj : {self.db_obj}")
        zi_logger.log("Connection __init__ : END")

    @keyword("Connect With Device")
    def connect_with_device(self,
                            device: str):
        zi_logger.log(f"lib.map.connection.connect_with_device({device})")
        state = self.db_obj.read_from_database(device, 'device_present')
        zi_logger.log(f"State: {state}")

        if state:
            connection = self.db_obj.read_device_connection(device)
            zi_logger.log(f"Connection : {connection}")
            connection_obj = self.get_connection_module_object(connection)
            zi_logger.log(f"connection_obj: {connection_obj}")
            status = connection_obj.connect_with_device(device)
            if not status:
                raise SkipExecution(
                    f"Could not established remote connection with device: {device}")

    @keyword("Is Device Alive")
    def is_device_alive(self,
                        device: str):
        zi_logger.log(f"lib.map.connection.get_file({device})")
        connection = self.db_obj.read_device_connection(device)
        connection_obj = self.get_connection_module_object(connection)
        return connection_obj.is_device_alive(device)

    @keyword("Execute Command")
    def execute_command(self,
                        device,
                        command: str,
                        return_stdout: bool =True,
                        return_stderr: bool =False,
                        return_rc:bool =False,
                        blocking_call:bool =True):
        zi_logger.log(f"lib.map.connection.execute_command({device}, {command})")
        connection = self.db_obj.read_device_connection(device)
        connection_obj = self.get_connection_module_object(connection)
        out = connection_obj.execute_command(command,
                                             return_stdout,
                                             return_stderr,
                                             return_rc,
                                             blocking_call)
        return out

    @keyword("Switch To Connection")
    def switch_connection(self,
                          device: str):
        zi_logger.log(f"lib.map.connection.switch_connection({device})")
        connection = self.db_obj.read_device_connection(device)
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)   

    @keyword("Close Connection")
    def close_connection(self,
                         device: str):
        zi_logger.log(f"lib.map.connection.close_connection({device})")
        state = self.db_obj.read_from_database(device, 'device_present')
        zi_logger.log(f"State: {state}")
        if state:
            connection = self.db_obj.read_device_connection(device)
            connection_obj = self.get_connection_module_object(connection)
            connection_obj.close_connection(device)

    @keyword("Get File")
    def get_file(self,
                 device: str,
                 source: str,
                 destination: str):
        zi_logger.log(f"lib.map.connection.get_file({device, source, destination})")
        connection = self.db_obj.read_device_connection(device)
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.get_file(source, destination)

    @keyword("Put File")
    def put_file(self,
                 device: str,
                 source: str,
                 destination: str):
        zi_logger.log(f"lib.map.connection.put_file({device, source, destination})")
        connection = self.db_obj.read_device_connection(device)
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.put_file(source, destination)
