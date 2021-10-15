# $scrap=`node main.js 2`;
use strict;
use JSON::XS;
use Try::Tiny;
use Data::Dumper::Concise;

goto $ARGV[0];
crawlAppData:crawlAppData($ARGV[1]);exit;
getDataCrawl:getDataCrawl();exit;


sub getDataCrawl{
	#TODO  transform code to json format
	my $cate=system ("node crawl.js category > temp/temp.category.crw.json");
	$cate=`cat temp/temp.category.crw.json`;
	$cate=~s/\n+//g;
	$cate=~s/\s+//g;
	$cate=~s/\t+//g;
	$cate=substr $cate,1,length($cate)-2;

	my @cate=(split ",",$cate);
	system ("echo '{'> temp/temp.apps.crw.json");
	my $links=scalar @cate;
	my $proc=0;
	print "crawl : ".$links." category\n";
	my $start=0;
	for my $cate (@cate){
		print $cate.beautySpace(length($cate),35)." -->>  ". ++$proc." :: ".$links."\n";
		system "echo ".'\"'. $cate.'\"'." ':[' >> temp/temp.apps.crw.json";

		while($start<=500){
	
			system "node crawl.js getAppsByCate $cate $start >> temp/temp.apps.crw.json";
			system ("echo ',' >> temp/temp.apps.crw.json");
			$start+=100;	
		}
		$start=0;
		system ("sed -i '".'$s'."/,//'"." temp/temp.apps.crw.json");
		system ("echo '],' >> temp/temp.apps.crw.json");

	}
	system ("sed -i '".'$s'."/,/\}/'"." temp/temp.apps.crw.json");
}

# Params $key is category
sub crawlAppData{
	my $key=$_[0];
	my $apps = `cat temp/temp.apps.crw.json`;
	$apps =  qq#$apps#;
	my $data = JSON::XS::decode_json($apps);
	my $num=0;
	my $lengthData=scalar @{%{$data}{$key}};
	for my $cursor (%{$data}{$key}->[0]){
		my $file ="google-play-data/".$key."Reviews.crw.json";
		system "echo {".'\"'. $key.'\"'." ':['> $file";

		print $num." ".$key.beautySpace(length($key),35)."==>>\t".$lengthData."\n";
		for my $line (@$cursor){
			my $procs=1;
			my $flag=0;
			
			while($flag!=-1){
				print " ".$procs." ";
				print $line->{'appId'}."\n";
				system "node crawl.js getReviewsById $line->{'appId'} $flag >> $file";
				system ("echo ',' >> $file");
				if(`cat $file`=~m/\[\]\n,\n$/){
					print "true \n";
					$flag=-1;
				}else{
					print "false \n";
					$flag+=40;
				}
				$procs++;
			}
		}
		system ("sed -i '".'$s'."/,/\]\}/'"." $file");

	}
	$num++;
	print "\n";
	
	# print scalar @{%{$data}{'FAMILY'}};
	# print Dumper %{$data}{'FAMILY'}->[6];
	# print scalar @dt[0];
}

sub beautySpace{
	my $space="";
	for (my $i=0; $i <= $_[1]-$_[0]-1; $i++) {
   		$space.=" ";
	}
	return $space;
}