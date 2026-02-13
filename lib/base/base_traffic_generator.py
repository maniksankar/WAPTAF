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
This module handles traffic generator functions an abstract method

Author: Zilogic Systems <code@zilogic.com>
"""
from abc import ABC, abstractmethod
from typing import Dict, Any, Optional

class BaseFeatureTrafficGenerator(ABC):
    """ This module provide abstract class for the APIs in traffic generator functions"""

    @abstractmethod
    def start_iperf_server(self,
                           device: str,
                           bind_ip: str,
                           log_name: str,
                           port: int):
        """ Start the iperf server function abstract method"""
        raise NotImplementedError("Subclass must implement start_iperf_server()")

    @abstractmethod
    def start_iperf_client(self,
                           device: str,
                           server_ip: str,
                           bind_ip: str,
                           protocol: str,
                           log_name: str,
                           port: int,
                           timeout: int,
                           bitrate: str = None,
                           tos: str = None,
                           window_size: str = None,
                           mode: str = None,
                           parallel_streams: int = None):
        """ Start the iperf client function abstract method"""
        raise NotImplementedError("Subclass must implement start_iperf_client()")

    @abstractmethod
    def stop_iperf_server(self,
                          device: str):
        """ Stop the iperf server function abstract method"""
        raise NotImplementedError("Subclass must implement stop_iperf_server()")

    @abstractmethod
    def get_iperf_log(self,
                      device: str,
                      remote_file: str,
                      local_file: str):
        """ Get the iperf log function abstract method"""
        raise NotImplementedError("Subclass must implement get_iperf_log()")

    @abstractmethod
    def put_iperf_log(self,
                      device: str,
                      local_file: str,
                      remote_file: str):
        """ Put the iperf log function abstract method"""
        raise NotImplementedError("Subclass must implement put_iperf_log()")

    @abstractmethod
    def remove_iperf_logs(self,
                          device: str,
                          dirpath: str):
        """Remove the iperf logs function abstract method"""
        raise NotImplementedError("Subclass must implement remove_iperf_logs()")

    @abstractmethod
    def remove_iperf_log(self,
                         device: str,
                         filename: str):
        """Remove the iperf log function abstract method"""
        raise NotImplementedError("Subclass must implement remove_iperf_log()")

    @abstractmethod
    def get_udp_metrics(self,
                        filename: str,
                        data_flow_role: str,
                        direction: str = None) -> Optional[Dict[str, Any]]:
        """ Get the udp metrics function abstract method"""
        raise NotImplementedError("Subclass must implement get_udp_metrics()")

    @abstractmethod
    def get_tcp_metrics(self,
                        filename: str,
                        data_flow_role: str,
                        direction: str = None) -> Dict[str, Any]:
        """ Get the tcp metrics function abstract method"""
        raise NotImplementedError("Subclass must implement get_tcp_metrics()")

    @abstractmethod
    def get_throughput(self,
                       filename: str,
                       protocol: str,
                       data_flow_role: str,
                       direction: str = None) -> str:
        """ Get the throughput function abstract method"""
        raise NotImplementedError("Subclass must implement get_throughput()")

    @abstractmethod
    def get_packet_loss(self,
                        filename: str,
                        protocol: str,
                        data_flow_role: str,
                        direction: str = None) -> int:
        """ Get the packet loss function abstract method"""
        raise NotImplementedError("Subclass must implement get_packet_loss()")

    @abstractmethod
    def get_jitter(self,
                   filename: str,
                   protocol: str,
                   data_flow_role: str,
                   direction: str = None) -> str:
        """ Get the jitter function abstract method"""
        raise NotImplementedError("Subclass must implement get_jitter()")

    @abstractmethod
    def get_time_span(self,
                      filename: str,
                      protocol: str,
                      data_flow_role: str,
                      direction: str = None) -> str:
        """ Get the time period or time span function abstract method"""
        raise NotImplementedError("Subclass must implement get_time_span()")

    @abstractmethod
    def get_transfer_rate(self,
                          filename: str,
                          protocol: str,
                          data_flow_role: str,
                          direction: str = None) -> str:
        """ Get the transfer rate function abstract method"""
        raise NotImplementedError("Subclass must implement get_transfer_rate()")

    @abstractmethod
    def iperf_log_should_exist(self,
                               device: str,
                               filename: str):
        """Check iperf log should exists function abstract method"""
        raise NotImplementedError("Subclass must implement iperf_log_should_exist()")

    @abstractmethod
    def iperf_log_should_not_exist(self,
                                   device: str,
                                   filename: str):
        """Check iperf log should not exists function abstract method"""
        raise NotImplementedError("Subclass must implement iperf_log_should_not_exist()")
