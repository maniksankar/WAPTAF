from zi4pitstop.lib.base.base_feature_interface import BaseFeatureInterface
from zi4pitstop.lib.bridge.database_module import DatabaseModule
from zi4pitstop.lib.bridge.connection_modules import ConnectionModules
import zi4pitstop.lib.utils.zi_logger as zi_logger

class FeatureInterface(BaseFeatureInterface,
                       DatabaseModule,
                       ConnectionModules):
    
    def __init__(self):
        zi_logger.log("RDKB.FeatureInterface __init__ : START")
        ConnectionModules.__init__(self)
        DatabaseModule.__init__(self)
        self.db_obj = self.get_database_module_object()
        zi_logger.log(f"==== db_obj : {self.db_obj}")
        zi_logger.log("RDKB.FeatureInterface __init__ : END")

    def set_ssid(self,
                 device):
        zi_logger.log(f"lib.rdkb.feature_interface.set_ssid({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        output, error = connection_obj.execute_command("df",
                                                       return_stderr = True)
        if error != '':
            raise Exception(f"Command execution failed : uname -a")
        zi_logger.log(f"client_get_ssid : {output}")
        return output
