from zi4pitstop.lib.utils.ssh_interface import SshInterface
from zi4pitstop.lib.utils.adb_interface import AdbInterface
import zi4pitstop.lib.utils.zi_logger as zi_logger

class ConnectionModules:

    __instance = None
    __modules = {'ssh': SshInterface, 'adb': AdbInterface}
    __module_objects = {}

    def __new__(cls, *args, **kwargs):
        if cls.__instance is None:
            zi_logger.log("ConnectionModules Instance created")
            cls.__instance = super().__new__(cls)
        return cls.__instance

    def __init__(self):
        zi_logger.log("ConnectionModules __init__")

    def get_connection_module_object(self, module):
        zi_logger.log(f"lib.bridge.connection_module.get_connection_module_object({module})")
        if module not in ConnectionModules.__module_objects:
            zi_logger.log(f"ConnectionModules.modules : {ConnectionModules.__modules}")
            ConnectionModules.__module_objects[module] = ConnectionModules.__modules[module]()
        return ConnectionModules.__module_objects[module]
