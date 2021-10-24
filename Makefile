.PHONY: clean deps converge

ENV=.env
PYTHON=python3
PYTHON_VERSION=$(shell ${PYTHON} -V | cut -d " " -f 2 | cut -c1-3)
SITE_PACKAGES=${ENV}/lib/python${PYTHON_VERSION}/site-packages
ENV_PYTHON=${ENV}/bin/python${PYTHON_VERSION}
IN_ENV=source ${ENV}/bin/activate;

default: deps

${ENV}:
	@echo "Creating Python ${PYTHON_VERSION} environment..." >&2
	@${PYTHON} -m venv ${ENV}
	@echo "Updating pip..." >&2
	@${ENV_PYTHON} -m pip install -U pip

deps: ${ENV}
	@${ENV_PYTHON} -m pip install -r requirements.txt
	@${IN_ENV} ansible-galaxy install -r requirements.yml

converge: deps
	@${IN_ENV} cd roles/wordpress_standalone; molecule converge


clean:
	@rm -rf ${ENV}
