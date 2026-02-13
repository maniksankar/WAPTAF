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

from datetime import datetime
import os

# Local Libraries
from zi4pitstop.lib.base.base_packet_sniffer import BaseFeaturePacketSniffer
from zi4pitstop.lib.bridge.database_module import DatabaseModule
from zi4pitstop.lib.bridge.connection_modules import ConnectionModules
import zi4pitstop.lib.utils.zi_logger as zi_logger


class PacketSniffer(BaseFeaturePacketSniffer,
                    DatabaseModule,
                    ConnectionModules):
    """Handles basic WiFi functionality keywords for Utils client."""

    def __init__(self):
        zi_logger.log("Utils.FeaturePacketSniffer __init__ : START")
        DatabaseModule.__init__(self)
        ConnectionModules.__init__(self)
        self.db_obj = self.get_database_module_object()
        zi_logger.log("Utils.FeaturePacketSniffer __init__ : END")

    def check_monitor_mode(self,
                           device: str) -> str:
        """
        Get the monitor mode status from given interface.
        """
        zi_logger.log(f"lib.utils.packet_sniffer.({device})")
        interface = self.db_obj.read_from_database(device, 'interface')
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        zi_logger.log(connection_obj)
        connection_obj.switch_connection(device)
        command = f"iw dev {interface} info | grep -i type"
        output, error = connection_obj.execute_command(command,
                                                       return_stdout=True,
                                                       return_stderr=True)
        zi_logger.log(f"output: {output}, error: {error}")
        if error:
            raise Exception(f"Command execution failed : {command}")
        return "monitor" in output.lower()



    def set_monitor_mode(self,
                         device: str):
        """
        Set the wireless interface to monitor mode.
        """

        zi_logger.log(f"lib.utils.packet_sniffer.({device})")
        interface = self.db_obj.read_from_database(device, 'interface')
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        zi_logger.log(connection_obj)
        connection_obj.switch_connection(device)
        if not self.check_monitor_mode(device):
            cmds = [
                f"ip link set {interface} down",
                f"iw {interface} set monitor none",
                f"ip link set {interface} up"
            ]
            for command in cmds:

                output, error = connection_obj.execute_command(command,
                                                       return_stdout=True,
                                                       return_stderr=True)
                zi_logger.log(f"output: {output}, error: {error}")
                if error:
                    raise Exception(f"Command execution failed : {command}")
                else:
                    zi_logger.log(f"{interface} is already in monitor mode.")


    def set_managed_mode(self,
                         device: str):
        """
        Set the wireless interface to Managed mode.
        """
         # Check if already in managed mode
        zi_logger.log(f"lib.utils.packet_sniffer.({device})")
        interface = self.db_obj.read_from_database(device, 'interface')
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        zi_logger.log(connection_obj)
        connection_obj.switch_connection(device)

        command = f"iw dev {interface} info | grep -i type"
        output, error = connection_obj.execute_command(command, return_stderr=True)
        if "managed" not in output.lower():
            cmds = [
                f"ip link set {interface} down",
                f"iw dev {interface} set type managed",
                f"ip link set {interface} up"
            ]
            for command in cmds:

                output, error = connection_obj.execute_command(command,
                                                       return_stdout=True,
                                                       return_stderr=True)
                zi_logger.log(f"output: {output}, error: {error}")
                if error:
                    raise Exception(f"Command execution failed : {command}")
                else:
                    zi_logger.log(f"{interface} is already in Manage mode.")
                

    def start_sniffing(self,
                       device: str,
                       pcap_filename: str = "sniff") -> str:
        """
        Start tcpdump-based sniffing on remote device in monitor mode.
        """
        zi_logger.log(f"lib.utils.packet_sniffer.({device})")
        interface = self.db_obj.read_from_database(device, 'interface')
        connection = self.db_obj.read_from_database(device, 'connection')
        pcap_dir = self.db_obj.read_from_database(device, "pcap_dir")
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        
        base = os.path.splitext(pcap_filename)[0]  # Remove .pcap if present
        filename = f"{base}_{timestamp}.pcap"

        if '/' not in base:
            full_path = os.path.join(pcap_dir, filename)
        else:
            full_path = filename  # Full path given

        self.pcap_file = full_path
        command = f"tcpdump -i {interface} -w {full_path}"
        connection_obj.execute_command(command, return_stderr=True, blocking_call=False)
        self.sniffing = True
        zi_logger.log(f"Starting sniffing on {device}, output file: {full_path}")
        return filename
    
    def stop_sniffing(self,
                      device: str):
        """
        Stop the sniffing session (kills tcpdump).
        """
        zi_logger.log(f"lib.utils.packet_sniffer.({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)        
        if self.sniffing:                    
            command = "pkill tcpdump"
            _, error = connection_obj.execute_command(command, return_stderr=True)
            if error:
                raise RuntimeError("Failed to stop tcpdump")
            self.sniffing = False
            zi_logger.log(f"Sniffing stopped on {device}")

    def get_pcap_file(self,
                  device: str,
                  pcap_file: str):
        """
        Fetch the exact `.pcap` file that was generated during sniffing from remote to local.
        """
        connection = self.db_obj.read_from_database(device, 'connection')
        pcap_dir = self.db_obj.read_from_database(device, "pcap_dir")
        local_dir = self.db_obj.read_from_database(device, "result_dir")

        # Log now after pcap_dir is defined
        zi_logger.log(f"lib.utils.packet_sniffer.get_pcap_file({device}, {pcap_dir})")

        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)

        # Use the dynamic file path generated at sniff time        
        if '/' not in pcap_file:
            remote_path = os.path.join(pcap_dir, pcap_file)
        else:
            remote_path = pcap_file  # Full path given

        if not remote_path:
            raise RuntimeError("No sniffed pcap_file found. Please `Start Sniffing`?")

        local_path = os.path.join(local_dir, os.path.basename(remote_path))
        os.makedirs(os.path.dirname(local_path), exist_ok=True)
        connection_obj.get_file(remote_path, local_path)

        zi_logger.log(f"PCAP file copied from {device}:{remote_path} to {local_path}")
        self.local_pcap_file = local_path
        return os.path.basename(local_path)
