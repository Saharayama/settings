from pathlib import Path
import sys
import subprocess

SUFFIX_LIST = ['.zip', '.7z']
SEVEN_ZIP = Path(r'C:\Program Files\7-Zip\7z.exe')

for n in sys.argv[1:]:
    archive_path = Path(n)
    out_dir = Path(archive_path.parent, archive_path.stem)
    if archive_path.suffix in SUFFIX_LIST:
        if out_dir.exists():
            print(f'{out_dir} already exists.')
            subprocess.call('PAUSE', shell = True)
            sys.exit()
        result = subprocess.run([SEVEN_ZIP, 'x', archive_path, '-o' + str(out_dir)])
        if result.returncode == 0:
            archive_path.unlink()
        else:
            subprocess.call('PAUSE', shell = True)
            sys.exit()
    else:
        print(f'{archive_path} is not supported.')
        subprocess.call('PAUSE', shell = True)
        sys.exit()
