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
    """Handles basic WiFi functionality keywords for Linux client."""
    
    def __init__(self):
        zi_logger.log("Linux.FeatureTrafficGenerator.__init__ : START")
        GenericTrafficGenerator.__init__(self)
        self.db_obj = self.get_database_module_object()
        zi_logger.log("Linux.FeatureClient __init__ : END")
    

    def stop_iperf_server(self,
                          device: str):
        """
        Stop the iperf server using pkill command
        """
        zi_logger.log(
            f"windows.feature_traffic_generator.stop_iperf_server({device})"
            )
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)

        software = "iperf3"

        platform = self.db_obj.read_from_database(device, 'platform')

        command = f"taskkill /IM {software}.exe /F"

        error = connection_obj.execute_command(command,
                                               return_stdout=False,
                                               return_stderr=True)

        if error:
            raise Exception(f"Command execution failed : {command}")

    def remove_iperf_logs(self,
                          device: str,
                          dirpath: str):
        """
        Remove Iperf Logs From specified device and specified directory.
        """
        zi_logger.log(
            f"windows.feature_traffic_generator.remove_iperf_logs({device}, {dirpath})"
            )
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        command = f"del {dirpath}\\*.log"

        error = connection_obj.execute_command(command,
                                               return_stdout=False,
                                               return_stderr=True)
        if error:
            raise Exception(f"Command execution failed : {command}")

    def remove_iperf_log(self,
                         device: str,
                         filename: str):
        """
        Remove Iperf Log From specified device.
        """
        zi_logger.log(
            f"windows.feature_traffic_generator.remove_iperf_log({device}, {filename})"
            )
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        
        command = f"del {filename}"

        error = connection_obj.execute_command(command,
                                               return_stdout=False,
                                               return_stderr=True)

        if error:
            raise Exception(f"Command execution failed : {command}")

    def iperf_log_should_exist(self,
                        device: str,
                        filename: str) -> None:
        """
        Check whether the specified iperf log
        file should exists on the given device.
        """
        zi_logger.log(
            f"windows.feature_traffic_generator.iperf_log_should_exist({device}, {filename})"
            )
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        
        command = f"dir {filename}"

        error = connection_obj.execute_command(command,
                                               return_stdout=False,
                                               return_stderr=True)
        if error != '':
            raise Exception(f"FileNotFoundError: {filename} not exists.")
    
    def iperf_log_should_not_exist(self,
                            device: str,
                            filename: str):
        """
        Check whether the specified iperf log file should not exists
        on the given device.
        """
        zi_logger.log(
            f"windows.feature_traffic_generator.iperf_log_should_not_exist({device}, {filename})"
            )
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)

        command = f"dir {filename}"

        error = connection_obj.execute_command(command,
                                             return_stdout=False,
                                             return_stderr=True)
        if error == '':
            raise Exception(f"FileFoundError: {filename} exists.")
    
    def start_iperf_server(self, # pylint: disable=R0913
                           device: str,
                           bind_ip: str,
                           log_name: str,
                           port: int = 5201):
        """
        Generate an iperf server and store logs locally.
        """
        zi_logger.log(
            f"windows.feature_traffic_generator.start_iperf_server({device},"
            f"{bind_ip}, {log_name}, {port})"
            )
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        version = self.get_iperf_version(device)
        log_file = f"{log_name}"

        cmd_parts = [
            f"start /b iperf{'3' if version == 3 else '2'}.exe -s",
            f"-B {bind_ip}",
            f"-p {port}",
            f"--logfile {log_name}"
        ]
        filter_cmd_parts = list(filter(None, cmd_parts))
        command = " ".join(filter_cmd_parts)

        error = connection_obj.execute_command(command,
                                               return_stdout=False,
                                               return_stderr=True,
                                               blocking_call=False)
        if error:
            raise Exception(f"Failed to start iPerf server: {error}")

    def start_iperf_client(self,  # pylint: disable=R0913
                           device: str,
                           server_ip: str,
                           bind_ip: str,
                           protocol: str,
                           log_name: str,
                           port: int = 5201,
                           timeout: int = 10,
                           mode: str = None,
                           tos: str = None,
                           bitrate: str = None,
                           window_size: str = None,
                           parallel_streams: int = None):
        """
        Generate an iperf client and store logs locally.
        """
        zi_logger.log(
            f"generic.generic_traffic_generator.start_iperf_client({device},"
            f"{server_ip}, {bind_ip}, {protocol}, {log_name}, {port}, {timeout},"
            f"{mode}, {bitrate}, {window_size}, {parallel_streams})"
        )

        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)

        protocol = protocol.lower()
        if protocol not in ('tcp', 'udp'):
            raise ValueError(f"Invalid protocol '{protocol}'. Must be 'tcp' or 'udp'")

        modes = [None, 'parallel', 'bidir', 'reverse']
        if mode and mode.lower() not in modes:
            raise ValueError(f"Mode '{mode}' not supported. Choose from {modes}")

        cmd_parts = [
            f"iperf3.exe -c {server_ip}",
            f"-B {bind_ip}",
            f"-p {port}",
            f"-t {timeout}",
            f"--logfile {log_name}",
            "-u" if protocol == "udp" else ""
        ]

        if mode:
            mode = mode.lower()
            if mode == "reverse":
                cmd_parts.append("-R")
            elif mode == "parallel":
                if not isinstance(parallel_streams, int) or parallel_streams < 1:
                    raise ValueError("Parallel mode requires a valid stream count (parallel_streams ≥ 1).")
                cmd_parts.append(f"-P {parallel_streams}")
            elif mode == "bidir":
                cmd_parts.append("--bidir")

        if tos:
            cmd_parts.append(f"-S {tos}")

        if bitrate and protocol == "udp":
            cmd_parts.append(f"-b {bitrate}")

        if window_size and protocol == "tcp":
            cmd_parts.append(f"-w {window_size}")

        filter_cmd_parts = list(filter(None, cmd_parts))
        command = " ".join(filter_cmd_parts)

        error = connection_obj.execute_command(command,
                                               return_stdout=False,
                                               return_stderr=True)
        if error:
            raise Exception(f"Failed to run iPerf client: {error}")
        