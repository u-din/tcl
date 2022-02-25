#########################################################################
proc ccodes:filter {str} {
  regsub -all -- {\003([0-9]{1,2}(,[0-9]{1,2})?)?|\017|\037|\002|\026|\006|\007} $str "" str
  return $str
}
bind RAW - PRIVMSG msgcheck
bind RAW - NOTICE msgcheck
proc msgcheck {from key arg} {
 global botnick
 set arg [split $arg]
 set nick [lindex [split $from !] 0]
 set uhost [string range $from [expr [string first "!" $from]+1] e]
 set target [lindex $arg 0]
 if {![string match *#* $target]} { set hand "*" }
 if {[string match *#* $target]} { set hand [nick2hand $nick $target] }
 set text [string range [join [lrange $arg 1 end]] 1 end]
 if {[isbotnick $nick]} {return}
 if {[string match ** $text]} {
  set text [string range [join [lrange $arg 1 end]] 0 end]
 }
 split:pub:msg $nick $uhost $hand $target $text
}
proc split:pub:msg {nick uhost hand target text} {
# if {![string match *#* $target]} {priv:msg $nick $uhost $hand $target $text}
 if {[string match *#* $target]} {pub:msg $nick $uhost $hand $target $text}
}
proc pub:msg {nick uhost hand target text} {
 long:text $nick $uhost $hand $target $text
 caps:lock $nick $uhost $hand $target $text
 no:repeat $nick $uhost $hand $target $text
 no:badword $nick $uhost $hand $target $text
 split:cmd $nick $uhost $hand $target $text
}

proc split:pub:msg {nick uhost hand target text} {
 if {[string match *#* $target]} {pub:msg $nick $uhost $hand $target $text}
}
proc pub:msg {nick uhost hand target text} {
 split:cmd $nick $uhost $hand $target $text
}
proc split:cmd {nick uhost hand chan text} {
 global botnick
 set text [ccodes:filter $text]
 set cmd [lindex $text 0]
 set cmd [string tolower $cmd]
 set string [lrange $text 1 end]
 
 if {($cmd == ".port") || ($cmd == "!port")} { pub:cekport $nick $uhost $hand $chan $text } 
 if {($cmd == ".calc") || ($cmd == "!calc")} { pub:hitung $nick $uhost $hand $chan $text } 
 if {($cmd == ".hitung") || ($cmd == "!hitung")} { pub:hitung $nick $uhost $hand $chan $text } 
 if {($cmd == ".jam") || ($cmd == "!jam") || ($cmd == ".time") || ($cmd == "!time")} { pub:time $nick $uhost $hand $chan $text } 
 if {($cmd == ".ping") || ($cmd == "!ping")} { pub:ping $nick $uhost $hand $chan $text } 
 if {($cmd == ".uptime") || ($cmd == "!uptime")} { pub:uptime $nick $uhost $hand $chan $text } 
 if {($cmd == ".s") || ($cmd == "!seen")} { pub:seen $nick $uhost $hand $chan $text } 
 if {($cmd == ".lastspoke") || ($cmd == "!lastspoke")} { pub:lastspoke $nick $uhost $hand $chan $text }
 if {($cmd == ".i") || ($cmd == "!idle")} { pub:cekidle $nick $uhost $hand $chan $text }
 if {($cmd == ".h") || ($cmd == "!host")} { pub:userhost $nick $uhost $hand $chan $text }
}


#portcheck

set portchk_setting(read) 1
proc pub:cekport {nick uhost hand chan text} {
 global portchk_setting
 set host [lindex [split $text] 1]
 set port [lindex [split $text] 2]
 if {$port == ""} {
  putquick "NOTICE $nick :Perintah :4 $portchk_setting(cmd_pub) 7<host> <port> "
  return
 }
 if {[catch {set sock [socket -async $host $port]} error]} {
  putquick "PRIVMSG $chan :15\[3POR3T15\]14 Koneksi 3 $host 14Port3 $port 4Gagal. "
 } else {
  set timerid [utimer 15 [list portchk_timeout_pub $chan $sock $host $port]]
  fileevent $sock writable [list portchk_connected_pub $chan $sock $host $port $timerid]
 }
}

proc portchk_connected {idx sock host port timerid} {
 killutimer $timerid
 set error [fconfigure $sock -error]
 if {$error != ""} {
  close $sock
  putdcc $idx "15\[4PoR4T15\]14 Koneksi ke3 $host 14Port3 $port 4Gawat \([string totitle $error]\) "
 } else {
  fileevent $sock writable {}
  fileevent $sock readable [list portchk_read $idx $sock $host $port]
  putdcc $idx "15\[3PoR3T15\]14 Koneksi ke3 $host 14Port3 $port 10Berangkat Bos"
 }
}
proc portchk_timeout {idx sock host port} {
 close $sock
 putdcc $idx "15\[5PoR5T15\]14 Koneksi ke3 $host 14Port3 $port 5Lagi Time Out Bos"
}
proc portchk_read {idx sock host port} {
 global portchk_setting
 if {$portchk_setting(read)} {
  if {[gets $sock read] == -1} {
   putdcc $idx "15\[3PoR3T15\]14 Koneksi ke3 $host 14Port3 $port 12Gagal Sudah Ditutup Bos"
   close $sock
  } else {
   putdcc $idx "$host \($port\) > $read"
  }
 } else {
  close $sock
 }
}
proc portchk_connected_pub {chan sock host port timerid} {
 killutimer $timerid
 set error [fconfigure $sock -error]
 if {$error != ""} {
  close $sock
  putquick "PRIVMSG $chan :15\[4PoR4T15\]14 Koneksi 3 $host 14Port3 $port 4Gagal."
 } else {
  fileevent $sock writable {}
  fileevent $sock readable [list portchk_read_pub $chan $sock $host $port]
  putquick "PRIVMSG $chan :15\[3PoR3T15\]14 Koneksi 3 $host 14Port3 $port 10Diterima."
 }
}
proc portchk_timeout_pub {chan sock host port} {
 close $sock
 putquick "PRIVMSG $chan :15\[5PoR5T15\]14 Koneksi 3 $host 14Port3 $port 5Lagi Time Out."
}
proc portchk_read_pub {sock} {
 global portchk_setting
 if {!$portchk_setting(read)} {
  close $sock
 } elseif {[gets $sock read] == -1} {
  putquick "PRIVMSG $chan :15\[3PoR3T15\]14 Koneksi 3 $host 14Port3 $port 12Gagal Sudah Ditutup. "
  close $sock
 }
}


#ping

bind ctcr - PING pingreply
proc pub:ping {nick uhost hand chan text} {
 pingnick $nick
 return 0
}
proc pingnick {nick} {
 putquick "PRIVMSG $nick :\001PING [expr {abs([clock clicks -milliseconds])}]\001"
}
proc pingreply {nick uhost hand dest key args} {
 set pingnum [lindex $args 0]
 set pingserver [lindex [split $::server :] 0]
 if {[regexp -- {^-?[0-9]+$} $pingnum]} {
  putquick "NOTICE $nick :15balasan,3 [expr {abs([expr [expr {abs([clock clicks -milliseconds])} - $pingnum] / 1000.000])}] 15detik, dari3 $pingserver "
 }
}


#uptime

proc pub:uptime {nick uhost hand chan arg} {
  putquick "PRIVMSG $chan :[zombieUp]"
}
proc zombieUp {} {
  set ::time(uptime) [expr [clock seconds]-$::uptime]
  set ::time(minggu) [expr $::time(uptime)/604800]
  set ::time(uptime) [expr $::time(uptime)-$::time(minggu)*604800]
  set ::time(hari) [expr $::time(uptime)/86400]
  set ::time(uptime) [expr $::time(uptime)-$::time(hari)*86400]
  set ::time(jam) [expr $::time(uptime)/3600]
  set ::time(uptime) [expr $::time(uptime)-$::time(jam)*3600]
  set ::time(menit) [expr $::time(uptime)/60]
  set ::time(uptime) [expr $::time(uptime)-$::time(menit)*60]
  set ::time(detik) $::time(uptime)
  set ::time(return) " $::time(minggu) minggu $::time(hari) hari $::time(jam) jam $::time(menit) menit $::time(detik) detik "
  return $::time(return)
}


#host

proc pub:userhost {nick uhost hand chan text} {
 set ::hostchan $chan
 set target [lindex $text 1]
 if {$target == "*"} { putquick "kick $chan $nick :Gak usah Badung ah!!" ; return }
 bind RAW - 311 user:host
 putquick "whois $target"
}
proc user:host {from key args} {
 set chan $::hostchan
 set nick [lindex [split $args] 1]
 set ident [lindex [split $args] 2]
 set host [lindex [split $args] 3]
 putquick "PRIVMSG $chan :14Host3 $nick 14: 3\($ident15@03$host\) "
 unbind RAW - 311 user:host
}


#cekidle

proc pub:cekidle {nick uhost hand chan text} {
 set ::idlechan $chan
 set text [lindex $text 1]
 bind RAW - 317 idle:cek
 putquick "whois $text :$text"
}
proc idle:cek { from key args } {
 set nick [lindex [split $args] 1]
 set chan $::idlechan
 set idletime [lindex [split $args] 2]
 set signon [lindex [split $args] 3]
 putquick "PRIVMSG $chan :3$nick 14 Idle:3 \( [duration $idletime] 14-3 SignOn: [ctime $signon]\)"
 unbind RAW - 317 idle:cek
}

putlog "==="
bind pub - .calc calc
bind pub - !calc calc
bind pub - .hitung calc
bind pub - !hitung calc
set pi 3.1415926535897932
set e 2.71828182845905
set g 9.81
proc calc {nick host handle channel arg} {
  global pi e g
  if {$arg != "" && ![string match "\[" $arg] && ![string match "\]" $arg]} { 
    putserv "PRIVMSG $channel :$nick alhasil [expr $arg]"
  } else {
    putserv "NOTICE $nick :12Caranya .hitung 1+1 --- konstanta: \$pi \$e \$g --- fungsi: abs(), acos(), asin(), atan(), atan2(), ceil(), cos(), cosh(), exp(), floor(), fmod(), hypot(), log(), log10(), pow(), round(), sin(), sinh(), sqrt(), tan(), tanh() --- \[ dan \] tidak boleh dipakai dalam expresi."
  }
}

bind pub - .jodoh Matcher
proc Matcher {nick uhost hand chan args} {
regsub -nocase -all \[{}] $args "" args
set origargs $args
set args [string tolower $args]
if {[llength $args] < 2} {
 putserv "NOTICE $nick :!04Jo04Do04h! Penggunaan .jodoh <nama cowok> <nama cewek>"
 return
}

set counter 0
set compatmarker 0
while {$counter != [string length $args]} {
 if {[string range $args $counter $counter] == "l"} {incr compatmarker 2}
 if {[string range $args $counter $counter] == "o"} {incr compatmarker 2}
 if {[string range $args $counter $counter] == "v"} {incr compatmarker 2}
 if {[string range $args $counter $counter] == "e"} {incr compatmarker 2}
 if {[string range $args $counter $counter] == "y"} {incr compatmarker 3}
 if {[string range $args $counter $counter] == "o"} {incr compatmarker 1}
 if {[string range $args $counter $counter] == "u"} {incr compatmarker 3}
 incr counter
}

set compatability 0
if {$counter > 0} {set compatability [expr 5 - ([string length $args] /2)]}
if {$counter > 2} {set compatability [expr 10 - ([string length $args] /2)]}
if {$counter > 4} {set compatability [expr 20 - ([string length $args] /2)]}
if {$counter > 6} {set compatability [expr 30 - ([string length $args] /2)]}
if {$counter > 8} {set compatability [expr 40 - ([string length $args] /2)]}
if {$counter > 10} {set compatability [expr 50 - ([string length $args] /2)]}
if {$counter > 12} {set compatability [expr 60 - ([string length $args] /2)]}
if {$counter > 14} {set compatability [expr 70 - ([string length $args] /2)]}
if {$counter > 16} {set compatability [expr 80 - ([string length $args] /2)]}
if {$counter > 18} {set compatability [expr 90 - ([string length $args] /2)]}
if {$counter > 20} {set compatability [expr 100 - ([string length $args] /2)]}
if {$counter > 22} {set compatability [expr 110 - ([string length $args] /2)]}

if {$compatability < 0} {set compatability 0}
if {$compatability > 100} {set compatability 100}
if {$compatability < 50} {
  set jodoh "boleh percaya.. boleh tidak.. tapi kemungkinan anda berdua belum jodoh. Maaf yah... :)"
} elseif {$compatability < 75} {
  set jodoh "Perlu usaha lebih giat lagi untuk melakukan pendekatan hati kalian berdua...!!"
} elseif {$compatability < 90} {
  set jodoh "awal yang bagus.. mendekati jodoh.. cuit cuit.. ayo lebih mesra lagi akh...!!"
} else {
  set jodoh "Jodoh banget nih... Nikah aja... jgn lupa undang bang udin yah...!!"
}
putserv "privmsg $chan :14Kecocokan antara03 $origargs 10sebesar04 $compatability% ($jodoh)"
return
}

bind mode - * thanksfor:mode

proc thanksfor:mode { nick host hand chan mode target } {
global botnick
if {$target == $botnick} {
   if {$mode == "+v"} { 
	   puthelp "PRIVMSG $chan :15M14akasih 15U14ntuk 15Voice14-nya $nick"
      }
	  if {$mode == "-v"} { 
	   puthelp "PRIVMSG $chan :15H14adah 15K14ok 15DeVoice14 Sih $nick"
      }
   if {$mode == "+o"} { 
	   puthelp "PRIVMSG $chan :15M14akasih 15U14ntuk 15Op14-nya $nick"
      }
	  if {$mode == "-o"} { 
	   puthelp "PRIVMSG $chan :15H14adah 15K14ok 15DeOp14 Sih $nick"
      }
	 if {$mode == "+h"} { 
	   puthelp "PRIVMSG $chan :15M14akasih 15U14ntuk 15HalfOp14-nya0 $nick"
   }
   if {$mode == "-h"} { 
	   puthelp "PRIVMSG $chan :15H14adah 15K14ok 15DeHalfOp14 Sih $nick"
      }
   if {$mode == "+vo"} { 
	   puthelp "PRIVMSG $chan :15M14akasih 15U14ntuk 15+vo14nya  $nick"
      }
	if {$mode == "-b"} { 
	   puthelp "PRIVMSG $chan :15M14akasih 15U14dah di 15un14Ban  $nick"
      }
}
}

putlog "__"
bind pub - .help pub_help
proc pub_help {nick uhost handle chan arg} {
    global botnick
    if {$arg == ""} {
      putserv "NOTICE $nick :Perintah 1 : | 12.port | 12.host  | 12.nsinfo | 12.csinfo | 12.idle <nick> | "
	  putserv "NOTICE $nick :Perintah 2 : | 12.hitung | 12.ping | 12.jam | 12.jodoh | 12.country |   "
	  putserv "NOTICE $nick :.help : Running all.tcl"
      return 0  }
}

bind dcc - country dcc_country
bind pub - !country pub_country
bind pub - .country pub_country
bind pub - .negara pub_country
bind msg - country msg_country
putlog "ketik .help di channel"
proc dcc_country {hand idx arg} {
  global country symbol
  if {[llength $arg] != 1} {
    putdcc $idx "Correct usage: .country <node>"
    putdcc $idx "      Example: .country .[lindex $symbol [rand [llength $country]]]"
    return 0
  }
  set this [lsearch -exact $symbol [string trimleft [string toupper $arg] .]]
  if {$this > -1} {
    putdcc $idx "Country name for .[string trimleft [string toupper $arg] .] is [lindex $country $this]"
    return 1
  } else {
    putdcc $idx "No country name found for .[string trimleft [string toupper $arg] .]"
    return 0
  }
}

proc pub_country {nick uhost hand channel arg} {
  global country symbol
  if {[llength $arg] != 1} {
    putserv "PRIVMSG $channel :Perintah: .country <kode>"
    putserv "PRIVMSG $channel :      Contoh: .country .[lindex $symbol [rand [llength $country]]]"
    return 0
  }
 
  set this [lsearch -exact $symbol [string trimleft [string toupper $arg] .]]
  if {$this > -1} {
    putserv "PRIVMSG $channel :15\[4COuN4tRy15\] 14Nama untuk3 [string trimleft [string toupper $arg] .] 14adalah3 [lindex $country $this]"
    return 1
  } else {
    putserv "PRIVMSG $channel :15\[4COuN4tRy15\] 14Tidak ditemukan4 [string trimleft [string toupper $arg] .]"
    return 0
  }
}

proc msg_country {nick uhost hand arg} {
  global country symbol
  if {[llength $arg] != 1} {
    putserv "NOTICE $nick :Correct usage: .country <node>"
    putserv "NOTICE $nick :      Example: .country .[lindex $symbol [rand [llength $country]]]"
    return 0
  }
  set this [lsearch -exact $symbol [string trimleft [string toupper $arg] .]]
  if {$this > -1} {
    putserv "NOTICE $nick :Country name for .[string trimleft [string toupper $arg] .] is [lindex $country $this]"
    return 1
  } else {
    putserv "NOTICE $nick :No country name found for .[string trimleft [string toupper $arg] .]"
    return 0
  }
}

set country {
 "AFGHANISTAN" "ALBANIA" "ALGERIA" "AMERICAN SAMOA"
 "ANDORRA" "ANGOLA" "ANGUILLA" "ANTARCTICA"
 "ANTIGUA AND BARBUDA" "ARGENTINA" "ARMENIA" "ARUBA"
 "AUSTRALIA" "AUSTRIA" "AZERBAIJAN" "BAHAMAS"
 "BAHRAIN" "BANGLADESH" "BARBADOS" "BELARUS"
 "BELGIUM" "BELIZE" "BENIN" "BERMUDA"
 "BHUTAN" "BOLIVIA" "BOSNIA" "BOTSWANA"
 "BOUVET ISLAND" "BRAZIL" "BRITISH INDIAN OCEAN TERRITORY" "BRUNEI DARUSSALAM"
 "BULGARIA" "BURKINA FASO" "BURUNDI" "BYELORUSSIAN SSR"
 "CAMBODIA" "CAMEROON" "CANADA" "CAP VERDE"
 "CAYMAN ISLANDS" "CENTRAL AFRICAN REPUBLIC" "CHAD" "CHILE"
 "CHINA" "CHRISTMAS ISLAND" "COCOS (KEELING) ISLANDS" "COLOMBIA"
 "COMOROS" "CONGO" "COOK ISLANDS" "COSTA RICA"
 "COTE D'IVOIRE" "CROATIA" "HRVATSKA" "CUBA"
 "CYPRUS" "CZECHOSLOVAKIA" "DENMARK" "DJIBOUTI"
 "DOMINICA" "DOMINICAN REPUBLIC" "EAST TIMOR" "ECUADOR"
 "EGYPT" "EL SALVADOR" "EQUATORIAL GUINEA" "ESTONIA"
 "ETHIOPIA" "FALKLAND ISLANDS" "MALVINAS" "FAROE ISLANDS"
 "FIJI" "FINLAND" "FRANCE" "FRENCH GUIANA"
 "FRENCH POLYNESIA" "FRENCH SOUTHERN TERRITORIES" "GABON" "GAMBIA"
 "GEORGIA" "GERMANY" "DEUTSCHLAND" "GHANA"
 "GIBRALTAR" "GREECE" "GREENLAND" "GRENADA"
 "GUADELOUPE" "GUAM" "GUATEMALA" "GUINEA"
 "GUINEA BISSAU" "GYANA" "HAITI" "HEARD AND MC DONALD ISLANDS"
 "HONDURAS" "HONG KONG" "HUNGARY" "ICELAND"
 "INDIA" "0,4INDO4,0NESIA" "IRAN" "IRAQ"
 "IRELAND" "ISRAEL" "ITALY" "JAMAICA"
 "JAPAN" "JORDAN" "KAZAKHSTAN" "KENYA"
 "KIRIBATI" "NORTH KOREA" "SOUTH KOREA" "KUWAIT"
 "KYRGYZSTAN" "LAOS" "LATVIA" "LEBANON"
 "LESOTHO" "LIBERIA" "LIBYAN ARAB JAMAHIRIYA" "LIECHTENSTEIN"
 "LITHUANIA" "LUXEMBOURG" "MACAU" "MACEDONIA"
 "MADAGASCAR" "MALAWI" "MALAYSIA" "MALDIVES"
 "MALI" "MALTA" "MARSHALL ISLANDS" "MARTINIQUE"
 "MAURITANIA" "MAURITIUS" "MEXICO" "MICRONESIA"
 "MOLDOVA" "MONACO" "MONGOLIA" "MONTSERRAT"
 "MOROCCO" "MOZAMBIQUE" "MYANMAR" "NAMIBIA"
 "NAURU" "NEPAL" "NETHERLANDS" "NETHERLANDS ANTILLES"
 "NEUTRAL ZONE" "NEW CALEDONIA" "NEW ZEALAND" "NICARAGUA"
 "NIGER" "NIGERIA" "NIUE" "NORFOLK ISLAND"
 "NORTHERN MARIANA ISLANDS" "NORWAY" "OMAN" "PAKISTAN"
 "PALAU" "PANAMA" "PAPUA NEW GUINEA" "PARAGUAY"
 "PERU" "PHILIPPINES" "PITCAIRN" "POLAND"
 "PORTUGAL" "PUERTO RICO" "QATAR" "REUNION"
 "ROMANIA" "RUSSIAN FEDERATION" "RWANDA" "SAINT KITTS AND NEVIS"
 "SAINT LUCIA" "SAINT VINCENT AND THE GRENADINES" "SAMOA" "SAN MARINO"
 "SAO TOME AND PRINCIPE" "SAUDI ARABIA" "SENEGAL" "SEYCHELLES"
 "SIERRA LEONE" "SINGAPORE" "SLOVENIA" "SOLOMON ISLANDS"
 "SOMALIA" "SOUTH AFRICA" "SPAIN" "SRI LANKA"
 "ST. HELENA" "ST. PIERRE AND MIQUELON" "SUDAN" "SURINAME"
 "SVALBARD AND JAN MAYEN ISLANDS" "SWAZILAND" "SWEDEN" "SWITZERoLAND"
 "CANTONS OF HELVETIA" "SYRIAN ARAB REPUBLIC" "TAIWAN" "TAJIKISTAN"
 "TANZANIA" "THAILAND" "TOGO" "TOKELAU"
 "TONGA" "TRINIDAD AND TOBAGO" "TUNISIA" "TURKEY"
 "TURKMENISTAN" "TURKS AND CAICOS ISLANDS" "TUVALU" "UGANDA"
 "UKRAINIAN SSR" "UNITED ARAB EMIRATES" "UNITED KINGDOM" "GREAT BRITAIN"
 "UNITED STATES OF AMERICA" "UNITED STATES MINOR OUTLYING ISLANDS" "URUGUAY"
 "SOVIET UNION" "UZBEKISTAN" "VANUATU" "VATICAN CITY STATE" "VENEZUELA"
 "VIET NAM" "VIRGIN ISLANDS (US)" "VIRGIN ISLANDS (UK)" "WALLIS AND FUTUNA ISLANDS"
 "WESTERN SAHARA" "YEMEN" "YUGOSLAVIA" "ZAIRE"
 "ZAMBIA" "ZIMBABWE" "COMMERCIAL ORGANIZATION (US)" "EDUCATIONAL INSTITUTION (US)"
 "NETWORKING ORGANIZATION (US)" "MILITARY (US)" "NON-PROFIT ORGANIZATION (US)"
 "GOVERNMENT (US)" "KOREA - DEMOCRATIC PEOPLE'S REPUBLIC OF" "KOREA - REPUBLIC OF"
 "LAO PEOPLES' DEMOCRATIC REPUBLIC" "RUSSIA" "SLOVAKIA" "CZECH"
}
set symbol {
 AF AL DZ AS AD AO AI AQ AG AR AM AW AU AT AZ BS BH BD BB BY BE
 BZ BJ BM BT BO BA BW BV BR IO BN BG BF BI BY KH CM CA CV KY CF
 TD CL CN CX CC CO KM CG CK CR CI HR HR CU CY CS DK DJ DM DO TP
 EC EG SV GQ EE ET FK FK FO FJ FI FR GF PF TF GA GM GE DE DE GH
 GI GR GL GD GP GU GT GN GW GY HT HM HN HK HU IS IN ID IR IQ IE
 IL IT JM JP JO KZ KE KI KP KR KW KG LA LV LB LS LR LY LI LT LU
 MO MK MG MW MY MV ML MT MH MQ MR MU MX FM MD MC MN MS MA MZ MM
 NA NR NP NL AN NT NC NZ NI NE NG NU NF MP NO OM PK PW PA PG PY
 PE PH PN PL PT PR QA RE RO RU RW KN LC VC WS SM ST SA SN SC SL
 SG SI SB SO ZA ES LK SH PM SD SR SJ SZ SE CH CH SY TW TJ TZ TH
 TG TK TO TT TN TR TM TC TV UG UA AE UK GB US UM UY SU UZ VU VA
 VE VN VI VG WF EH YE YU ZR ZM ZW COM EDU NET MIL ORG GOV KP KR
 LA SU SK CZ
}

set cprev "."
set fromchan "NONE"
set cctarget "NONE"
set fromchancs "NONE"
set cctargetcs "NONE"
set fromchanns "NONE"
set cctargetns "NONE"
bind pub - "${cprev}version" proc:version
bind pub - "${cprev}csinfo" proc:csinfo
bind pub - "${cprev}nsinfo" proc:nsinfo
bind ctcr - VERSION ctcr:version
bind notc - * notc:version

proc proc:version {nick uhost hand chan text} {
    global botnick fromchan cctarget
    if {[string tolower $nick] != [string tolower $botnick]} {
        set fromchan $chan
        set cctarget [lindex $text 0]
        putquick "PRIVMSG $cctarget :\001VERSION\001"
        return 1}}

proc proc:csinfo {nick uhost hand chan text} {
    global botnick fromchancs cctargetcs
    if {[string tolower $nick] != [string tolower $botnick]} {
        set fromchancs $chan
        set cctargetcs [lindex $text 0]
        putquick "cs info $cctargetcs"
        return 1
    }
}

proc proc:nsinfo {nick uhost hand chan text} {
    global botnick fromchanns cctargetns
    if {[string tolower $nick] != [string tolower $botnick]} {
        set fromchanns $chan
        set cctargetns [lindex $text 0]
        putquick "ns info $cctargetns"
        return 1
    }
}


#cek version

proc ctcr:version {nick uhost hand dest key arg} {
    global botnick fromchan cctarget
    if {($fromchan == "NONE") || ($cctarget == "NONE")} {return 0}
    if {[string tolower $nick] != [string tolower $botnick]} {
        putquick "PRIVMSG $fromchan :14(06$nick 14VERSION 15reply4!14) 1: \00314$arg\003"
        set fromchan "NONE"
        set cctarget "NONE"
        return 1
    }
}

proc notc:version {nick uhost hand text {dest ""}} {
    global botnick fromchan cctarget fromchancs cctargetcs fromchanns cctargetns
    if {$dest == ""} { set dest $botnick }
    if {($fromchan != "NONE") && ($cctarget != "NONE")} {
        if {([string tolower $nick] == [string tolower $cctarget]) && ([string match "*version*" [lindex [string tolower $text] 0]])} {
            putquick "PRIVMSG $fromchan :14(06$nick 14VERSION 15reply4!14) 1: \00314$text\003"
            set fromchan "NONE"
            set cctarget "NONE"
            return 1
        }
    }   
    if {($fromchancs != "NONE") && ($cctargetcs != "NONE")} {
        if {[string tolower $nick] == "chanserv"} {
            putquick "PRIVMSG $fromchancs :\00314$text\003"
            if {[string match "*end of info*" [zzstripcodes [string tolower $text]]]} {
                set fromchancs "NONE"
                set cctargetcs "NONE"
                return 1
            }
        }
    }
    if {($fromchanns != "NONE") && ($cctargetns != "NONE")} {
        if {[string tolower $nick] == "nickserv"} {
            putquick "PRIVMSG $fromchanns :\00314$text\003"
            if {[string match "*end of info*" [zzstripcodes [string tolower $text]]]} {
                set fromchanns "NONE"
                set cctargetns "NONE"
                return 1
            }
        }
    }
}


#version

bind ctcp - VERSION ctcppingreply

proc ctcppingreply {nick uhost hand dest key arg} {
    global botnick
    putserv "NOTICE $nick :\001VERSION Bot Premium\001"
    return 1
}

bind ctcp - FINGER ctcpfingerreply
proc ctcpfingerreply {nick uhost hand dest key arg} {
    global botnick
    putserv "NOTICE $nick :\001FINGER Bot Premium \001"
    return 1
}

proc zzstripcodes {text} {
    regsub -all -- "\003(\[0-9\]\[0-9\]?(,\[0-9\]\[0-9\]?)?)?" $text "" text
    regsub -all -- "\t" $text " " text
    set text "[string map -nocase [list \002 "" \017 "" \026 "" \037 ""] $text]"
    return $text
}

bind pub - .time timecheck
bind pub - .jam timecheck
bind RAW - 391 timereply
set servtime "halcyon.us.il.dal.net"
proc timecheck { nick uhost hand chan text } {
 global botnick servtime
 putquick "TIME $servtime"
 set ::timechan $chan
}
proc timereply { from keyword arguments } {
 set channel $::timechan
 time:output $channel $arguments
}
proc time:output { channel arguments } {
global botnick servtime
 set day [lindex [split $arguments] 2]
 if {$day == ":Monday"} { set hari "Senin" }
 if {$day == ":Tuesday"} { set hari "Selasa" }
 if {$day == ":Wednesday"} { set hari "Rabu" }
 if {$day == ":Thursday"} { set hari "Kamis" }
 if {$day == ":Friday"} { set hari "03Jum'at" }
 if {$day == ":Saturday"} { set hari "Sabtu" }
 if {$day == ":Sunday"} { set hari "04Minggu" }
 set tanggal [lindex [split $arguments] 4]
 set month [lindex [split $arguments] 3]
 if {$month == "January"} { set bulan "Januari" }
 if {$month == "February"} { set bulan "Februari" }
 if {$month == "March"} { set bulan "Maret" }
 if {$month == "April"} { set bulan "April" }
 if {$month == "May"} { set bulan "Mei" }
 if {$month == "June"} { set bulan "Juni" }
 if {$month == "July"} { set bulan "Juli" }
 if {$month == "August"} { set bulan "Agustus" }
 if {$month == "September"} { set bulan "September" }
 if {$month == "October"} { set bulan "Oktober" }
 if {$month == "November"} { set bulan "November" }
 if {$month == "December"} { set bulan "Desember" }
 set tahun [lindex [split $arguments] 5]
 set jam [lindex [split $arguments] 7]
 putquick "PRIVMSG $channel :Sekarang $hari - $tanggal $bulan $tahun - $jam WIB "
}
putlog "isfan.tcl Loaded"

