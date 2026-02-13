from zi4pitstop.lib.base.base_feature_interface import BaseFeatureInterface
from zi4pitstop.lib.bridge.database_module import DatabaseModule
from zi4pitstop.lib.bridge.connection_modules import ConnectionModules
import zi4pitstop.lib.utils.zi_logger as zi_logger

class FeatureFirewall(BaseFeatureInterface,
                       DatabaseModule,
                       ConnectionModules):

    def __init__(self):
        zi_logger.log("Openwrt.FeatureFirewall __init__ : START")
        DatabaseModule.__init__(self)
        ConnectionModules.__init__(self)
        self.db_obj = self.get_database_module_object()
        zi_logger.log(f"==== db_obj : {self.db_obj}")
        zi_logger.log("Openwrt.FeatureFirewall __init__ : END")

    def load_firewall(self,
                        device):

        zi_logger.log(f"lib.openwrt.feature_radio.load_firewall({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        command = "uci commit"
        _, error = connection_obj.execute_command(command,return_stderr=True)

        command = "/etc/init.d/firewall restart"
        _, error = connection_obj.execute_command(command,return_stderr=True)

    def get_firewall_zone_index_by_name(self,
                                            device: str,
                                            zone_name: str):
    	"""
    	Get firewall zone index using zone name.
    	"""

    	zi_logger.log(f"lib.openwrt.feature_firewall.get_firewall_zone_index_by_name({device})")
    	connection = self.db_obj.read_from_database(device, 'connection')
    	connection_obj = self.get_connection_module_object(connection)
    	connection_obj.switch_connection(device)

    	command = (
        	f"uci show firewall | "
        	f"grep \"name='{zone_name}'\" | "
        	f"cut -d'[' -f2 | cut -d']' -f1"
    	)

    	zi_logger.log(f"COMMAND : {command}")
    	output, error = connection_obj.execute_command(command,return_stderr=True)
    	if error:
            raise RuntimeError(f"Command execution failed : {command}")
    	if not output:
            raise RuntimeError(f"Firewall zone with name '{zone_name}' not found")
    	return output.strip()

    def set_zone_name(self,
                           device: str,
                           zone_name: str,
                           zone_new_name: str):
        """
        set firewall zone network to the specifi index.
        """

        zi_logger.log(f"lib.openwrt.feature_firewall.get_zone_network({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            #it is used get the zone_index value
            zone_index = self.get_firewall_zone_index_by_name(device, zone_name)
        except Exception as err:
            zi_logger.log(f"ERROR: {err}")
            raise RuntimeError(
                f"Could not find firewall zone index for zone '{zone_new_name}'")

        command = f"uci set firewall.@zone[{zone_index}].name='{zone_new_name}'"
        _, error = connection_obj.execute_command(command, return_stderr=True)
        if error:
            raise RuntimeError(f"Command execution failed : {command}")

    def add_firewall_zone(self,
                      device: str,
                      zone_index: int,
                      zone_name: str):
        """
        Add firewall zone and set its name
        """

        zi_logger.log(f"lib.openwrt.feature_radio.add_firewall_zone({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)

        # Adding firewall zone
        command = "uci add firewall zone"
        print(f"COMMAND : {command}")
        _, error = connection_obj.execute_command(command, return_stderr=True)
        if error:
                raise RuntimeError(f"Command execution failed : {command}")

        # Set zone name
        command = f"uci set firewall.@zone[{zone_index}].name={zone_name}"
        print(f"COMMAND : {command}")
        _, error = connection_obj.execute_command(command, return_stderr=True)
        if error:
                raise RuntimeError(f"Command execution failed : {command}")

    def get_zone_name(self,
                        device: str,
                        zone_name: str):
        """
        Get firewall zone name using zone name.
        """

        zi_logger.log(f"lib.openwrt.feature_firewall.get_zone_name({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            #it is used get the zone_index value
            zone_index = self.get_firewall_zone_index_by_name(device, zone_name)
        except Exception as err:
            zi_logger.log(f"ERROR: {err}")
            raise RuntimeError(
                f"Could not find firewall zone index for zone '{zone_name}'")

        command = f"uci get firewall.@zone[{zone_index}].name"
        zi_logger.log(f"COMMAND : {command}")
        output, error = connection_obj.execute_command(command, return_stderr=True)
        if error:
            raise RuntimeError(f"Command execution failed : {command}")
        return output.strip()

    def set_zone_network(self,
			   device: str,
			   zone_name: str,
			   zone_network: str):
        """
        set firewall zone network to the specifi index.
        """

        zi_logger.log(f"lib.openwrt.feature_firewall.get_zone_network({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            #it is used get the zone_index value
            zone_index = self.get_firewall_zone_index_by_name(device, zone_name)
        except Exception as err:  
            zi_logger.log(f"ERROR: {err}")
            raise RuntimeError(
                f"Could not find firewall zone index for zone '{zone_name}'")

        command = f"uci set firewall.@zone[{zone_index}].network='{zone_network}'"
        _, error = connection_obj.execute_command(command, return_stderr=True)
        if error:
            raise RuntimeError(f"Command execution failed : {command}")

    def get_zone_network(self,
                        device: str,
                        zone_name: str):
        """
        Get firewall zone network using zone name.
        """

        zi_logger.log(f"lib.openwrt.feature_firewall.get_zone_network({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            #it is used get the zone_index value
            zone_index = self.get_firewall_zone_index_by_name(device, zone_name)
        except Exception as err:
            zi_logger.log(f"ERROR: {err}")
            raise RuntimeError(
                f"Could not find firewall zone index for zone '{zone_name}'")

        command = f"uci get firewall.@zone[{zone_index}].network"
        zi_logger.log(f"COMMAND : {command}")
        output, error = connection_obj.execute_command(command, return_stderr=True)
        if error:
            raise RuntimeError(f"Command execution failed : {command}")
        return output.strip()

    def set_zone_input(self,
                           device: str,
                           zone_name: str,
                           zone_input: str):
        """
        set firewall zone input to the specifi index.
        """

        zi_logger.log(f"lib.openwrt.feature_firewall.get_zone_input({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)

        try:
            #it is used get the zone_index value
            zone_index = self.get_firewall_zone_index_by_name(device, zone_name)
        except Exception as err:  
            zi_logger.log(f"ERROR: {err}")
            raise RuntimeError(
                f"Could not find firewall zone index for zone '{zone_name}'")

        command = f"uci set firewall.@zone[{zone_index}].input='{zone_input}'"
        _, error = connection_obj.execute_command(command, return_stderr=True)
        if error:
             raise RuntimeError(f"Command execution failed : {command}")

    def get_zone_input(self,
                        device: str,
                        zone_name: str):
        """
        Get firewall zone input using zone name.
        """

        zi_logger.log(f"lib.openwrt.feature_firewall.get_zone_input({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            #it is used get the zone_index value
            zone_index = self.get_firewall_zone_index_by_name(device, zone_name)
        except Exception as err:
            zi_logger.log(f"ERROR: {err}")
            raise RuntimeError(
                f"Could not find firewall zone index for zone '{zone_name}'")

        command = f"uci get firewall.@zone[{zone_index}].input"
        zi_logger.log(f"COMMAND : {command}")
        output, error = connection_obj.execute_command(command, return_stderr=True)
        if error:
            raise RuntimeError(f"Command execution failed : {command}")
        return output.strip()

    def set_zone_output(self,
                           device: str,
                           zone_name: str,
                           zone_output: str):
        """
        set firewall zone output to the specifi index.
        """

        zi_logger.log(f"lib.openwrt.feature_firewall.get_zone_output({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)

        try:
            #it is used get the zone_index value
            zone_index = self.get_firewall_zone_index_by_name(device, zone_name)
        except Exception as err:  
            zi_logger.log(f"ERROR: {err}")
            raise RuntimeError(
                f"Could not find firewall zone index for zone '{zone_name}'")

        command = f"uci set firewall.@zone[{zone_index}].output='{zone_output}'"
        _, error = connection_obj.execute_command(command, return_stderr=True)
        if error:
             raise RuntimeError(f"Command execution failed : {command}")

    def get_zone_output(self,
                        device: str,
                        zone_name: str):
        """
        Get firewall zone output using zone name.
        """

        zi_logger.log(f"lib.openwrt.feature_firewall.get_zone_output({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            #it is used get the zone_index value
            zone_index = self.get_firewall_zone_index_by_name(device, zone_name)
        except Exception as err:
            zi_logger.log(f"ERROR: {err}")
            raise RuntimeError(
                f"Could not find firewall zone index for zone '{zone_name}'")

        command = f"uci get firewall.@zone[{zone_index}].output"
        zi_logger.log(f"COMMAND : {command}")
        output, error = connection_obj.execute_command(command, return_stderr=True)
        if error:
            raise RuntimeError(f"Command execution failed : {command}")
        return output.strip()

    def set_zone_forward(self,
                           device: str,
                           zone_name: str,
                           zone_forward: str):
        """
        set firewall zone forward to the specifi index.
        """

        zi_logger.log(f"lib.openwrt.feature_firewall.get_zone_forward({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)

        try:
            #it is used get the zone_index value
            zone_index = self.get_firewall_zone_index_by_name(device, zone_name)
        except Exception as err:
            zi_logger.log(f"ERROR: {err}")
            raise RuntimeError(
                f"Could not find firewall zone index for zone '{zone_name}'")

        command = f"uci set firewall.@zone[{zone_index}].forward='{zone_forward}'"
        _, error = connection_obj.execute_command(command, return_stderr=True)
        if error:
             raise RuntimeError(f"Command execution failed : {command}")

    def get_zone_forward(self,
                        device: str,
                        zone_name: str):
        """
        Get firewall zone forward using zone name.
        """

        zi_logger.log(f"lib.openwrt.feature_firewall.get_zone_forward({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            #it is used get the zone_index value
            zone_index = self.get_firewall_zone_index_by_name(device, zone_name)
        except Exception as err:
            zi_logger.log(f"ERROR: {err}")
            raise RuntimeError(
                f"Could not find firewall zone index for zone '{zone_name}'")

        command = f"uci get firewall.@zone[{zone_index}].forward"
        zi_logger.log(f"COMMAND : {command}")
        output, error = connection_obj.execute_command(command, return_stderr=True)
        if error:
            raise RuntimeError(f"Command execution failed : {command}")
        return output.strip()

    def set_zone_source(self,
                           device: str,
                           zone_name: str,
                           zone_source: str):
        """
        set firewall zone source to the specifi index.
        """

        zi_logger.log(f"lib.openwrt.feature_firewall.get_zone_source({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)

        try:
            #it is used get the zone_index value
            zone_index = self.get_firewall_zone_index_by_name(device, zone_name)
        except Exception as err:  
            zi_logger.log(f"ERROR: {err}")
            raise RuntimeError(
                f"Could not find firewall zone index for zone '{zone_name}'")

        command = f"uci set firewall.@zone[{zone_index}].src='{zone_source}'"
        _, error = connection_obj.execute_command(command, return_stderr=True)
        if error:
             raise RuntimeError(f"Command execution failed : {command}")

    def get_zone_source(self,
                        device: str,
                        zone_name: str):
        """
        Get firewall zone source using zone name.
        """

        zi_logger.log(f"lib.openwrt.feature_firewall.get_zone_source({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            #it is used get the zone_index value
            zone_index = self.get_firewall_zone_index_by_name(device, zone_name)
        except Exception as err:
            zi_logger.log(f"ERROR: {err}")
            raise RuntimeError(
                f"Could not find firewall zone index for zone '{zone_name}'")

        command = f"uci get firewall.@zone[{zone_index}].src"
        zi_logger.log(f"COMMAND : {command}")
        output, error = connection_obj.execute_command(command, return_stderr=True)
        if error:
            raise RuntimeError(f"Command execution failed : {command}")
        return output.strip()

    def set_zone_destination(self,
                           device: str,
                           zone_name: str,
                           zone_destination: str):
        """
        set firewall zone destination to the specifi index.
        """

        zi_logger.log(f"lib.openwrt.feature_firewall.get_zone_destination({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)

        try:
            #it is used get the zone_index value
            zone_index = self.get_firewall_zone_index_by_name(device, zone_name)
        except Exception as err:
            zi_logger.log(f"ERROR: {err}")
            raise RuntimeError(
                f"Could not find firewall zone index for zone '{zone_name}'")

        command = f"uci set firewall.@zone[{zone_index}].dest='{zone_destination}'"
        _, error = connection_obj.execute_command(command, return_stderr=True)
        if error:
             raise RuntimeError(f"Command execution failed : {command}")

    def get_zone_destination(self,
                        device: str,
                        zone_name: str):
        """
        Get firewall zone output using zone name.
        """

        zi_logger.log(f"lib.openwrt.feature_firewall.get_zone_destination({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            #it is used get the zone_index value
            zone_index = self.get_firewall_zone_index_by_name(device, zone_name)
        except Exception as err:
            zi_logger.log(f"ERROR: {err}")
            raise RuntimeError(
                f"Could not find firewall zone index for zone '{zone_name}'")

        command = f"uci get firewall.@zone[{zone_index}].dest"
        zi_logger.log(f"COMMAND : {command}")
        output, error = connection_obj.execute_command(command, return_stderr=True)
        if error:
            raise RuntimeError(f"Command execution failed : {command}")
        return output.strip()

    def set_zone_masq(self,
                           device: str,
                           zone_name: str,
                           zone_masq: int):
        """
        set firewall zone masq to the specifi index.
        """

        zi_logger.log(f"lib.openwrt.feature_firewall.get_zone_masq({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)

        try:
            #it is used get the zone_index value
            zone_index = self.get_firewall_zone_index_by_name(device, zone_name)
        except Exception as err: 
            zi_logger.log(f"ERROR: {err}")
            raise RuntimeError(
                f"Could not find firewall zone index for zone '{zone_name}'")

        command = f"uci set firewall.@zone[{zone_index}].masq='{zone_masq}'"
        _, error = connection_obj.execute_command(command, return_stderr=True)
        if error:
             raise RuntimeError(f"Command execution failed : {command}")

    def get_zone_masq(self,
                        device: str,
                        zone_name: str):
        """
        Get firewall zone masq using zone name.
        """

        zi_logger.log(f"lib.openwrt.feature_firewall.get_zone_masq({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            #it is used get the zone_index value
            zone_index = self.get_firewall_zone_index_by_name(device, zone_name)
        except Exception as err:
            zi_logger.log(f"ERROR: {err}")
            raise RuntimeError(
                f"Could not find firewall zone index for zone '{zone_name}'")

        command = f"uci get firewall.@zone[{zone_index}].masq"
        zi_logger.log(f"COMMAND : {command}")
        output, error = connection_obj.execute_command(command, return_stderr=True)
        if error:
            raise RuntimeError(f"Command execution failed : {command}")
        return output.strip()

