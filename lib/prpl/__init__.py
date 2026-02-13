from zi4pitstop.lib.prpl.feature_radio import FeatureRadio
from zi4pitstop.lib.prpl.feature_interface import FeatureInterface
#from zi4pitstop.lib.openwrt.feature_ping import FeaturePing
#from zi4pitstop.lib.openwrt.feature_traffic_generator import FeatureTrafficGenerator
#from zi4pitstop.lib.openwrt.feature_operating_system import FeatureOperatingSystem
import zi4pitstop.lib.utils.zi_logger as zi_logger

class Prpl(FeatureRadio,
           FeatureInterface):
              #FeaturePing,
              #FeatureTrafficGenerator,
              #FeatureOperatingSystem):
    
    def __init__(self):
        zi_logger.log("Openwrt __init__ : START")
        FeatureRadio.__init__(self)
        FeatureInterface.__init__(self)
        #FeaturePing.__init__(self)
        #FeatureTrafficGenerator.__init__(self)
        #FeatureOperatingSystem.__init__(self)


        
