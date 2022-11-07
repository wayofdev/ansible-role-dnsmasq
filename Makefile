###
### Variables
###

export ANSIBLE_FORCE_COLOR = 1
export PY_COLORS = 1
export PYTHONIOENCODING = UTF-8
export LC_CTYPE = en_US.UTF-8
export LANG = en_US.UTF-8

# https://serverfault.com/questions/1031491/display-ansible-playbook-output-properly-formatted
# https://stackoverflow.com/questions/50009505/ansible-stdout-formatting
export ANSIBLE_STDOUT_CALLBACK = unixy

TASK_TAGS ?= "dnsmasq-install,dnsmasq-configure"
REQS ?= requirements.yml
INSTALL_POETRY ?= true
POETRY_BIN ?= poetry
POETRY_RUNNER ?= poetry run
ANSIBLE_LATER_BIN = ansible-later

# leave empty to disable
# -v - verbose;
# -vv - more details
# -vvv - enable connection debugging
DEBUG_VERBOSITY ?= -vvv

ifneq ($(TERM),)
	BLACK := $(shell tput setaf 0)
	RED := $(shell tput setaf 1)
	GREEN := $(shell tput setaf 2)
	YELLOW := $(shell tput setaf 3)
	LIGHTPURPLE := $(shell tput setaf 4)
	PURPLE := $(shell tput setaf 5)
	BLUE := $(shell tput setaf 6)
	WHITE := $(shell tput setaf 7)
	RST := $(shell tput sgr0)
else
	BLACK := ""
	RED := ""
	GREEN := ""
	YELLOW := ""
	LIGHTPURPLE := ""
	PURPLE := ""
	BLUE := ""
	WHITE := ""
	RST := ""
endif
MAKE_LOGFILE = /tmp/ansible-role-dnsmasq.log
MAKE_CMD_COLOR := $(BLUE)

default: all

help:
	@echo 'Management commands for package:'
	@echo 'Usage:'
	@echo '    ${MAKE_CMD_COLOR}make${RST}                       Shows this menu'
	@grep -E '^[a-zA-Z_0-9%-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "    ${MAKE_CMD_COLOR}make %-21s${RST} %s\n", $$1, $$2}'
	@echo
	@echo '    📑 Logs are stored in      $(MAKE_LOGFILE)'
	@echo
	@echo '    📦 Package                 ansible-role-dnsmasq (github.com/wayofdev/ansible-role-dnsmasq)'
	@echo '    🤠 Author                  Andrij Orlenko (github.com/lotyp)'
	@echo '    🏢 ${YELLOW}Org                     wayofdev (github.com/wayofdev)${RST}'
.PHONY: help

all: help
PHONY: all


# Installation Actions, Dependencies
# ------------------------------------------------------------------------------------
install: install-poetry install-deps ## Installs poetry and it's dependencies to run this role
.PHONY: install

install-deps: ## Installs python and ansible dependencies, to run this role
	$(POETRY_BIN) install
	$(POETRY_RUNNER) ansible-galaxy install -r $(REQS)
.PHONY: install-deps

install-poetry: ## Installs poetry into currently running system
ifeq ($(INSTALL_POETRY),true)
	sudo sh contrib/poetry-bin/install.sh
else
	@echo "Poetry installation disabled by global variable! Exiting..."
	@exit 0
endif
.PHONY: install-poetry


# Various actions for role testing
# ------------------------------------------------------------------------------------
m-local: ## Run tests against local (this) machine
	$(POETRY_RUNNER) molecule test --scenario-name default-macos-on-localhost -- $(DEBUG_VERBOSITY) --tags $(TASK_TAGS) --ask-become-pass
.PHONY: m-local

m-remote: ## Run tests against SSH machine
	$(POETRY_RUNNER) molecule test --scenario-name default-macos-over-ssh -- $(DEBUG_VERBOSITY) --tags $(TASK_TAGS)
.PHONY: m-remote

login-mac:
	$(POETRY_RUNNER) molecule login \
		--host macos-12-vm \
		--scenario-name default-macos-over-ssh
.PHONY: login-mac


# Git Actions
# ------------------------------------------------------------------------------------
hooks: ## Installs pre-commit hooks for this repository
	$(POETRY_RUNNER) pre-commit install
	$(POETRY_RUNNER) pre-commit autoupdate
.PHONY: hooks


# Custom Commands
# ------------------------------------------------------------------------------------
test-dns: ## Tests installed role by making ping to custom .docker domain
	sudo dscacheutil -flushcache
	sudo killall -HUP mDNSResponder
	ping -c 6 default.subdomain.docker
.PHONY: test-dns

install-role: ## Installs this role locally
	ansible-playbook tests/main.yml --ask-become-pass
.PHONY: install-role


# Quality Check Actions
# ------------------------------------------------------------------------------------
lint: later ## Runs various linter tools to check code quality of this role
	$(POETRY_RUNNER) yamllint .
	$(POETRY_RUNNER) ansible-lint . --force-color
.PHONY: lint

debug-version:
	$(POETRY_RUNNER) ansible --version
.PHONY: debug-version

later: ## Quality Check — runs ansible-later linter over this role
	$(POETRY_RUNNER) $(ANSIBLE_LATER_BIN) **/*.yml
.PHONY: later
