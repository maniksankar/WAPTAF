#base_feature_packet_sniffer
from abc import ABC, abstractmethod

class BaseFeaturePacketSniffer(ABC):

    @abstractmethod
    def check_monitor_mode(self,
                           device: str):
        pass

    @abstractmethod
    def set_monitor_mode(self,
                         device: str):
        pass

    @abstractmethod
    def set_managed_mode(self,
                         device: str):
        pass

    @abstractmethod
    def start_sniffing(self,
                       device: str,
                       pcap_filename: str = "sniff"):
        pass

    @abstractmethod
    def stop_sniffing(self,
                      device: str):
        pass

    @abstractmethod
    def get_pcap_file(self,
                      device: str,
                      pcap_file: str):
        pass