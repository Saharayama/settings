import subprocess
import sys

subprocess.Popen([r"C:\Program Files\Microsoft VS Code\Code.exe", "-n", *sys.argv[1:]])
