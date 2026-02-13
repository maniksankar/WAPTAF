from zi4pitstop.lib.bridge.database_module import DatabaseModule
from robot.api.deco import keyword
import zi4pitstop.lib.utils.zi_logger as zi_logger

class Database(DatabaseModule):

    ROBOT_AUTO_KEYWORDS = False
    ROBOT_LIBRARY_SCOPE = 'Global'

    def __init__(self):
        zi_logger.log("Map - Database __init__ : START")
        DatabaseModule.__init__(self)
        self.db_obj = self.get_database_module_object()
        zi_logger.log(f"==== db_obj : {self.db_obj}")
        zi_logger.log("Map - Database __init__ : END")

    @keyword("Initialize Database")
    def initialize_database(self, config_path):
        zi_logger.log(f"lib.map.database.initialize_database({config_path})")
        self.db_obj.initialize_database(config_path)

    @keyword("Read From Database")
    def read_from_database(self, *args):
        zi_logger.log(f"lib.map.database.read_from_database({args})")
        ret = self.db_obj.read_from_database(*args)
        return ret

    @keyword("Write Into Database")
    def write_into_database(self, *args):
        zi_logger.log(f"lib.map.database.write_into_database({args})")
        ret = self.db_obj.write_into_database(*args)
        return ret

    @keyword("Get Testbed Devices")
    def get_testbed_devices(self):
        zi_logger.log(f"lib.map.database.get_testbed_devices()")
        devices = self.db_obj.get_testbed_devices()
        return devices
        
