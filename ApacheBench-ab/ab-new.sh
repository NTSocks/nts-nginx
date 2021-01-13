#!/bin/bash

#thread_arr=(1 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60 62 64)
thread_arr=(1 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32)

for thread in ${thread_arr[@]};
do

rm ./data/ab_init_$thread.log
./ab -k -c $thread -n $thread http://10.176.22.211/VOD4K/Test_track11.15.mp4 >> ./data/ab_init_$thread.log

wait
echo -e "\nConcurrency level: ${thread}"
echo -n "total length(bytes): "
cat ./data/ab_init_$thread.log | grep "HTML transferred:" | awk '{print $3}'
echo -n "total time(ms): "
cat ./data/ab_init_$thread.log | grep "Time taken for tests:" | awk '{print $7}'
#echo "Time per connection:"
#cat ./data/ab_init_$thread.log | grep "connect:"
echo "Connection Times (ms)"
echo "              min  mean[+/-sd] median   max"
cat ./data/ab_init_$thread.log | grep "Connect:"
cat ./data/ab_init_$thread.log | grep "Processing:"
cat ./data/ab_init_$thread.log | grep "Waiting:"
cat ./data/ab_init_$thread.log | grep "Total:"
echo -n "Complete requests: "
cat ./data/ab_init_$thread.log | grep "Complete requests:" | awk '{print $3}'
echo -n "Failed requests: "
cat ./data/ab_init_$thread.log | grep "Failed requests:" | awk '{print $3}'
#echo -e "\nTransfer rate(Kbytes/sec): "
#cat ab_init_$thread.log | grep "Transfer rate:" | awk '{print $3}'

done
