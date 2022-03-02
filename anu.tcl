# How to active:
# 1- Change "#i" to channel will echo the actions.
# 2- Access your bot via dcc and active the channel that you want to spy by:
# .chanset #channel +spy

# Notes:
# - Just a reporting channel
# - You can are spying multiple channels

setudef flag spy
set spyechochannel "#i"

bind join - * spyjoinecho
proc spyjoinecho {n u h c} {
if {[lsearch -exact [channel info $c] {+spy}] != "-1"} {
global spyechochannel
putserv "privmsg $spyechochannel :\002CHANNEL:\002 $c | $n joined channel"
}
}
bind part - * spypartecho
proc spypartecho {n u h c t} {
if {[lsearch -exact [channel info $c] {+spy}] != "-1"} {
global spyechochannel
putserv "privmsg $spyechochannel :\002CHANNEL:\002 $c | $n left channel ($t)"
}
}
bind kick - * spykickecho
proc spykickecho {n u h c w e} {
if {[lsearch -exact [channel info $c] {+spy}] != "-1"} {
global spyechochannel
putserv "privmsg $spyechochannel :\002CHANNEL:\002 $c | $w has been kicked by $n ($e)"
}
}
bind pubm - * spymsgecho
proc spymsgecho { n u h c t } {
if {[lsearch -exact [channel info $c] {+spy}] != "-1"} {
global spyechochannel
putserv "privmsg $spyechochannel :\002CHANNEL:\002 $c | $n said: $t"
}
}
bind mode - * spymodeecho
proc spymodeecho { n u h c m t } {
if {[lsearch -exact [channel info $c] {+spy}] != "-1"} {
global spyechochannel
putserv "privmsg $spyechochannel :\002CHANNEL:\002 $c | $n sets mode: $m $t"
}
}
bind nick - * spynickecho
proc spynickecho {n u h c nn} {
if {[lsearch -exact [channel info $c] {+spy}] != "-1"} {
global spyechochannel
putserv "privmsg $spyechochannel :\002CHANNEL:\002 $c | $n is now known as: $nn"
}
}
bind ctcp - action spyactionecho
proc spyactionecho {n u h d k t} {
global botnick
if {$d == $botnick} {
return 0
} elseif {[lsearch -exact [channel info $d] {+spy}] != "-1"} {
global spyechochannel
putserv "privmsg $spyechochannel :\002CHANNEL:\002 $d | ACTION: $n $t"
}
}
