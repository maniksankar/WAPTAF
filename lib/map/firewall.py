from zi4pitstop.lib.bridge.database_module import DatabaseModule
from zi4pitstop.lib.bridge.platform_modules import PlatformModules
from robot.api.deco import keyword
import zi4pitstop.lib.utils.zi_logger as zi_logger

class Firewall(DatabaseModule,
                PlatformModules):

    ROBOT_AUTO_KEYWORDS = False
    ROBOT_LIBRARY_SCOPE = 'Global'

    def __init__(self):
        zi_logger.log("Firewall __init__ : START")
        DatabaseModule.__init__(self)
        PlatformModules.__init__(self)
        self.db_obj = self.get_database_module_object()
        zi_logger.log(f"==== db_obj : {self.db_obj}")
        zi_logger.log("Firewall __init__ : END")

    @keyword("Load Firewall")
    def load_firewall(self,
                        device: str):

        zi_logger.log(f"lib.map.firewall.load_firewall({device})")
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        platform_obj.load_firewall(device)


    @keyword("Get Firewall Zone Index by Name")
    def get_firewall_zone_index_by_name(self,
                                            device: str,
                                            zone_name: str):

        zi_logger.log(f"lib.map.firewall.get_firewall_zone_index_by_name({device})")
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        return platform_obj.get_firewall_zone_index_by_name(device,zone_name)

    @keyword("Add Firewall Zone")
    def add_firewall_zone(self,
                      device: str,
                      zone_index: int,
                      zone_name: str):

        zi_logger.log(f"lib.map.firewall.add_firewall_zone({device})")
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        return platform_obj.add_firewall_zone(device,zone_index,zone_name)

    @keyword("Set Zone Name")
    def set_zone_name(self,
                           device: str,
                           zone_name: str,
                           zone_new_name: str):

        zi_logger.log(f"lib.map.firewall.set_zone_name({device})")
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        return platform_obj.set_zone_name(device,zone_name,zone_new_name)

    @keyword("Get Zone Name")
    def get_zone_name(self,
                        device: str,
                        zone_name: str):

        zi_logger.log(f"lib.map.firewall.get_zone_name({device})")
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        return platform_obj.get_zone_name(device,zone_name)

    @keyword("Set Zone Network")
    def set_zone_network(self,
                           device: str,
                           zone_name: str,
                           zone_network: str):

        zi_logger.log(f"lib.map.firewall.set_zone_network({device})")
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        return platform_obj.set_zone_network(device,zone_name,zone_network)

    @keyword("Get Zone Network")
    def get_zone_network(self,
                        device: str,
                        zone_name: str):

        zi_logger.log(f"lib.map.firewall.get_zone_network({device})")
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        return platform_obj.get_zone_network(device,zone_name)


    @keyword("Set Zone Input")
    def set_zone_input(self,
                           device: str,
                           zone_name: str,
                           zone_input: str):

        zi_logger.log(f"lib.map.firewall.set_zone_input({device})")
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        return platform_obj.set_zone_input(device,zone_name,zone_input)

    @keyword("Get Zone Input")
    def get_zone_input(self,
                        device: str,
                        zone_name: str):

        zi_logger.log(f"lib.map.firewall.get_zone_input({device})")
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        return platform_obj.get_zone_input(device,zone_name)

    @keyword("Set Zone Output")
    def set_zone_output(self,
                           device: str,
                           zone_name: str,
                           zone_output: str):

        zi_logger.log(f"lib.map.firewall.set_zone_output({device})")
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        return platform_obj.set_zone_output(device,zone_name,zone_output)

    @keyword("Get Zone Output")
    def get_zone_output(self,
                        device: str,
                        zone_name: str):

        zi_logger.log(f"lib.map.firewall.get_zone_output({device})")
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        return platform_obj.get_zone_output(device,zone_name)

    @keyword("Set Zone Forward")
    def set_zone_forward(self,
                           device: str,
                           zone_name: str,
                           zone_forward: str):

        zi_logger.log(f"lib.map.firewall.set_zone_forward({device})")
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        return platform_obj.set_zone_forward(device,zone_name,zone_forward)

    @keyword("Get Zone Forward")
    def get_zone_forward(self,
                        device: str,
                        zone_name: str):

        zi_logger.log(f"lib.map.firewall.get_zone_forward({device})")
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        return platform_obj.get_zone_forward(device,zone_name)

    @keyword("Set Zone source")
    def set_zone_source(self,
                           device: str,
                           zone_name: str,
                           zone_source: str):

        zi_logger.log(f"lib.map.firewall.set_zone_source({device})")
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        return platform_obj.set_zone_source(device,zone_name,zone_source)

    @keyword("Get Zone Source")
    def get_zone_source(self,
                        device: str,
                        zone_name: str):

        zi_logger.log(f"lib.map.firewall.get_zone_source({device})")
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        return platform_obj.get_zone_source(device,zone_name)

    @keyword("Set Zone Destination")
    def set_zone_destination(self,
                           device: str,
                           zone_name: str,
                           zone_destination: str):

        zi_logger.log(f"lib.map.firewall.set_zone_destination({device})")
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        return platform_obj.set_zone_destination(device,zone_name,zone_destination)

    @keyword("Get Zone Destination")
    def get_zone_destination(self,
                        device: str,
                        zone_name: str):

        zi_logger.log(f"lib.map.firewall.get_zone_destination({device})")
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        return platform_obj.get_zone_destination(device,zone_name)

    @keyword("Set Zone Masq")
    def set_zone_masq(self,
                           device: str,
                           zone_name: str,
                           zone_masq: int):

        zi_logger.log(f"lib.map.firewall.set_zone_masq({device})")
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        return platform_obj.set_zone_masq(device,zone_name,zone_masq)

    @keyword("Get Zone Masq")
    def get_zone_masq(self,
                        device: str,
                        zone_name: str):

        zi_logger.log(f"lib.map.firewall.get_zone_masq({device})")
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        return platform_obj.get_zone_masq(device,zone_name)


