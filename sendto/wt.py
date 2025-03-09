import subprocess
import sys
from pathlib import Path


def get_directories(paths):
    return {
        str(Path(path).parent if Path(path).is_file() else Path(path)) for path in paths
    }


def build_command(directories):
    command = "wt " + " ".join([f'-d "{dir_path}" ;' for dir_path in directories])
    return command.rstrip(" ;")


def open_windows_terminal(paths):
    directories = get_directories(paths)
    command = build_command(directories)
    subprocess.Popen(command)


if __name__ == "__main__":
    open_windows_terminal(sys.argv[1:])
