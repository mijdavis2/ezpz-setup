# ezpz-setup
Abstracted &amp; remotely available python project setup scripts

## What it do
- Installs pip and virtualenv if you don't already have it.
- Creates `env` in your project dir (so remember to add `env/` to your `.gitignore`).
- Installs all dependencies from requirements.txt in your project dir ONLY when there's an update to your local requirements.txt (nice for saving time during automation pipelines)

## Why
- Use lots of different computers/vms/cronjobs/automation etc? This saves tons of setup time.
- Project level `env` dir is much more accessible than `$HOME/.virtualenvs/.../` which how virtualenvwrapper and virtualenvburrito handle virtualenv.

## Usage
1. Copy `setup.sh` into the parent dir of your python package
2. Update `PYTHON_VERSION` in in `setup.sh`
3. Run `source setup.sh`
