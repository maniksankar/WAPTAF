from zi4pitstop.lib.rdkb.feature_radio import FeatureRadio
from zi4pitstop.lib.rdkb.feature_interface import FeatureInterface
import zi4pitstop.lib.utils.zi_logger as zi_logger

class Rdkb(FeatureRadio,
           FeatureInterface):
    
    def __init__(self):
        zi_logger.log("Rdkb __init__ : START")
        FeatureRadio.__init__(self)
        FeatureInterface.__init__(self)
        zi_logger.log("Rdkb __init__ : END")
