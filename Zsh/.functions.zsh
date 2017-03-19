# Scp function
function scp_function() {
	local FILE
	case "$1" in
		fcass*)		FILE="chrisnys@login.samfundet.no:"
					scp "$FILE$3" "$2"	;;
		fhouse*)	FILE="coffie@192.168.35.133:"
					scp "$FILE$3" "$2"	;;
		tcass*)		FILE="chrisnys@login.samfundet.no:"
					scp "$2" "$FILE$3"	;; 
		thouse*)	FILE="coffie@192.168.35.133:"
					scp "$2" "$FILE$3"	;; 
		*)
					scp "$1" "$2"	;;
	esac
}	

	

