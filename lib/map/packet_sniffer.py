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


from robot.api.deco import keyword

from zi4pitstop.lib.bridge.database_module import DatabaseModule
from zi4pitstop.lib.bridge.utils_modules import UtilsModules
import zi4pitstop.lib.utils.zi_logger as zi_logger

class PacketSniffer(DatabaseModule,
                    UtilsModules):
    """
    PacketSniffer is a Robot Framework test library designed for  wireless sniffing automation.
    Provides monitor mode control, remote sniffing, and .pcap file fetching.
    """

    ROBOT_AUTO_KEYWORDS = False
    ROBOT_LIBRARY_SCOPE = 'Global'

    
    def __init__(self):
        zi_logger.log("PacketSniffer __init__ : START")
        DatabaseModule.__init__(self)
        UtilsModules.__init__(self)
        self.db_obj = self.get_database_module_object()
        zi_logger.log(f"==== db_obj : {self.db_obj}")
        zi_logger.log("PacketSniffer __init__ : END")

    @keyword("Get Monitor Mode")
    def get_monitor_mode(self,
                         device: str) -> bool:
        """
        Get whether the wireless interface is already in monitor mode.

        - ``device`` is the name given to the sniffer as mentioned
                     in the testbed.yaml config file

        - ``Returns`` If the interface is in monitor mode, its true. Otherwise false.

        Example:
        | ${ret} | Get Monitor Mode | sniffer |
        """
        zi_logger.log(f"lib.map.packetsniffer.get_monitor_mode({device}")
        utils_obj = self.get_utils_module_object('sniffer')
        state = utils_obj.get_monitor_mode(device)
        return state

    @keyword("Set Monitor Mode")
    def set_monitor_mode(self,
                         device: str):
        """
        Set the wireless interface to monitor mode.

        - ``device`` is the name given to the sniffer as mentioned
                     in the testbed.yaml config file
        
        Example:
        | Set Monitor Mode | sniffer |
        """
        zi_logger.log(f"lib.map.packetsniffer.set_monitor_mode({device}")
        utils_obj = self.get_utils_module_object('sniffer')
        utils_obj.set_monitor_mode(device)

    @keyword("Set Managed Mode")
    def set_managed_mode(self,
                         device: str):
        """
        Set the wireless interface to Managed mode.

        - ``device``: The device Name from the config File.

        Raises:
            Exception if Managed mode setup fails.

        Example:
        | Set Managed Mode | sniffer |
        """
 
        zi_logger.log(f"lib.map.packetsniffer.set_managed_mode({device}")
        utils_obj = self.get_utils_module_object('sniffer')
        managed_set = utils_obj.set_managed_mode(device)
        return managed_set

        
    @keyword("Start Sniffing")
    def start_sniffing(self,
                       device: str,
                       pcap_filename: str = "sniff") -> str:
        """
        Start tcpdump-based sniffing on remote device in monitor mode.

        - ``device``: The device Name from the config File.
        - ``pcap_filename``: Filename or full path. Timestamp will be appended.

        Returns the full path of the pcap file.
        """
        zi_logger.log(f"lib.map.packetsniffer.start_sniffing({device},{pcap_filename}")
        utils_obj = self.get_utils_module_object('sniffer')
        sniff_start = utils_obj.start_sniffing(device, pcap_filename)
        return sniff_start

    
    @keyword("Stop Sniffing")
    def stop_sniffing(self,
                      device: str):
        """
        Stop the sniffing session (kills tcpdump).

        - ``device``: The device Name from the config File.

        Example:
        | Stop Sniffing | sniffer |
        """
        zi_logger.log(f"lib.map.packetsniffer.stop_sniffing({device}")
        utils_obj = self.get_utils_module_object('sniffer')
        sniff_stop = utils_obj.stop_sniffing(device)
        return sniff_stop

    @keyword("Get Pcap File")
    def get_pcap_file(self,
                      device: str,
                      pcap_file: str):
        """
        Fetch the exact `.pcap` file that was generated during sniffing from remote to local.

        Example:
        | Fetch PCAP File From Sniffer | sniffer |
        """
        zi_logger.log(f"lib.map.packetsniffer.get_pcap_file({device},{pcap_file}")
        utils_obj = self.get_utils_module_object('sniffer')
        fetch_pcap = utils_obj.get_pcap_file(device, pcap_file)
        return fetch_pcap
