#set feed(24chasa) {
#  URL=http://www.24chasa.bg/RSS.asp
#  DATABASE=scripts/dbase/rssnews/.24chasa
#  CHANNELS=#sofia
#  POSTNEWS=1
#  POSTLIMIT=4
#  PUBLIMIT=4
#  MSGLIMIT=10
#  POSTLAYOUT=\[<upfirstchar <news>> - \002<link>\002\]
#  TRIGLAYOUT=\[\002<id>\002\] <upfirstchar <news>> - \002<link>\002
#}

#set feed(youtube) {
#  URL=http://www.youtube.com/user/TeodorBG/feed
#  DATABASE=scripts/dbase/rssnews/.youtube
#  CHANNELS=#sofia
#  POSTNEWS=1
#  POSTLIMIT=4
#  PUBLIMIT=4
#  MSGLIMIT=10
#  POSTLAYOUT=\[<upfirstchar <news>> - \002<link>\002\]
#  TRIGLAYOUT=\[\002<id>\002\] <upfirstchar <news>> - \002<link>\002
#}

set feed(G) {
  URL=https://news.google.com/rss?hl=id&gl=ID&ceid=ID:id
  DATABASE=scripts/dbase/rssnews/.google
  CHANNELS=#oops
  POSTNEWS=1
  POSTLIMIT=4
  PUBLIMIT=4
  MSGLIMIT=10
  POSTLAYOUT=0,2 <upfirstchar <news>> - 9<link> 
  TRIGLAYOUT=\[\002<id>\002\] <upfirstchar <news>> - \002<link>\002
}



## ---- End of Setup -------------------------------------------
## -------------------------------------------------------------

if {[package vcompare [info tclversion] 8.4] < 0} {
  putlog "You don't have TCL 8.4, you have to upgrade to version 8.4 or higher to use [file tail [info script]]."
  return;
}

package require http

namespace eval rss {
  variable protect 60
  variable timeout 20
  variable pubbind {!news}
  variable msgbind {news}
  variable v_major 4
  variable v_minor 5
  variable v_build 0251
  variable version $v_major.$v_minor.$v_build
  variable client "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7) Gecko/20040803 Firefox/0.9.3"
  bind PUB -|- $pubbind [namespace current]::public
  bind MSG -|- $msgbind [namespace current]::private
  bind TIME -|- {?0 * * * *} [namespace current]::check
  namespace export public private check
}

proc rss::check {args} {
  global feed
  variable client
  variable timeout
  putquick "PING :[clock seconds]" -next
  foreach id [array names feed] {
    set url "0"
    set database "0"
    set channels "0"
    set postnews "1"
    set postlimit "3"
    set publimit "3"
    set msglimit "10"
    set postlayout {\00314(\00307<publisher>\00314)\00307 <news> \00314<\00307<link>\00314>\003}
    foreach line [split $feed($id) \n] {
      regsub -all -- {/\*.*?\*/} $line {} line
      regexp -nocase -- {^\s*URL=(.+?)\s*$} $line tmp url
      regexp -nocase -- {^\s*DATABASE=(.+?)\s*$} $line tmp database
      regexp -nocase -- {^\s*CHANNELS=(.+?)\s*$} $line tmp channels
      regexp -nocase -- {^\s*POSTNEWS=(.+?)\s*$} $line tmp postnews
      regexp -nocase -- {^\s*POSTLIMIT=(.+?)\s*$} $line tmp postlimit
      regexp -nocase -- {^\s*PUBLIMIT=(.+?)\s*$} $line tmp publimit
      regexp -nocase -- {^\s*MSGLIMIT=(.+?)\s*$} $line tmp msglimit
      regexp -nocase -- {^\s*POSTLAYOUT=(.+?)\s*$} $line tmp postlayout
    }
    if {($url == 0) || ($database == 0) || ($channels == 0)} {
      putlog "RSS: Warning: Couldn't load configuration for the \[$id\] feed."
      continue
    }
    if {$postnews == 0} {
      continue
    }
    if {![file isdirectory [file dirname $database]]} {
      file mkdir [file dirname $database]
    }
    set count 0
    set data {}
    http::config -useragent $client
    catch {http::geturl $url -command "[namespace current]::check:data {$database} {$channels} {$postlimit} {$postlayout}" -timeout [expr $timeout * 1000]}
  }
}

proc rss::check:data {database channels postlimit postlayout token} {
  upvar 0 $token state
  if {![string equal -nocase $state(status) "ok"]} {
    return 0
  }
  set latestnews "iddqd"
  if {[file exists $database]} {
    set temp [open $database r+]
    set latestnews [gets $temp]
    if {[string length $latestnews] <= 1} {
      set latestnews "iddqd"
    }
    close $temp
  }
  set data [http::data $token]
  http::cleanup $token
  set publisher [publisher $data]
  set data [parse $data]
  set temp [open $database w+]
  set postlayout [join $postlayout { }]
  foreach {item} $data {
    regsub -all -- {<id>} $postlayout [lindex $item 0] output
    regsub -all -- {<publisher>} $output $publisher output
    regsub -all -- {<link>} $output [lindex $item 1] output
    regsub -all -- {<news>} $output [lindex $item 2] output
    regsub -all -- {<upfirstchar\s(.*?)>} [clean $output] {[upfirstchar "\1"]} output
    puts $temp [decode [subst $output]]
  }
  close $temp
  set count 0
  set temp [open $database r+]
  while {![eof $temp]} {
    gets $temp headline
    if {([string equal -nocase $latestnews $headline]) || ([string equal -nocase $latestnews "iddqd"]) || ($count == $postlimit)} {
      break
    }
    incr count
    msg $channels $headline
  }
  close $temp
}

proc rss::news {target id type} {
  global feed
  variable client
  variable timeout
  if {$type == 2} {
    set msgtype PRIVMSG
  } else {
    set msgtype NOTICE
  }
  set url "0"
  set publimit "3"
  set msglimit "10"
  set triglayout "\00314\[\00307<id>\00314\]\00307 <news> \00314<\00307<link>\00314>\003"
  foreach item [split $feed($id) \n] {
    regsub -all -- {/\*.*?\*/} $item {} item
    regexp -nocase -- {^\s*URL=(.+?)\s*$} $item tmp url
    regexp -nocase -- {^\s*PUBLIMIT=(.+?)\s*$} $item tmp publimit
    regexp -nocase -- {^\s*MSGLIMIT=(.+?)\s*$} $item tmp msglimit
    regexp -nocase -- {^\s*TRIGLAYOUT=(.+?)\s*$} $item tmp triglayout
  }
  if {($url == 0)} {
    putquick "$msgtype $target :Warning: Couldn't load configuration for the \[$id\] feed."
    return 0
  }
  if {$type == 1} {
    set limit $msglimit
  } elseif {$type == 2} {
    set limit $publimit
  } else {
    return 0
  }
  http::config -useragent $client
  catch {http::geturl $url -timeout [expr $timeout * 1000]} token
  if {[regexp -nocase -- {^couldn\'t\sopen\ssocket:\s+?(.*)$} $token tmp state(status)]} {
    putquick "$msgtype $target :Warning: Couldn't connect to the \[$id\] feed ($state(status))."
    return 0
  }
  upvar 0 $token state
  if {![string equal -nocase $state(status) "ok"]} {
    putquick "$msgtype $target :Warning: Couldn't connect to the \[$id\] feed (connection $state(status))."
    return 0
  }
  set data [http::data $token]
  http::cleanup $token
  set publisher [publisher $data]
  set data [parse $data]
  set count 0
  set triglayout [join $triglayout { }]
  foreach {item} $data {
    incr count
    regsub -all -- {<id>} $triglayout [lindex $item 0] output
    regsub -all -- {<publisher>} $output $publisher output
    regsub -all -- {<link>} $output [lindex $item 1] output
    regsub -all -- {<news>} $output [lindex $item 2] output
    regsub -all -- {<upfirstchar\s(.*?)>} [clean $output] {[upfirstchar "\1"]} output
    set output [decode [subst $output]]
    if {$type == 2} {
      if {[regexp -- {c} [getchanmode $target]]} {
        set output [stripcodes c $output]
      }
    }
    puthelp "$msgtype $target :$output"
    if {($count == $limit)} {
      break
    }
  }
}

proc rss::publisher {content} {
  set publisher {n/a}
  regsub -all -- {\n+|\s+|\t+} $content { } content
  regsub -all -- {([\\&])} $content {\\\1} content
  regexp -nocase -- {<title>(.+?)</title>} $content tmp publisher
  return $publisher
}

proc rss::parse {content} {
  regsub -all -- {\n+|\s+|\t+} $content { } content
  regsub -all -- {([\\&])} $content {\\\1} content
  set item 0
  set news ""
  while {[regexp -nocase -- {<item(\s[^>]*?)?>(.+?)</item>} $content -> & value]} {
    incr item
    set title {n/a}
    regexp -nocase -- {<title>(.+?)</title>} $value -> title
    regexp -nocase -- {\<\!\[CDATA\[(.*?)\]\]\>} $title -> title
    set link {n/a}
    regexp -nocase -- {<link>(.+?)</link>} $value -> link
    regexp -nocase -- {\<\!\[CDATA\[(.*?)\]\]\>} $link -> link
    regsub -nocase -- {<item.*?>.+?</item>} $content {} content
    lappend news "$item {$link} {$title}"
  }
  return [lsort -integer -unique -index 0 $news]
}

proc rss::decode {content} {
  if {![regexp -- & $content]} {
    return $content
  }
  set escapes {
    &nbsp; \x20 &quot; \x22 &amp; \x26 &apos; \x27 &ndash; \x2D &lt; \x3C &gt; \x3E &tilde; \x7E &euro; \x80 &iexcl; \xA1
    &cent; \xA2 &pound; \xA3 &curren; \xA4 &yen; \xA5 &brvbar; \xA6 &sect; \xA7 &uml; \xA8 &copy; \xA9 &ordf; \xAA &laquo; \xAB
    &not; \xAC &shy; \xAD &reg; \xAE &hibar; \xAF &deg; \xB0 &plusmn; \xB1 &sup2; \xB2 &sup3; \xB3 &acute; \xB4 &micro; \xB5
    &para; \xB6 &middot; \xB7 &cedil; \xB8 &sup1; \xB9 &ordm; \xBA &raquo; \xBB &frac14; \xBC &frac12; \xBD &frac34; \xBE &iquest; \xBF
    &Agrave; \xC0 &Aacute; \xC1 &Acirc; \xC2 &Atilde; \xC3 &Auml; \xC4 &Aring; \xC5 &AElig; \xC6 &Ccedil; \xC7 &Egrave; \xC8 &Eacute; \xC9
    &Ecirc; \xCA &Euml; \xCB &Igrave; \xCC &Iacute; \xCD &Icirc; \xCE &Iuml; \xCF &ETH; \xD0 &Ntilde; \xD1 &Ograve; \xD2 &Oacute; \xD3
    &Ocirc; \xD4 &Otilde; \xD5 &Ouml; \xD6 &times; \xD7 &Oslash; \xD8 &Ugrave; \xD9 &Uacute; \xDA &Ucirc; \xDB &Uuml; \xDC &Yacute; \xDD
    &THORN; \xDE &szlig; \xDF &agrave; \xE0 &aacute; \xE1 &acirc; \xE2 &atilde; \xE3 &auml; \xE4 &aring; \xE5 &aelig; \xE6 &ccedil; \xE7
    &egrave; \xE8 &eacute; \xE9 &ecirc; \xEA &euml; \xEB &igrave; \xEC &iacute; \xED &icirc; \xEE &iuml; \xEF &eth; \xF0 &ntilde; \xF1
    &ograve; \xF2 &oacute; \xF3 &ocirc; \xF4 &otilde; \xF5 &ouml; \xF6 &divide; \xF7 &oslash; \xF8 &ugrave; \xF9 &uacute; \xFA &ucirc; \xFB
    &uuml; \xFC &yacute; \xFD &thorn; \xFE &yuml; \xFF
  }
  set content [string map $escapes $content]
  regsub -all -- {&[a-zA-Z]+?;} [clean $content] {?} content
  regsub -all -- {&#(\d{1,3});} $content {[format %c [scan \1 %d]]} content
  return [subst $content]
}

proc rss::private {nickname hostname handle arguments} {
 global feed
 variable spam
 variable protect
  set arguments [clean $arguments]
  set spewfeed [lindex $arguments 0]
  if {![validfeed $spewfeed 1]} {
    putquick "NOTICE $nickname :Please supply a valid feed: [join [lsort -dictionary [array names feed]] ",\x20"]"
    return 0
  }
  set spewfeed [validfeed $spewfeed 2]
  if {([info exists spam(flood,$spewfeed,$hostname)])} {
    set s [expr [clock seconds] - $spam(flood,$spewfeed,$hostname)]
    if {$s < $protect} {
      putquick "NOTICE $nickname :Sorry - This trigger has recently been used. It will be unlocked in [expr $protect - $s] seconds."
      return 0
    }
  }
  set spam(flood,$spewfeed,$hostname) [clock seconds]
  news $nickname $spewfeed 1
}

proc rss::public {nickname hostname handle channel arguments} {
 global feed
 variable spam
 variable protect
  set arguments [clean $arguments]
  set spewfeed [lindex $arguments 0]
  if {![validfeed $spewfeed 1]} {
    putquick "PRIVMSG $channel :Please supply a valid feed: [join [lsort -dictionary -unique [array names feed]] ",\x20"]"
    return 0
  }
  set spewfeed [validfeed $spewfeed 2]
  if {([info exists spam(flood,$spewfeed,$channel)]) && (![isop $nickname $channel])} {
    set s [expr [clock seconds] - $spam(flood,$spewfeed,$channel)]
    if {$s < $protect} {
      putquick "PRIVMSG $channel :Sorry - This trigger has recently been used. It will be unlocked in [expr $protect - $s] seconds."
      return 0
    }
  }
  set spam(flood,$spewfeed,$channel) [clock seconds]
  set channels 0
  foreach item [split $feed($spewfeed) \n] {
    regsub -all -- {/\*.*\*/} $item {} item
    regexp -nocase -- {^\s*CHANNELS=(.+?)\s*$} $item tmp channels
  }
  if {([lsearch -exact [string tolower $channels] [string tolower $channel]] == -1) && (![string equal -nocase $channels "ALL"])} {
    putquick "PRIVMSG $channel :The \[$spewfeed\] feed is not available on this channel. ($channels)"
    return 0
  }
  news $channel $spewfeed 2
}

proc rss::msg {channels headline} {
  if {[string equal -nocase $channels "ALL"]} {
    foreach channel [channels] {
      if {[regexp -- {c} [getchanmode $channel]] && [regexp -- {\003} $headline]} {
        lappend nocolors $channel
      } else {
        lappend colors $channel
      }
    }
  } else {
    foreach channel [channels] {
      if {[lsearch -exact [string tolower $channels] [string tolower $channel]] >= 0} {
        if {[regexp -- {c} [getchanmode $channel]] && [regexp -- {\003} $headline]} {
          lappend nocolors $channel
        } else {
          lappend colors $channel
        }
      }
    }
  }
  if {[info exists nocolors]} {
    putquick "PRIVMSG [join $nocolors {,}] :[stripcodes c $headline]"
  }
  if {[info exists colors]} {
    putquick "PRIVMSG [join $colors {,}] :$headline"
  }
}

proc rss::validfeed {keyword type} {
 global feed
  foreach id [array names feed] {
    if {[string equal -nocase $id $keyword]} {
      switch -exact -- $type {
        {1} {
          return 1
        }
        {2} {
          return $id
        }
      }
    }
  }
  return 0
}

proc rss::upfirstchar {content} {
  regsub -all -- {((^|\s)([a-z]))} [clean $content] {[string toupper "\1"]} content
  return [subst $content]
}

proc rss::clean {string} {
  regsub -all -- {([\(\)\[\]\{\}\$\"\\])} $string {\\\1} string
  return $string
}

putlog "Script loaded: RSS feed parser $rss::version is loaded"
