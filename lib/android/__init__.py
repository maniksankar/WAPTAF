from zi4pitstop.lib.android.feature_client import FeatureClient
import zi4pitstop.lib.utils.zi_logger as zi_logger

class Android(FeatureClient):
    def __init__(self):
        zi_logger.log("Adb __init__ : START")
        FeatureClient.__init__(self)
        zi_logger.log("Adb __init__ : END")

