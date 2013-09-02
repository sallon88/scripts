#bin/sh
cd /home/sallon/Downloads/goagent/local/

is_proxy_start()
{
	netstat -tunpl 2> /dev/null | grep :8000 > /dev/null 2>&1
}

proxy_start()
{
	if is_proxy_start; then
		echo "proxy already running.\n"
		exit 1
	fi
	python proxy.py > /dev/null 2>&1 &
}

proxy_stop()
{
	if [ ! is_proxy_start ]; then
		echo "proxy isn't running.\n"
		exit 1
	fi
	proxy_pid=$(netstat -tunpl 2> /dev/null | grep :8000 | awk {'print $7'} | awk -F/ {'print $1'})
	kill -9 $proxy_pid
}

case "${1-start}" in
	start)
		if proxy_start; then
			echo "proxy started.\n"
		fi
		;;

	stop)
		if proxy_stop; then
			echo "proxy stoped.\n"
		fi
		;;
esac
