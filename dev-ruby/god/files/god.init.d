#!/sbin/runscript
# Copyright 2013 - Mauro Toffanin

NAME="God"

# configurable options
GOD_CONFIG_DIR="${GOD_CONFIG_DIR:-/etc/god}"
GOD_LOG_FILE="${GOD_LOG_FILE:-/var/log/god/god.log}"
GOD_LOG_LEVEL="${GOD_LOG_LEVEL:-debug}"
GOD_EXECUTABLE="${GOD_EXECUTABLE:-/usr/local/bin/god}"
GOD_PORT"${GOD_PORT}:-"
PIDFILE="${PIDFILE:-/var/run/god/god.pid}"

depend() {
	[[ -n ${GOD_PORT} ]] && need net
}

# check paths for pid / log files
checkpaths() {
	# pid files
	PIDDIR="$( dirname ${PIDFILE} )"
	[[ ! -d ${PIDDIR} ]] && checkpath -d -m 740 ${PIDDIR}

	# log files
	LOGDIR="$( dirname ${GOD_LOG_FILE} )"
	[[ ! -d ${LOGDIR} ]] && checkpath -d -m 740 ${LOGDIR}
}

# run God's self diagnostic
# note: we force stdout / stderr redirect to avoid to clutter the console
#       output, but this requires to run 'god check' in foreground troughout
#       start-stop-daemon and to stop the process afterward.
rundiagnostic() {
	ebegin "Checking for required kernel and system features"
		start-stop-daemon --q -b \
			--pidfile ${PIDFILE} \
			--wait 1000 \
			--stderr "${GOD_LOG_FILE}" \
			--stdout "${GOD_LOG_FILE}" \
			--exec "${GOD_EXECUTABLE}" \
			-- check
	eend $? "Please, check file log '${GOD_LOG_FILE}' to see why bootstrap failed"
}

checkreqs() {
	rundiagnostic || return 1
	start-stop-daemon --stop --quiet --pidfile ${PIDFILE}
}

bootstrap() {
	ebegin "Starting ${NAME}"
		start-stop-daemon --start --q \
			--pidfile ${PIDFILE} \
			--wait 1000 \
			--exec "${GOD_EXECUTABLE}" \
			-- -P "${PIDFILE}" -l "${GOD_LOG_FILE}" \-\-log-level ${GOD_LOG_LEVEL}
	eend $? "Failed to start ${NAME} - Please, check file log '${GOD_LOG_FILE}' to see why startup failed"
}

loadingtask () {
	ebegin  "  Loading task: $( basename ${1} )"
		start-stop-daemon -q -b \
			--stderr "${GOD_LOG_FILE}" \
			--stdout "${GOD_LOG_FILE}" \
			--exec "${GOD_EXECUTABLE}" \
			-- load "${1}"
	eend $? "  Failed to load task: ${1}"
}

start() {
	checkpaths
	checkreqs || return 1

	# starting God in daemon mode
	bootstrap || return 1

	# loading all the *.god tasks inside
	# the God's configuration directory
	for task in "${GOD_CONFIG_DIR}"/*.god; do
		[[ -r ${task} ]] && loadingtask ${task}
	done
}

stop() {
	ebegin "Stopping ${NAME}"
		start-stop-daemon --stop \
			--pidfile ${PIDFILE} \
			--exec "${GOD_EXECUTABLE}" \
			-- terminate
	eend $? "Failed to stop ${NAME}"
}

status() {
	ebegin "${NAME} Info"
		start-stop-daemon \
			--pidfile ${PIDFILE} \
			--exec "${GOD_EXECUTABLE}" \
			-- -V
	eend $?
	echo
	ebegin "${NAME} Status"
		start-stop-daemon \
			--pidfile ${PIDFILE} \
			--exec "${GOD_EXECUTABLE}" \
			-- status
	eend $?
}
