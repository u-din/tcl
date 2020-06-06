##########################################################################
#
# BlackSeen 1.3
# Editor : udin
# Server : irc.chating.id                     
#
##########################################################################
#
#-it`s a new type of seen
#-it has a database foreach channel.
#-tcl-ul logs where is activate.
#-now it shows how much time the user stayed on chan.
#-added a system to notify users on join, if they were searched with !seen
#-added a timer to erase old records.
#
#             To activate .chanset +blackseen 
#
#               .seen *!*@host | !seen <nick>
#
##########################################################################

#Set here the flag required to use the command ? ( -|- for everyone )

set seen(flags) "-|-"


#Set here the first char.

set seen(chars) ". ! ` -"

#Anti-Flood Protection (searches:seconds)

set seen(flood) "4:5"

#Set here 1 daca if you want the messages to be trough NOTICE or 0 if you want
#to be trough PRIVMSG chan.

set seen(how) "1"

#After how many days the records will be deleted ?

set seen(limittime) "90"

#Timer-Time for checking ( hours )

set seen(verifytime) "12"


##########################################################################
#
#                              There`s no END
#
#
##########################################################################

foreach s(char) $seen(chars) {
bind pub $seen(flags) $s(char)s recordz:seen
}
bind join - * record:join
bind join - * record:seened
bind part - * record:part
bind sign - * record:sign
bind kick - * record:kick
bind splt - * record:split
bind nick - * record:changenick
setudef flag blackseen
set dir "${username}.BlackSeen.db"
set dir1 "${username}.seenrecord.db"

if {![file exists $dir]} {
set file [open $dir w]
close $file
}

if {![file exists $dir1]} {
set file [open $dir1 w]
close $file
}


if {![info exists record:expire_running]} {
timer [expr $seen(verifytime) * 60] record:expire
set record:expire_running 1
}

proc record:join {nick host hand chan} {
global dir botnick
if {![channel get $chan blackseen]} {
return 0
}
set lin 0
set time [unixtime]
set host "*!$host"
if {[isbotnick $nick]} { return 0 }
set who "JOIN $chan $nick $host $time 0"
set file [open $dir "r"]
set database [read -nonewline $file]
close $file
set data [split $database "\n"]
foreach line $data {
set lin [expr $lin +1]
set userentry [lindex [split $line] 2]
set chanentry [lindex [split $line] 1]
if {[string equal -nocase $userentry $nick] && [string match -nocase $chanentry $chan]} { 
if {$line != ""} {
set num [expr $lin - 1]
set delete [lreplace $data $num $num]
set files [open $dir "w"]
puts $files [join $delete "\n"]
close $files
}
}
}
set file [open $dir "r"]
set data [read -nonewline $file]
close $file
if {$data == ""} {
set files [open $dir "w"]
close $files
}
set file [open $dir "a"]
puts $file "$who"
close $file
}

proc record:part {nick host hand chan arg} {
global dir botnick
if {![channel get $chan blackseen]} {
return 0
}
set lin 0
set time [unixtime]
set reason [join [lrange [split $arg] 0 end]]
if {$reason == ""} { set reason "No Reason"}
set host "*!$host"
if {[isbotnick $nick]} { return 0 }
set who "PART $chan $nick $host $time 0 $reason"
set file [open $dir "r"]
set database [read -nonewline $file]
close $file
set data [split $database "\n"]
foreach line $data {
set lin [expr $lin +1]
set userentry [lindex [split $line] 2]
set chanentry [lindex [split $line] 1]
if {[string equal -nocase $userentry $nick] && [string match -nocase $chanentry $chan]} { 
set joined [lindex [split $line] 0]
if {$joined == "JOIN"} {
set j [lindex [split $line] 4]
set who "PART $chan $nick $host $time $j $reason"
}
if {$line != ""} {
set num [expr $lin - 1]
set delete [lreplace $data $num $num]
set files [open $dir "w"]
puts $files [join $delete "\n"]
close $files
}
}
}
set file [open $dir "r"]
set data [read -nonewline $file]
close $file
if {$data == ""} {
set files [open $dir "w"]
close $files
}
set file [open $dir "a"]
puts $file "$who"
close $file
}


proc record:sign {nick host hand chan arg} {
global dir botnick
if {![channel get $chan blackseen]} {
return 0
}
set lin 0
set time [unixtime]
set host "*!$host"
set reason [join [lrange [split $arg] 0 end]]
if {$reason == ""} { set reason "No Reason"}
if {[isbotnick $nick]} { return 0 }
set who "SIGN $chan $nick $host $time 0 $reason"
set file [open $dir "r"]
set database [read -nonewline $file]
close $file
set data [split $database "\n"]
foreach line $data {
set lin [expr $lin +1]
set userentry [lindex [split $line] 2]
set chanentry [lindex [split $line] 1]
if {[string equal -nocase $userentry $nick] && [string match -nocase $chanentry $chan]} { 
set joined [lindex [split $line] 0]
if {$joined == "JOIN"} {
set j [lindex [split $line] 4]
set who "SIGN $chan $nick $host $time $j $reason"
}
if {$line != ""} {
set num [expr $lin - 1]
set delete [lreplace $data $num $num]
set files [open $dir "w"]
puts $files [join $delete "\n"]
close $files
}
}
}
set file [open $dir "r"]
set data [read -nonewline $file]
close $file
if {$data == ""} {
set files [open $dir "w"]
close $files
}
set file [open $dir "a"]
puts $file "$who"
close $file
}

proc record:kick {nick host hand chan kicked reason} {
global dir botnick
if {![channel get $chan blackseen]} {
return 0
}
set lin 0
set time [unixtime]
set hosted [getchanhost $kicked $chan]
set hosted "*!$hosted"
set reason [join [lrange [split $reason] 0 end]]
if {[isbotnick $kicked]} { return 0 }
set who "KICK $chan $kicked $hosted $time 0 $reason"
set file [open $dir "r"]
set database [read -nonewline $file]
close $file
set data [split $database "\n"]
foreach line $data {
set lin [expr $lin +1]
set userentry [lindex [split $line] 2]
set chanentry [lindex [split $line] 1]
if {[string equal -nocase $userentry $kicked] && [string match -nocase $chanentry $chan]} { 
set joined [lindex [split $line] 0]
if {$joined == "JOIN"} {
set j [lindex [split $line] 4]
set who "KICK $chan $kicked $hosted $time $j $reason"
}
if {$line != ""} {
set num [expr $lin - 1]
set delete [lreplace $data $num $num]
set files [open $dir "w"]
puts $files [join $delete "\n"]
close $files
}
}
}
set file [open $dir "r"]
set data [read -nonewline $file]
close $file
if {$data == ""} {
set files [open $dir "w"]
close $files
}
set file [open $dir "a"]
puts $file "$who"
close $file
}


proc record:split {nick host hand chan args} {
global dir botnick
if {![channel get $chan blackseen]} {
return 0
}
set lin 0
set time [unixtime]
set host "*!$host"
if {[isbotnick $nick]} { return 0 }
set who "SPLIT $chan $nick $host $time 0"
set file [open $dir "r"]
set database [read -nonewline $file]
close $file
set data [split $database "\n"]
foreach line $data {
set lin [expr $lin +1]
set userentry [lindex [split $line] 2]
set chanentry [lindex [split $line] 1]
if {[string equal -nocase $userentry $nick] && [string match -nocase $chanentry $chan]} { 
set joined [lindex [split $line] 0]
if {$joined == "JOIN"} {
set j [lindex [split $line] 4]
set who "SPLIT $chan $nick $host $time $j"
}
if {$line != ""} {
set num [expr $lin - 1]
set delete [lreplace $data $num $num]
set files [open $dir "w"]
puts $files [join $delete "\n"]
close $files
}
}
}
set file [open $dir "r"]
set data [read -nonewline $file]
close $file
if {$data == ""} {
set files [open $dir "w"]
close $files
}
set file [open $dir "a"]
puts $file "$who"
close $file
}

proc record:changenick {nick host hand chan newnick} {
global dir botnick
if {![channel get $chan blackseen]} {
return 0
}
set lin 0
set time [unixtime]
set host "*!$host"
if {[isbotnick $nick]} { return 0 }
set who "NICKCHANGE $chan $nick $host $time 0 $newnick"
set file [open $dir "r"]
set database [read -nonewline $file]
close $file
set data [split $database "\n"]
foreach line $data {
set lin [expr $lin +1]
set userentry [lindex [split $line] 2]
set chanentry [lindex [split $line] 1]
if {[string equal -nocase $userentry $nick] && [string match -nocase $chanentry $chan]} { 
if {$line != ""} {
set num [expr $lin - 1]
set delete [lreplace $data $num $num]
set files [open $dir "w"]
puts $files [join $delete "\n"]
close $files
}
}
}
set file [open $dir "r"]
set data [read -nonewline $file]
close $file
if {$data == ""} {
set files [open $dir "w"]
close $files
}
set file [open $dir "a"]
puts $file "$who"
close $file
}

proc recordz:seen {nick uhost hand chan arg} {
global dir dir1 seen count botnick
if {![channel get $chan blackseen]} {
return 0
}
set i 0
set what [lindex [split $arg] 0]
set number [scan $seen(flood) %\[^:\]]
set timer [scan $seen(flood) %*\[^:\]:%s]
foreach tmr [utimers] {
if {[string match "*count(flood:$uhost:$chan)*" [join [lindex $tmr 1]]]} {
killutimer [lindex $tmr 2]
}
}
if {![info exists count(flood:$uhost:$chan)]} { 
set count(flood:$uhost:$chan) 0 
}
incr count(flood:$uhost:$chan)
utimer $timer [list unset count(flood:$uhost:$chan)]

if {$count(flood:$uhost:$chan) == "$number"} {
puthelp "NOTICE $nick :Asteapta 1 minut inainte de a incepe cautarea."
return 0
}

if {[string match -nocase $what $nick]} { puthelp "NOTICE $nick :$nick look in the mirror :)"
return 0
}
if {[onchan $what $chan]} { puthelp "NOTICE $nick :$what is already on $chan :)"
return 0
}

set file [open $dir "r"]
set database [read -nonewline $file]
close $file
if {$database == ""} { puthelp "NOTICE $nick :I dont have any record in my database."
return 0
}
if {![string match -nocase "*!*" "$what"]} {
set time [unixtime]
set mask "$nick!$uhost"
seen:rec $what $chan $time $mask
}

set data [split $database "\n"]
foreach line $data {
set how [lindex [split $line] 0]
set userentry [lindex [split $line] 2]
set chanentry [lindex [split $line] 1]
set host [lindex [split $line] 3]
set timer [lindex [split $line] 4]
set jointime [lindex [split $line] 5]
set reason [lrange [split $line] 6 end]
set newnick [lindex [split $line] 6]
set totalyear [expr [unixtime] - $timer]
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

	if {$hours < 1} {set hourstext ""} elseif {$hours == 1} {set hourstext "$hours hour, "} {set hourstext "$hours hours, "}

	if {$mins < 1} {set minstext ""} elseif {$mins == 1} {set minstext "$mins minute"} {set minstext "$mins minutes"}

	set output $yearstext$daystext$hourstext$minstext

if {$totalyear < 60} {
set output "$totalyear seconds"
}
set staytime [expr [unixtime] - $jointime]
set stayt [expr $timer - $jointime]
if {$stayt >= 31536000} {
		set yearsfull [expr $stayt/31536000]
		set years [expr int($yearsfull)]
		set yearssub [expr 31536000*$years]
		set totalday [expr $stayt - $yearssub]
	}
	if {$stayt < 31536000} {
		set totalday $stayt
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

	if {$hours < 1} {set hourstext ""} elseif {$hours == 1} {set hourstext "$hours hour, "} {set hourstext "$hours hours, "}

	if {$mins < 1} {set minstext ""} elseif {$mins == 1} {set minstext "$mins minute"} {set minstext "$mins minutes"}

	set staytime $yearstext$daystext$hourstext$minstext

if {$stayt < 60} {
set staytime "$stayt seconds"
}
set date  [clock format $timer -format %d.%m.]
set hour  [clock format $timer -format %H:%M]
if {$jointime == "0"} { set staymsg "I dont know how much he stayed."
} else { set staymsg "after he stayed $staytime on $chan."}
if {[string equal -nocase $userentry $what] && [string match -nocase $chanentry $chan]} { 
set host [string trim $host "*!~"]
set i [expr $i +1]
if {$i < 6} {
lappend entry $userentry
}
set seenfound 1

if {[lindex [split $line] 0] == "PART"} {
set reply "[join $entry ","] ($host) left $chan about $output ($date $hour) stating: $reason, $staymsg"
}
if {[lindex [split $line] 0] == "SIGN"} {
set reply "[join $entry ","] ($host) left IRC about $output ($date $hour) stating: $reason, $staymsg"
}
if {[lindex [split $line] 0] == "JOIN"} {
if {[onchan $what $chan]} { set nowon "$what is stil here."} else { set nowon "I dont see $what on $chan" }
set reply "[join $entry ","] ($host) joined $chan about $output ($date $hour).$nowon"
}
if {[lindex [split $line] 0] == "SPLIT"} {
set reply "[join $entry ","] ($host) left in *.net *.split about $output ($date $hour), $staymsg"
}
if {[lindex [split $line] 0] == "KICK"} {
set reply "[join $entry ","] ($host) was kicked on $chan about $output ($date $hour) with the reason ($reason), $staymsg"
}
if {[lindex [split $line] 0] == "NICKCHANGE"} {
if {[onchan $newnick $chan]} { set nowon "$newnick is stil here." } else { set nowon "I dont see $newnick on $chan" }
set reply "[join $entry ","] ($host) changed his NICK in $newnick about $output ($date $hour).$nowon"
}
}
if {$what == "*!*@*"} { return 0 }
if {[string match -nocase $what $host] && [string match -nocase $chanentry $chan]} {
set host [string trim $host "*!~"]
set i [expr $i +1]
if {$i < 6} {
lappend entry $userentry
}

set seenfound 1
if {[lindex [split $line] 0] == "PART"} {
set reply "[join $entry ","] ($host) left $chan about $output ($date $hour) stating: $reason, $staymsg"
}
if {[lindex [split $line] 0] == "SIGN"} {
set reply "[join $entry ","] ($host) left IRC about $output ($date $hour) stating: $reason, $staymsg"
}
if {[lindex [split $line] 0] == "JOIN"} {
if {[onchan $userentry $chan]} { set nowon "$userentry is stil here."} else { set nowon "I dont see $userentry on $chan" }
set reply "[join $entry ","] ($host) joined $chan about $output ($date $hour).$nowon"
}
if {[lindex [split $line] 0] == "SPLIT"} {
set reply "[join $entry ","] ($host) left in *.net *.split about $output ($date $hour), $staymsg"
}
if {[lindex [split $line] 0] == "KICK"} {
set reply "[join $entry ","] ($host) was kicked on $chan about $output ($date $hour) with the reason ($reason), $staymsg"
}
if {[lindex [split $line] 0] == "NICKCHANGE"} {
if {[onchan $newnick $chan]} { set nowon "$newnick is stil here." } else { set nowon "I dont see $newnick on $chan" }
set reply "[join $entry ","] ($host) changed his NICK in $newnick about $output ($date $hour).$nowon"
}
}

}
if {[info exists reply]} {
if {$seen(how) == "1"} {
puthelp "NOTICE $nick :$reply"
} else { puthelp "PRIVMSG $chan :$reply"
}
}

if {![info exists seenfound]} {
puthelp "NOTICE $nick :I dont remember $what."
}
}

proc seen:rec {nick chan time who} {
global dir1
set lin 0
set w "$nick $chan $time $who"
if {[isbotnick $nick]} { return 0 }
set filez [open $dir1 "r"]
set databases [read -nonewline $filez]
close $filez
set datas [split $databases "\n"]
foreach line $datas {
set lin [expr $lin +1]
set userentry [lindex [split $line] 0]
set chanentry [lindex [split $line] 1]
set inculpat [lindex [split $line] 3]
if {[string equal -nocase $userentry $nick] && [string match -nocase $chanentry $chan]} { 
set w "$nick $chan $time $who"
if {![string match -nocase $inculpat $who]} {
lappend wer $inculpat $who
set w "$nick $chan $time [join $wer " , "]"
}

if {$line != ""} {
set num [expr $lin - 1]
set delete [lreplace $datas $num $num]
set files [open $dir1 "w"]
puts $files [join $delete "\n"]
close $files
}
}

}
set filez [open $dir1 "r"]
set datas [read -nonewline $filez]
close $filez
if {$datas == ""} {
set files [open $dir1 "w"]
close $files
}
set filez [open $dir1 "a"]
puts $filez "$w"
close $filez
}

proc record:seened {nick host hand chan} {
global dir1
if {![channel get $chan blackseen]} {
return 0
}
set lin 0
set filez [open $dir1 "r"]
set databases [read -nonewline $filez]
close $filez
set datas [split $databases "\n"]
foreach line $datas {
set lin [expr $lin +1]
set userentry [lindex [split $line] 0]
set chanentry [lindex [split $line] 1]
if {[string equal -nocase $userentry $nick] && [string match -nocase $chanentry $chan]} { 
set time [lindex [split $line] 2]
set date  [clock format $time -format %d.%m.]
set hour  [clock format $time -format %H:%M]
set totalyear [expr [unixtime] - $time]
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
	if {$years < 1} {set yearstext ""} elseif {$years == 1} {set yearstext "$years an, "} {set yearstext "$years ani, "}

	if {$days < 1} {set daystext ""} elseif {$days == 1} {set daystext "$days zi, "} {set daystext "$days zile, "}

	if {$hours < 1} {set hourstext ""} elseif {$hours == 1} {set hourstext "$hours ora, "} {set hourstext "$hours ore, "}

	if {$mins < 1} {set minstext ""} elseif {$mins == 1} {set minstext "$mins minut"} {set minstext "$mins minute"}

	set howmuch $yearstext$daystext$hourstext$minstext

if {$totalyear < 60} {
set howmuch "$totalyear secunde"
}

set bywho [lrange [split $line] 3 end]
puthelp "NOTICE $nick :$bywho looked for you with seen on $chan about $howmuch ($date $hour)."
if {$line != ""} {
set num [expr $lin - 1]
set delete [lreplace $datas $num $num]
set files [open $dir1 "w"]
puts $files [join $delete "\n"]
close $files
}
}
}
}

proc record:expire {} {
global dir seen
putlog "Checking informations..."
set curtime [unixtime]
set lin 0
set countlin 0
set day 86400
set file [open $dir "r"]
set database [read -nonewline $file]
close $file
set data [split $database "\n"]
foreach line $data {
set lin [expr $lin +1]
set lastseen [lindex [split $line] 4]
set limitseen [expr ($curtime - $lastseen)/$day]
if {$limitseen > $seen(limittime)} {
set countlin [expr $countlin +1]
if {$line != ""} {
set num [expr $lin - 1]
set delete [lreplace $data $num $num]
set files [open $dir "w"]
puts $files [join $delete "\n"]
close $files
}
}
}
putlog "Found $countlin expired information."
timer [expr $seen(verifytime) * 60] record:expire
return 1
}


putlog "Seen Loaded"
