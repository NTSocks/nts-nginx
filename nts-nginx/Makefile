
default:	build

clean:
	rm -rf Makefile objs

build:
	$(MAKE) -f objs/Makefile

install:
	$(MAKE) -f objs/Makefile install

modules:
	$(MAKE) -f objs/Makefile modules

upgrade:
	/home/ntb-server1/nginx-nts/local/nginx/sbin/nginx -t

	kill -USR2 `cat /home/ntb-server1/nginx-nts/local/nginx/logs/nginx.pid`
	sleep 1
	test -f /home/ntb-server1/nginx-nts/local/nginx/logs/nginx.pid.oldbin

	kill -QUIT `cat /home/ntb-server1/nginx-nts/local/nginx/logs/nginx.pid.oldbin`
