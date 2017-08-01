pvcreate /dev/sda3
vgextend ${vgdisplay | grep 'VG Name' | sed -e 's/\s*VG Name\s*\([0-9\-\_a-zA-Z]\+\).*/\1/'} /dev/sda3

