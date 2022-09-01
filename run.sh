#!/bin/bash

# Enter repository
cd /workspace/linux-4.4

# Build kernel package
git checkout 4.4.285-cip63-rt36/stretch-ls102xa/master
apt-get build-dep -y -aarmhf .
dpkg-buildpackage -us -uc -b -aarmhf

# Check return
if [ $? -eq 0 ]; then
  echo "Successfully run kernel build."
else
  echo "Failed to run kernel build."
  exit 1
fi

exit 0
