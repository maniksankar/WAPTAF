from abc import ABC, abstractmethod

class BaseFeatureOperatingSystem(ABC):

    @abstractmethod
    def check_openwrt_version(self,
                        device: str):
        pass

    @abstractmethod
    def check_os_release(self,
                   device: str):
        pass

    @abstractmethod
    def check_kernel_version(self,
                       device: str):
        pass
