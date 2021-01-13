#!/bin/bash

thread_arr=(1 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32)

for thread in ${thread_arr[@]};
do

rm ab_init_$thread.log
./ab -k -c $thread -n $thread http://10.176.22.211/VOD4K/Test_track11.15.mp4 >> ab_init_$thread.log

wait
echo -e "\nConcurrency level: ${thread}"
echo -n "total length(bytes): "
cat ab_init_$thread.log | grep "Document Length:" | awk '{sum += $3};END {print sum}'
echo -n "total time(ms): "
cat ab_init_$thread.log | grep "Time per request" | grep "(mean)" | awk '{sum += $4};END {print sum}'
echo -n "Complete requests: "
cat ab_init_$thread.log | grep "Complete requests:" | awk '{sum += $3};END {print sum}'
echo -n "Failed requests: "
cat ab_init_$thread.log | grep "Failed requests:" | awk '{sum += $3};END {print sum}'
#echo -e "\nTransfer rate(Kbytes/sec): "
#cat ab_init_$thread.log | grep "Transfer rate:" | awk '{print $3}'

done
