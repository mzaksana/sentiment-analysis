use strict;
use warnings;
use Data::Dumper::Concise;
use JSON;

# ARGV 2 for part file
main();
my $counter=0;
my $src0;
my $src1;
my $src2;
my $src3;
my $src4;

sub initF{
	 open($src0,'>',"../../data/src/0/tokopedia-0-$ARGV[2].data");
	 open($src1,'>',"../../data/src/1/tokopedia-1-$ARGV[2].data");
	 open($src2,'>',"../../data/src/2/tokopedia-2-$ARGV[2].data");
	 open($src3,'>',"../../data/src/3/tokopedia-3-$ARGV[2].data");
	 open($src4,'>',"../../data/src/4/tokopedia-4-$ARGV[2].data");

}
sub closeF{
	close $src0;
	close $src1;
	close $src2;
	close $src3;
	close $src4;
}

sub main{
	initF();
        my @targets=split "\n",`cat $ARGV[0]`;
		my $max=scalar @targets;
        for my $target (@targets){
			print $counter++." - $max :: ".$target."\n";
			readF($ARGV[1].$target);
        }
	closeF();
}

sub readF{
        my $file=`cat $_[0]`;
        # print $file;
        # $file=~/"message":"(.*?)","rating_description":".*","rating":(.*?)/g;
        my @lines=$file=~/"review_id":(.*?),"update_time"/g;

		for my $line (@lines){
			my $str="";
			$line=~/,"rating":(.*?)$/;
			my $star=$1;
			$str.=$1;
			$line=~/"message":"(.*?)"/;
			if(length($1)!=0){
				$str.="::-::".$1;
				writeF($star,$str);
				print "\n";
			}
		}
        # print Dumper($obj);
}

sub writeF{
	my $num=$_[0]-1;
	if($num=="0"){
		print $src0 "$_[1]\n";
		return 0;
	}
	if($num==1){
		print $src1 "$_[1]\n";
		return 0;
	}
	if($num==2){
		print $src2 "$_[1]\n";
		return 0;
	}
	if($num==3){
		print $src3 "$_[1]\n";
		return 0;
	}
	if($num==4){
		print $src4 "$_[1]\n";
		return 0;
	}

}

sub cleanStr{
    my $str = $_[0];
    # $dot= quotemeta '.';
    $str =~ s/>/ /g;
    $str =~ s/&(.*?)/ /g;
    $str =~ s/[\s,\n,'']&(.*?);/ /g;
    $str =~ s/[\+\:\]\|\[\@\#\$\%\*\&\,\/\\\(\)\;"]+/ /g;
    # $str =~ s/[\]\|\[\@\#\$\%\*\&\\\(\)\"]+//g;
    $str =~ s/-/ /g;
    $str =~ s/[^,.!?\w+]/ /g;
    $str =~ s/\n+/ /g;
    $str =~ s/^\s+/ /g;
    $str =~ s/\s+$/ /g;
    $str =~ s/^$//g;
    $str =~ s/!*//g;
    $str =~ s/\.//g;
    $str =~ s/\!//g;
    $str =~ s/\?//g;
    $str =~ s/\s+/ /g;
    $str =~ s/^\s+|\s+$//g;
    # $str =~ s/[\s,\n,'']&(.*?);//g;
    # $str =~ s/[,!.]//g;sub remove_stopwrod{
    return $str;
}

