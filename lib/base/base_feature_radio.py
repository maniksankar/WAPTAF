from abc import ABC, abstractmethod

class BaseFeatureRadio(ABC):

    @abstractmethod
    def load_wifi(self, device):
        pass

    @abstractmethod
    def set_channel(self, device, index, channel):
        pass

    @abstractmethod
    def get_channel(self, device, index):
        pass

    @abstractmethod
    def check_channel(self, device, index, channel):
        pass
"""
    @abstractmethod
    def check_regulatory_domain(self, device, index, reg_domain):
        raise NotImplementedError("Subclass must implement check_regulatory_domain()")

    @abstractmethod
    def get_physical_interface_index(self, device, index):
        raise NotImplementedError("Subclass must implement get_physical_interface_index()")

    @abstractmethod
    def get_supported_channels_count(self, device, index):
        raise NotImplementedError("Subclass must implement get_supported_channels_count()")

    @abstractmethod
    def get_supported_channels_list(self, device, index):
        raise NotImplementedError("Subclass must implement get_supported_channels_list()")
    
    @abstractmethod
    def get_highest_supported_channel(self, device, index):
        raise NotImplementedError("Subclass must implement get_highest_supported_channel()")

"""
