
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
	/home/spark2/nginx-nts/local/nginx/sbin/nginx -t

	kill -USR2 `cat /home/spark2/nginx-nts/local/nginx/logs/nginx.pid`
	sleep 1
	test -f /home/spark2/nginx-nts/local/nginx/logs/nginx.pid.oldbin

	kill -QUIT `cat /home/spark2/nginx-nts/local/nginx/logs/nginx.pid.oldbin`
