# Editor : udin
# Server : irc.chating.id
###############
##[ binding ]##
###############
set vchan "#lockdown";
bind pub * .v cek_nick
bind pub * !v cek_nick
bind pub * !ver cek_nick
bind pub * versi cek_nick
bind ctcr * VERSION versi_nick
################
##[ Prosedur ]##
################

proc cek_nick {nick uhost hand chan x} {
  global vnick vchan
  set x [string toupper $x]
  if {$x == "" || [string match "#*" $x]} {
    puthelp "NOTICE $nick :Penggunaan:.v <me/nick>"
    return 0
  } elseif {$x == "ME"} {
    putserv "PRIVMSG $nick :\001VERSION\001"
    set vnick $nick
    set vchan $chan
    return 1
  } else {
    putserv "PRIVMSG $x :\001VERSION\001"
    set vnick $nick
    set vchan $chan
    return 1
  }
}

proc versi_nick {nick uhost hand dest key arg} {
  global botnick reply vnick vchan
#      set reply [string toupper $arg]
	set dengan_version {
	{pake}
	{menggunakan}
	{use}
	{dengan}
	{makek}
	{chat dengan}
	}
        set dengan_version [lindex $dengan_version [rand [llength $dengan_version]]]
      putserv "PRIVMSG $vchan :$nick $dengan_version $arg"
}

putlog "versi.tcl is LoadeD..!!"
