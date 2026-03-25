from zi4pitstop.lib.base.base_feature_interface import BaseFeatureInterface
from zi4pitstop.lib.bridge.database_module import DatabaseModule
from zi4pitstop.lib.bridge.connection_modules import ConnectionModules
import zi4pitstop.lib.utils.zi_logger as zi_logger

class FeatureInterface(BaseFeatureInterface,
                       DatabaseModule,
                       ConnectionModules):

    def __init__(self):
        zi_logger.log("Openwrt.FeatureInterface __init__ : START")
        DatabaseModule.__init__(self)
        ConnectionModules.__init__(self)
        self.db_obj = self.get_database_module_object()
        zi_logger.log(f"==== db_obj : {self.db_obj}")
        zi_logger.log("Openwrt.FeatureInterface __init__ : END")

    def set_interface_from_database(self,
                                    device: str,
                                    index: str):
        """
        To set interface name for the specific interface index
        """
        zi_logger.log(f"lib.openwrt.feature_radio.set_interface_from_database({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            interface = self.db_obj.read_from_database(device, "wifi_iface").format(index)
            ifname = self.db_obj.read_from_database(device, "wifi_ifname") + str(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Interface of the device : {device}")

        command = f"uci set wireless.{interface}.ifname={ifname}"
        print(f"COMMAND : {command}")
        _, error = connection_obj.execute_command(command,
                                              return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")

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
            interface = self.db_obj.read_from_database(device, "wifi_iface").format(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")

        command = f"uci set wireless.{interface}.ssid={ssid}"
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
            interface = self.db_obj.read_from_database(device, "wifi_iface").format(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f"uci get wireless.{interface}.ssid"
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
            interface = self.db_obj.read_from_database(device, "wifi_iface").format(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")

        command = f"uci set wireless.{interface}.encryption={encryption}"
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
            interface = self.db_obj.read_from_database(device, "wifi_iface").format(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f"uci get wireless.{interface}.encryption"
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
            interface = self.db_obj.read_from_database(device, "wifi_iface").format(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")

        command = f"uci set wireless.{interface}.key={password}"
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
        command = f"uci get wireless.{interface}.key"
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

    def set_wifi_iface_device(self,
                              device: str,
                              index: str,
                              wifi_device: str):
        """Set the wifi-iface device """
        zi_logger.log(f"lib.openwrt.feature_radio.set_wifi_iface_device({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            interface = self.db_obj.read_from_database(device, "wifi_iface").format(index)
            ifname = self.db_obj.read_from_database(device, "wifi_ifname") + str(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Interface of the device : {device}")

        command = f"uci set wireless.{interface}.device={wifi_device}"
        print(f"COMMAND : {command}")
        _, error = connection_obj.execute_command(command,
                                              return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")   

    def get_wifi_iface_device(self,
                          device: str,
                          index: str,
                          expected_if_device: str):
        """
        Get the wifi-iface device (wifi0, wifi1, etc.) for the given radio index.
        If expected_if_device is provided, validate it.
        Otherwise just return the actual value.
        """
        zi_logger.log(f"lib.openwrt.feature_radio.get_wifi_iface_device({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            interface = self.db_obj.read_from_database(device, "wifi_iface").format(index)
        except Exception as err:
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find wifi-iface for device: {device}")

        command = f"uci get wireless.{interface}.device"
        zi_logger.log(f"COMMAND: {command}")

        output, error = connection_obj.execute_command(command, return_stderr=True)
        if error:
            raise RuntimeError(f"Command execution failed: {command}")

        output = output.strip()
        if expected_if_device is not None:
            if output != expected_if_device:
                raise RuntimeError(
                    f"Mismatch: Expected device '{expected_if_device}' "
                    f"but got '{output}' for wireless.{interface}.device"
                )
        return output


    def set_wifi_iface_network(self,
                               device: str,
                               index: str,
                                network: str) -> str:
        """
        Set the network for the wifi-iface
        example:
            uci set wireless.@wifi-iface[1].network='lan'
        """
        zi_logger.log(f"lib.openwrt.feature_radio.set_wifi_iface_network({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)

        try:
           index = self.db_obj.read_from_database(device, index)
           interface = self.db_obj.read_from_database(device, "wifi_iface").format(index)
        except Exception as err:
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the network of the device : {device}")

        command = f"uci set wireless.{interface}.network='{network}'"
        _,error =connection_obj.execute_command(command, return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")

    def get_wifi_iface_network(self,
                               device: str,
                               index: str) -> str:
        """
        Get the network assigned to a specific wifi interface from the device.

        - device: Device name from the database
        - index: Radio index key (e.g., 2g_radio_index, 5g_radio_index)

        Returns:
        - Network name assigned to the wifi interface.
        """
        zi_logger.log(f"lib.openwrt.feature_radio.get_wifi_iface_network({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index_value = self.db_obj.read_from_database(device, index)
            interface = self.db_obj.read_from_database(device, "wifi_iface").format(index_value)
        except Exception as err:
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find wifi-iface for device: {device}")
        command = f"uci get wireless.{interface}.network"
        zi_logger.log(f"COMMAND: {command}")
        output, error = connection_obj.execute_command(command, return_stderr=True)
        if error:
            raise RuntimeError(f"Command execution failed: {command}")

        return output.strip()

    def set_wifi_iface_mode(self,
                            device: str,
                            index: str,
                            mode: str):
        """
        Set the mode for the wifi-iface
        example:
            uci set wireless.@wifi-iface[1].mode='ap'
        """
        zi_logger.log(f"lib.openwrt.feature_radio.set_wifi_iface_mode({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)

        try:
           index = self.db_obj.read_from_database(device, index)
           interface = self.db_obj.read_from_database(device, "wifi_iface").format(index)
        except Exception as err:
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the mode of the device : {device}")

        command = f"uci set wireless.{interface}.mode='{mode}'"
        _,error =connection_obj.execute_command(command, return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")

    def get_wifi_iface_mode(self,
                            device: str,
                            index: str) -> str:
        """
        Get the mode assigned to a specific wifi interface from the device.

        - device: Device name from the database
        - index: Radio index key (e.g., 2g_radio_index, 5g_radio_index)

        Returns:
        - Mode of the wifi interface (e.g., ap, sta).
        """
        zi_logger.log(f"lib.openwrt.feature_radio.get_wifi_iface_mode({device})")

        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index_value = self.db_obj.read_from_database(device, index)
            interface = self.db_obj.read_from_database(device, "wifi_iface").format(index_value)
        except Exception as err:
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find wifi-iface for device: {device}")
        command = f"uci get wireless.{interface}.mode"
        zi_logger.log(f"COMMAND: {command}")
        output, error = connection_obj.execute_command(command, return_stderr=True)
        if error:
            raise RuntimeError(f"Command execution failed: {command}")

        return output.strip()

    def check_mode(self,
                   device: str,
                   index: str,
                   mode: str):

        zi_logger.log(f"lib.openwrt.feature_radio.check_type({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            ifname = self.db_obj.read_from_database(device, "wifi_ifname") + str(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f"iw dev {ifname} info | grep type | awk '{{print$2}}'"
        output, error = connection_obj.execute_command(command,
                                                   return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")
        if output != mode:
            raise RuntimeError(f"Given mode {mode} is not matched \
                               with expected mode {output}")


    def set_wifi_iface_isolate(self, device: str, index: str, isolate: int):
        """
        Set the 'isolate' option for a specific Wi-Fi interface.

        - device: Device name from the database
        - index: Radio index key (e.g., 2g_radio_index, 5g_radio_index)
        - isolate: 1 to enable client isolation, 0 to disable
        """
        zi_logger.log(f"lib.openwrt.feature_radio.set_wifi_iface_isolate({device})")

        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)

        try:
            index_value = self.db_obj.read_from_database(device, index)
            interface = self.db_obj.read_from_database(device, "wifi_iface").format(index_value)
        except Exception as err:
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find wifi-iface for device: {device}")

        command = f"uci set wireless.{interface}.isolate={isolate}"
        zi_logger.log(f"COMMAND: {command}")

        output, error = connection_obj.execute_command(command,return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")
        return str(output)


    def get_wifi_iface_isolate(self, device: str, index: str) -> str:
        """
        Get the 'isolate' option for a specific Wi-Fi interface.

        - device: Device name from the database
        - index: Radio index key (e.g., 2g_radio_index, 5g_radio_index)

        Returns:
        - '1' if client isolation is enabled, '0' if disabled
        """
        zi_logger.log(f"lib.openwrt.feature_radio.get_wifi_iface_isolate({device})")

        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)

        try:
            index_value = self.db_obj.read_from_database(device, index)
            interface = self.db_obj.read_from_database(device, "wifi_iface").format(index_value)
        except Exception as err:
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find wifi-iface for device: {device}")

        command = f"uci get wireless.{interface}.isolate"
        zi_logger.log(f"COMMAND: {command}")

        output, error = connection_obj.execute_command(command, return_stderr=True)
        if error:
            raise RuntimeError(f"Command execution failed: {command}")
        return output.strip()

    def add_wifi_interface(self,
                           device: str):
        zi_logger.log(f"lib.openwrt.feature_radio.add_wifi_interface({device})")

        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)

        command = "uci add wireless wifi-iface"
        zi_logger.log(f"Executing command: {command}")
        _, error = connection_obj.execute_command(command, return_stderr=True)

        if error:
            raise RuntimeError(f"Failed to add an wifi interface: {error}")

        iface_list = self.db_obj.read_from_database(device, "wifi_iface_index")
        iface_list.append(iface_list[-1] + 1)
        self.db_obj.write_into_database(device, "wifi_iface_index", iface_list)


    def delete_wifi_interface(self, 
                          device: str, 
                          vap_name: str):

        zi_logger.log(f"lib.openwrt.feature_radio.delete_wifi_interface({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)

        try:
            find_iface_cmd = (
                f"uci show wireless | "
                f"grep \"name='{vap_name}'\" | "
                f"cut -d. -f2"
            )

            interface, err = connection_obj.execute_command(find_iface_cmd, return_stderr=True)
            if err or not interface.strip():
                raise RuntimeError("wifi-iface not found")
            interface = interface.strip()
        except Exception as err:
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find wifi-iface for device: {device}")
        command = f"uci del wireless.{interface}"
        output, error = connection_obj.execute_command(command,return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")
        return str(output)

    def set_vap_device(self,
                        device: str,
                        index: str,
                        radio: str):
        """
        To set SSID for the specific interface.
        """
        zi_logger.log(f"lib.openwrt.feature_radio.set_ssid({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            interface = self.db_obj.read_from_database(device, "wifi_iface").format(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")

        command = f"uci set wireless.{interface}.device={radio}"
        print(f"COMMAND : {command}")
        _, error = connection_obj.execute_command(command,
                                              return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")

    def get_vap_device(self, 
                        device: str, 
                        index: str) -> str:

        zi_logger.log(f"lib.openwrt.feature_radio.get_vap_device({device})")        
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index_value = self.db_obj.read_from_database(device, index)
            interface = self.db_obj.read_from_database(device, "wifi_iface").format(index_value)
        except Exception as err:
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find wifi-iface for device: {device}")
        command = f"uci get wireless.{interface}.device"
        zi_logger.log(f"COMMAND: {command}")
        output, error = connection_obj.execute_command(command, return_stderr=True)
        if error:
            raise RuntimeError(f"Command execution failed: {command}")

        return output.strip()

    def set_vap_name(self,
                        device: str,
                        index: str,
                        name: str):

        zi_logger.log(f"lib.openwrt.feature_radio.set_vap_name({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            interface = self.db_obj.read_from_database(device, "wifi_iface").format(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device name: {device}")

        command = f"uci set wireless.{interface}.name={name}"
        print(f"COMMAND : {command}")
        _, error = connection_obj.execute_command(command,
                                              return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")

    def get_vap_name(self, 
                        device: str, 
                        index: str) -> str:

        zi_logger.log(f"lib.openwrt.feature_radio.get_vap_name({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index_value = self.db_obj.read_from_database(device, index)
            interface = self.db_obj.read_from_database(device, "wifi_iface").format(index_value)
        except Exception as err:
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find wifi-iface for device: {device}")
        command = f"uci get wireless.{interface}.name"
        zi_logger.log(f"COMMAND: {command}")
        output, error = connection_obj.execute_command(command, return_stderr=True)
        if error:
            raise RuntimeError(f"Command execution failed: {command}")

        return output.strip()

    def check_vap_mode(self, 
                        device: str, 
                        vap_ssid: str, 
                        mode: str):
        zi_logger.log(f"lib.openwrt.feature_radio.check_vap_mode({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)

        try:

            find_iface_cmd = (
                "iw dev | "
                f"awk -v ssid='{vap_ssid}' "
                "'/Interface/ {iface=$2} "
                "$1==\"ssid\" && $2==ssid {print iface; exit}'"
            )

            interface, err = connection_obj.execute_command(find_iface_cmd, return_stderr=True)
            if err or not interface or not interface.strip():
                raise RuntimeError("wifi interface not found")
            interface = interface.strip()
        except Exception as err:
            zi_logger.log(f"ERROR: {err}")
            raise RuntimeError(
                f"Could not find wifi interface for device: {device}") from err

        command = (
            f"iw dev {interface} info | "
            "grep type | "
            "awk '{print $2}'"
        )
        output, error = connection_obj.execute_command(command, return_stderr=True)
        if error or not output:
            raise RuntimeError(f"Command execution failed: {command}")
        actual_mode = output.strip()
        return actual_mode == mode


    def check_vap_ssid(self,
                        device: str,
                        vap_index: str,
                        vap_ssid:str):

        zi_logger.log(f"lib.openwrt.feature_radio.check_vap_ssid({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)

        try:
            find_iface_cmd = (
                "iw dev | "
                f"awk -v ssid='{vap_ssid}' "
                "'/Interface/ {iface=$2} "
                "$1==\"ssid\" && $2==ssid {print iface; exit}'"
            )

            interface, err = connection_obj.execute_command(find_iface_cmd, return_stderr=True)
            if err or not interface.strip():
                raise RuntimeError("wifi-iface not found")
            interface = interface.strip()
        except Exception as err:
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find wifi-iface for device: {device}")
        command = f"iw dev {interface} info | grep ssid | awk '{{print$2}}'"
        output, error = connection_obj.execute_command(command,return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")
        return str(output)

    # def set_vap_name(self,
    #                     device: str,
    #                     index: str,
    #                     name: str):

    #     zi_logger.log(f"lib.openwrt.feature_radio.set_vap_name({device})")
    #     connection = self.db_obj.read_from_database(device, 'connection')
    #     connection_obj = self.get_connection_module_object(connection)
    #     connection_obj.switch_connection(device)
    #     try:
    #         index = self.db_obj.read_from_database(device, index)
    #         interface = self.db_obj.read_from_database(device, "wifi_iface").format(index)
    #     except Exception as err: # pylint: disable=broad-except
    #         print(f"ERROR: {err}")
    #         raise RuntimeError(f"Could not find out the Radio of the device name: {device}")

    #     command = f"uci set wireless.{interface}.name={name}"
    #     print(f"COMMAND : {command}")
    #     _, error = connection_obj.execute_command(command,
    #                                           return_stderr=True)
    #     if error != '':
    #         raise RuntimeError(f"Command execution failed : {command}")


    def set_interface_state(self,
                        device: str,
                        index: str,
                        state: bool):
        """
        To set Disable/Enable State for the specific Interface
        """
        zi_logger.log(f"lib.openwrt.feature_radio.set_interface_state({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            interface = self.db_obj.read_from_database(device, "wifi_iface").format(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        if state:
            state = 0
        else:
            state = 1
        command = f"uci set wireless.{interface}.disabled={state}"
        print(f"COMMAND : {command}")
        _, error = connection_obj.execute_command(command,
                                                  return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")

    def get_interface_state(self,
                        device: str,
                        index: str) -> bool:
        """
        To get Disable/Enable State assigned to a specific Interface 
        """
        zi_logger.log(f"lib.openwrt.feature_radio.get_interface_state({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            interface = self.db_obj.read_from_database(device, "wifi_iface").format(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f"uci get wireless.{interface}.disabled"
        output, error = connection_obj.execute_command(command,
                                                       return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")
        output = int(output)
        if output:
            output = 0
        else:
            output = 1
        return output

