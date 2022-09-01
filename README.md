# Moxa Linux 4.4 Kernel for Products with LS102xA SoC

*This branch* (4.4.285-cip63-rt36/stretch-ls102xa/master) is used to build linux 4.4 kernel for Moxa Products with LS102xA SoC.
* [UC-8410A Series](https://github.com/Moxa-Linux/ProductList#uc-8410a-series)
* [UC-8540 Series](https://github.com/Moxa-Linux/ProductList#uc-8540-series)
* [UC-8580 Series](https://github.com/Moxa-Linux/ProductList#uc-8580-series)

For more information of products, refer to [Moxa Products List](https://github.com/Moxa-Linux/ProductList).

## Version Tags, Branch and Kernel Sourece Table

| Tags | Branch | Kernel Sourece | State |
| ---- | ------ | -------------- | ----- |
| UC-8410A_V4.1.2<br>UC-8540_V2.1<br>UC-8580_V2.1 | [4.4.285-cip63-rt36/stretch-ls102xa/master](https://github.com/Moxa-Linux/linux-4.4/tree/4.4.285-cip63-rt36/stretch-ls102xa/master) (*This branch*) | [linux-4.4](https://github.com/Moxa-Linux/linux-4.4/) (*This repository*) | `Latest` |
| UC-8410A_V3.2   | [4.4.201-cip39-rt26/jessie/master](https://github.com/Moxa-Linux/ls1021a-linux-4.4/tree/4.4.201-cip39-rt26/jessie/master) | [ls1021a-linux-4.4](https://github.com/Moxa-Linux/ls1021a-linux-4.4) | `Outdated` |

## Moxa Linux 4.4 Kernel Building Flow

The following steps are the building flow of kernel for Moxa Products using LS102xA SoC.

### Install qemu

Install qemu related packages for the cross-build process:

```
apt-get install qemu-user-static
```

### Download Source

Get the kernel sources by `git clone`:

```
mkdir workspace
cd workspace
git clone https://github.com/Moxa-Linux/linux-4.4.git
```

We provide two way for user to build kernel package.

### Way One (*recommend*)

It is done by `docker-compose` command.

```
cd linux-4.4
docker-compose up
```

`.deb` files show in `workspace` directory when the building process is done.

### Way Two

* Prepare Building Environment

  We provide [moxa-dockerfiles](https://github.com/Moxa-Linux/moxa-dockerfiles) for building environment.<br>
  You can follow steps in the repository to prepare your environment.

* Create docker container

  Kernel is compiled in the docker container.<br>
  Here is the command to create the docker container that is needed by us.

```
# sudo docker run -d -it -v ${PWD}:/workspace moxa-package-builder:1.0.0 bash
d103e6df5f719f9430056f9c23cf4e3e518d4a4f8b5b65e55889b90c258886c6
```

  After executing, Container ID (`d103e6df5f719f9430056f9c23cf4e3e518d4a4f8b5b65e55889b90c258886c6`) would show on terminal.

* Build kernel package

  Kernel is packed in debian package.<br>
  Here are commands to start docker container and build kernel package:

```
# docker start -ia <Container ID>
# cd /workspace/linux-4.4
# git checkout 4.4.285-cip63-rt36/stretch-ls102xa/master
# apt-get build-dep -aarmhf .
# dpkg-buildpackage -us -uc -b -aarmhf
```

`.deb` files show in `workspace` directory when the building process is done.

### Upgrade kernel

You can upgrade kernel through the kernel package.<br>
Here are steps to upgrade `UC-8410A` series kernel.

* Upload the kernel package

  Kernel packages can be uploaded to device by the command:

```
# scp uc8410a-kernel*.deb uc8410a-modules*.deb moxa@192.168.3.127:/tmp
```

* Install the kernel packages

  Kernel packages can be installed on device by the commands:

```
# cd /tmp
# dpkg -i *.deb
# sync
```

**NOTE: Remember to reboot the device after install the kernel package!**
