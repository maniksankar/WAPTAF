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
Traffic Generator Module.

Author: Zilogic Systems <code@zilogic.com>

This module provides utilities for generating network traffic using SSH,
including support for TCP, UDP, and multicast traffic flows.
"""
# Standard Libraries
import sys
import platform
from typing import Pattern, Dict, Any, Optional

# Third-party Libraries
from robot.api.deco import keyword

# Local Libraries
from zi4pitstop.lib.bridge.database_module import DatabaseModule
from zi4pitstop.lib.bridge.platform_modules import PlatformModules
import zi4pitstop.lib.utils.zi_logger as zi_logger

class TrafficGenerator(DatabaseModule,
                       PlatformModules):
    """
    TrafficGenerator is a Robot Framework test library for
    performing iperf-based traffic generation over SSH.

    This library is designed to cover the full functionality of
    the iperf tool across different platforms.

    It provides multiple keywords that allow interaction with
    iperf through SSH connections.
    """
    ROBOT_AUTO_KEYWORDS = False
    ROBOT_LIBRARY_SCOPE = 'Global'

    def __init__(self):
        zi_logger.log("Traffic_Generator __init__ : START")
        DatabaseModule.__init__(self)
        PlatformModules.__init__(self)
        self.db_obj = self.get_database_module_object()
        zi_logger.log(f"==== db_obj : {self.db_obj}")
        zi_logger.log("Traffic_generator __init__ : END")
    
    def __get_platform(self):
        """ Get testpc platform"""
        return platform.system().lower()

    @keyword("Start Iperf Server")
    def start_iperf_server(self, # pylint: disable=R0913
                           device: str,
                           bind_ip: str,
                           log_name: str,
                           port: int = 5201):
        """
        Generate an iperf server and store logs locally.

        - ``device`` Specifies the device name.
        - ``bind_ip`` Specified associated with the address
        - ``log_name`` Name of the log file,
            typically set to the test case name.
        - ``port`` Specifies the port number. The default is 5201.

        Example:
        | Start Iperf Server  | Ap | 192.168.1.1 | demo |
        | Start Iperf Server  | Ap | 192.168.1.1 | log_name = TC001 | 5001 |
        | Start Iperf Server  | Ap | 192.168.1.1 | demo | port = 5222 |

        """
        zi_logger.log(
            f"lib.map.TrafficGenerator.start_iperf_server({device}, "
            f"{bind_ip}, {log_name}, {port} ")
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        platform_obj.start_iperf_server(device,
                                        bind_ip,
                                        log_name,
                                        port)

    @keyword("Start Iperf Client")
    def start_iperf_client(self, # pylint: disable=R0913
                           device: str,
                           server_ip: str,
                           bind_ip: str,
                           protocol: str,
                           log_name: str,
                           port: int = 5201,
                           timeout: int = 10,
                           bitrate: str = None,
                           tos: str = None,
                           window_size: str = None,
                           mode: str = None,
                           parallel_streams: int = None):
        """
        Generate an iperf client and store logs locally.

        - ``device``            Specifies the device name.
        - ``server_ip``         Specifies the server IP address.
                                This is a mandatory parameter.
        - ``bind_ip``           Specifies the IP address to bind locally.
        - ``protocol``          Specifies the protocol type (e.g., tcp or udp).
        - ``log_name``          Name of the log file, typically set to the test case name.
        - ``port``              Specifies the port number. The default is 5201.
        - ``timeout``           Duration to run the service. The default is 10 seconds.
        - ``bitrate``           Bitrate for UDP traffic (e.g., '10M'). Only valid for UDP.
        - ``tos``               Type of Service (TOS) or DSCP value (e.g., '0x20').
        - ``window_size``       TCP window size (e.g., '256K'). Only valid for TCP.
        - ``mode``              Specifies the iperf mode (e.g., 'parallel', 'bidir', 'reverse').
        - ``parallel_streams``  Number of parallel client streams (e.g., 4).

        Example:
        | Start Iperf Client | client1 | 172.16.0.100 | 172.16.0.1 | Tcp | demo.log |
        | Start Iperf Client | Ap | 172.16.0.100 | 172.16.0.1 | Udp | TC001.log | 5001 | 10 |
        | Start Iperf Client | Ap | 172.16.0.100 | 172.16.0.1 | Udp | TC002.log | 5201 | 20 | 10M | 0x20 | 256K |
        | Start Iperf Client | client2 | 192.168.1.10 | 192.168.1.1 | Tcp | TC003.log | 5201 | mode=parallel | parallel_streams=4 |
        """
        zi_logger.log(
            f"lib.map.TrafficGenerator.start_iperf_client({device}, "
            f"{server_ip}, {bind_ip}, {protocol}, {log_name}, {port}, {timeout}")
        
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        platform_obj.start_iperf_client(device,
                                        server_ip,
                                        bind_ip,
                                        protocol,
                                        log_name,
                                        port,
                                        timeout,
                                        bitrate,
                                        tos,
                                        window_size,
                                        mode,
                                        parallel_streams)

    @keyword("Stop Iperf Server")
    def stop_iperf_server(self,
                          device: str):
        """
        Stop the iperf server using `pkill` on Linux/macOS
        or `taskkill` on Windows.

        - ``device``       Specifies the device name.

        Example:
        | Stop Iperf Server | Ap |
        """
        zi_logger.log(
            f"lib.map.TrafficGenerator.stop_iperf_server({device})")
        
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        platform_obj.stop_iperf_server(device)

    @keyword("Get Iperf Log")
    def get_iperf_log(self,
                      device: str,
                      remote_file: str,
                      local_file: str):
        """
        Retrieve a iperf log from the remote machine.

        - ``device`` Specified a remote device.
        - ``remote_file`` The file path on the remote machine.
        - ``local_file`` The destination path on the local.

        Example:
        | Get Iperf Log | Ap | /remote/file.log | /tmp/file.log | #Linux |
        | Get Iperf Log | Ap | C:\\remote\\file.log | C:\\file.log | #Windows |
        """
        zi_logger.log(
            f"lib.map.TrafficGenerator.get_iperf_log({device},"  
            f"{remote_file}, {local_file})")        
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        platform_obj.get_iperf_log(device, remote_file, local_file)
    
    @keyword("Put Iperf Log")
    def put_iperf_log(self,
                      device: str,
                      local_file: str,
                      remote_file: str):
        """
        Transfer a file from the local machine to the remote machine.

        - ``device`` Specified the remote machine.
        - ``local_file`` The file path on the local machine.
        - ``remote_file`` The destination path on the remote.

        Example:
        | Put Iperf Log | Ap | /test/file.log | /tmp/file.log | # Linux |
        | Put Iperf Log | Ap | C:\\local\\file.log | C:\\file.log | # Windows |
        """
        zi_logger.log(
            f"lib.map.TrafficGenerator.put_iperf_log({device}, "  
            f"{local_file}, {remote_file}")
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        platform_obj.put_iperf_log(device, local_file, remote_file)
    
    @keyword("Remove Iperf Logs")
    def remove_iperf_logs(self,
                          device: str,
                          dirpath: str):
        """
        Remove Iperf Logs From specified device and specified directory.

        - ``device`` Mention a device name.
        - ``dirpath`` Specified a directory path

        Example:
        | Remove Iperf Logs | Client | /tmp | # For Linux |
        | Remove Iperf Logs | Client | C:\\Windows\temp" | # Windows |
        """
        zi_logger.log(
            f"lib.map.TrafficGenerator.remove_iperf_logs({device})")

        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        platform_obj.remove_iperf_logs(device, dirpath)

    @keyword("Remove Iperf Log")
    def remove_iperf_log(self,
                         device: str,
                         filename: str):
        """
        Remove Iperf Log From specified device.

        - ``device`` Mention a device name.
        - ``filename`` Specified filename.

        Example:
        | Remove Iperf Log | Client | /tmp/iperf.log |  # For Linux |
        | Remove Iperf Log | Client | C:\\temp\\iperf.log | # Windows |
        """
        zi_logger.log(
            f"lib.map.TrafficGenerator.remove_iperf_log({device})")

        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        platform_obj.remove_iperf_log(device, filename)
    
    @keyword("Get Udp Metrics")
    def get_udp_metrics(self,
                        filename: str,
                        data_flow_role: str,
                        direction: str=None) -> Optional[Dict[str, Any]]:
        """
        Extract UDP metrics from the filename. Ex: like interval, jitter etc.,

        - ``filename`` Specified a given log file.
        - ``data_flow_role`` Type of data flow like ('sender' or 'receiver').
        - ``direction``: Specifies the direction of data flow ('transmitter' or 'receiver').
            This argument is applicable only for bidirectional mode logs. Default is ``None``.
        - ``return`` A dictionary containing UDP metrics or None.

        Example:
        | ${metrics} = | Get Udp Metrics | /tmp/client.log | sender   |
        | ${metrics} = | Get Udp Metrics | C:\\temp\\client.log | receiver |
        | ${metrics} = | Get Udp Metrics | C:\\temp\\client.log | receiver | transmitter |
        """
        zi_logger.log(
            f"lib.map.TrafficGenerator.get_udp_metrics({filename}, {data_flow_role}, {direction})")
        platform = self.__get_platform()
        platform_obj = self.get_platform_module_object(platform)
        metrics = platform_obj.get_udp_metrics(filename, data_flow_role, direction)
        return metrics

    @keyword("Get Tcp Metrics")
    def get_tcp_metrics(self,
                        filename: str,
                        data_flow_role: str,
                        direction: str = None) -> Dict[str, Any]:
        """
        Extract TCP metrics from the log filename. Ex: interval, bitrate.

        - ``filename``: Specified log file path.
        - ``data_flow_role``: Type of data flow ('sender' or 'receiver').
        - ``direction``: Specifies the direction of data flow ('transmitter' or 'receiver').  
            This argument is applicable only for bidirectional mode logs. Default is ``None``.
        - ``return``: A dictionary containing TCP metrics or None.

        Example:
        | ${metrics} = | Get Tcp Metrics | /tmp/client.log | sender   |
        | ${metrics} = | Get Tcp Metrics | C:\\temp\\client.log | receiver |
        | ${metrics} = | Get Tcp Metrics | C:\\temp\\client.log | receiver | transmitter |
        """
        zi_logger.log(
            f"lib.map.TrafficGenerator.get_tcp_metrics({filename},{data_flow_role},{direction})")
        platform = self.__get_platform()
        platform_obj = self.get_platform_module_object(platform)
        metrics = platform_obj.get_tcp_metrics(filename, data_flow_role, direction)
        return metrics

    @keyword("Get Throughput")
    def get_throughput(self,
                       filename: str,
                       protocol: str,
                       data_flow_role: str,
                       direction: str = None) -> str:
        """
        Extract throughput from the given log filename.

        - ``filename`` Path to the file containing throughput data.
        - ``protocol`` Protocol type ('tcp' or 'udp').
        - ``data_flow_role`` Type of data ('sender' or 'receiver').
        - ``direction``: Specifies the direction of data flow ('transmitter' or 'receiver').  
            This argument is applicable only for bidirectional mode logs. Default is ``None``.
        - ``return`` Throughput value as a string.

        Example:
        | ${out} | Get Throughput | /tmp/a.log | tcp | sender   | # linux   |
        | ${out} | Get Throughput | C:\\b.log  | udp | receiver | # Windows |
        | ${out} | Get Throughput | /tmp/a.log | tcp | sender   | transmitter | # bidirectional |
        """
        zi_logger.log(
            f"lib.map.TrafficGenerator.get_throughput({filename},"
            f"{protocol}, {data_flow_role}, {direction})")
        platform = self.__get_platform()
        platform_obj = self.get_platform_module_object(platform)
        throughput = platform_obj.get_throughput(filename, protocol, data_flow_role, direction)
        return throughput
    
    @keyword("Get Packet Loss")
    def get_packet_loss(self,
                        filename: str,
                        protocol: str,
                        data_flow_role: str,
                        direction: str = None) -> int:
        """
        Extracting packet loss from the given log filename.

        - ``filename`` Path to the file containing throughput data.
        - ``protocol`` Protocol type ('tcp' or 'udp').
        - ``data_flow_role`` Type of data ('sender' or 'receiver').
        - ``direction``: Specifies the direction of data flow ('transmitter' or 'receiver').  
            This argument is applicable only for bidirectional mode logs. Default is ``None``.
        - ``return`` packet loss value as a integer.

        Example:
        | ${out} | Get Packet Loss | /tmp/a.log | tcp | sender | #linux |
        | ${out} | Get Packet Loss | C:\\b.log | udp | receiver | #Windows |
        | ${out} | Get Packet Loss | a.log | tcp | sender | receiver | # bidirectional |
        """
        zi_logger.log(
            f"lib.map.TrafficGenerator.get_packet_loss({filename},"
            f"{protocol}, {data_flow_role}, {direction})")
        platform = self.__get_platform()
        platform_obj = self.get_platform_module_object(platform)
        loss = platform_obj.get_packet_loss(filename, protocol, data_flow_role, direction)
        return loss

    @keyword("Get Jitter")
    def get_jitter(self,
                   filename: str,
                   protocol: str,
                   data_flow_role: str,
                   direction: str = None) -> str:
        """
        Extracting jitter from the given log filename.

        - ``filename`` Path to the file containing throughput data.
        - ``protocol`` Protocol type ('tcp' or 'udp').
        - ``data_flow_role`` Type of data ('sender' or 'receiver').
        - ``direction``: Specifies the direction of data flow ('transmitter' or 'receiver').  
            This argument is applicable only for bidirectional mode logs. Default is ``None``.
        - ``return`` jitter value as a string. For Example: 0.038 ms.

        Example:
        | ${out} | Get Jitter | /tmp/client.log | tcp | sender | #linux |
        | ${out} | Get Jitter | C:\\a.log | udp | receiver | # Windows |
        | ${out} | Get Jitter | client.log | udp | sender | transmitter | # bidirectional |
        """
        zi_logger.log(
            f"lib.map.TrafficGenerator.get_jitter({filename},"
            f"{protocol}, {data_flow_role}, {direction})")
        platform = self.__get_platform()
        platform_obj = self.get_platform_module_object(platform)
        jitter = platform_obj.get_jitter(filename, protocol, data_flow_role, direction)
        return jitter
    
    @keyword("Get Time Span")
    def get_time_span(self,
                      filename: str,
                      protocol: str,
                      data_flow_role: str,
                      direction: str = None) -> str:
        """
        Extracting interval or time span from the given filename.

        - ``filename`` Path to the file containing throughput data.
        - ``protocol`` Protocol type ('tcp' or 'udp').
        - ``data_flow_role`` Type of data ('sender' or 'receiver').
        - ``direction``: Specifies the direction of data flow ('transmitter' or 'receiver').  
            This argument is applicable only for bidirectional mode logs. Default is ``None``.
        - ``return`` Interval value as a string. For Example: 0.00-10.00 ms

        Example:
        | ${out} | Get Time Span | /tmp/client.log | tcp | sender | # linux |
        | ${out} | Get Time Span | C:\\a.log | udp | receiver | # Windows |
        | ${out} | Get Time Span | client.log | tcp | sender | transmitter | # bidirectional |
        """
        zi_logger.log(
            f"lib.map.TrafficGenerator.get_time_span({filename},"
            f"{protocol}, {data_flow_role}, {direction})")
        platform = self.__get_platform()
        platform_obj = self.get_platform_module_object(platform)
        interval = platform_obj.get_time_span(filename, protocol, data_flow_role, direction)
        return interval

    @keyword("Get Transfer Rate")
    def get_transfer_rate(self,
                          filename: str,
                          protocol: str,
                          data_flow_role: str,
                          direction: str = None) -> str:
        """
        Extracting transfer rate from the given filename.

        - ``filename`` Path to the file containing throughput data.
        - ``protocol`` Protocol type ('tcp' or 'udp').
        - ``data_flow_role`` Type of data ('sender' or 'receiver').
        - ``direction``: Specifies the direction of data flow ('transmitter' or 'receiver').  
            This argument is applicable only for bidirectional mode logs. Default is ``None``.
        - ``return`` Transfer rate value as a string. For Example: 1.25 MBytes

        Example:
        | ${out} | Get Transfer Rate | /tmp/a.log | tcp | sender | #linux |
        | ${out} | Get Transfer Rate | C:\\b.log | udp | receiver | #Windows |
        | ${out} | Get Transfer Rate | /tmp/a.log | tcp | sender | transmitter |
        """
        zi_logger.log(
            f"lib.map.TrafficGenerator.get_transfer_rate({filename},"
            f"{protocol}, {data_flow_role}, {direction})")
        platform = self.__get_platform()
        platform_obj = self.get_platform_module_object(platform)
        transfer_rate = platform_obj.get_transfer_rate(filename,
                                                       protocol,
                                                       data_flow_role,
                                                       direction)
        return transfer_rate
    
    @keyword("Iperf Log Should Exist")
    def iperf_log_should_exist(self,
                               device: str,
                               filename: str) -> None:
        """
        Check whether the specified iperf log
        file should exists on the given device.

        - ``device``: Name of the device to check (e.g., DUT or client).
        - ``filename``: Name of the iperf log file to verify.

        - Raises: FileNotFoundError: If the specified log file does
                  not exist on the device.

        Example:
        | Iperf Log Should Exist | Ap | /tmp/iperf_client.log |
        """
        zi_logger.log(
            f"lib.map.TrafficGenerator.iperf_log_should_exist({device}, {filename})")
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        platform_obj.iperf_log_should_exist(device, filename)

    @keyword("Iperf Log Should Not Exist")
    def iperf_log_should_not_exist(self,
                            device: str,
                            filename: str):
        """
        Check whether the specified iperf log file should not exists
        on the given device.

        - ``device``: Name of the device to check (e.g., DUT or client).
        - ``filename``: Name of the iperf log file to verify.

        - Raises: FileFoundError: If the specified log file
                  does exist on the device.

        Example:
        | Iperf Log Should Not Exist  | Ap | /tmp/client.log |
        """
        zi_logger.log(
            f"lib.map.TrafficGenerator.iperf_log_should_not_exist({device}, {filename})")
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        platform_obj.iperf_log_should_not_exist(device, filename)
