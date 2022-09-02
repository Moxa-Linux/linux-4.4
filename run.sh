#!/bin/bash

# Enter repository
cd /linux-4.4

# Switch to am335x branch
git checkout 4.4.285-cip63-rt36/stretch-am335x/master

# Uncomment following part if kernel configuration is tainted
#make distclean
#git checkout debian/

# Build kernel package
apt-get build-dep -y -aarmhf .
dpkg-buildpackage -us -uc -b -aarmhf

# Collect artifact
mkdir -p /linux-4.4/artifact
mv /*.deb /linux-4.4/artifact.

# Check return
if [ $? -eq 0 ]; then
  echo "Successfully run kernel build."
else
  echo "Failed to run kernel build."
  exit 1
fi

exit 0
