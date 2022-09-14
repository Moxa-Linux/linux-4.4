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

The following steps are building flow of kernel for Moxa Products using LS102xA SoC.

### Prerequisites

Install `qemu` related packages for the cross-build process:

```
apt-get install qemu-user-static
```

### Download Source

Get the kernel sources by `git clone`:

```
git clone https://github.com/Moxa-Linux/linux-4.4.git
```

Switch to ls102xa branch.

```
cd linux-4.4/
git checkout 4.4.285-cip63-rt36/stretch-ls102xa/master
```

### Build Kernel Package

Two ways are provided to build kernel package.

#### Way One: Build by `docker-compose` (*recommend*)

Use `docker-compose` command.

```
cd linux-4.4
docker-compose up
```

After the building process is completed, `.deb` files is shown in `linux-4.4/artifact/` directory.

#### Way Two: Build Manually

[moxa-dockerfiles](https://github.com/Moxa-Linux/moxa-dockerfiles) is provided for building environment.
Follow steps to build the docker environment and get the kernel package.

1. Build the docker image from Dockerfile

   ```
   docker build -t moxa-package-builder:1.0.0 .
   ```

2. Create docker container

   By docker volumes, current directory is mapped to `/linux-4.4` in docker container.

   ```
   docker run -d -it -v ${PWD}:/linux-4.4 moxa-package-builder:1.0.0 bash
   ---
   d103e6df5f719f9430056f9c23cf4e3e518d4a4f8b5b65e55889b90c258886c6
   ```

   After executing the command, Container ID (`d103e6df5f719f9430056f9c23cf4e3e518d4a4f8b5b65e55889b90c258886c6`) is shown on terminal.

3. Build kernel package

   Execute commands to start and attach to docker container.
   Then, pack the kernel into debian packages in docker container.

   ```
   docker start -ia <Container ID>
   cd /linux-4.4
   apt-get build-dep -aarmhf .
   dpkg-buildpackage -us -uc -b -aarmhf
   mkdir -p /linux-4.4/artifact
   mv /*.deb /linux-4.4/artifact/.
   ```

   After the building process is completed, `.deb` files is shown in `linux-4.4/artifact/` 
   directory.

### Upgrade kernel

You can upgrade kernel through the kernel package.
Follow the steps to upgrade `UC-8410A` series kernel.

* Upload the kernel package (by `scp`)

  ```
  scp uc8410a-kernel*.deb uc8410a-modules*.deb moxa@192.168.3.127:/tmp
  ```

* Install the kernel packages

  ```
  cd /tmp
  dpkg -i *.deb
  sync
  ```
  
  **NOTE: Remember to reboot the device after install the kernel package!**
