# Moxa Linux 4.4 Kernel for Products with AM335x SoC

*This branch* (4.4.285-cip63-rt36/stretch-am335x/master) is used to build linux 4.4 kernel for Moxa Products with AM335x SoC.
* [UC-2100 Series](https://github.com/Moxa-Linux/ProductList#uc-2100-series)
* [UC-3100 Series](https://github.com/Moxa-Linux/ProductList#uc-3100-series)
* [UC-5100 Series](https://github.com/Moxa-Linux/ProductList#uc-5100-series)
* [UC-8100A-ME Series](https://github.com/Moxa-Linux/ProductList#uc-8100a-me-series)
* [UC-8100 Series](https://github.com/Moxa-Linux/ProductList#uc-8100-series)
* [UC-8100-ME Series](https://github.com/Moxa-Linux/ProductList#uc-8100-me-series)

For more information of products, refer to [Moxa Products List](https://github.com/Moxa-Linux/ProductList).

## Version Tags, Branch and Kernel Sourece Table

| Tags | Branch | Kernel Sourece | State |
| ---- | ------ | -------------- | ----- |
| UC-2100_V1.11<br>UC-2100_V1.12<br>UC-3100_V1.5<br>UC-5100_V1.4<br>UC-3100_V1.6<br>UC-8100_V3.5<br>UC-8100-ME_V3.1<br>UC-8100A-ME_V1.6 | [4.4.285-cip63-rt36/stretch-am335x/master](https://github.com/Moxa-Linux/linux-4.4/tree/4.4.285-cip63-rt36/stretch-am335x/master) (*This branch*) | [linux-4.4](https://github.com/Moxa-Linux/linux-4.4/) (*This repository*) | `Latest` |
| UC-2100_V1.6<br>UC-3100_V1.2<br>UC-5100_V1.2<br>UC-8100_V3.2 | [4.4.190-cip36-rt25/stretch/master](https://github.com/Moxa-Linux/am335x-linux-4.4/tree/4.4.190-cip36-rt25/stretch/master) | [am335x-linux-4.4](https://github.com/Moxa-Linux/am335x-linux-4.4) | `Outdated` |
| UC-3100_V1.0<br>UC-3100_V1.1<br>UC-5100_V1.0<br>UC-5100_V1.1<br>UC-8100_V3.0<br>UC-8100_V3.1<br>UC-2100_V1.2<br>UC-2100_V1.3<br>UC-2100_V1.4<br>UC-2100_V1.5<br>UC-8100-ME_V3.0<br>UC-8100A-ME_V1.0<br>UC-8100A-ME_V1.1<br>UC-8100A-ME_V1.2<br>UC-8100A-ME_V1.3 | [4.4.190-cip36-rt25/stretch/master](https://github.com/Moxa-Linux/am335x-linux-4.4/tree/4.4.190-cip36-rt25/stretch/master) | [am335x-linux-4.4](https://github.com/Moxa-Linux/am335x-linux-4.4) | `Outdated` |

## Moxa Linux 4.4 Kernel Building Flow

The following steps are the building flow of kernel for Moxa Products using AM335x SoC.

### Install qemu

Install qemu related packages for the cross-build process:

```
apt-get install qemu-user-static
```

### Download Source

Get the kernel sources by `git clone`:

```
git clone https://github.com/Moxa-Linux/linux-4.4.git
```

We provide two way for user to build kernel package.

### Way One: Build Kernel Package by `docker-compose` (*recommend*)

It is done by `docker-compose` command.

```
cd linux-4.4
docker-compose up
```

`.deb` files show in `linux-4.4/artifact/` directory when the building process is done.

### Way Two: Build Kernel Package Manually

* Prepare Building Environment

  We provide [moxa-dockerfiles](https://github.com/Moxa-Linux/moxa-dockerfiles) for building environment.<br>
  You can follow steps in the repository to prepare your environment.

* Create docker container

  Kernel is compiled in the docker container.<br>
  Here is the command to create the docker container that is needed by us.

  ```
  # sudo docker run -d -it -v ${PWD}:/linux-4.4 moxa-package-builder:1.0.0 bash
  d103e6df5f719f9430056f9c23cf4e3e518d4a4f8b5b65e55889b90c258886c6
  ```

  After executing, Container ID (`d103e6df5f719f9430056f9c23cf4e3e518d4a4f8b5b65e55889b90c258886c6`) would show on terminal.

* Build kernel package

  Kernel is packed in debian package.<br>
  Here are commands to start docker container and build kernel package:

  ```
  # docker start -ia <Container ID>
  # cd /linux-4.4
  # git checkout 4.4.285-cip63-rt36/stretch-am335x/master
  # apt-get build-dep -aarmhf .
  # dpkg-buildpackage -us -uc -b -aarmhf
  # mkdir -p /linux-4.4/artifact
  # mv /*.deb /linux-4.4/artifact/.
  ```

  `.deb` files show in `linux-4.4/artifact/` directory when the building process is done.

### Upgrade kernel

You can upgrade kernel through the kernel package.<br>
Here are steps to upgrade `UC-5100` series kernel.

* Upload the kernel package

  Kernel packages can be uploaded to device by the command:

  ```
  # scp uc5100-kernel*.deb uc5100-modules*.deb moxa@192.168.3.127:/tmp
  ```

* Install the kernel packages

  Kernel packages can be installed on device by the commands:

  ```
  # cd /tmp
  # dpkg -i *.deb
  # sync
  ```
  
  **NOTE: Remember to reboot the device after install the kernel package!**
