#This script is written to suit the hybrid7-ircd with a hybserv2 services
#find us at /server irc.chating.id

#set-nete si pass za bota
set password "AbvChanB07"
# tezi po princip sa ok, ne tryabva da se pipat...
set nsnick "NickServ"
set csnick "ChanServ"
set nsserv "NickServ!NickServ@services.chating.id"
set csserv "ChanServ!ChanServ@services.chating.id"

#ottuk nadolu ne pipai, ili ne plachi ako go razvalish :)
#end of cfgable lines

bind raw -|- NOTICE ident:NickServ

proc ident:NickServ {from keyword arg} {
 global nsnick csnick password nsserv csserv 
 set servresp [lindex $arg 1]
 set msg [lrange $arg 0 end]
 if {$from==$nsserv || $from ==$csserv} {
  if {[lindex $arg 2]=="nickname" || [lindex $arg 2]=="identification"} { 
   putquick "PRIVMSG $nsnick :IDENTIFY $password"
   putlog "Services requested IDENTIFY.."
  }
 }
}

putlog "ident.tcl loaded"
