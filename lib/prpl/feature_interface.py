from zi4pitstop.lib.base.base_feature_interface import BaseFeatureInterface
from zi4pitstop.lib.bridge.database_module import DatabaseModule
from zi4pitstop.lib.bridge.connection_modules import ConnectionModules
import zi4pitstop.lib.utils.zi_logger as zi_logger

class FeatureInterface(BaseFeatureInterface,
                       DatabaseModule,
                       ConnectionModules):

    def __init__(self):
        zi_logger.log("Prpl.FeatureInterface __init__ : START")
        DatabaseModule.__init__(self)
        ConnectionModules.__init__(self)
        self.db_obj = self.get_database_module_object()
        zi_logger.log(f"==== db_obj : {self.db_obj}")
        zi_logger.log("Prpl.FeatureInterface __init__ : END")

    def set_interface_from_database(self,
                                    device: str,
                                    index: str):
        """
        To set interface name for the specific interface index
        """
        print("Dummy function...")

    def get_interface(self,
                      device: str,
                      index: str) -> str:
        """
        To get interface name assigned to a specific interface index
        """
        zi_logger.log(f"lib.openwrt.feature_radio.get_interface({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            interface = self.db_obj.read_from_database(device, "wifi_iface").format(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Interface of the device : {device}")
        command = f"uci get wireless.{interface}.ifname"
        output, error = connection_obj.execute_command(command,
                                                   return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")
        return str(output)

    def check_interface(self,
                        device: str,
                        index: str):
        """
        To check interface name assigned to a specific interface index.
        """
        zi_logger.log(f"lib.openwrt.feature_radio.check_interface({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            ifname = self.db_obj.read_from_database(device, "wifi_ifname") + str(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f"ifconfig -a | grep {ifname} | awk '{{print$1}}'"
        output, error = connection_obj.execute_command(command,
                                                   return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")
        if str(output) != ifname:
            raise RuntimeError(f"Given ifname {ifname} is not matched \
                               with expected ifname {output}")

    def set_ssid(self,
                 device: str,
                 index: str,
                 ssid: str):
        """
        To set SSID for the specific interface.
        """
        zi_logger.log(f"lib.openwrt.feature_radio.set_ssid({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            #interface = self.db_obj.read_from_database(device, "wifi_iface").format(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")

        command = f"ubus-cli Device.WiFi.SSID.{index}.SSID={ssid}"
        print(f"COMMAND : {command}")
        _, error = connection_obj.execute_command(command,
                                              return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")

    def get_ssid(self,
                 device: str,
                 index: str) -> str:
        """
        To get SSID assigned to a specific interface.
        """
        zi_logger.log(f"lib.openwrt.feature_radio.get_ssid({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            #interface = self.db_obj.read_from_database(device, "wifi_iface").format(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f'ubus-cli Device.WiFi.SSID.{index}.SSID? | grep "=" | cut -d \'"\' -f 2'
        output, error = connection_obj.execute_command(command,
                                                   return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")
        return str(output)

    def check_ssid(self,
                   device: str,
                   index: str,
                   ssid: str):
        """
        To check SSID assigned to a specific interface,
        Which will be derived from the radio index.
        """
        zi_logger.log(f"lib.openwrt.feature_radio.check_ssid({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            ifname = self.db_obj.read_from_database(device, "wifi_ifname") + str(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f"iw dev {ifname} info | grep ssid | awk '{{print$2}}'"
        output, error = connection_obj.execute_command(command,
                                                   return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")
        if output != ssid:
            raise RuntimeError(f"Given ssid {ssid} is not matched \
                               with expected ssid {output}")

    def set_encryption(self,
                       device: str,
                       index: str,
                       encryption: str):
        """
        To set encryption for the specific interface.
        """
        zi_logger.log(f"lib.openwrt.feature_radio.set_encryption({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            #interface = self.db_obj.read_from_database(device, "wifi_iface").format(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")

        command = f"ubus-cli Device.WiFi.AccessPoint.{index}.Security.ModeEnabled={encryption}"
        print(f"COMMAND : {command}")
        _, error = connection_obj.execute_command(command,
                                              return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")

    def get_encryption(self,
                       device: str,
                       index: str) -> str:
        """
        To get encryption set to a specific interface.
        """
        zi_logger.log(f"lib.openwrt.feature_radio.get_encryption({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            #interface = self.db_obj.read_from_database(device, "wifi_iface").format(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f'ubus-cli Device.WiFi.AccessPoint.{index}.Security.ModeEnabled? | grep "=" | cut -d \'"\' -f 2'
        output, error = connection_obj.execute_command(command,
                                                   return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")
        return str(output)

    def set_password(self,
                     device: str,
                     index: str,
                     password: str):
        """
        To set password for the specific interface.
        """
        zi_logger.log(f"lib.openwrt.feature_radio.set_password({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            #interface = self.db_obj.read_from_database(device, "wifi_iface").format(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")

        command = f"ubus-cli Device.WiFi.AccessPoint.{index}.Security.KeyPassPhrase={password}"
        print(f"COMMAND : {command}")
        _, error = connection_obj.execute_command(command,
                                              return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")

    def get_password(self,
                     device: str,
                     index: str) -> str:
        """
        To get password assigned to a specific interface.
        """
        zi_logger.log(f"lib.openwrt.feature_radio.get_password({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            interface = self.db_obj.read_from_database(device, "wifi_iface").format(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f'ubus-cli Device.WiFi.AccessPoint.{index}.Security.KeyPassPhrase? | grep "=" | cut -d \'"\' -f 2'
        output, error = connection_obj.execute_command(command,
                                                   return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")
        return str(output)

    def set_sae_parameters(self,
                           device: str,
                           index: str):
        """
        Set SAE-related encryption parameters for the specific wireless interface.
    
        Parameters:
        - device: Device name from the database.
        - index: Index key to get interface index from the database.
        """
        zi_logger.log(f"lib.openwrt.feature_radio.set_sae_parameters({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            interface = self.db_obj.read_from_database(device, "wifi_iface").format(index)
        except Exception as err:  # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not determine the radio interface of the device: {device}")
        
        sae_commands = [
            f"uci set wireless.{interface}.sae='1'",
            f"uci set wireless.{interface}.sae_password='1234567890'",
            f"uci set wireless.{interface}.sae_pwe='1'",
            f"uci set wireless.{interface}.sae_groups='19'",
            f"uci set wireless.{interface}.en_6g_sec_comp='0'"
        ]
        
        for cmd in sae_commands:
            zi_logger.log(f"Executing: {cmd}")
            output, error = connection_obj.execute_command(cmd,
                                                           return_stdout=True,
                                                           return_stderr=True)
            if error:
                raise RuntimeError(f"Command execution failed: {cmd}, Error: {error}")

    def check_brctl_show(self,
                         device: str,
                         expected_bridge: str = "br-lan",
                         expected_interfaces: list = None) -> str:

        """
        Run 'brctl show' on the device and validate the bridge and its interfaces.

        - device: Device name from the database.
        - expected_bridge: Bridge to check (default: 'br-lan').
        - expected_interfaces: List of interfaces expected in the bridge.

        Returns:
        - Raw 'brctl show' output.

        Raises:
        - RuntimeError if bridge or interfaces are not found.
        """
        zi_logger.log(f"lib.openwrt.feature_radio.check_brctl_show({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        conn_obj = self.get_connection_module_object(connection)
        conn_obj.switch_connection(device)
        output, error = conn_obj.execute_command("brctl show", return_stderr=True)
        if error:
            raise RuntimeError(f"brctl show failed: {error}")
        if expected_bridge not in output:
            raise RuntimeError(f"Bridge '{expected_bridge}' not found in brctl show output.")

        if expected_interfaces:
            for iface in expected_interfaces:
                 if iface not in output:
                       raise RuntimeError(f"Interface '{iface}' not found in bridge '{expected_bridge}'.")

        return output

    def get_dut_bridge_ipv4(self,
                            device: str) -> str:
        """
        Get The IPv4 address from given interface.
        """
        zi_logger.log(f"lib.openwrt.feature_radio.get_dut_bridge_ipv4({device})")
        interface = self.db_obj.read_from_database(device, 'bridge_iface')
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        zi_logger.log(connection_obj)
        connection_obj.switch_connection(device)
        command = f"/sbin/ifconfig {interface} | grep 'inet ' | awk -F: '{{print $2}}' | awk '{{print $1}}'"
        output, error = connection_obj.execute_command(command,
                                                       return_stdout=True,
                                                       return_stderr=True)
        zi_logger.log(f"output: {output}, error: {error}")
        if error:
            raise Exception(f"Command execution failed : {command}")
        return output

    def get_dut_wan_ipv4(self,
                         device: str) -> str:
        """
        Get The IPv4 address from given interface.
        """
        zi_logger.log(f"lib.openwrt.feature_radio.get_dut_wan_ipv4({device})")
        interface = self.db_obj.read_from_database(device, 'wan_iface')
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        zi_logger.log(connection_obj)
        connection_obj.switch_connection(device)
        command = f"/sbin/ifconfig {interface} | grep 'inet ' | awk -F: '{{print $2}}' | awk '{{print $1}}'"
        output, error = connection_obj.execute_command(command,
                                                       return_stdout=True,
                                                       return_stderr=True)
        zi_logger.log(f"output: {output}, error: {error}")
        if error:
            raise Exception(f"Command execution failed : {command}")
        return output
