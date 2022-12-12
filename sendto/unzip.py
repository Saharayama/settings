from pathlib import Path
import sys
import subprocess

suffix_list = ['.zip', '.7z']
seven_zip = Path(r'C:\Program Files\7-Zip\7z.exe')

for n in sys.argv[1:]:
    archive_path = Path(n)
    out_dir = Path(archive_path.parent, archive_path.stem)
    if archive_path.suffix in suffix_list:
        if out_dir.exists():
            print(str(out_dir) + ' already exists.')
            subprocess.call('PAUSE', shell = True)
            sys.exit()
        result = subprocess.run([seven_zip, 'x', archive_path, '-o' + str(out_dir)])
        if result.returncode == 0:
            archive_path.unlink()
        else:
            subprocess.call('PAUSE', shell = True)
            sys.exit()
    else:
        print(str(archive_path) + ' is not supported.')
        subprocess.call('PAUSE', shell = True)
        sys.exit()
