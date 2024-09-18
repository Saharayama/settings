import sys
import subprocess
from pathlib import Path

for n in sys.argv[1:]:
    path = Path(n)
    if path.is_dir():
        path_dir = path
    elif path.is_file():
        path_dir = path.parent.resolve()
    else:
        continue
    subprocess.Popen([r"wt", "-d", path_dir])
