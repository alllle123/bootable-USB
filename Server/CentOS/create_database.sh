#!/bin/bash

sed -i 's/<user>/kvalitetsflytt.se/g' wordpress.sql
sed -i 's/<website>/kvalitetsflytt.se/g' wordpress.sql
sed -i 's/<password>/ZmY3ZjJiZmYxYzZmOWZi/g' wordpress.sql

mysql -p < wordpress.sql

