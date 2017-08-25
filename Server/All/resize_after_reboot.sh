pvresize /dev/sda2
lvextend -l +100%FREE /dev/volgrp/root
resize2fs /dev/volgrp/root
