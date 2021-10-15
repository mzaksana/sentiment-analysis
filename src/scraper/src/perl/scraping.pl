#
# Program ini digunakan untuk melalukan crawling
#
# Author: Muammar Zikri Aksana
# College of Science, Syiah Kuala Univ
#
# Date: Jan 2019
#
# Dependencies:
# 1. Mechanize
# 2. Tiny

use strict;
use HTTP::Request;
use LWP::UserAgent;
use Mojo::DOM;
use Data::Dumper;

my @targets;
my $counter=0;
my $max;
my $proc=$ARGV[0];
my %skip;
main();

sub loadSkip{
    my $file=`ls /media/mza/7a871433-4378-4462-9aae-cd28893cbcca/data-twm/data/ | cut -d'.' -f 1`;
    for my $line (split "\n",$file){
        $skip{$line}=1;
    }
}

sub loadTargets{
    # TODO ganti kalau selesai
    @targets = split "\n",`cat ../../data/links/used/part/$_[0]`;
    $max= scalar @targets;
}

sub main{
    loadSkip();
    loadTargets($ARGV[0]);
    my $count=1;
    for my $target(@targets){
        scraping($target);
        # delete row from file
        system "sed -i ".$count."d ../../data/links/used/part/$ARGV[0]";
    }
}

sub scraping{
    print "link\n";
    print $_[0];
    print "\n--\n";

    my $request = HTTP::Request->new(GET => $_[0]);
    my $ua = LWP::UserAgent->new;
    my $response = $ua->request($request);
    my $res=%{$response}{'_headers'};
    
    my $num = $res->{'client-response-num'};
    my $productId=getId($res->{'x-meta-branch-deeplink-$android-deeplink-path'});
    if(exists $skip{$productId}){
        print "skip id $productId\n";
        return;
    }
    # print "\n";
    my $uri='https://www.tokopedia.com/reputationapp/review/api/v2/product/'.$productId.'?page=1&total=1000';

    # if($num<1){
    #     print "skip \n";
    #     return;
    # }
    $counter++;
    print "\tcrawl : $productId   ::: $counter <> $max\n ";

    $request = HTTP::Request->new(GET => $uri);
    $response = $ua->request($request);
    $res=$response->content();
    system "echo '".$uri."' >> ../../data/data/$proc";
    system "echo '".$res."' > /media/mza/7a871433-4378-4462-9aae-cd28893cbcca/data-twm/data/$productId".".json";
    undef $request;
    undef $ua;
    undef $response;
    undef $res;
}

# param 1 product/469429568
# param 1 product/{id}
sub getId{
    return (split '/',$_[0])[1];
}