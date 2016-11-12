# ezpz-setup
Abstracted &amp; remotely available python project setup scripts

## What it do
- Installs pip and virtualenv if you don't already have it.
- Creates `env` in your project dir (and adds `env/` to your `.gitignore`).
- Installs all dependencies from requirements.txt in your project dir ONLY when there's an update to your local requirements.txt (nice for saving time during automation pipelines)

## Why
- Use lots of different computers/vms/cronjobs/automation etc? This saves tons of setup time.
- Project level `env` dir is much more accessible than `$HOME/.virtualenvs/.../` which how virtualenvwrapper and virtualenvburrito handle virtualenv.

## Usage

**Manual**
1. Copy `setup.sh` ([raw](https://raw.githubusercontent.com/mijdavis2/ezpz-setup/master/setup.sh)) into the parent dir of your python package
2. Update `PYTHON_VERSION` in in `setup.sh` to your project's minimum python version
3. Run `source setup.sh`

**Automated**
What are you making?
1. Generic python project: [generator-pyboot](https://github.com/mijdavis2/generator-pyboot)
2. Pypi package: [generator-pypi](https://github.com/mijdavis2/generator-pypi-master)
3. Python webapp with Weppy: [generator-weppy-mvc](https://github.com/mijdavis2/generator-weppy-mvc)
