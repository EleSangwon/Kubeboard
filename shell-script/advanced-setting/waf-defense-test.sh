#!/bin/bash
for i in {1..400}
do
  echo "Request ${i}"
  curl --head https://www.soongsil-honey-badger.com/home
done

exit 0