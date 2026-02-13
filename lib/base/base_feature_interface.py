from abc import ABC, abstractmethod

class BaseFeatureInterface(ABC):

    @abstractmethod
    def set_ssid(self):
        pass
