from zi4pitstop.lib.base.base_feature_interface import BaseFeatureInterface
from zi4pitstop.lib.bridge.database_module import DatabaseModule
from zi4pitstop.lib.bridge.connection_modules import ConnectionModules
import zi4pitstop.lib.utils.zi_logger as zi_logger

class FeatureSystem(BaseFeatureInterface,
                       DatabaseModule,
                       ConnectionModules):

    def __init__(self):
        zi_logger.log("Openwrt.FeatureSystem __init__ : START")
        DatabaseModule.__init__(self)
        ConnectionModules.__init__(self)
        self.db_obj = self.get_database_module_object()
        zi_logger.log(f"==== db_obj : {self.db_obj}")
        zi_logger.log("Openwrt.FeatureSystem __init__ : END")

    def load_system(self,
                        device):

        zi_logger.log(f"lib.openwrt.feature_radio.load_system({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        command = "uci commit"
        _, error = connection_obj.execute_command(command,return_stderr=True)

        command = "/etc/init.d/system restart"
        _, error = connection_obj.execute_command(command,return_stderr=True)

    def set_time_zone(self,
                        device: str,
                        system_index: int,
			            time_zone: str):
        """
        set system time zone to the specifi index.
        """

        zi_logger.log(f"lib.openwrt.feature_firewall.set_time_zone({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)

        command = f"uci set system.@system[{system_index}].timezone='{time_zone}'"
        _, error = connection_obj.execute_command(command, return_stderr=True)
        if error:
             raise RuntimeError(f"Command execution failed : {command}")

    def get_time_zone(self,
                        device: str,
                        system_index: int):
        """
        Get system time zone .
        """

        zi_logger.log(f"lib.openwrt.feature_firewall.get_zone_forward({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)

        command = f"uci get system.@system[{system_index}].timezone"
        zi_logger.log(f"COMMAND : {command}")
        output, error = connection_obj.execute_command(command, return_stderr=True)
        if error:
            raise RuntimeError(f"Command execution failed : {command}")
        return output.strip()
