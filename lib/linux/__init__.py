from zi4pitstop.lib.linux.feature_client import FeatureClient
from zi4pitstop.lib.linux.feature_ping import FeaturePing
from zi4pitstop.lib.linux.feature_traffic_generator import FeatureTrafficGenerator
import zi4pitstop.lib.utils.zi_logger as zi_logger

class Linux(FeatureClient,
            FeaturePing,
            FeatureTrafficGenerator):
    
    def __init__(self):
        zi_logger.log("Linux __init__ : START")
        FeatureClient.__init__(self)
        FeaturePing.__init__(self)
        FeatureTrafficGenerator.__init__(self)
        zi_logger.log("Linux __init__ : END")

        
