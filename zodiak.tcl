# Editor : udin
# Server : irc.chating.id
##############################################
### Start configuring variables from here! ###
############################################## 

# Configuration settings:

# Owner
set zoowner "i" 

# Update
set zoupdate "2020"
set zoversion "20.20"

# location
set zocountry "Indonesia"
set zostate "Jakarta"

# End configuration

package require http 2.0

bind pub - .zod pub:zodiak 

proc pub:zodiak {nick host hand chan arg} { 


  set arg1 [lindex $arg 0]
  set arg2 [lindex $arg 1] 
  
  if {$arg1=="" || $arg2==""} { 
    putserv "PRIVMSG $chan :Format yg benar !zodiak <aries,taurus,gemini, cancer,leo,virgo, libra,scorpio,sagitarius, capricorn,aquarius,pisces> <umum>" 
	putserv "PRIVMSG $chan :Zodiak di update setiap minggu lhoo.."
	puthelp "PRIVMSG $chan :Catatan: Zodiak ini hanyalah permainan dan iseng belaka. Jangan dipercaya sebagai ramalan."
	return 0 
  } 
  switch [string tolower $arg1] { 
    "aries" { 
		if { $arg2=="umum" } {
			set result [getzodiakumum "https://www.fimela.com/zodiak/aries"]			
		}
		
    } "taurus" { 
		if { $arg2=="umum" } {
			set result [getzodiakumum "https://www.fimela.com/zodiak/taurus"]			
		}
		
    } "gemini" { 
		if { $arg2=="umum" } {
			set result [getzodiakumum "https://www.fimela.com/zodiak/gemini"]			
		}
		
    } "cancer" { 
		if { $arg2=="umum" } {
			set result [getzodiakumum "https://www.fimela.com/zodiak/cancer"]			
		}
		
    } "leo" { 
		if { $arg2=="umum" } {
			set result [getzodiakumum "https://www.fimela.com/zodiak/leo"]			
		}
		
    } "virgo" { 
		if { $arg2=="umum" } {
			set result [getzodiakumum "https://www.fimela.com/zodiak/virgo"]			
		}
		
    } "libra" { 
		if { $arg2=="umum" } {
			set result [getzodiakumum "https://www.fimela.com/zodiak/libra"]			
		}
		
    } "scorpio" { 
	
		if { $arg2=="umum" } {
			set result [getzodiakumum "https://www.fimela.com/zodiak/scorpio"]			
		}
       
    } "sagitarius" { 
		if { $arg2=="umum" } {
			set result [getzodiakumum "https://www.fimela.com/zodiak/sagitarius"]			
		}
		
    } "capricorn" { 
		if { $arg2=="umum" } {
			set result [getzodiakumum "https://www.fimela.com/zodiak/capricorn"]			
		}
		
    } "aquarius" { 
		if { $arg2=="umum" } {
			set result [getzodiakumum "https://www.fimela.com/zodiak/aquarius"]			
		}
		
    } "pisces" { 
		if { $arg2=="umum" } {
			set result [getzodiakumum "https://www.fimela.com/zodiak/pisces"]			
		}
		
    } default { 
    putserv "PRIVMSG $chan :Format yg benar !zodiak <aries,taurus,gemini, cancer,leo,virgo, libra,scorpio,sagitarius, capricorn,aquarius,pisces> <umum>" 
	putserv "PRIVMSG $chan :Zodiak di update setiap hari lhoo.."
	puthelp "PRIVMSG $chan :Catatan: Zodiak ini hanyalah permainan dan iseng belaka. Jangan dipercaya sebagai ramalan."
    } 
  } 
  
putserv "PRIVMSG $chan :4[string toupper $arg1]:14 $result"
  
} 

proc getzodiakumum {url} {

	set http [http::config -useragent mozilla] 
	set http [http::geturl $url -timeout [expr 1000 * 10]] 
	set html [http::data $http] 
  
	regexp {<b>Umum:</b><br /><br />(.*)<br />} $html zodiak 
	regsub -all "<b>Umum:</b>" $zodiak "" zodiak 
	regsub -all "<br />" $zodiak "" zodiak
	
	return "$zodiak" 

}

putlog "TCL Name : TCL zodiak edited by $zoowner $zocountry $zostate $zoversion $zoupdate"
