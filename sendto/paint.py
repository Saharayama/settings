import sys
import subprocess

for n in sys.argv[1:]:
    subprocess.Popen(['mspaint', n])
