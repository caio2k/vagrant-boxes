# Vagrant Base Boxes

## Downloads

### CentOS 6 _x86\_64_

Features

* kernel 2.6.32-x
* VirtualBox Guest Additions 5.x
* ansible 2.x

Download

* Atlas Box: [caio2k/centos6](https://app.vagrantup.com/caio2k/boxes/centos6)
* Direct download: [CentOS-6.10-x86_64-v20181215.box](https://github.com/caio2k/vagrant-boxes/releases/download/v20181215/CentOS-6.10-x86_64-v20181215.box)

### CentOS 7 _x86\_64_

Features

* kernel 3.10.0-x
* VirtualBox Guest Additions 5.2.22
* ansible 2.7+

Downloads

* Atlas Box: [caio2k/centos7](https://app.vagrantup.com/caio2k/boxes/centos7)

## How to build on your own

These boxes were automatically built using [packer](http://www.packer.io) v1.3 (v0.6.0 for pre-2018 images) and the definitions in this repo.

```sh
$ packer build centos7.json
```

This repo is heavily based on the [veewee project's](https://github.com/jedi4ever/veewee) definitions for a minimal CentOS installation.
