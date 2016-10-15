#!/usr/bin/env bash
# -------------------------------------------------------------------
# [Michael J. Davis]
#    ezpz-setup.sh
#          No hassle setup to isntall virtualenv & dependencies
# -------------------------------------------------------------------

VERSION=0.1.0
USAGE='Usage: source ezpz-setup.sh -hv -p "/path/to/python/" -r "required.python.version" -q "/path/to/requirements.txt"'

{
  [[ "${BASH_SOURCE[0]}" != $0 ]] && echo "Setting up your package"
} || {
  echo "
  Please run script as 'source'
  ${USAGE}
  "
  exit 1
}

# --- Option processing ---------------------------------------------
while getopts ":v:h:p:r:q:" o; do
  case "${o}" in
    v)
      echo "Version $VERSION"
      return 0;
      ;;
    h)
      echo $USAGE
      return 0;
      ;;
    p)
      USE_PYTHON=$OPTARG
      ;;
    r)
      REQUIRED_PYTHON_VERSION=$OPTARG
      ;;
    q)
      REQUIREMENTS_DIR=$OPTARG
      ;;
    ?)
      echo "Unknown option $OPTARG"
      return 0;
      ;;
    :)
      echo "No argument value for option $OPTARG"
      return 0;
      ;;
    *)
      echo $USAGE
      echo "Unknown error while processing options"
      return 0;
      ;;
  esac
done

if [ ! ${REQUIRED_PYTHON_VERSION} ]
then
  echo ${USAGE}
fi

THIS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


# ------------------------------------------------------------------
#  CHECK PYTHON VERSION
# ------------------------------------------------------------------
PY_VERSION_SPLIT=( ${REQUIRED_PYTHON_VERSION//\./ } )
PY_MAJ_REQ=${PY_VERSION_SPLIT[0]}
PY_MIN_REQ=${PY_VERSION_SPLIT[1]}
PY_PAT_REQ=${PY_VERSION_SPLIT[2]}

if [ ! ${USE_PYTHON} ]
then
    USE_PYTHON="$( which python"$PY_MAJ_REQ"."$PY_MIN_REQ" )"
    if [ ! ${USE_PYTHON} ]
    then
        echo "Python $PY_MAJ_REQ.$PY_MIN_REQ not found"
        return 1
    fi
fi

PMAJOR="$( "$USE_PYTHON" -c 'import platform; major, minor, patch = platform.python_version_tuple(); print(major);' )"
PMINOR="$( "$USE_PYTHON" -c 'import platform; major, minor, patch = platform.python_version_tuple(); print(minor);' )"
PPATCH="$( "$USE_PYTHON" -c 'import platform; major, minor, patch = platform.python_version_tuple(); print(patch);' )"

if [[ "$PMAJOR" -ge $PY_MAJ_REQ ]] && [[ "$PMINOR" -ge $PYMIN_REQ ]] && [[ "$PPATCH" -ge $PY_PAT_REQ ]]
then
    echo "Using python$PMAJOR.$PMINOR.$PPATCH"
else
    echo "Python version must be $PY_MAJ_REQ.$PY_MIN_REQ.$PY_PAT_REQ"
    echo "Yours is $PMAJOR.$PMINOR.$PPATCH :("
    return 1
fi

# ------------------------------------------------------------------
#  CHECK FOR AND INSTALL VIRTUALENV/PIP
# ------------------------------------------------------------------
USE_PIP="$( which pip"$PY_MAJ_REQ" )"
checkin_virtualenv() {
    create_virtualenv() { $( which virtualenv ) ${THIS_DIR}/env -p ${USE_PYTHON}; }
    {
        create_virtualenv
    } || {
        echo "This package requires pip and virtualenv"
        {
            ${USE_PYTHON} -c "import pip"
        } || {
            echo "Installing pip for python$PY_MAJ_REQ.$PY_MIN_REQ"
            curl https://bootstrap.pypa.io/get-pip.py | ${USE_PYTHON}
        } || {
            echo "Could not install pip"
            echo "Please see: https://pip.pypa.io/en/stable/installing/"
            return 1
        }
        # Now that pip is installed - create virtualenv
        {
            create_virtualenv
        } || {
            echo "Installing virtualenv"
            {
              USE_PIP="$( which pip"$PY_MAJ_REQ" )"
              sudo ${USE_PIP} install virtualenv
              create_virtualenv
            } || {
              echo "Could not install virtualenv"
              echo "Please see: https://virtualenv.pypa.io/en/stable/installation/"
              return 1
            }
        }
    }
}

if [ ! -d ${THIS_DIR}/env ]
then
    checkin_virtualenv
fi

# -----------------------------------------------------------------
#  Activate virtualenv and install dependencies
# -----------------------------------------------------------------
source ${THIS_DIR}/env/bin/activate

if [ ! "$REQUIREMENTS_DIR" ]
then
    REQUIREMENTS_DIR="$THIS_DIR"
fi
REQ_FILE="${REQUIREMENTS_DIR}/requirements.txt"

if [ -f ${THIS_DIR}/env/requirements.txt ]
then
    {
        cmp --silent ${REQ_FILE} ${THIS_DIR}/env/requirements.txt
    } && {
        return 0
    }
fi

# Install and cache requirements file so we only run pip install if it's changed
${USE_PIP} install -r ${REQ_FILE} && \cp ${REQ_FILE} ${THIS_DIR}/env/requirements.txt
return 0
