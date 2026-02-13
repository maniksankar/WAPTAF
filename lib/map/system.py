from zi4pitstop.lib.bridge.database_module import DatabaseModule
from zi4pitstop.lib.bridge.platform_modules import PlatformModules
from robot.api.deco import keyword
import zi4pitstop.lib.utils.zi_logger as zi_logger

class System_setting(DatabaseModule,
                PlatformModules):

    ROBOT_AUTO_KEYWORDS = False
    ROBOT_LIBRARY_SCOPE = 'Global'

    def __init__(self):
        zi_logger.log("System __init__ : START")
        DatabaseModule.__init__(self)
        PlatformModules.__init__(self)
        self.db_obj = self.get_database_module_object()
        zi_logger.log(f"==== db_obj : {self.db_obj}")
        zi_logger.log("System __init__ : END")

    @keyword("Load System")
    def load_system(self,
                        device: str):

        zi_logger.log(f"lib.map.firewall.load_system({device})")
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        platform_obj.load_system(device)
    
    @keyword("Set Time Zone")
    def set_time_zone(self,
                        device: str,
                        system_index: int,
			            time_zone: str):
        
        zi_logger.log(f"lib.map.firewall.set_time_zone({device})")
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        return platform_obj.set_time_zone(device,system_index,time_zone)
    
    @keyword("Get Time Zone")
    def get_time_zone(self,
                        device: str,
                        system_index: int):
        zi_logger.log(f"lib.map.firewall.get_time_zone({device})")
        platform = self.db_obj.read_from_database(device, 'platform')
        platform_obj = self.get_platform_module_object(platform)
        return platform_obj.get_time_zone(device,system_index)
