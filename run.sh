#!/bin/bash

# Enter repository
cd /linux-4.4

# Uncomment following part if kernel configuration is tainted
#make distclean
#git checkout debian/

# Build kernel package
apt-get build-dep -y -aarmhf .
dpkg-buildpackage -us -uc -b -aarmhf

# Check return
if [ $? -eq 0 ]; then
  echo "Successfully run kernel build."
else
  echo "Failed to run kernel build."
  exit 1
fi

# Collect artifact
mkdir -p /linux-4.4/artifact
mv /*.deb /linux-4.4/artifact/.

exit 0
