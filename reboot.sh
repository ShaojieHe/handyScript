check_pid(){
	PID=`ps -ef |grep -v grep | grep server.py |awk '{print $2}'`
}
	check_pid
	[[ ! -z ${PID} ]] && /etc/init.d/ssr stop
	/etc/init.d/ssr start
	check_pid
	[[ ! -z ${PID} ]] && echo "restarted ssr server"
