import subprocess
import sys

for n in sys.argv[1:]:
    subprocess.Popen([r"mspaint", n])
