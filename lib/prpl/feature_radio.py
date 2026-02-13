from zi4pitstop.lib.base.base_feature_radio import BaseFeatureRadio
from zi4pitstop.lib.bridge.database_module import DatabaseModule
from zi4pitstop.lib.bridge.connection_modules import ConnectionModules
import zi4pitstop.lib.utils.zi_logger as zi_logger
import time

class FeatureRadio(BaseFeatureRadio,
                   DatabaseModule,
                   ConnectionModules):
    
    def __init__(self):
        zi_logger.log("Prpl.FeatureRadio __init__ : START")
        DatabaseModule.__init__(self)
        ConnectionModules.__init__(self)
        self.db_obj = self.get_database_module_object()
        zi_logger.log(f"==== db_obj : {self.db_obj}")
        zi_logger.log("Prpl.FeatureRadio __init__ : END")

    def load_wifi(self,
                  device):
        zi_logger.log(f"lib.plpl.feature_radio.load_wifi({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        command = "ubus-cli Device.WiFi.Radio.*.Enable=0"
        _, error = connection_obj.execute_command(command,
                                                  return_stderr=True)
        time.sleep(1)
        command = "ubus-cli Device.WiFi.Radio.*.Enable=1"
        _, error = connection_obj.execute_command(command,
                                                  return_stderr=True)

    def set_channel(self,
                    device,
                    index,
                    channel):
        zi_logger.log(f"lib.plpl.feature_radio.set_channel({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            #radio = self.db_obj.read_from_database(device, 'wifi_device') + str(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")

        command = f"ubus-cli Device.WiFi.Radio.{index}.Channel={channel}"
                
        output, error = connection_obj.execute_command(command,
                                                       return_stderr = True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")

    def get_channel(self,
                    device,
                    index):
        zi_logger.log(f"lib.plpl.feature_radio.get_channel({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            #radio = self.db_obj.read_from_database(device, 'wifi_device') + str(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")

        command = f"ubus-cli Device.WiFi.Radio.{index}.Channel? | grep 'Channel=' | cut -d '=' -f 2"
                
        output, error = connection_obj.execute_command(command,
                                                       return_stderr = True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")
        return int(output)
        
    def check_channel(self,
                      device,
                      index,
                      channel):
        zi_logger.log(f"lib.plpl.feature_radio.check_channel({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            ifname = self.db_obj.read_from_database(device, 'wifi_ifname') + str(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")

        command = f"iw dev {ifname} info | grep -i channel | awk '{{print $2}}'"
        output, error = connection_obj.execute_command(command,
                                                       return_stderr = True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")

        if int(output) != channel:
            raise RuntimeError(f"Given channel {channel} not matched with expected channel {output}")

    def set_bandwidth(self,
                      device: str,
                      index: str,
                      bandwidth: str):
        """
        To set Bandwidth for the specific radio index
        """
        zi_logger.log(f"lib.plpl.feature_radio.set_bandwidth({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            #radio = self.db_obj.read_from_database(device, "wifi_device") + str(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f"ubus-cli Device.WiFi.Radio.{index}.OperatingChannelBandwidth={bandwidth}"
        _, error = connection_obj.execute_command(command,
                                                  return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")

    
    def get_bandwidth(self,
                      device: str,
                      index: str) -> str:
        """
        To get bandwidth assigned to a specific radio index
        """
        zi_logger.log(f"lib.plpl.feature_radio.get_bandwidth({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            radio = self.db_obj.read_from_database(device, "wifi_device") + str(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f'ubus-cli Device.WiFi.Radio.{index}.OperatingChannelBandwidth? | grep "=" | cut -d \'"\' -f 2'
        output, error = connection_obj.execute_command(command,
                                                       return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")
        return output

    
    def check_bandwidth(self,
                        device: str,
                        index: str,
                        bandwidth: int):
        """
        To check bandwidth assigned to a specific radio index
        """
        zi_logger.log(f"lib.plpl.feature_radio.check_bandwidth({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            ifname = self.db_obj.read_from_database(device, "wifi_ifname") + str(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f"iw dev {ifname} info | grep channel | awk '{{print$6}}'"
        output, error = connection_obj.execute_command(command,
                                                       return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")
        if int(output) != bandwidth:
            raise RuntimeError(f"Given bandwidth {bandwidth} is not matched \
                              with expected bandwidth {output}")
    
    def set_radio_state(self,
                        device: str,
                        index: str,
                        state: bool):
        """
        To set Disable/Enable State for the specific radio
        """
        zi_logger.log(f"lib.plpl.feature_radio.set_radio_state({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            #radio = self.db_obj.read_from_database(device, "wifi_device") + str(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f"ubus-cli Device.WiFi.Radio.{index}.Enable={state}"
        print(f"COMMAND : {command}")
        _, error = connection_obj.execute_command(command,
                                                  return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")

    
    def get_radio_state(self,
                        device: str,
                        index: str) -> bool:
        """
        To get Disable/Enable State assigned to a specific radio index
        """
        zi_logger.log(f"lib.plpl.feature_radio.get_radio_state({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            #radio = self.db_obj.read_from_database(device, "wifi_device") + str(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f"ubus-cli Device.WiFi.Radio.{index}.Enable? | grep 'Enable=' | cut -d '=' -f 2"
        output, error = connection_obj.execute_command(command,
                                                       return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")
        return int(output)

    
    def set_radio_standard(self,
                           device: str,
                           index: str,
                           standard: str):
        """
        To set standard(hwmode) to a specific radio index
        """
        zi_logger.log(f"lib.plpl.feature_radio.set_radio_standard({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            #radio = self.db_obj.read_from_database(device, "wifi_device") + str(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f"ubus-cli Device.WiFi.Radio.{index}.OperatingStandards={standard}"
        print(f"COMMAND : {command}")
        _, error = connection_obj.execute_command(command,
                                                  return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")

    
    def get_radio_standard(self,
                           device: str,
                           index: str) -> str:
        """
        To get standard assigned to a specific radio index
        """
        zi_logger.log(f"lib.plpl.feature_radio.get_radio_standard({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            #radio = self.db_obj.read_from_database(device, "wifi_device") + str(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f'ubus-cli Device.WiFi.Radio.{index}.OperatingStandards? | grep "=" | cut -d \'"\' -f 2'
        output, error = connection_obj.execute_command(command,
                                                       return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")
        return output

    
    def set_txpower(self,
                    device: str,
                    index: str,
                    txpower: int):
        """
        To set transmit power to a specific radio index
        """
        zi_logger.log(f"lib.plpl.feature_radio.set_txpower({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            #radio = self.db_obj.read_from_database(device, "wifi_device") + str(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f"ubus-cli Device.WiFi.Radio.{index}.TransmitPower={txpower}"
        print(f"COMMAND : {command}")
        _, error = connection_obj.execute_command(command,
                                                  return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")

    
    def get_txpower(self,
                    device: str,
                    index: str) -> int:
        """
        To get transmit power assigned to a specific radio
        """
        zi_logger.log(f"lib.plpl.feature_radio.get_txpower({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            #radio = self.db_obj.read_from_database(device, "wifi_device") + str(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f"ubus-cli Device.WiFi.Radio.{index}.TransmitPower? | grep '=' | cut -d '=' -f 2"
        output, error = connection_obj.execute_command(command,
                                                       return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")
        return int(output)

    
    def check_txpower(self,
                      device: str,
                      index: str,
                      txpower: int):
        """
        Check the tx power assigned to a specific radio index
        """
        zi_logger.log(f"lib.plpl.feature_radio.check_txpower({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            ifname = self.db_obj.read_from_database(device, "wifi_ifname") + str(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f"iwinfo {ifname} info | grep Tx-Power | awk '{{print$2}}'"
        output, error = connection_obj.execute_command(command,
                                                       return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")

        if int(output) != txpower:
            raise RuntimeError(f"Given txpower {txpower} not matched with \
                              the expected txpower {output}")

    def set_noscan(self,
                   device: str,
                   index: str,
                   noscan: int):
        """
        To set noscan to a specific radio index
        """
        zi_logger.log(f"lib.plpl.feature_radio.set_noscan({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            radio = self.db_obj.read_from_database(device, "wifi_device") + str(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f"uci set wireless.{radio}.noscan={noscan}"
        print(f"COMMAND : {command}")
        _, error = connection_obj.execute_command(command,
                                                  return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")

    def set_prop_coext(self,
                        device: str,
                        index: str):
        """
        To set noscan to a specific radio index
        """
        zi_logger.log(f"lib.plpl.feature_radio.set_noscan({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            ifname = self.db_obj.read_from_database(device, "wifi_ifname") + str(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f"cfg80211tool {ifname} disablecoext 1"
        print(f"COMMAND : {command}")
        _, error = connection_obj.execute_command(command,
                                                  return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")

    def set_prop_cfg(self,
                        device: str,
                        index: str):
        """
        To set noscan to a specific radio index
        """
        zi_logger.log(f"lib.plpl.feature_radio.set_noscan({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index  = self.db_obj.read_from_database(device, index)
            ifname = self.db_obj.read_from_database(device, "wifi_ifname") + str(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f"cfg80211tool {ifname} vht_11ng 1"
        print(f"COMMAND : {command}")
        _, error = connection_obj.execute_command(command,
                                                  return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")

    def get_noscan(self,
                   device: str,
                   index: str) -> int:
        """
        To get noscan assigned to a specific radio index
        """
        zi_logger.log(f"lib.plpl.feature_radio.get_noscan({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            radio = self.db_obj.read_from_database(device, "wifi_device") + str(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f"uci get wireless.{radio}.noscan"
        output, error = connection_obj.execute_command(command,
                                                       return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")
        return int(output)

    def set_regulatory_domain(self,
                              device: str,
                              reg_domain: str):
        """
        To set the regulatory domain to a specific radio index
        """
        zi_logger.log(f"lib.plpl.feature_radio.set_regulatory_domain({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
#        try:
#            index = self.db_obj.read_from_database(device, index)
#            radio = self.db_obj.read_from_database(device, "wifi_device") + str(index)
#        except Exception as err: # pylint: disable=broad-except
#            print(f"ERROR: {err}")
#            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f"ubus-cli Device.WiFi.Radio.*.RegulatoryDomain={reg_domain}"
        print(f"COMMAND : {command}")
        _, error = connection_obj.execute_command(command,
                                                  return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")

    def get_regulatory_domain(self,
                              device: str,
                              index: str) -> str:
        """
        To get regulatory domain assigned to a specific radio index
        """
        zi_logger.log(f"lib.plpl.feature_radio.get_regulatory_domain({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            #radio = self.db_obj.read_from_database(device, "wifi_device") + str(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f'ubus-cli Device.WiFi.Radio.{index}.RegulatoryDomain? | grep "=" | cut -d \'"\' -f 2'
        output, error = connection_obj.execute_command(command,
                                                       return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")
        return output

    def __get_phy_index(self,
                        device: str,
                        index: str) -> int:
        """
        Get the physical interface index for the given radio index
        """
        zi_logger.log(f"lib.plpl.feature_radio.__get_phy_index({device},{index})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            ifname = self.db_obj.read_from_database(device, "wifi_ifname") + str(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f"iw {ifname} info | grep 'wiphy' | awk '{{ print $2}}'"
        output, error = connection_obj.execute_command(command,
                                                       return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")
        return output
    
    def check_regulatory_domain(self,
                                device: str,
                                index: str,
                                reg_domain: str):
        """
        Check the regulatory domain assigned to a specific radio index
        """
        zi_logger.log(f"lib.plpl.feature_radio.check_regulatory_domain({device})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)

        try:
            phy_index = self.__get_phy_index(device, index)
            phy_ifname = self.db_obj.read_from_database(device, "wifi_phy_ifname") + str(phy_index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        
        sed_expr = "sed -n 's/^country \([A-Z][A-Z]\):.*/\\1/p'"
        command = f"iw {phy_ifname} reg get | {sed_expr}"
        output, error = connection_obj.execute_command(command,
                                                       return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")

        if output.upper() != reg_domain.upper():
            raise RuntimeError(
                f"Given regulatory domain {reg_domain.upper()} is not matched."
                f"with expected regulatory domain {output.upper()}")
    
    def get_physical_interface_index(self,
                                     device: str,
                                     index: str) -> int:
        """
        Get the physical interface index for the given radio index
        """
        zi_logger.log(f"lib.plpl.feature_radio.get_physical_interface_index({device},{index})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            ifname = self.db_obj.read_from_database(device, "wifi_ifname") + str(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f"iw {ifname} info | grep 'wiphy' | awk '{{ print $2}}'"
        output, error = connection_obj.execute_command(command,
                                                       return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")
        return int(output)
    
    def get_supported_channels_list(self,
                                    device: str,
                                    index: str) -> list:
        """Get the supported channels list for the given radio index"""
        zi_logger.log(f"lib.plpl.feature_radio.get_supported_channels_list({device},{index})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            ifname = self.db_obj.read_from_database(device, "wifi_ifname") + str(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f"iwlist {ifname} channel | grep '^ *Channel' | awk '{{print $2}}' | sort -n"
        output, error = connection_obj.execute_command(command,
                                                       return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")
        channels_list = output.strip().split('\n')
        return [int(channel) for channel in channels_list]

    def get_highest_supported_channel(self,
                                      device: str,
                                      index: str) -> int:  
        """Get the highest supported channels count for the given radio index"""
        zi_logger.log(f"lib.plpl.feature_radio.get_highest_supported_channel({device},{index})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            ifname = self.db_obj.read_from_database(device, "wifi_ifname") + str(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f"iwlist {ifname} channel | grep '^ *Channel' | awk '{{print $2}}' | sort -n | tail -1"
        output, error = connection_obj.execute_command(command,
                                                       return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")

        return int(output)

    def get_supported_channels_count(self,
                                     device: str,
                                     index: str) -> int:  
        """Get the supported channels list for the given radio index"""
        zi_logger.log(f"lib.plpl.feature_radio.get_supported_channels_count({device},{index})")
        connection = self.db_obj.read_from_database(device, 'connection')
        connection_obj = self.get_connection_module_object(connection)
        connection_obj.switch_connection(device)
        try:
            index = self.db_obj.read_from_database(device, index)
            ifname = self.db_obj.read_from_database(device, "wifi_ifname") + str(index)
        except Exception as err: # pylint: disable=broad-except
            print(f"ERROR: {err}")
            raise RuntimeError(f"Could not find out the Radio of the device : {device}")
        command = f"iwlist {ifname} channel | grep 'channels in total' | awk '{{print $2}}'"
        output, error = connection_obj.execute_command(command,
                                                       return_stderr=True)
        if error != '':
            raise RuntimeError(f"Command execution failed : {command}")

        return int(output)
