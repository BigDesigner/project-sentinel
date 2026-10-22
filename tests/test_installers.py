"""Exercise installer behavior in isolated temporary destinations."""

import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]
POWERSHELL = shutil.which('pwsh') or shutil.which('powershell')
BASH = shutil.which('bash')
if not BASH and os.name == 'nt':
    candidate = Path('C:/Program Files/Git/bin/bash.exe')
    if candidate.is_file():
        BASH = str(candidate)


class InstallerTests(unittest.TestCase):
    def exercise(self, host, target):
        with tempfile.TemporaryDirectory(prefix='.sentinel-installer-', dir=ROOT) as temp:
            destination = Path(temp) / 'skills with spaces'
            if host == 'powershell':
                command = [POWERSHELL, '-NoProfile', '-File', str(ROOT / 'install.ps1'),
                           '-Target', target, '-SkillsDir', str(destination)]
            else:
                command = [BASH, str(ROOT / 'install.sh'), '--target', target.lower(),
                           '--skills-dir', str(destination)]
            def run():
                return subprocess.run(command, cwd=ROOT, capture_output=True, text=True)

            first = run()
            self.assertEqual(first.returncode, 0, first.stdout + first.stderr)
            for source in (ROOT / 'skills').iterdir():
                self.assertEqual((destination / source.name / 'SKILL.md').read_bytes(),
                                 (source / 'SKILL.md').read_bytes())
            policy = destination / 'sentinel-rescue/agents/openai.yaml'
            self.assertIn('allow_implicit_invocation: false', policy.read_text())
            # Linked installs are repeatable; copy fallback preserves existing copies.
            second = run()
            installed_skill = destination / 'sentinel'
            junction = getattr(os.path, 'isjunction', lambda _: False)(installed_skill)
            if installed_skill.is_symlink() or junction:
                self.assertEqual(second.returncode, 0, second.stdout + second.stderr)
            else:
                self.assertNotEqual(second.returncode, 0)
            # A separate destination exercises collision handling without altering
            # any installed link or copy.
            conflict_destination = Path(temp) / 'conflicting skills'
            collision = conflict_destination / 'sentinel'
            collision.mkdir(parents=True)
            marker = collision / 'personal.txt'
            marker.write_text('preserve user data')
            command[-1] = str(conflict_destination)
            conflict = run()
            self.assertNotEqual(conflict.returncode, 0)
            self.assertEqual(marker.read_text(), 'preserve user data')
            self.assertFalse((collision / 'SKILL.md').exists())
            self.assertEqual((ROOT / 'skills/sentinel/SKILL.md').read_bytes(),
                             (ROOT / 'templates/sentinel-directive.md').read_bytes())

    @unittest.skipUnless(POWERSHELL, 'PowerShell unavailable')
    def test_powershell_codex(self):
        self.exercise('powershell', 'Codex')

    @unittest.skipUnless(POWERSHELL, 'PowerShell unavailable')
    def test_powershell_claude(self):
        self.exercise('powershell', 'Claude')

    @unittest.skipUnless(BASH, 'Bash unavailable')
    def test_bash_codex(self):
        self.exercise('bash', 'Codex')

    @unittest.skipUnless(BASH, 'Bash unavailable')
    def test_bash_claude(self):
        self.exercise('bash', 'Claude')


if __name__ == '__main__':
    unittest.main()
