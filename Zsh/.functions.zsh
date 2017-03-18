# Scp function
function scp_function() {
	local TRANSFER
	case "$1" in
		cass*)	TRANSFER="chrisnys@login.samfundet.no:"
				scp "$TRANSFER$3" "$2"	;;
		house*) TRANSFER="coffie@192.168.35.133:"
				scp "$TRANSFER$3" "$2"	;;
		*)
			scp "$1" "$2"	;;
	esac
}	

	

