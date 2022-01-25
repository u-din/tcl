######################################################################
# Adzan By JoJo
# Modifikasi otomatis oleh dono - irc.ayochat.or.id
# Initial release: 20 November 2009
# Modifikasi oleh dono: 20 April 2014
# ShareAdzan oleh wie - irc.wnet.tk - 09 September 2018
# Version 12.09.18
######################################################################
# Gunakan .chanset #channel +shareadzan
######################################################################

package require http
package require tls
::http::register https 443 tls:socket

set sharetime(format) "%A %B %d %Y -- %H:%M:%S"
set kodedaerah "308"
set namadaerah "Jakarta Pusat"

bind time - "00 03 * * *" ShareAdzan
bind pub - !adzan pub:sholat

setudef flag shareadzan

proc tls:socket args { 
	set opts [lrange $args 0 end-2] 
	set host [lindex $args end-1] 
	set port [lindex $args end] 
	::tls::socket -servername $host {*}$opts $host $port 
}

proc ShareAdzan {mins hours days months years} { 
	global kodedaerah namadaerah
	SaveAdzan $kodedaerah $namadaerah
}

proc SaveAdzan {kodedaerah namadaerah} {
global waktu waktusubuh waktudzuhur waktuashar waktumaghrib waktuisya waktutweet wsubuh wdzuhur washar wmaghrib wisya
#	set connect [::http::geturl http://jadwal-sholat.info/daily.php?id=$kodedaerah]
#	set connect [::http::geturl http://jadwalsholatimsak.com/daily.php?id=$kodedaerah]
	set connect [::http::geturl https://www.jadwalsholat.org/adzan/daily.php?id=$kodedaerah]
	set files [::http::data $connect]
#	set l [regexp -all -inline -- {.*?<tr class="table_light" align="center"><td><b>.*?</b></td><td>.*?</td><td>(.*?):(.*?)</td><td>(.*?):(.*?)</td><td>(.*?):(.*?)</td><td>(.*?):(.*?)</td><td>(.*?):(.*?)</td></tr>.*?<tr class="table_block_title"><td colspan="7">} $files]
	set l [regexp -all -inline -- {.*?<tr class="table_light" align="center"><td><b>.*?</b></td><td>.*?</td><td>(.*?):(.*?)</td><td>.*?</td><td>.*?</td><td>(.*?):(.*?)</td><td>(.*?):(.*?)</td><td>(.*?):(.*?)</td><td>(.*?):(.*?)</td></tr>.*?<tr class="table_block_title"><td colspan="9">} $files]
	   if {[llength $l] != 0} {
			foreach {black a b c d e f g h i j} $l {
			set a [string trim $a " \n"]
			set b [string trim $b " \n"]
			set c [string trim $c " \n"]
			set d [string trim $d " \n"]
			set e [string trim $e " \n"]
			set f [string trim $f " \n"]
			set g [string trim $g " \n"]
			set h [string trim $h " \n"]
			set i [string trim $i " \n"]
			set j [string trim $j " \n"]

			regsub -all {<.+?>} $a {} a	
			regsub -all {<.+?>} $b {} b
			regsub -all {<.+?>} $c {} c
			regsub -all {<.+?>} $d {} d
			regsub -all {<.+?>} $e {} e
			regsub -all {<.+?>} $f {} f
			regsub -all {<.+?>} $g {} g
			regsub -all {<.+?>} $h {} h
			regsub -all {<.+?>} $i {} i
			regsub -all {<.+?>} $j {} j
			
			putlog "Ambil Data Otomatis Dari https://www.jadwalsholat.org/"
			
			set waktusubuh "$b $a * * *"
			set wsubuh "$a:$b:00"
			bind time - "$b $a * * *" share:subuh

			set waktudzuhur "$d $c * * *"
			set wdzuhur "$c:$d:00"
			bind time - "$d $c * * *" share:dzuhur

			set waktuashar "$f $e * * *"
			set washar "$e:$f:00"
			bind time - "$f $e * * *" share:ashar

			set waktumaghrib "$h $g * * *"
			set wmaghrib "$g:$h:00"
			bind time - "$h $g * * *" share:maghrib

			set waktuisya "$j $i * * *"
			set wisya "$i:$j:00"
			bind time - "$j $i * * *" share:isya
			
		foreach chan [channels] {
		if {[channel get $chan shareadzan]} {
			replacetime
			puthelp "PRIVMSG $chan :\[Jadwal Sholat \00307$namadaerah\003 Dan Sekitarnya, $waktu\] Subuh: $wsubuh - Dzuhur: $wdzuhur - Ashar: $washar - Maghrib: $wmaghrib - Isya: $wisya"
				}
			}
		}
	}
}

proc share:subuh {nick uhost hand chan arg} {
	global waktusubuh wsubuh namadaerah
	foreach chan [channels] {
		if {[channel get $chan shareadzan]} {
			puthelp "PRIVMSG $chan :*** Waktu Tepat Menunjukan Pukul\00303 $wsubuh\003 WIB, Waktunya Untuk Melaksanakan Ibadah Sholat \00304Subuh\003 Untuk Daerah \00307$namadaerah\003 Dan Sekitarnya ***"
			catch { unbind time - "$waktusubuh" share:subuh }
		}
	}
}

proc share:dzuhur {nick uhost hand chan arg} {
	global waktudzuhur wdzuhur namadaerah
	foreach chan [channels] {
		if {[channel get $chan shareadzan]} {
			puthelp "PRIVMSG $chan :*** Waktu Tepat Menunjukan Pukul\00303 $wdzuhur\003 WIB, Waktunya Untuk Melaksanakan Ibadah Sholat \00304Dzuhur\003 Untuk Daerah \00307$namadaerah\003 Dan Sekitarnya ***"
			catch { unbind time - "$waktudzuhur" share:dzuhur }
		}
	}
}

proc share:ashar {nick uhost hand chan arg} {
	global waktuashar washar namadaerah
	foreach chan [channels] {
		if {[channel get $chan shareadzan]} {
			puthelp "PRIVMSG $chan :*** Waktu Tepat Menunjukan Pukul\00303 $washar\003 WIB, Waktunya Untuk Melaksanakan Ibadah Sholat \00304Ashar\003 Untuk Daerah \00307$namadaerah\003 Dan Sekitarnya ***"
			catch { unbind time - "$waktuashar" share:ashar }
		}
	}
}

proc share:maghrib {nick uhost hand chan arg} {
	global waktumaghrib wmaghrib namadaerah
	foreach chan [channels] {
		if {[channel get $chan shareadzan]} {
			puthelp "PRIVMSG $chan :*** Waktu Tepat Menunjukan Pukul\00303 $wmaghrib\003 WIB, Waktunya Untuk Melaksanakan Ibadah Sholat \00304Maghrib\003 Untuk Daerah \00307$namadaerah\003 Dan Sekitarnya ***"
			catch { unbind time - "$waktumaghrib" share:maghrib }
		}
	}
}
proc share:isya {nick uhost hand chan arg} {
	global waktuisya wisya namadaerah
	foreach chan [channels] {
		if {[channel get $chan shareadzan]} {
			puthelp "PRIVMSG $chan :*** Waktu Tepat Menunjukan Pukul\00303 $wisya\003 WIB, Waktunya Untuk Melaksanakan Ibadah Sholat \00304Isya\003 Untuk Daerah \00307$namadaerah\003 Dan Sekitarnya ***"
			catch { unbind time - "$waktuisya" share:isya }
		}
	}
}

proc pub:sholat {nick uhost hand chan text} {
	global snamadaerah skodedaerah otime
	set skodedaerah ""
	set snamadaerah ""
	if {[channel get $chan shareadzan]} {
	set rtime [unixtime]
	if { $rtime - $otime  > 15} {
	if {$text == ""} {
          puthelp "NOTICE $nick :Gunakan: !adzan <kotamu>"
          return 0
	 }
	 set namanih [string tolower $text]
	switch -- $namanih {
	"ambarawa" { 
	set skodedaerah "1" 
	set snamadaerah "Ambarawa"
	}
	"ambon" { 
	set skodedaerah "2" 
	set snamadaerah "Ambon" 
	}
	"amlapura" { 
	set skodedaerah "3" 
	set snamadaerah "Amlapura" 
	}
	"amuntai" { 
	set skodedaerah "4" 
	set snamadaerah "Amuntai" 
	}
	"argamakmur" { 
	set skodedaerah "5" 
	set snamadaerah "Argamakmur" 
	}
	"atambua" { 
	set skodedaerah "6" 
	set snamadaerah "Atambua" 
	}
	"babo" { 
	set skodedaerah "7" 
	set snamadaerah "Babo" 
	}
	"bagan siapiapi" { 
	set skodedaerah "8" 
	set snamadaerah "Bagan Siapiapi" 
	}
	"bajawa" { 
	set skodedaerah "9" 
	set snamadaerah "Bajawa" 
	}
	"balige" { 
	set skodedaerah "10" 
	set snamadaerah "Balige" 
	}
	"balikpapan" { 
	set skodedaerah "11" 
	set snamadaerah "Balikpapan" 
	}
	"banda aceh" { 
	set skodedaerah "12" 
	set snamadaerah "Banda Aceh" 
	}
	"bandarlampung" { 
	set skodedaerah "13" 
	set snamadaerah "Bandarlampung" 
	}
	"bandung" { 
	set skodedaerah "14" 
	set snamadaerah "Bandung" 
	}
	"bangkalan" { 
	set skodedaerah "15" 
	set snamadaerah "Bangkalan" 
	}
	"bangkinang" { 
	set skodedaerah "16" 
	set snamadaerah "Bangkinang" 
	}
	"bangko" { 
	set skodedaerah "17" 
	set snamadaerah "Bangko" 
	}
	"bangli" { 
	set skodedaerah "18" 
	set snamadaerah "Bangli" 
	}
	"banjar" { 
	set skodedaerah "19" 
	set snamadaerah "Banjar" 
	}
	"banjar baru" { 
	set skodedaerah "20" 
	set snamadaerah "Banjar Baru" 
	}
	"banjarmasin" { 
	set skodedaerah "21" 
	set snamadaerah "Banjarmasin" 
	}
	"banjarnegara" { 
	set skodedaerah "22" 
	set snamadaerah "Banjarnegara" 
	}
	"bantaeng" { 
	set skodedaerah "23" 
	set snamadaerah "Bantaeng" 
	}
	"banten" { 
	set skodedaerah "24" 
	set snamadaerah "Banten" 
	}
	"bantul" { 
	set skodedaerah "25" 
	set snamadaerah "Bantul" 
	}
	"banyuwangi" { 
	set skodedaerah "26" 
	set snamadaerah "Banyuwangi" 
	}
	"barabai" { 
	set skodedaerah "27" 
	set snamadaerah "Barabai" 
	}
	"barito" { 
	set skodedaerah "28" 
	set snamadaerah "Barito" 
	}
	"barru" { 
	set skodedaerah "29" 
	set snamadaerah "Barru" 
	}
	"batam" { 
	set skodedaerah "30" 
	set snamadaerah "Batam" 
	}
	"batang" { 
	set skodedaerah "31" 
	set snamadaerah "Batang" 
	}
	"batu" { 
	set skodedaerah "32"
    set snamadaerah "Batu" 
	}
	"baturaja" { 
	set skodedaerah "33" 
	set snamadaerah "Baturaja" 
	}
	"batusangkar" { 
	set skodedaerah "34" 
	set snamadaerah "Batusangkar" 
	}
	"baubau" { 
	set skodedaerah "35" 
	set snamadaerah "Baubau" 
	}
	"bekasi" { 
	set skodedaerah "36" 
	set snamadaerah "Bekasi" 
	}
	"bengkalis" { 
	set skodedaerah "37" 
	set snamadaerah "Bengkalis" 
	}
	"bengkulu" { 
	set skodedaerah "38" 
	set snamadaerah "Bengkulu" 
	}
	"benteng" { 
	set skodedaerah "39" 
	set snamadaerah "Benteng" 
	}
	"biak" { 
	set skodedaerah "40" 
	set snamadaerah "Biak" 
	}
	"bima" { 
	set skodedaerah "41" 
	set snamadaerah "Bima" 
	}
	"binjai" { 
	set skodedaerah "42" 
	set snamadaerah "Binjai" 
	}
	"bireuen" { 
	set skodedaerah "43" 
	set snamadaerah "Bireuen" 
	}
	"bitung" { 
	set skodedaerah "44" 
	set snamadaerah "Bitung" 
	}
	"blitar" { 
	set skodedaerah "45" 
	set snamadaerah "Blitar" 
	}
	"blora" { 
	set skodedaerah "46" 
	set snamadaerah "Blora" 
	}
	"bogor" { 
	set skodedaerah "47" 
	set snamadaerah "Bogor" 
	}
	"bojonegoro" { 
	set skodedaerah "48" 
	set snamadaerah "Bojonegoro" 
	}
	"bondowoso" { 
	set skodedaerah "49" 
	set snamadaerah "Bondowoso" 
	}
	"bontang" { 
	set skodedaerah "50" 
	set snamadaerah "Bontang" 
	}
	"boyolali" { 
	set skodedaerah "51" 
	set snamadaerah "Boyolali" 
	}
	"brebes" { 
	set skodedaerah "52" 
	set snamadaerah "Brebes" 
	}
	"bukit tinggi" { 
	set skodedaerah "53" 
	set snamadaerah "Bukit Tinggi" 
	}
	"bulukumba" { 
	set skodedaerah "54" 
	set snamadaerah "Bulukumba" 
	}
	"buntok" { 
	set skodedaerah "55" 
	set snamadaerah "Buntok" 
	}
	"cepu" { 
	set skodedaerah "56" 
	set snamadaerah "Cepu" 
	}
	"ciamis" { 
	set skodedaerah "57" 
	set snamadaerah "Ciamis" 
	}
	"cianjur" { 
	set skodedaerah "58" 
	set snamadaerah "Cianjur" 
	}
	"cibinong" { 
	set skodedaerah "59" 
	set snamadaerah "Cibinong" 
	}
	"cilacap" { 
	set skodedaerah "60" 
	set snamadaerah "Cilacap" 
	}
	"cilegon" { 
	set skodedaerah "61" 
	set snamadaerah "Cilegon" 
	}
	"cimahi" { 
	set skodedaerah "62" 
	set snamadaerah "Cimahi" 
	}
	"cirebon" { 
	set skodedaerah "63" 
	set snamadaerah "Cirebon" 
	}
	"curup" { 
	set skodedaerah "64" 
	set snamadaerah "Curup" 
	}
	"demak" { 
	set skodedaerah "65" 
	set snamadaerah "Demak" 
	}
	"denpasar" { 
	set skodedaerah "66" 
	set snamadaerah "Denpasar" 
	}
	"depok" { 
	set skodedaerah "67" 
	set snamadaerah "Depok" 
	}
	"dili" { 
	set skodedaerah "68" 
	set snamadaerah "Dili" 
	}
	"dompu" { 
	set skodedaerah "69" 
	set snamadaerah "Dompu" 
	}
	"donggala" { 
	set skodedaerah "70" 
	set snamadaerah "Donggala" 
	}
	"dumai" { 
	set skodedaerah "71" 
	set snamadaerah "Dumai" 
	}
	"ende" { 
	set skodedaerah "72" 
	set snamadaerah "Ende" 
	}
	"enggano" { 
	set skodedaerah "73" 
	set snamadaerah "Enggano" 
	}
	"enrekang" { 
	set skodedaerah "74" 
	set snamadaerah "Enrekang" 
	}
	"fakfak" { 
	set skodedaerah "75" 
	set snamadaerah "Fakfak" 
	}
	"garut" { 
	set skodedaerah "76" 
	set snamadaerah "Garut" 
	}
	"gianyar" { 
	set skodedaerah "77" 
	set snamadaerah "Gianyar" 
	}
	"gombong" { 
	set skodedaerah "78" 
	set snamadaerah "Gombong" 
	}
	"gorontalo" { 
	set skodedaerah "79" 
	set snamadaerah "Gorontalo" 
	}
	"gresik" { 
	set skodedaerah "80" 
	set snamadaerah "Gresik" 
	}
	"gunung sitoli" { 
	set skodedaerah "81" 
	set snamadaerah "Gunung Sitoli" 
	}
	"indramayu" { 
	set skodedaerah "82" 
	set snamadaerah "Indramayu" 
	}
	"jambi" { 
	set skodedaerah "83" 
	set snamadaerah "Jambi" 
	}
	"jayapura" { 
	set skodedaerah "84" 
	set snamadaerah "Jayapura" 
	}
	"jember" { 
	set skodedaerah "85" 
	set snamadaerah "Jember" 
	}
	"jeneponto" { 
	set skodedaerah "86" 
	set snamadaerah "Jeneponto" 
	}
	"jepara" { 
	set skodedaerah "87" 
	set snamadaerah "Jepara" 
	}
	"jombang" { 
	set skodedaerah "88" 
	set snamadaerah "Jombang" 
	}
	"kabanjahe" { 
	set skodedaerah "89" 
	set snamadaerah "Kabanjahe" 
	}
	"kalabahi" { 
	set skodedaerah "90" 
	set snamadaerah "Kalabahi" 
	}
	"kalianda" { 
	set skodedaerah "91" 
	set snamadaerah "Kalianda" 
	}
	"kandangan" { 
	set skodedaerah "92" 
	set snamadaerah "Kandangan" 
	}
	"karanganyar" { 
	set skodedaerah "93" 
	set snamadaerah "Karanganyar" 
	}
	"karawang" { 
	set skodedaerah "94" 
	set snamadaerah "Karawang" 
	}
	"kasungan" { 
	set skodedaerah "95" 
	set snamadaerah "Kasungan" 
	}
	"kayuagung" { 
	set skodedaerah "96" 
	set snamadaerah "Kayuagung" 
	}
	"kebumen" { 
	set skodedaerah "97" 
	set snamadaerah "Kebumen" 
	}
	"kediri" { 
	set skodedaerah "98" 
	set snamadaerah "Kediri" 
	}
	"kefamenanu" { 
	set skodedaerah "99" 
	set snamadaerah "Kefamenanu" 
	}
	"kendal" { 
	set skodedaerah "100" 
	set snamadaerah "Kendal" 
	}
	"kendari" { 
	set skodedaerah "101" 
	set snamadaerah "Kendari" 
	}
	"kertosono" { 
	set skodedaerah "102" 
	set snamadaerah "Kertosono" 
	}
	"ketapang" { 
	set skodedaerah "103" 
	set snamadaerah "Ketapang" 
	}
	"kisaran" { 
	set skodedaerah "104" 
	set snamadaerah "Kisaran" 
	}
	"klaten" { 
	set skodedaerah "105" 
	set snamadaerah "Klaten" 
	}
	"kolaka" { 
	set skodedaerah "106" 
	set snamadaerah "Kolaka" 
	}
	"kota baru pulau laut" { 
	set skodedaerah "107" 
	set snamadaerah "Kota Baru Pulau Laut" 
	}
	"kota bumi" { set skodedaerah "108" 
	set snamadaerah "Kota Bumi" }
	"kota jantho" { set skodedaerah "109" 
	set snamadaerah "Kota Jantho" }
	"kotamobagu" { set skodedaerah "110" 
	set snamadaerah "Kotamobagu" }
	"kuala kapuas" { set skodedaerah "111" 
	set snamadaerah "Kuala Kapuas" }
	"kuala kurun" { set skodedaerah "112" 
	set snamadaerah "Kuala Kurun" }
	"kuala pembuang" { set skodedaerah "113" 
	set snamadaerah "Kuala Pembuang" }
	"kuala tungkal" { set skodedaerah "114" 
	set snamadaerah "Kuala Tungkal" }
	"kudus" { set skodedaerah "115" 
	set snamadaerah "Kudus" }
	"kuningan" { set skodedaerah "116" 
	set snamadaerah "Kuningan" }
	"kupang" { set skodedaerah "117" 
	set snamadaerah "Kupang" }
	"kutacane" { set skodedaerah "118" 
	set snamadaerah "Kutacane" }
	"kutoarjo" { set skodedaerah "119" 
	set snamadaerah "Kutoarjo" }
	"labuhan" { set skodedaerah "120" 
	set snamadaerah "Labuhan" }
	"lahat" { set skodedaerah "121" 
	set snamadaerah "Lahat" }
	"lamongan" { set skodedaerah "122" 
	set snamadaerah "Lamongan" }
	"langsa" { set skodedaerah "123" 
	set snamadaerah "Langsa" }
	"larantuka" { set skodedaerah "124" 
	set snamadaerah "Larantuka" }
	"lawang" { set skodedaerah "125" 
	set snamadaerah "Lawang" }
	"lhoseumawe" { set skodedaerah "126" 
	set snamadaerah "Lhoseumawe" }
	"limboto" { set skodedaerah "127" 
	set snamadaerah "Limboto" }
	"lubuk basung" { set skodedaerah "128" 
	set snamadaerah "Lubuk Basung" }
	"lubuk linggau" { set skodedaerah "129" 
	set snamadaerah "Lubuk Linggau" }
	"lubuk pakam" { set skodedaerah "130" 
	set snamadaerah "Lubuk Pakam" }
	"lubuk sikaping" { set skodedaerah "131" 
	set snamadaerah "Lubuk Sikaping" }
	"lumajang" { set skodedaerah "132" 
	set snamadaerah "Lumajang" }
	"luwuk" { set skodedaerah "133" 
	set snamadaerah "Luwuk" }
	"madiun" { set skodedaerah "134" 
	set snamadaerah "Madiun" }
	"magelang" { set skodedaerah "135" 
	set snamadaerah "Magelang" }
	"magetan" { set skodedaerah "136" 
	set snamadaerah "Magetan" }
	"majalengka" { set skodedaerah "137" 
	set snamadaerah "Majalengka" }
	"majene" { set skodedaerah "138" 
	set snamadaerah "Majene" }
	"makale" { set skodedaerah "139" 
	set snamadaerah "Makale" }
	"makassar" { set skodedaerah "140" 
	set snamadaerah "Makassar" }
	"malang" { set skodedaerah "141" 
	set snamadaerah "Malang" }
	"mamuju" { set skodedaerah "142" 
	set snamadaerah "Mamuju" }
	"manna" { set skodedaerah "143" 
	set snamadaerah "Manna" }
	"manokwari" { set skodedaerah "144" 
	set snamadaerah "Manokwari" }
	"marabahan" { set skodedaerah "145" 
	set snamadaerah "Marabahan" }
	"maros" { set skodedaerah "146" 
	set snamadaerah "Maros" }
	"martapura kalsel" { set skodedaerah "147" 
	set snamadaerah "Martapura Kalsel" }
	"masohi" { set skodedaerah "148" 
	set snamadaerah "Masohi" }
	"mataram" { set skodedaerah "149" 
	set snamadaerah "Mataram" }
	"maumere" { set skodedaerah "150" 
	set snamadaerah "Maumere" }
	"medan" { set skodedaerah "151" 
	set snamadaerah "Medan" }
	"mempawah" { 
	set skodedaerah "152" 
	set snamadaerah "Mempawah" 
	}
	"menado" { 
	set skodedaerah "153" 
	set snamadaerah "Menado" 
	}
	"mentok" { set skodedaerah "154" 
	set snamadaerah "Mentok" }
	"merauke" { set skodedaerah "155" 
	set snamadaerah "Merauke" }
	"metro" { set skodedaerah "156" 
	set snamadaerah "Metro" }
	"meulaboh" { set skodedaerah "157" 
	set snamadaerah "Meulaboh" }
	"mojokerto" { set skodedaerah "158" 
	set snamadaerah "Mojokerto" }
	"muara bulian" { set skodedaerah "159" 
	set snamadaerah "Muara Bulian" }
	"muara bungo" { set skodedaerah "160" 
	set snamadaerah "Muara Bungo" }
	"muara enim" { set skodedaerah "161" 
	set snamadaerah "Muara Enim" }
	"muara teweh" { set skodedaerah "162" 
	set snamadaerah "Muara Teweh" }
	"muaro sijunjung" { set skodedaerah "163" 
	set snamadaerah "Muaro Sijunjung" }
	"muntilan" { set skodedaerah "164" 
	set snamadaerah "Muntilan" }
	"nabire" { set skodedaerah "165" 
	set snamadaerah "Nabire" }
	"negara" { set skodedaerah "166" 
	set snamadaerah "Negara" }
	"nganjuk" { set skodedaerah "167" 
	set snamadaerah "Nganjuk" }
	"ngawi" { set skodedaerah "168" 
	set snamadaerah "Ngawi" }
	"nunukan" { set skodedaerah "169" 
	set snamadaerah "Nunukan" }
	"pacitan" { set skodedaerah "170" 
	set snamadaerah "Pacitan" }
	"padang" { set skodedaerah "171" 
	set snamadaerah "Padang" }
	"padang panjang" { set skodedaerah "172" 
	set snamadaerah "Padang Panjang" }
	"padang sidempuan" { set skodedaerah "173" 
	set snamadaerah "Padang Sidempuan" }
	"pagaralam" { set skodedaerah "174" 
	set snamadaerah "Pagaralam" }
	"painan" { set skodedaerah "175" 
	set snamadaerah "Painan" }
	"palangkaraya" { set skodedaerah "176" 
	set snamadaerah "Palangkaraya" }
	"palembang" { set skodedaerah "177" 
	set snamadaerah "Palembang" }
	"palopo" { set skodedaerah "178" 
	set snamadaerah "Palopo" }
	"palu" { set skodedaerah "179" 
	set snamadaerah "Palu" }
	"pamekasan" { set skodedaerah "180" 
	set snamadaerah "Pamekasan" }
	"pandeglang" { set skodedaerah "181" 
	set snamadaerah "Pandeglang" }
	"pangka_" { set skodedaerah "182" 
	set snamadaerah "Pangka_" }
	"pangkajene sidenreng" { set skodedaerah "183" 
	set snamadaerah "Pangkajene Sidenreng" }
	"pangkalan bun" { set skodedaerah "184" 
	set snamadaerah "Pangkalan Bun" }
	"pangkalpinang" { set skodedaerah "185" 
	set snamadaerah "Pangkalpinang" }
	"panyabungan" { set skodedaerah "186" 
	set snamadaerah "Panyabungan" }
	"par_" { set skodedaerah "187" 
	set snamadaerah "Par_" }
	"parepare" { set skodedaerah "188" 
	set snamadaerah "Parepare" }
	"pariaman" { set skodedaerah "189" 
	set snamadaerah "Pariaman" }
	"pasuruan" { set skodedaerah "190" 
	set snamadaerah "Pasuruan" }
	"pati" { set skodedaerah "191" 
	set snamadaerah "Pati" }
	"payakumbuh" { set skodedaerah "192" 
	set snamadaerah "Payakumbuh" }
	"pekalongan" { set skodedaerah "193" 
	set snamadaerah "Pekalongan" }
	"pekan baru" { set skodedaerah "194" 
	set snamadaerah "Pekan Baru" }
	"pemalang" { set skodedaerah "195" 
	set snamadaerah "Pemalang" }
	"pematang siantar" { 
	set skodedaerah "196" 
	set snamadaerah "Pematang Siantar" 
	}
	"pendopo" { set skodedaerah "197" 
	set snamadaerah "Pendopo" }
	"pinrang" { set skodedaerah "198" 
	set snamadaerah "Pinrang" }
	"pleihari" { set skodedaerah "199" 
	set snamadaerah "Pleihari" }
	"polewali" { set skodedaerah "200" 
	set snamadaerah "Polewali" }
	"pondok gede" { set skodedaerah "201" 
	set snamadaerah "Pondok Gede" }
	"ponorogo" { set skodedaerah "202" 
	set snamadaerah "Ponorogo" }
	"pontianak" { set skodedaerah "203" 
	set snamadaerah "Pontianak" }
	"poso" { 
	set skodedaerah "204" 
	set snamadaerah "Poso" 
	}
	"prabumulih" { 
	set skodedaerah "205" 
	set snamadaerah "Prabumulih" 
	}
	"praya" { 
	set skodedaerah "2" 
	set snamadaerah "Praya" 
	}
	"probolinggo" { 
	set skodedaerah "207" 
	set snamadaerah "Probolinggo" 
	}
	"purbalingga" { set skodedaerah "208" 
	set snamadaerah "Purbalingga" }
	"purukcahu" { set skodedaerah "209" 
	set snamadaerah "Purukcahu" }
	"purwakarta" { set skodedaerah "210" 
	set snamadaerah "Purwakarta" }
	"purwodadigrobogan" { set skodedaerah "211" 
	set snamadaerah "Purwodadigrobogan" }
	"purwokerto" { set skodedaerah "212" 
	set snamadaerah "Purwokerto" }
	"purworejo" { set skodedaerah "213" 
	set snamadaerah "Purworejo" }
	"putussibau" { set skodedaerah "214" 
	set snamadaerah "Putussibau" }
	"raha" { set skodedaerah "215" 
	set snamadaerah "Raha" }
	"rangkasbitung" { set skodedaerah "216" 
	set snamadaerah "Rangkasbitung" }
	"rantau" { set skodedaerah "217" 
	set snamadaerah "Rantau" }
	"rantauprapat" { set skodedaerah "218" 
	set snamadaerah "Rantauprapat" }
	"rantepao" { set skodedaerah "219" 
	set snamadaerah "Rantepao" }
	"rembang" { set skodedaerah "220" 
	set snamadaerah "Rembang" }
	"rengat" { set skodedaerah "221" 
	set snamadaerah "Rengat" }
	"ruteng" { set skodedaerah "222" 
	set snamadaerah "Ruteng" }
	"sabang" { set skodedaerah "223" 
	set snamadaerah "Sabang" }
	"salatiga" { set skodedaerah "224" 
	set snamadaerah "Salatiga" }
	"samarinda" { set skodedaerah "225" 
	set snamadaerah "Samarinda" }
	"sambas, kalbar" { set skodedaerah "313" 
	set snamadaerah "Sambas, Kalbar" }
	"sampang" { set skodedaerah "226" 
	set snamadaerah "Sampang" }
	"sampit" { set skodedaerah "227" 
	set snamadaerah "Sampit" }
	"sanggau" { set skodedaerah "228" 
	set snamadaerah "Sanggau" }
	"sawahlunto" { set skodedaerah "229" 
	set snamadaerah "Sawahlunto" }
	"sekayu" { set skodedaerah "230" 
	set snamadaerah "Sekayu" }
	"selong" { set skodedaerah "231" 
	set snamadaerah "Selong" }
	"semarang" { set skodedaerah "232" 
	set snamadaerah "Semarang" }
	"sengkang" { set skodedaerah "233" 
	set snamadaerah "Sengkang" }
	"serang" { set skodedaerah "234" 
	set snamadaerah "Serang" }
	"serui" { set skodedaerah "235" 
	set snamadaerah "Serui" }
	"sibolga" { set skodedaerah "236" 
	set snamadaerah "Sibolga" }
	"sidikalang" { set skodedaerah "237" 
	set snamadaerah "Sidikalang" }
	"sidoarjo" { set skodedaerah "238" 
	set snamadaerah "Sidoarjo" }
	"sigli" { set skodedaerah "239" 
	set snamadaerah "Sigli" }
	"singaparna" { set skodedaerah "240" 
	set snamadaerah "Singaparna" }
	"singaraja" { set skodedaerah "241" 
	set snamadaerah "Singaraja" }
	"singkawang" { set skodedaerah "242" 
	set snamadaerah "Singkawang" }
	"sinjai" { set skodedaerah "243" 
	set snamadaerah "Sinjai" }
	"sintang" { set skodedaerah "244" 
	set snamadaerah "Sintang" }
	"situbondo" { set skodedaerah "245" 
	set snamadaerah "Situbondo" }
	"slawi" { set skodedaerah "246" 
	set snamadaerah "Slawi" }
	"sleman" { set skodedaerah "247" 
	set snamadaerah "Sleman" }
	"soasiu" { set skodedaerah "248" 
	set snamadaerah "Soasiu" }
	"soe" { set skodedaerah "249" 
	set snamadaerah "Soe" }
	"solo" { set skodedaerah "250" 
	set snamadaerah "Solo" }
	"solok" { set skodedaerah "251" 
	set snamadaerah "Solok" }
	"soreang" { set skodedaerah "252" 
	set snamadaerah "Soreang" }
	"sorong" { set skodedaerah "253" 
	set snamadaerah "Sorong" }
	"sragen" { set skodedaerah "254" 
	set snamadaerah "Sragen" }
	"stabat" { set skodedaerah "255" 
	set snamadaerah "Stabat" }
	"subang" { set skodedaerah "256" 
	set snamadaerah "Subang" }
	"sukabumi" { set skodedaerah "257" 
	set snamadaerah "Sukabumi" }
	"sukoharjo" { set skodedaerah "258" 
	set snamadaerah "Sukoharjo" }
	"sumbawa besar" { set skodedaerah "259" 
	set snamadaerah "Sumbawa Besar" }
	"sumedang" { set skodedaerah "260" 
	set snamadaerah "Sumedang" }
	"sumenep" { set skodedaerah "261" 
	set snamadaerah "Sumenep" }
	"sungai liat" { set skodedaerah "262" 
	set snamadaerah "Sungai Liat" }
	"sungai penuh" { set skodedaerah "263" 
	set snamadaerah "Sungai Penuh" }
	"sungguminasa" { set skodedaerah "264" 
	set snamadaerah "Sungguminasa" }
	"surabaya" { set skodedaerah "265" 
	set snamadaerah "Surabaya" }
	"surakarta" { set skodedaerah "266" 
	set snamadaerah "Surakarta" }
	"tabanan" { set skodedaerah "267" 
	set snamadaerah "Tabanan" }
	"tahuna" { set skodedaerah "268" 
	set snamadaerah "Tahuna" }
	"takalar" { set skodedaerah "269" 
	set snamadaerah "Takalar" }
	"takengon" { set skodedaerah "270" 
	set snamadaerah "Takengon" }
	"tamiang layang" { set skodedaerah "271" 
	set snamadaerah "Tamiang Layang" }
	"tanah grogot" { set skodedaerah "272" 
	set snamadaerah "Tanah Grogot" }
	"tangerang" { set skodedaerah "273" 
	set snamadaerah "Tangerang" }
	"tanjung balai" { set skodedaerah "274" 
	set snamadaerah "Tanjung Balai" }
	"tanjung enim" { set skodedaerah "275" 
	set snamadaerah "Tanjung Enim" }
	"tanjung pandan" { set skodedaerah "276" 
	set snamadaerah "Tanjung Pandan" }
	"tanjung pinang" { set skodedaerah "277" 
	set snamadaerah "Tanjung Pinang" }
	"tanjung redep" { set skodedaerah "278" 
	set snamadaerah "Tanjung Redep" }
	"tanjung selor" { set skodedaerah "279" 
	set snamadaerah "Tanjung Selor" }
	"tapak tuan" { set skodedaerah "280" 
	set snamadaerah "Tapak Tuan" }
	"tarakan" { set skodedaerah "281" 
	set snamadaerah "Tarakan" }
	"tarutung" { set skodedaerah "282" 
	set snamadaerah "Tarutung" }
	"tasikmalaya" { set skodedaerah "283" 
	set snamadaerah "Tasikmalaya" }
	"tebing tinggi" { set skodedaerah "284" 
	set snamadaerah "Tebing Tinggi" }
	"tegal" { set skodedaerah "285" 
	set snamadaerah "Tegal" }
	"temanggung" { set skodedaerah "286" 
	set snamadaerah "Temanggung" }
	"tembilahan" { set skodedaerah "287" 
	set snamadaerah "Tembilahan" }
	"tenggarong" { set skodedaerah "288" 
	set snamadaerah "Tenggarong" }
	"ternate" { set skodedaerah "289" 
	set snamadaerah "Ternate" }
	"tolitoli" { set skodedaerah "290" 
	set snamadaerah "Tolitoli" }
	"tondano" { set skodedaerah "291" 
	set snamadaerah "Tondano" }
	"trenggalek" { set skodedaerah "292" 
	set snamadaerah "Trenggalek" }
	"tual" { set skodedaerah "293" 
	set snamadaerah "Tual" }
	"tuban" { set skodedaerah "294" 
	set snamadaerah "Tuban" }
	"tulung agung" { set skodedaerah "295" 
	set snamadaerah "Tulung Agung" }
	"ujung berung" { set skodedaerah "296" 
	set snamadaerah "Ujung Berung" }
	"ungaran" { set skodedaerah "297" 
	set snamadaerah "Ungaran" }
	"waikabubak" { set skodedaerah "298" 
	set snamadaerah "Waikabubak" }
	"waingapu" { set skodedaerah "299" 
	set snamadaerah "Waingapu" }
	"wamena" { set skodedaerah "300" 
	set snamadaerah "Wamena" }
	"watampone" { set skodedaerah "301" 
	set snamadaerah "Watampone" }
	"watansoppeng" { set skodedaerah "302" 
	set snamadaerah "Watansoppeng" }
	"wates" { set skodedaerah "303" 
	set snamadaerah "Wates" }
	"wonogiri" { set skodedaerah "304" 
	set snamadaerah "Wonogiri" }
	"wonosari" { set skodedaerah "305" 
	set snamadaerah "Wonosari" }
	"wonosobo" { set skodedaerah "306" 
	set snamadaerah "Wonosobo" }
	"yogyakarta" { set skodedaerah "307" 
	set snamadaerah "Yogyakarta" }
	"jakarta pusat" { set skodedaerah "308"
	set snamadaerah "Jakarta Pusat" }
	"jakarta barat" { set skodedaerah "309" 
	set snamadaerah "Jakarta Barat" }
	"jakarta selatan" { set skodedaerah "310" 
	set snamadaerah "Jakarta Selatan" }
	"jakarta timur" { set skodedaerah "311" 
	set snamadaerah "Jakarta Timur" }
	"jakarta utara" { 
	set skodedaerah "312" 
	set snamadaerah "Jakarta Utara" 
	}
    "sambas" { 
	set skodedaerah "313" 
	set snamadaerah "Sambas" 
	}
    "masamba" { 
	set skodedaerah "314" 
	set snamadaerah "Masamba" 
	}
    "bula" { 
	set skodedaerah "315" 
	set snamadaerah "Bula SBT" 
	}
    "bahaur" { 
	set skodedaerah "316" 
	set snamadaerah "Bahaur" 
	}		
	default { 
		set skodedaerah "" 	 
		set snamadaerah "" 
		}
	}	
		Pub:ShareAdzan $skodedaerah $snamadaerah $chan
		set otime $rtime
		}
	}
}

set otime 0

proc Pub:ShareAdzan {skodedaerah snamadaerah chan} {
global waktu sharesubuh sharedzuhur shareashar sharemaghrib shareisya
#	set connect [::http::geturl http://jadwal-sholat.info/daily.php?id=$skodedaerah]
#	set connect [::http::geturl http://jadwalsholatimsak.com/daily.php?id=$skodedaerah]
	set connect [::http::geturl https://www.jadwalsholat.org/adzan/daily.php?id=$skodedaerah]
	set files [::http::data $connect]
#	set l [regexp -all -inline -- {.*?<tr class="table_light" align="center"><td><b>.*?</b></td><td>.*?</td><td>(.*?):(.*?)</td><td>(.*?):(.*?)</td><td>(.*?):(.*?)</td><td>(.*?):(.*?)</td><td>(.*?):(.*?)</td></tr>.*?<tr class="table_block_title"><td colspan="7">} $files]
	set l [regexp -all -inline -- {.*?<tr class="table_light" align="center"><td><b>.*?</b></td><td>.*?</td><td>(.*?):(.*?)</td><td>.*?</td><td>.*?</td><td>(.*?):(.*?)</td><td>(.*?):(.*?)</td><td>(.*?):(.*?)</td><td>(.*?):(.*?)</td></tr>.*?<tr class="table_block_title"><td colspan="9">} $files]
	   if {[llength $l] != 0} {
			foreach {black a b c d e f g h i j} $l {
			set a [string trim $a " \n"]
			set b [string trim $b " \n"]
			set c [string trim $c " \n"]
			set d [string trim $d " \n"]
			set e [string trim $e " \n"]
			set f [string trim $f " \n"]
			set g [string trim $g " \n"]
			set h [string trim $h " \n"]
			set i [string trim $i " \n"]
			set j [string trim $j " \n"]

			regsub -all {<.+?>} $a {} a	
			regsub -all {<.+?>} $b {} b
			regsub -all {<.+?>} $c {} c
			regsub -all {<.+?>} $d {} d
			regsub -all {<.+?>} $e {} e
			regsub -all {<.+?>} $f {} f
			regsub -all {<.+?>} $g {} g
			regsub -all {<.+?>} $h {} h
			regsub -all {<.+?>} $i {} i
			regsub -all {<.+?>} $j {} j
			
			putlog "Ambil Data Manual Dari https://www.jadwalsholat.org/"
			
			set sharesubuh "$a:$b:00"
			set sharedzuhur "$c:$d:00"
			set shareashar "$e:$f:00"
			set sharemaghrib "$g:$h:00"
			set shareisya "$i:$j:00"
			
			replacetime
			puthelp "PRIVMSG $chan :\(Jadwal Sholat \00307$snamadaerah\003 dan Sekitarnya, $waktu\) Subuh: $sharesubuh - Dzuhur: $sharedzuhur - Ashar: $shareashar - Maghrib: $sharemaghrib - Isya: $shareisya"
			set skodedaerah ""
			set snamadaerah ""	
		}	
	}
}
   
proc replacetime { } {
global sharetime waktu
set arguments [clock format [clock seconds] -timezone :Asia/Jakarta -format $sharetime(format)]
	set day [lindex [split $arguments] 0]
	if {$day == "Monday"} { set hari "\00312Senin\003" }
	if {$day == "Tuesday"} { set hari "\00312Selasa\003" }
	if {$day == "Wednesday"} { set hari "\00312Rabu\003" }
	if {$day == "Thursday"} { set hari "\00312Kamis\003" }
	if {$day == "Friday"} { set hari "\00303Jum'at\003" }
	if {$day == "Saturday"} { set hari "\00304Sabtu\003" }
	if {$day == "Sunday"} { set hari "\00304Minggu\003" }
	set tanggal [lindex [split $arguments] 2]
	set month [lindex [split $arguments] 1]
	if {$month == "January"} { set bulan "Jan" }
	if {$month == "February"} { set bulan "Feb" }
	if {$month == "March"} { set bulan "Mar" }
	if {$month == "April"} { set bulan "Apr" }
	if {$month == "May"} { set bulan "Mei" }
	if {$month == "June"} { set bulan "Jun" }
	if {$month == "July"} { set bulan "Jul" }
	if {$month == "August"} { set bulan "Agus" }
	if {$month == "September"} { set bulan "Sept" }
	if {$month == "October"} { set bulan "Okt" }
	if {$month == "November"} { set bulan "Nov" }
	if {$month == "December"} { set bulan "Des" }
	set tahun [lindex [split $arguments] 3]
	set jam [lindex [split $arguments] 5]

	set waktu "$hari, $tanggal $bulan $tahun"
}

putlog "\002SHAREADZAN:\002 Adzan.tcl is loaded."
