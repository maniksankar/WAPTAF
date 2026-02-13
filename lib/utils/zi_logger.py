

enable_log = True

def log(message):
    if enable_log:
        print(f"LOG : {message}")

def enable_log(status):
    global enable_log
    enable_log = status
