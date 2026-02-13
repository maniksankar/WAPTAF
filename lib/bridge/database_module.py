from zi4pitstop.lib.utils.database import Database
import zi4pitstop.lib.utils.zi_logger as zi_logger

class DatabaseModule:

    __instance = None
    __module_object = None

    def __new__(cls, *args, **kwargs):
        if cls.__instance is None:
            zi_logger.log("DatabaseModule Instance created")
            cls.__instance = super().__new__(cls)
        return cls.__instance

    def __init__(self):
        zi_logger.log("DatabaseModule __init__")

    def get_database_module_object(self):
        zi_logger.log(f"lib.bridge.database_module.get_database_module_object()")
        if DatabaseModule.__module_object is None:
             DatabaseModule.__module_object = Database()
        return DatabaseModule.__module_object
