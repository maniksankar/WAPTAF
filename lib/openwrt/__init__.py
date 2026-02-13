from zi4pitstop.lib.openwrt.feature_radio import FeatureRadio
from zi4pitstop.lib.openwrt.feature_interface import FeatureInterface
from zi4pitstop.lib.openwrt.feature_ping import FeaturePing
from zi4pitstop.lib.openwrt.feature_traffic_generator import FeatureTrafficGenerator
from zi4pitstop.lib.openwrt.feature_operating_system import FeatureOperatingSystem
from zi4pitstop.lib.openwrt.feature_firewall import FeatureFirewall
from zi4pitstop.lib.openwrt.feature_system import FeatureSystem
import zi4pitstop.lib.utils.zi_logger as zi_logger

class Openwrt(FeatureRadio,
              FeatureInterface,
              FeaturePing,
              FeatureTrafficGenerator,
              FeatureOperatingSystem,
              FeatureFirewall,
              FeatureSystem):
    
    def __init__(self):
        zi_logger.log("Openwrt __init__ : START")
        FeatureRadio.__init__(self)
        FeatureInterface.__init__(self)
        FeatureFirewall.__init__(self)
        FeaturePing.__init__(self)
        FeatureTrafficGenerator.__init__(self)
        FeatureOperatingSystem.__init__(self)
        FeatureSystem.__init__(self)
        


        
