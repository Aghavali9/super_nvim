"""Exercise installer using isolated directories and a stub version probe."""
import os
from pathlib import Path
import subprocess
import tempfile

script = Path(__file__).resolve().parents[1] / 'installer.sh'
with tempfile.TemporaryDirectory(prefix='super nvim test ') as tmp:
    root = Path(tmp)
    bin_dir = root / 'bin'
    bin_dir.mkdir()
    probe = bin_dir / 'nvim'
    probe.write_text('#!/bin/sh\nexit 0\n')
    probe.chmod(0o755)
    env = dict(os.environ, XDG_CONFIG_HOME=str(root / 'config'), PATH=str(bin_dir) + os.pathsep + os.environ['PATH'])
    def run(*args, success=True):
        r = subprocess.run(['bash', str(script), *args], env=env, capture_output=True, text=True)
        assert (r.returncode == 0) == success, r.stdout + r.stderr
        return r
    run('--dry-run')
    assert not (root / 'config').exists(), 'dry run wrote files'
    run('--app', '../escape', success=False)
    run()
    target = root / 'config' / 'super_nvim'
    assert (target / 'lua/config/theme.lua').is_file()
    (target / 'sentinel').write_text('previous configuration')
    run()
    backups = list((root / 'config').glob('super_nvim.backup.*'))
    assert len(backups) == 1 and (backups[0] / 'sentinel').read_text() == 'previous configuration'
    assert not (target / 'sentinel').exists()
    nested = subprocess.run(['bash', str(target / 'installer.sh')], env=env, capture_output=True)
    assert nested.returncode != 0, 'must not move its own source'
    print('PASS installer: dry run, invalid target, install, backup, self-install rejection')
