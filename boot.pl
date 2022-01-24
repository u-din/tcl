#!/usr/bin/env perl
##################################
## Bot Clone Loader IPv4        ##
##          MAKNYUS.pl   v.1    ##
##################################
use IO::Socket;
my $server = "irc.chating.id";
my $port = "6667";
my $channel= "#i";
my $admin = "isfan";
my $procname = "/usr/bin/atd4";
if ($#ARGV == -1)
{
    print "+ MAKNYUS : usage perl boot.pl <jumlah clone>\n";
    exit(-1);
}
$SIG{CHLD} = sub { wait };
$jumlahclone = $ARGV[0];
$fixclone = $jumlahclone+1;
$0 = $procname . "\0";
print "\n+ BOT IPv4 Clone\n";
print "+ Server : $server\n";
print "+ Port : $port\n";
print "+ Admin : $admin\n";
print "+ Clone : $jumlahclone\n\n";

my $clone = 1;
do {
$clone=$clone+1;
sleep(5);
my $pid = fork();
unless ($pid) {
$away = 0;
my $botnick = &mynick;
my $notc = "[\002B\037o\037T\002]";
&connect;
sub connect(){
 $sock = IO::Socket::INET->new(PeerAddr => $server,
                                PeerPort => $port,
                                Proto => "tcp") or die "Can't connect to $server.\n";
 print $sock "USER $botnick 8 * :$notc\r\n";
 print $sock "NICK $botnick \n";
}

while(<$sock>){
 chomp;
 $line   = $_;
 $backup = $line;
 $line   = lc($line);
 $away ++;

if($away == "100") {
   print $sock "AWAY ".&mylogo." ".&versi." $^V \n";
   $away = 0;
}
if($backup =~ m/^PING :(.*?)$/gi) {
   print $sock "PONG $1 \r\n";
}
if($line=~/376/){
   print "+ $botnick -> coNnECteD!!\n";
   print $sock "JOIN $channel \r\n";
}
if($line=~/433/){
  my $botnick = &mynick;
  &connect;
}
if($line=~/^error :closing link:/){
  print "LOG: Connection has been closed, trying to reconnect!...\n";
  &connect;
 }
if($backup=~/^:(\S+)!(\S+)\@(\S+) PRIVMSG $botnick :\001VERSION\001.$/){
  print $sock "NOTICE $1 :\001VERSION ".&versi." $^V \001\n";
 }

### Chat ###
if($backup=~/^:$admin!(\S+)\@(\S+) PRIVMSG (\S+) :.say (.*?).$/){
   print $sock "PRIVMSG $3 :$4\n";
}
if($backup=~/^:$admin!(\S+)\@(\S+) PRIVMSG (\S+) :.jo (.*?).$/){
   print $sock "NOTICE $admin :$notc JoiNInG $4\n";
   print $sock "JOIN $4\n";
}
if($backup=~/^:$admin!(\S+)\@(\S+) PRIVMSG (\S+) :.pa (.*?).$/){
   print $sock "NOTICE $admin :$notc pARtiNG $4\n";
   print $sock "PART $4 ".&mylogo."\n";
}
if($backup=~/^:$admin!(\S+)\@(\S+) PRIVMSG (\S+) :.raw (.*?).$/){
   print $sock "NOTICE $admin :$notc cOMmaNd: $4\n";
   print $sock "$4\n";
}
if($backup=~/^:$admin!(\S+)\@(\S+) PRIVMSG (\S+) :$botnick off/){
   print $sock "NOTICE $admin :$notc TuRnInG oFF\n";
   print $sock "QUIT ".&mylogo." ShuTDoWn ReQueST bY \0030,1 [$admin] \003\n";
   my $mati = `kill -9 $$`;
}
if($backup=~/^:$admin!(\S+)\@(\S+) PRIVMSG (\S+) :$botnick restart/){
   print $sock "NOTICE $admin :$notc JuMPiNg tO ReStARt\n";
   print $sock "QUIT ".&mylogo." rEsTArt ReQueST bY \0030,1 [$admin] \003\n";
   sleep(2);
   &connect;
}
}
sub mylogo {
        my @aw = ("1","0","14");
        my @bw = ("2","3","4","5","6","7","8","9","10","11","12");
        my $aco = $bw[rand scalar @bw];
        my $bco = $aw[rand scalar @aw];
        my $mylogo = "\003".$aco.",".$bco."B\003".$bco.",".$aco."\037o\037\003".$aco.",".$bco."T\003";
        return $mylogo;
}

sub mynick {
        my @prefix = ("co_","ce_","dr_","id_");
        my @midfix = ("medan","jambi","riau","gorontalo","manado","malang","palembang","padang","aceh","lampung","jakarta","bandung","semarang","solo");
        my $acak = int(rand(999)) + 100;
        my $pprefix = $prefix[rand scalar @prefix];
        my $mmidfix = $midfix[rand scalar @midfix];
        my $hasilakhir = $pprefix.$mmidfix.$acak;
        return $hasilakhir;
}

sub versi {
        my $vver = "BoT rUNnING wITh peRL";
        return $vver;
}
}
}
until($clone == $fixclone);
