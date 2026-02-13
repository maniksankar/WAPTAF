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
import os
import re
from typing import Pattern, Dict, Any, Optional

# Third-party Libraries
from robot.api.deco import keyword

# Local Libraries
from zi4pitstop.lib.bridge.database_module import DatabaseModule
from zi4pitstop.lib.bridge.connection_modules import ConnectionModules
from zi4pitstop.lib.base.base_traffic_generator import BaseFeatureTrafficGenerator
import zi4pitstop.lib.utils.zi_logger as zi_logger


class GenericTrafficGenerator(BaseFeatureTrafficGenerator,
                              DatabaseModule,
                              ConnectionModules):
    """
    This module provides generic functionalities for generating network traffic using SSH,
    including support for TCP, UDP, and multicast traffic flows.
    """
    def __init__(self):
        zi_logger.log("generic.GenericTrafficGenerator.__init__ : START")
        DatabaseModule.__init__(self)
        ConnectionModules.__init__(self)
        self.db_obj = self.get_database_module_object()
        zi_logger.log("generic.GenericTrafficGenerator.__init__ : END")
    
    def start_iperf_server(self, # pylint: disable=R0913
                           device: str,
                           bind_ip: str,
                           log_name: str,
                           port: int = 5201):
        """
        Generate an iperf server and store logs locally.
        """
        zi_logger.log(
            f"generic.generic_traffic_generator.start_iperf_server({device},"
            f"{bind_ip}, {log_name}, {port})"
            )
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        log_file = f"{log_name}"

        cmd_parts = [
            "iperf3 -s",
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
                           bitrate: str = None,
                           tos: str = None,
                           window_size: str = None,
                           mode: str = None,
                           parallel_streams: int = None):
        """
        Generate an iperf client and store logs locally.
        """
        zi_logger.log(
            f"generic.generic_traffic_generator.start_iperf_client({device},"
            f"{server_ip}, {bind_ip}, {protocol}, {log_name}, {port}, {timeout},"
            f"{bitrate}, {tos}, {window_size}, {mode}, {parallel_streams})"
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
            f"iperf3 -c {server_ip}",
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

    def get_iperf_log(self,
                      device: str,
                      remote_file: str,
                      local_file: str):
        """
        Retrieve a iperf log from the remote machine.
        """
        zi_logger.log(
            f"generic.generic_traffic_generator.get_iperf_log({device},"
            f"{remote_file}, {local_file}")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        connection_obj.get_file(remote_file, local_file)

    def put_iperf_log(self,
                      device: str,
                      local_file: str,
                      remote_file: str):
        """
        Transfer a file from the local machine to the remote machine.
        """
        zi_logger.log(
            f"generic.generic_traffic_generator.put_iperf_log({device},"
            f"{local_file}, {remote_file}")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        connection_obj.put_file(local_file, remote_file)

    # Pattern 
    def _tcp_sender_pattern(self) -> Pattern:
        return re.compile(
            r'\[\s*\d+\]\s+'                # [ ID]
            r'([\d\.]+-[\d\.]+)\s+sec\s+'   # Interval
            r'([\d\.]+\s+\w+)\s+'           # Transfer
            r'([\d\.]+\s+\w+/sec)\s+'       # Bitrate
            r'(\d+)\s+'                     # Retransmissions
            r'\s+sender'                    # sender marker
        )

    def _tcp_receiver_pattern(self) -> Pattern:
        return re.compile(
            r'\[\s*\d+\]\s+'                # [ ID]
            r'([\d\.]+-[\d\.]+)\s+sec\s+'   # Interval
            r'([\d\.]+\s+\w+)\s+'           # Transfer
            r'([\d\.]+\s+\w+/sec)'          # Bitrate
            r'\s+receiver'                  # receiver marker
        )

    def _udp_sender_pattern(self) -> Pattern:
        return re.compile(
            r'\[\s*\d+\]\s+'                # [ ID]
            r'([\d\.]+-[\d\.]+)\s+sec\s+'   # Interval
            r'([\d\.]+\s+\w+)\s+'           # Transfer
            r'([\d\.]+\s+\w+/sec)\s+'       # Bitrate
            r'([\d\.]+)\s+ms\s+'            # Jitter
            r'(\d+/\d+\s+\(\d+(\.\d+)?%\))' # Packet Loss
            r'\s+sender'                    # sender marker
        )

    def _udp_receiver_pattern(self) -> Pattern:
        return re.compile(
            r'\[\s*\d+\]\s+'                # [ ID]
            r'([\d\.]+-[\d\.]+)\s+sec\s+'   # Interval
            r'([\d\.]+\s+\w+)\s+'           # Transfer
            r'([\d\.]+\s+\w+/sec)\s+'       # Bitrate
            r'([\d\.]+)\s+ms\s+'            # Jitter
            r'(\d+/\d+\s+\(\d+(\.\d+)?%\))' # Packet Loss
            r'\s+receiver'                  # receiver marker
        )

    # Parallel stream sum pattern
    def _tcp_sum_sender_pattern(self) -> Pattern:
        return re.compile(
            r'\[SUM\]\s+'                   
            r'([\d\.]+-[\d\.]+)\s+sec\s+'   # Interval
            r'([\d\.]+\s+\w+)\s+'           # Transfer
            r'([\d\.]+\s+\w+/sec)\s+'       # Bitrate
            r'(\d+)\s+'                     # Retransmissions
            r'\s+sender'                    # sender marker
        )

    def _tcp_sum_receiver_pattern(self) -> Pattern:
        return re.compile(
            r'\[SUM\]\s+'                   
            r'([\d\.]+-[\d\.]+)\s+sec\s+'   # Interval
            r'([\d\.]+\s+\w+)\s+'           # Transfer
            r'([\d\.]+\s+\w+/sec)'          # Bitrate
            r'\s+receiver'                  # receiver marker
        )

    def _udp_sum_sender_pattern(self) -> Pattern:
        return re.compile(
            r'\[SUM\]\s+'                   # [SUM]
            r'([\d\.]+-[\d\.]+)\s+sec\s+'   # Interval
            r'([\d\.]+\s+\w+)\s+'           # Transfer
            r'([\d\.]+\s+\w+/sec)\s+'       # Bitrate
            r'([\d\.]+)\s+ms\s+'            # Jitter
            r'(\d+/\d+\s+\(\d+(\.\d+)?%\))' # Packet Loss
            r'\s+sender'                    # sender marker
        )

    def _udp_sum_receiver_pattern(self) -> Pattern:
        return re.compile(
            r'\[SUM\]\s+'                   # [SUM]
            r'([\d\.]+-[\d\.]+)\s+sec\s+'   # Interval
            r'([\d\.]+\s+\w+)\s+'           # Transfer
            r'([\d\.]+\s+\w+/sec)\s+'       # Bitrate
            r'([\d\.]+)\s+ms\s+'            # Jitter
            r'(\d+/\d+\s+\(\d+(\.\d+)?%\))' # Packet Loss
            r'\s+receiver'                  # receiver marker
        )

    # bidirectional stream udp pattern
    def _udp_tx_sender_pattern(self) -> Pattern:
        return re.compile(
            r'\[TX-C\]\s+'                   # [TX-C]
            r'([\d\.]+-[\d\.]+)\s+sec\s+'   # Interval
            r'([\d\.]+\s+\w+)\s+'           # Transfer
            r'([\d\.]+\s+\w+/sec)\s+'       # Bitrate
            r'([\d\.]+)\s+ms\s+'            # Jitter
            r'(\d+/\d+\s+\(\d+(\.\d+)?%\))' # Packet Loss
            r'\s+sender'                    # sender marker
        )

    def _udp_tx_receiver_pattern(self) -> Pattern:
        return re.compile(
            r'\[TX-C\]\s+'                   # [TX-C]
            r'([\d\.]+-[\d\.]+)\s+sec\s+'   # Interval
            r'([\d\.]+\s+\w+)\s+'           # Transfer
            r'([\d\.]+\s+\w+/sec)\s+'       # Bitrate
            r'([\d\.]+)\s+ms\s+'            # Jitter
            r'(\d+/\d+\s+\(\d+(\.\d+)?%\))' # Packet Loss
            r'\s+receiver'                  # receiver marker
        )

    def _udp_rx_sender_pattern(self) -> Pattern:
        return re.compile(
            r'\[RX-C\]\s+'                   # [RX-C]
            r'([\d\.]+-[\d\.]+)\s+sec\s+'   # Interval
            r'([\d\.]+\s+\w+)\s+'           # Transfer
            r'([\d\.]+\s+\w+/sec)\s+'       # Bitrate
            r'([\d\.]+)\s+ms\s+'            # Jitter
            r'(\d+/\d+\s+\(\d+(\.\d+)?%\))' # Packet Loss
            r'\s+sender'                    # sender marker
        )

    def _udp_rx_receiver_pattern(self) -> Pattern:
        return re.compile(
            r'\[RX-C\]\s+'                   # [RX-C]
            r'([\d\.]+-[\d\.]+)\s+sec\s+'   # Interval
            r'([\d\.]+\s+\w+)\s+'           # Transfer
            r'([\d\.]+\s+\w+/sec)\s+'       # Bitrate
            r'([\d\.]+)\s+ms\s+'            # Jitter
            r'(\d+/\d+\s+\(\d+(\.\d+)?%\))' # Packet Loss
            r'\s+receiver'                  # receiver marker
        )

    # bidirectional stream tcp pattern
    def _tcp_tx_sender_pattern(self) -> Pattern:
        return re.compile(
            r'\[TX-C\]\s+'                   
            r'([\d\.]+-[\d\.]+)\s+sec\s+'   # Interval
            r'([\d\.]+\s+\w+)\s+'           # Transfer
            r'([\d\.]+\s+\w+/sec)\s+'       # Bitrate
            r'(\d+)\s+'                     # Retransmissions
            r'\s+sender'                    # sender marker
        )

    def _tcp_tx_receiver_pattern(self) -> Pattern:
        return re.compile(
            r'\[TX-C\]\s+'                   
            r'([\d\.]+-[\d\.]+)\s+sec\s+'   # Interval
            r'([\d\.]+\s+\w+)\s+'           # Transfer
            r'([\d\.]+\s+\w+/sec)'          # Bitrate
            r'\s+receiver'                  # receiver marker
        )
    
    def _tcp_rx_sender_pattern(self) -> Pattern:
        return re.compile(
            r'\[RX-C\]\s+'                   
            r'([\d\.]+-[\d\.]+)\s+sec\s+'   # Interval
            r'([\d\.]+\s+\w+)\s+'           # Transfer
            r'([\d\.]+\s+\w+/sec)\s+'       # Bitrate
            r'(\d+)\s+'                     # Retransmissions
            r'\s+sender'                    # sender marker
        )

    def _tcp_rx_receiver_pattern(self) -> Pattern:
        return re.compile(
            r'\[RX-C\]\s+'                   
            r'([\d\.]+-[\d\.]+)\s+sec\s+'   # Interval
            r'([\d\.]+\s+\w+)\s+'           # Transfer
            r'([\d\.]+\s+\w+/sec)'          # Bitrate
            r'\s+receiver'                  # receiver marker
        )

    def _get_file_content(self,
                          filename: str) -> str:
        """
        Extracting file contents from given filename name.
        """
        if not os.path.exists(filename):
            raise FileNotFoundError(f"Error: {filename} does not exist.")
        with open(filename, 'r', encoding="utf-8") as file:
            file_content = file.read()
            return file_content

    def get_udp_metrics(self,
                        filename: str,
                        data_flow_role: str,
                        direction: Optional[str] = None) -> Optional[Dict[str, Any]]:
        """
        Extract UDP metrics from an iperf log file.
        Handles normal, parallel, reverse, and bidirectional modes.
        """
        zi_logger.log(
            f"generic.generic_traffic_generator.get_udp_metrics({filename},"
            f"{data_flow_role}, direction={direction})"
        )
        
        file_content = self._get_file_content(filename)
        data_flow_role = data_flow_role.lower()

        if direction:
            direction = direction.lower()
            if direction == "transmitter":
                if data_flow_role == "sender":
                    match = self._udp_tx_sender_pattern().search(file_content)
                elif data_flow_role == "receiver":
                    match = self._udp_tx_receiver_pattern().search(file_content)
                else:
                    raise ValueError(f"Invalid data_flow_role: {data_flow_role}")
            elif direction == "receiver":
                if data_flow_role == "sender":
                    match = self._udp_rx_sender_pattern().search(file_content)
                elif data_flow_role == "receiver":
                    match = self._udp_rx_receiver_pattern().search(file_content)
                else:
                    raise ValueError(f"Invalid data_flow_role: {data_flow_role}")
            else:
                raise ValueError(f"Invalid direction: {direction}. Must be 'transmitter' or 'receiver'.")
        else:
            if data_flow_role == 'sender':
                match = self._udp_sum_sender_pattern().search(file_content)
                if not match:
                    match = self._udp_sender_pattern().search(file_content)
            elif data_flow_role == 'receiver':
                match = self._udp_sum_receiver_pattern().search(file_content)
                if not match:
                    match = self._udp_receiver_pattern().search(file_content)
            else:
                raise ValueError(f"Invalid data_flow_role: {data_flow_role}")

        if not match:
            raise ValueError(f"Failed to parse {data_flow_role} UDP metrics "
                             f"from file: {filename} (direction={direction})")

        return {
            'type': 'udp',
            'role': data_flow_role,
            'interval': match.group(1),
            'transfer': match.group(2),
            'bitrate': match.group(3),
            'jitter': f"{match.group(4)} ms",
            'packet_loss': match.group(5)
        }

    def get_tcp_metrics(self,
                        filename: str,
                        data_flow_role: str,
                        direction: Optional[str] = None) -> Dict[str, Any]:
        """
        Extract TCP metrics from an iperf log file.
        Supports normal, parallel, reverse, and bidirectional modes.
        """
        zi_logger.log(
            f"generic.generic_traffic_generator.get_tcp_metrics({filename}, "
            f"{data_flow_role}, direction={direction})"
        )

        file_content = self._get_file_content(filename)
        print(file_content)
        data_flow_role = data_flow_role.lower()

        tcp_match = None
        retransmission = None

        if direction:
            direction = direction.lower()
            if direction == "transmitter":
                if data_flow_role == "sender":
                    tcp_match = self._tcp_tx_sender_pattern().search(file_content)
                    retransmission = int(tcp_match.group(4))
                elif data_flow_role == "receiver":
                    tcp_match = self._tcp_tx_receiver_pattern().search(file_content)
                else:
                    raise ValueError(f"Invalid data_flow_role: {data_flow_role}")
            elif direction == "receiver":
                if data_flow_role == "sender":
                    tcp_match = self._tcp_rx_sender_pattern().search(file_content)
                    retransmission = int(tcp_match.group(4))
                elif data_flow_role == "receiver":
                    tcp_match = self._tcp_rx_receiver_pattern().search(file_content)
                else:
                    raise ValueError(f"Invalid data_flow_role: {data_flow_role}")
            else:
                raise ValueError(f"Invalid direction: {direction}. Must be 'transmitter' or 'receiver'.")
        else:
            if data_flow_role == "sender":
                tcp_match = self._tcp_sender_pattern().search(file_content)
                if not tcp_match:
                    tcp_match = self._tcp_sum_sender_pattern().search(file_content)

                if tcp_match:
                    retransmission = int(tcp_match.group(4))
            elif data_flow_role == "receiver":
                tcp_match = self._tcp_receiver_pattern().search(file_content)
                if not tcp_match:
                    tcp_match = self._tcp_sum_receiver_pattern().search(file_content)
            else:
                raise ValueError(f"Invalid data_flow_role: {data_flow_role}")

        if not tcp_match:
            raise ValueError(f"Failed to parse TCP metrics from file: {filename} "
                             f"(role={data_flow_role}, direction={direction})")
        return {
            'type': 'tcp',
            'role': data_flow_role,
            'interval': tcp_match.group(1),
            'transfer': tcp_match.group(2),
            'bitrate': tcp_match.group(3),
            'retransmissions': retransmission
        }

    def get_throughput(self,
                       filename: str,
                       protocol: str,
                       data_flow_role: str,
                       direction: Optional[str] = None) -> str:
        """
        Extract throughput from the given log filename.
        """
        zi_logger.log(
            f"generic.generic_traffic_generator.get_throughput({filename},"
            f"{protocol}, {data_flow_role}, direction={direction})"
            )
        protocol = protocol.lower()
        valid_protocols = {"tcp", "udp"}

        data_flow_role = data_flow_role.lower()
        valid_types = {"sender", "receiver"}

        if protocol not in valid_protocols:
            raise ValueError(f"Invalid protocol: '{protocol}'.",
                             "Must be 'tcp' or 'udp'.")

        if data_flow_role not in valid_types:
            raise ValueError(
                f"Invalid type: '{data_flow_role}'.",
                "Must be 'sender' or 'receiver'.")
        metrics = {}
        if protocol == "tcp":
            metrics = self.get_tcp_metrics(
                filename, data_flow_role, direction)
        elif protocol == "udp":
            metrics = self.get_udp_metrics(
                filename, data_flow_role, direction)

        if 'bitrate' not in metrics:
            raise Exception("Bitrate information not found in metrics.")
        return metrics['bitrate']

    def get_packet_loss(self,
                        filename: str,
                        protocol: str,
                        data_flow_role: str,
                        direction: Optional[str] = None) -> int:
        """
        Extracting packet loss from the given log filename.
        """
        zi_logger.log(
            f"generic.generic_traffic_generator.get_packet_loss({filename},"
            f"{protocol}, {data_flow_role}, direction={direction})"
            )
        metrics = {}
        protocol = protocol.lower()
        valid_protocols = {"tcp", "udp"}

        data_flow_role = data_flow_role.lower()
        valid_types = {"sender", "receiver"}

        if protocol not in valid_protocols:
            raise ValueError(f"Invalid protocol: '{protocol}'.",
                             "Must be 'tcp' or 'udp'.")

        if data_flow_role not in valid_types:
            raise ValueError(f"Invalid type: '{data_flow_role}'.",
                             "Must be 'sender' or 'receiver'.")

        if protocol == "tcp":
            metrics = self.get_tcp_metrics(
                filename, data_flow_role, direction)
            packet_loss = metrics['retransmissions']
            return packet_loss

        metrics = self.get_udp_metrics(
            filename, data_flow_role, direction)
        packet_loss = metrics['packet_loss']

        loss_pattern = r"\((\d+)%\)"
        match = re.search(loss_pattern, packet_loss)

        if not match:
            raise Exception("Packet loss pattern doesn't match")

        return match.group(1)

    def get_jitter(self,
                   filename: str,
                   protocol: str,
                   data_flow_role: str,
                   direction: Optional[str] = None) -> str:
        """
        Extracting jitter from the given log filename.
        """
        zi_logger.log(
            f"generic.generic_traffic_generator.get_jitter({filename},"
            f"{protocol}, {data_flow_role}, direction={direction})"
            )
        protocol = protocol.lower()
        data_flow_role = data_flow_role.lower()
        valid_types = {"sender", "receiver"}

        if protocol != 'udp':
            raise ValueError(
                f"Invalid protocol: '{protocol}'."
                f"Must be 'udp'. Jitter is not available in tcp"
            )

        if data_flow_role not in valid_types:
            raise ValueError(f"Invalid type: '{data_flow_role}'.",
                             "Must be 'sender' or 'receiver'.")

        metrics = self.get_udp_metrics(
            filename, data_flow_role, direction)
        return metrics['jitter']

    def get_time_span(self,
                      filename: str,
                      protocol: str,
                      data_flow_role: str,
                      direction: Optional[str] = None) -> str:
        """
        Extracting interval or time span from the given filename.
        """
        zi_logger.log(
            f"generic.generic_traffic_generator.get_time_span({filename},"
            f"{protocol}, {data_flow_role}, direction={direction})"
            )
        protocol = protocol.lower()
        valid_protocols = {"tcp", "udp"}

        data_flow_role = data_flow_role.lower()
        valid_types = {"sender", "receiver"}

        if protocol not in valid_protocols:
            raise ValueError(f"Invalid protocol: '{protocol}'.",
                             "Must be 'tcp' or 'udp'.")

        if data_flow_role not in valid_types:
            raise ValueError(f"Invalid type: '{data_flow_role}'."
                             "Must be 'sender' or 'receiver'.")
        metrics = {}
        if protocol == "tcp":
            metrics = self.get_tcp_metrics(
                filename, data_flow_role, direction)
        elif protocol == "udp":
            metrics = self.get_udp_metrics(
                filename, data_flow_role, direction)

        if 'interval' not in metrics:
            raise Exception("Interval information not found in metrics.")
        return metrics['interval']
    
    def get_transfer_rate(self,
                          filename: str,
                          protocol: str,
                          data_flow_role: str,
                          direction: Optional[str] = None) -> str:
        """
        Extracting transfer rate from the given filename.
        """
        zi_logger.log(
            f"generic.generic_traffic_generator.get_transfer_rate({filename},"
            f"{protocol}, {data_flow_role}, direction={direction})"
            )
        metrics = {}
        protocol = protocol.lower()
        valid_protocols = {"tcp", "udp"}

        data_flow_role = data_flow_role.lower()
        valid_types = {"sender", "receiver"}

        if protocol not in valid_protocols:
            raise ValueError(f"Invalid protocol: '{protocol}'.",
                             "Must be 'tcp' or 'udp'.")

        if data_flow_role not in valid_types:
            raise ValueError(
                f"Invalid type: '{data_flow_role}'.",
                "Must be 'sender' or 'receiver'.")

        if protocol == "tcp":
            metrics = self.get_tcp_metrics(
                filename, data_flow_role, direction)
        elif protocol == "udp":
            metrics = self.get_udp_metrics(
                filename, data_flow_role, direction)

        if 'transfer' not in metrics:
            raise Exception("Transfer rate information not found in metrics.")
        return metrics['transfer']

    def stop_iperf_server(self,
                          device: str):
        """
        Stop the iperf server using pkill command
        """
        zi_logger.log(
            f"generic.feature_traffic_generator.stop_iperf_server({device})"
            )
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)

        platform = self.db_obj.read_from_database(device, 'platform')

        command = "killall iperf3"

        connection_obj.execute_command(command,
                                       return_stdout=False,
                                       return_stderr=True)

    def remove_iperf_logs(self,
                          device: str,
                          dirpath: str):
        """
        Remove Iperf Logs From specified device and specified directory.
        """
        zi_logger.log(
            f"generic.feature_traffic_generator.remove_iperf_logs({device}, {dirpath})"
            )
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        command = f"rm {dirpath}/*.log"

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
            f"generic.feature_traffic_generator.remove_iperf_log({device}, {filename})"
            )
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        
        command = f"rm {filename}"

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
            f"generic.feature_traffic_generator.iperf_log_should_exist({device}, {filename})"
            )
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        
        command = f"ls {filename}"

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
            f"generic.feature_traffic_generator.iperf_log_should_not_exist({device}, {filename})"
            )
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)

        command = f"ls {filename}"

        error = connection_obj.execute_command(command,
                                               return_stdout=False,
                                               return_stderr=True)
        if error == '':
            raise Exception(f"FileFoundError: {filename} exists.")
