from zi4pitstop.lib.openwrt import Openwrt
from zi4pitstop.lib.rdkb import Rdkb
from zi4pitstop.lib.linux import Linux
from zi4pitstop.lib.prpl import Prpl
from zi4pitstop.lib.android import Android
import zi4pitstop.lib.utils.zi_logger as zi_logger

class PlatformModules:

    __instance = None
    __modules = {'openwrt': Openwrt,
                 'rdkb' : Rdkb,
                 'linux' : Linux,
                 'android' : Android,
                 'prpl' : Prpl}
    __module_objects = {}

    def __new__(cls, *args, **kwargs):
        if cls.__instance is None:
            zi_logger.log("PlatformModules Instance created")
            cls.__instance = super().__new__(cls)
        return cls.__instance

    def __init__(self):
        zi_logger.log("PlatformModules __init__")

    def get_platform_module_object(self, module):
        zi_logger.log(f"lib.bridge.platform_modules.get_platform_module_object({module})")
        if module not in PlatformModules.__module_objects:
             PlatformModules.__module_objects[module] = PlatformModules.__modules[module]()
        return PlatformModules.__module_objects[module]
