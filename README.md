
# NTSocks-Enabled nginx and ApacheBench-tool

360 degree videos streaming demands more bandwidth and lower latency for satisfying the high quality of user experience. Thanks to the rapid development of merging 5G network, the transmission speed and bandwidth between edge client and edge cloud have been improved by orders of magnitude. This means current TCP-based transfer between gateway server and video servers within Edge Cloud can block the critical data path of 360 degree streaming. To this end, we propose high-performance NTSocks-driven 360 degree streaming over modern NTB hardware, which can dramatically decrease average/ p99 tail latency and improve QoS of 360° video streaming.

Taking 360 degree streaming transfer in Edge Cloud as a typical case, nginx is treated as media web server while ApacheBench-tool acts as edge gateway. The requests from edge client is delivered to edge gateway server via fast 5G mobile network. Then edge gateway server (ApacheBench-tool) forwards the requests to media server which stores slice files. We use ApacheBench-tool to sumulate the traffic pattern of 360 degree video streaming. Each request generally contains 20~30 video slides, which can be abstracted as one job. We benchmark 10000 jobs on the same keep-alive long connection and caculate average latency, tail latency distribution to quantify the QoS of 360 degree video transfer inside edge cloud.


To evaluate the performance gains brounght by NTSocks, we compare NTSocks-enabled 360° video streaming with TCP-based and VPP-based ones, respectively. The metrics include average and p99 job completion time, which can easily reflect the QoS. 360° video streaming is benchmarking over single and multiple keep-alive connections, respectively. The detailed decription of experimental process and results are as follows.


## System Requirements

- OS: Ubuntu 18.04.5 LTS with Linux Kernel 5.1.3-050103-lowlatency.

- Hwardware Testbed:
    - CPU: Intel(R) Xeon(R) Gold 5218 CPU @ 2.30GHz with 64 CPU cores.
    - Memory: 64GB DDR4 with 2666 MT/s speed.
    - NIC: Mellanox MT28800 ConnectX-5 RNIC with 100 Gbps capacity.
    - NTB device: Intel Corporation Sky Lake-E Non-Transparent Bridge Registers.

- Configuration DPDK NTB Environment
    - please refer to https://bobohuang_sun.coding.net/s/8da4b90c-6f5d-4afa-b66d-81f73720bee2


## NTSocks-enabled nginx

### Build

#### Build NTSocks

```sh
# build NTSocks
git clone -b feature/nts-nginx git@e.coding.net:bobohuang_sun/NTSock.git

# NTSOCK_HOME indicate the root path of NTSocks
cd $NTSOCK_HOME

./build-nts.sh $PWD
```

#### Build nts-nginx

```sh
# build nginx-nts

git clone -b develop https://e.coding.net/bobohuang_sun/nginx-nts/nginx-nts.git

cd ./nginx-nts/nts-nginx

# you can also specify other nts-nginx installation path, like '~/nginx'
./build.sh ~/nts-nginx/local/nginx
```


### Run

#### Run NTSocks

- Run ntb-proxy:
    ```sh
    cd $NTSOCK_HOME
    ./proxy.sh $PWD
    ```

- Run nts monitor:
    ```sh
    cd $NTSOCK_HOME
    ./monitor.sh $PWD
    ```


#### Run nts-nginx

- Enter nginx root path: 
    ```sh
    # cd [nts-nginx installation path], like  ~/nts-nginx/local/nginx
    cd  ~/nts-nginx/local/nginx
    ```

- Set nginx config file `conf/nginx.conf` as the following, (e.g., we take `10.176.22.211:80` as nginx server):

    ```sh
    #user  nobody;
    worker_processes  0;

    #error_log  logs/error.log;
    #error_log  logs/error.log  notice;
    error_log  logs/error.log  debug;

    #pid        logs/nginx.pid;
    daemon off;
    master_process off;

    events {
        worker_connections  1024;
    }


    http {
        include       mime.types;
        default_type  application/octet-stream;

        sendfile        on;

        keepalive_timeout  65;

        server {
            listen       10.176.22.211:80;
            server_name  10.176.22.211;

            location / {
                root   html;
                index  index.html index.htm;
            }


            # redirect server error pages to the static page /50x.html
            #
            error_page   500 502 503 504  /50x.html;
            location = /50x.html {
                root   html;
            }

        }

    }
    ```

- Copy 360° video slide files into `./html/VOD4K/` directory:
    ```sh
    mkdir -p ./html/VOD4K

    # assume Video slides files is stored in `~/nginx-nts/local/nginx/html/VOD4K`
    cp ~/nginx-nts/local/nginx/html/VOD4K/* ./html/VOD4K/
    ```

- Startup nginx daemon:

    ```sh
    # modify corresponding conf/nginx.conf, please refer to /home/ntb-server2/nginx-nts/local/nginx/conf/nginx.conf
    ./sbin/nginx
    ```


## NTSocks-enabled ApacheBench-tool

### Build

#### Build NTSocks

```sh
# build NTSocks
git clone -b feature/nts-nginx git@e.coding.net:bobohuang_sun/NTSock.git

# NTSOCK_HOME indicate the root path of NTSocks
cd $NTSOCK_HOME

./build-nts.sh $PWD
```

#### Build nts-ApacheBench-tool

```sh
# build nginx-nts

# if you have cloned, don't git clone once again.
git clone -b develop https://e.coding.net/bobohuang_sun/nginx-nts/nginx-nts.git

cd ./nginx-nts/ApacheBench-ab

make clean
make
```


### Run 

#### Run NTSocks

- Run ntb-proxy:
    ```sh
    cd $NTSOCK_HOME
    ./proxy.sh $PWD
    ```

- Run nts monitor:
    ```sh
    cd $NTSOCK_HOME
    ./monitor.sh $PWD
    ```


#### Run nts-ApacheBench-tool

```sh
# cd nginx-nts root path, e.g., `cd ~/nginx-nts`

cd ./ApacheBench-ab
# simplely verify the correctness of ApacheeBench-tool
./nts-ab-test.sh

# for single connection with specified request number
# ./ab-new.sh

# for multiple connections with specified request number 
# ab-new-mul.sh

```
