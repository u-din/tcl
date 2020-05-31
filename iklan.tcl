# Editor : udin
# Server : irc.chating.id
######################################

#	+iklan = untuk menambahkan iklan
#	!iklan = untuk melihat daftar iklan
#	!reset = menghapus daftar iklan yang tersimpan

# chan pengecualian
set chankecuali "#log"

bind pub f +iklan pub_+iklan
bind pub f !iklan pub_listiklan
bind pub o !reset ikln_pub_list
bind time - "15 *" kchi_ikln_timer
bind time - "45 *" kchi_ikln_timer

set varawal {
	"\u0003\u0032\u00bb\u0003\u0031\u0032\u00bb\u0003\u0031\u0030\u00bb\u0003\u0031\u0031\u00bb\u0003\u0031\u0034\u007c\u0003\u0031\u0031\u00ab\u0003\u0031\u0030\u00ab\u0003\u0031\u0032\u00ab\u0003\u0032\u00ab\u0003\u0031\u0034\u0003"
	"\u0003\u0031\u0032\u0021\u0003\u0036\u0021\u0003\u0034\u0021\u0003\u0037\u0021\u0003\u0038\u0021\u0003\u0031\u0031\u007c\u0003\u0038\u0021\u0003\u0037\u0021\u0003\u0034\u0021\u0003\u0036\u0021\u0003\u0031\u0032\u0021\u0003"
	"\u0003\u0030\u0037\u00b7\u0060\u0022\u00b4\u00b7\u002e\u00b8\u002c\u002e\u00b7\u00a8\u0060\u00b7\u007e\u003e\u0003"
	"\u0003\u0031\u0030\u0028\u0003\u0031\u0034\u005f\u002e\u00b7\u00b4\u0003\u0031\u0030\u00af\u0028\u0003\u0031\u0034\u005f\u002e\u00b7\u00b4\u0003\u0031\u0030\u00af\u0028\u0003\u0031\u0034\u005f\u002e\u00b7\u00b4\u0003\u0031\u0030\u00af\u0003"
}

set varakhir {
	"\u0003\u0032\u00bb\u0003\u0031\u0032\u00bb\u0003\u0031\u0030\u00bb\u0003\u0031\u0031\u00bb\u0003\u0031\u0034\u007c\u0003\u0031\u0031\u00ab\u0003\u0031\u0030\u00ab\u0003\u0031\u0032\u00ab\u0003\u0032\u00ab\u0003\u0031\u0034\u0003"
	"\u0003\u0031\u0032\u0021\u0003\u0036\u0021\u0003\u0034\u0021\u0003\u0037\u0021\u0003\u0038\u0021\u0003\u0031\u0031\u007c\u0003\u0038\u0021\u0003\u0037\u0021\u0003\u0034\u0021\u0003\u0036\u0021\u0003\u0031\u0032\u0021\u0003"
	"\u0003\u0030\u0037\u003c\u007e\u00b7\u00b4\u00a8\u00b7\u002e\u002c\u00b8\u002e\u00b7\u0060\u0022\u00b4\u00b7\u0003"
	"\u0003\u0031\u0030\u00af\u0003\u0031\u0034\u0060\u00b7\u002e\u005f\u0003\u0031\u0030\u0029\u00af\u0003\u0031\u0034\u0060\u00b7\u002e\u005f\u0003\u0031\u0030\u0029\u00af\u0003\u0031\u0034\u0060\u00b7\u002e\u005f\u0003\u0031\u0030\u0029\u0003"
}
proc kasewarna {} {
	set warna [lindex "03 04 07 14" [rand 4]]
	return $warna
}
proc pub_+iklan {nick host hand chan text} {
	set temp [open "iklan.txt" a+]
	puts $temp "$text"
	close $temp
	putserv "PRIVMSG $chan :tersimpan \002\[\002$text\002\]\002"
}
proc pub_listiklan {nick host hand chan text} {
	if {[file exists "iklan.txt"]} {
		set temp [open "iklan.txt" r]
		set data [read $temp]
		close $temp
		set newdata [split $data "\n"]
		foreach ndata $newdata {
			putserv "PRIVMSG $nick :$ndata"
		}
	} {
		puthelp "NOTICE $nick :daftar kosong"
	}
}
proc ikln_pub_list {nick host hand chan text} {
	if {[file exists "iklan.txt"]} {
		set temp [open "iklan.txt" r]
		set data [read $temp]
		close $temp
		set newdata [split $data "\n"]
		foreach ndata $newdata {
			putserv "PRIVMSG $nick :$ndata"
		}
		exec rm -rf iklan.txt
		putserv "PRIVMSG $chan :Daftar Iklan di reset"
	} {
		putserv "PRIVMSG $chan :Daftar Iklan sudah di reset"
	}
}

proc kchi_ikln_timer {min h d m y} {
	global varakhir varawal chankecuali
	set rand [rand [llength $varawal]]
	set open [lindex $varawal $rand]
	set close [lindex $varakhir $rand]
	if {[file exists "iklan.txt"]} {
		set temp [open "iklan.txt" r]
		set data [read $temp]
		close $temp
		set newdata [split $data "\n"]
		set postrandom [lindex $newdata [rand [expr [llength $newdata] -1]]]
		foreach channel [channels] {
			if {[lsearch -exact [string tolower $chankecuali] [string tolower $channel]] != -1} {
				continue
			}
			putserv "PRIVMSG $channel :$open \003[kasewarna]$postrandom\003 $close"
		}
	} {
		return 0
	}
}
putlog "iklan.tcl -: LoadeD :-"
