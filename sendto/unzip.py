import subprocess
import sys
from pathlib import Path

SUPPORTED_SUFFIXES = {".zip", ".7z", ".gz", ".tar", ".zst"}
SEVEN_ZIP = Path(r"C:\Program Files\7-Zip\7z.exe")


def pause_and_exit(message: str = "") -> None:
    if message:
        print(message)
    subprocess.call("PAUSE", shell=True)
    sys.exit(1)


for n in sys.argv[1:]:
    archive_path = Path(n)
    out_dir = archive_path.parent / archive_path.stem
    if archive_path.is_file() and archive_path.suffix.lower() in SUPPORTED_SUFFIXES:
        if out_dir.exists():
            pause_and_exit(f"{out_dir} already exists.")
        result = subprocess.run([SEVEN_ZIP, "x", archive_path, f"-o{out_dir}"])
        if result.returncode == 0:
            archive_path.unlink()
        else:
            pause_and_exit()
    else:
        pause_and_exit(f"{archive_path} is not supported.")
