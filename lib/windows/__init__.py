from zi4pitstop.lib.windows.feature_traffic_generator import FeatureTrafficGenerator
import zi4pitstop.lib.utils.zi_logger as zi_logger

class Linux(FeatureTrafficGenerator):
    
    def __init__(self):
        zi_logger.log("Linux __init__ : START")
        FeatureTrafficGenerator.__init__(self)
        zi_logger.log("Linux __init__ : END")

        
