from zi4pitstop.lib.map.radio import Radio
from zi4pitstop.lib.map.interface import Interface
from zi4pitstop.lib.map.client import Client
from zi4pitstop.lib.map.connection import Connection
from zi4pitstop.lib.map.database import Database
import zi4pitstop.lib.utils.zi_logger as zi_logger
from zi4pitstop.lib.map.ping import Ping
from zi4pitstop.lib.map.traffic_generator import TrafficGenerator
from zi4pitstop.lib.map.operating_system import OperatingSystem
from zi4pitstop.lib.map.firewall import Firewall
from zi4pitstop.lib.map.system import System_setting

class Pitstop(Radio,
              Interface,
              Client,
              Connection,
              Database,
              Ping,
              TrafficGenerator,
              OperatingSystem,
              Firewall,
              System_setting):

    def __init__(self):
        zi_logger.enable_log(True)
        zi_logger.log("******* Pitstop __init__ : START")
        Radio.__init__(self)
        Interface.__init__(self)
        Client.__init__(self)
        Connection.__init__(self)
        Database.__init__(self)
        Ping.__init__(self)
        TrafficGenerator.__init__(self)
        OperatingSystem.__init__(self)
        Firewall.__init__(self)
        System_setting.__init__(self)
        zi_logger.log("******* Pitstop __init__ : END")
