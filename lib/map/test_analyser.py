import re
from robot.api import logger
from zi4pitstop.lib.bridge.database_module import DatabaseModule


class test_analyser(DatabaseModule):

    ROBOT_LISTENER_API_VERSION = 3

    def __init__(self):
        DatabaseModule.__init__(self)
        self.__db_obj = self.get_database_module_object()
        self.device_alive = []

    def __update_device_alive(self):
        self.device_alive = self.__db_obj.get_live_devices()
        print(f"Devices alive : {self.device_alive}")

    def check_device_tags(self, tags):
        print(f"Tags : {tags}")
        if 'ap' not in self.device_alive:
            return 'ap'
        for tag in tags:
            if tag.startswith('dev') and tag not in self.device_alive:
                return tag
        return True

    def start_test(self, data, result):
        print("==== test_analyser.start_test")
        tags   = [str(t).lower() for t in data.tags]
        self.__update_device_alive()
        device = self.check_device_tags(tags)

        if device == True:
            return   # all devices alive â run normally

        reason = f"Device '{device}' is not alive"
        print(f"Skipping â {reason}")

        # ââ Overwrite Test Setup in-place ââââââââââââââââââââââââââââââââââââââ
        # data.setup is the suite-level "Test Precondition" keyword.
        # If left as-is and the DUT (ap) is dead, Test Precondition will FAIL
        # before the body even starts â test ends as FAIL, not SKIP.
        # Replacing it with Skip here ensures the setup itself triggers SKIP.
        #
        # DO NOT use data.setup = None or create a new object.
        # Overwrite .name and .args on the EXISTING object â this is what RF
        # serialises into its execution plan.
        if data.setup and hasattr(data.setup, 'name'):
            data.setup.name = "Skip"
            data.setup.args = [reason]

        # ââ Overwrite first body keyword in-place ââââââââââââââââââââââââââââââ
        # DO NOT call data.body.clear() â that leaves the body empty and RF
        # raises "Test cannot be empty".
        # DO NOT call data.body.create_keyword() â in some RF versions the
        # object is created detached and body stays empty â same error.
        #
        # Instead: overwrite data.body[0] directly on the existing object.
        # RF will execute Skip, which raises SkipExecution from inside the
        # keyword execution stack (the only place RF honours it).
        # body[1], body[2], ... never run because Skip halts execution.
        if data.body:
            data.body[0].name = "Skip"
            data.body[0].args = [reason]

    def end_test(self, data, result):
        print(f"==== test_analyser.end_test  status={result.status}")
