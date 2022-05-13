<br>

<div align="center">
<img width="456" height="60" src="./assets/logo.gh-light-mode-only.png#gh-light-mode-only">
<img width="456" height="60" src="./assets/logo.gh-dark-mode-only.png#gh-dark-mode-only">
</div>

<br>

<br>

<div align="center">
<a href="https://actions-badge.atrox.dev/wayofdev/ansible-role-dnsmasq/goto"><img alt="Build Status" src="https://img.shields.io/endpoint.svg?url=https%3A%2F%2Factions-badge.atrox.dev%2Fwayofdev%2Fansible-role-dnsmasq%2Fbadge&style=flat-square"/></a>
<a href="https://galaxy.ansible.com/lotyp/dnsmasq"><img alt="Ansible Role" src="https://img.shields.io/ansible/role/58558?style=flat-square"/></a>
<a href="https://github.com/wayofdev/ansible-role-dnsmasq/tags"><img src="https://img.shields.io/github/v/tag/wayofdev/ansible-role-dnsmasq?sort=semver&style=flat-square" alt="Latest Version"></a>
<a href="https://galaxy.ansible.com/lotyp/dnsmasq">
<img alt="Ansible Quality Score" src="https://img.shields.io/ansible/quality/58558?style=flat-square"/></a>
<a href="https://galaxy.ansible.com/lotyp/dnsmasq">
<img alt="Ansible Role" src="https://img.shields.io/ansible/role/d/58558?style=flat-square"/></a>
<a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square" alt="Software License"/></a>
</div>



<br>

# Ansible Role: Dnsmasq for MacOS

Role is used to automate installation and setup of [dnsmasq](https://thekelleys.org.uk/dnsmasq/doc.html). Dnsmasq provides network infrastructure for small networks: DNS, DHCP, router advertisement and network boot.

By default, role configures Dnsmasq to serve `*.docker` and `*.mac` domains as `localhost`. This allows you to use wildcard domains, like `your.subdomain.project.docker` for every of your project.

### → Purpose

Developers will be familiar with the process of updating your `/etc/hosts` file to direct traffic for `yourproject.docker` to `127.0.0.1`. Most will also be familiar with the problems of this approach:

- it requires a configuration change every time you add or remove a project; and
- it requires administration access to make the change.

For ***nix** and **MacOS** users there is a solution – **Dnsmasq**, which replaces the need for you, to edit the hosts file for each project you work with. Dnsmasq works good together with [Træfik](https://traefik.io/) and **Docker**.

There is a known issue with [Docker for Mac](https://www.docker.com/docker-mac) – "[.localhost DNS doesn’t resolve in browsers other than Chrome](https://forums.docker.com/t/localhost-dns-doesnt-resolve-in-browsers-other-than-chrome/16300)". Users who are working on Windows and using WSL or without it, will also have problems to get wildcard domains like `my.virtual.host.docker` working. For them, there is other thread and solutions described on [superuser.com](https://superuser.com/questions/135595/using-wildcards-in-names-in-windows-hosts-file).

<br>

If you **like/use** this role, please consider **starring** it. Thanks!

<br>

## 📑 Requirements

  - **Homebrew**: Requires `homebrew` already installed (you can use `geerlingguy.mac.homebrew` to install it on your Mac).
  - **ansible.community.general** – installation handled by `Makefile`

<br>

## 🔧 Role Variables

Available variables are listed below, along with example values (see `defaults/main.yml`):

### → Structure

Add domain names that will be mapped to ip addresses. Defaults should be fine, if you are using our wayofdev/mac-provisioner playbook:

```yaml
dnsmasq_hosts:
  # Mapping some top level domains to localhost
  - {domain: docker, ip: 127.0.0.1}
  - {domain: mac, ip: 127.0.0.1}
```

<br>

## 📦 Dependencies

  - (Soft dependency) `geerlingguy.homebrew`

<br>

## 📗 Example Playbook

```yaml
---
- hosts: localhost

  vars:
    dnsmasq_hosts:
      - {domain: docker, ip: 127.0.0.1}
      - {domain: mac, ip: 127.0.0.1}

  roles:
    - geerlingguy.mac.homebrew
    - lotyp.dnsmasq
```

<br>

## ⚙️ Development

To install dependencies and start development you can check contents of our `Makefile`

**Install** depdendencies:

```bash
$ make install-deps
```

**Install** all git hooks:

```bash
$ make hooks
```

<br>

## 🧪 Testing

For local testing you can use these comands to test whole role or separate tasks:

> :warning: **Notice**: By defaut all tests are ran against your local machine!

```bash
# run all tasks
$ make test

# test that dnsmasq is serving your new domains
$ make test-dns
```

<br>

## 🤝 License

[![Licence](https://img.shields.io/github/license/wayofdev/ansible-role-dnsmasq?style=for-the-badge)](./LICENSE)

<br>

## 🙆🏼‍♂️ Author Information

This role was created in **2022** by [lotyp / wayofdev](https://github.com/wayofdev).

<br>

## 📚 Resources

* [robertdebock/ansible-role-dnsmasq](https://github.com/robertdebock/ansible-role-dnsmasq) ansible role to manage dnsmasq on Alpine, Debian, Fedora, Ubuntu...

* Also Debian/Ubuntu users can take a look at [Debops](https://galaxy.ansible.com/debops/)'s [Dnsmasq role](https://galaxy.ansible.com/debops/dnsmasq/).

* An Ansible role for managing Dnsmasq on RHEL/CentOS 7 of Fedora. [bertvv/ansible-dnsmasq](https://github.com/bertvv/ansible-dnsmasq)
