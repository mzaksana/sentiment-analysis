#!/usr/bin/perl
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
use Try::Tiny;
use WWW::Mechanize;
use Mojo::DOM;
use Data::Dumper;

my $mech = WWW::Mechanize->new(autocheck => 1); # inisialisasi 
# Untuk Melakukan crawling , beberapa website meminta user agent
my $initial_user_agent = 'Mozilla/5.0 (Linux; U; Android 2.2; de-de; HTC Desire HD 1.18.161.2 Build/FRF91) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1';
$mech->agent($initial_user_agent);

my $loop=1;             # var untuk counter , sebagai informasi untuk menunjukkan hitungan url yang dicrawling
my %urls;               # hash untuk menampung unik url
my $go=0;               # var untuk counter link unik
my $startAt=localtime;  # untuk menyimpan waktu awal pada saat program dijalankan

my $target_url="https://www.tokopedia.com";
my @target_uri;
my @urls;

my %proc_uri;

main();

sub loadProcUri{
    my $filename = '../../data/links/proc.seed';
    my @lines;
    if (-f $filename) {
        @lines= split "\n",`cat ../../data/links/proc.seed`;
    }else{
        system "touch ../../data/links/proc.seed";
        @lines= split "\n",`cat ../../data/links/proc.seed`;

    }

    for my $line (@lines){
        $proc_uri{$line}=1;
    }
}

sub loadTargetUri{
    my $filename = '../../data/links/crawl.seed';
    if (-f $filename) {
        @target_uri= split "\n",`cat $filename`;
    }
}

sub main{
    loadProcUri();
    loadTargetUri();
    # print getPage($target_url.'/p/olahraga/outdoor-sport/paracord?page=1');
    # getBasePage($target_url.'/p');
    readGetBasePage($ARGV[0],$ARGV[1]);
	return 1;
}

sub readGetBasePage{
    my $num=0;
    for (my $i=$_[0];$i<=$_[1];$i++){
        my $counter=1;
        my $flag=0;
        $num++;
        do{
            if(exists $proc_uri{$target_uri[$i].'?page='.$counter}){
                print "skip \n";
                $counter++;
                next;
            }
            print $num." :: ".($_[1]-$_[0])." <> scraping :: ".$target_uri[$i].'?page='.$counter;
            print "\n";
            $flag=getPage($target_uri[$i].'?page='.$counter);
            system "echo ".$target_uri[$i]."?page=$counter >> ../../data/links/proc.seed";
            # system "echo ".$target_url.$dd->attr->{href}." >> ../../data/links/target.seed";
            waitInputTimeOut(2);
            $counter++;
        }while($flag);
    }
}

# from to
sub getBasePage{
    exit;
	#folder-file-url
    # perintah wget melakukan crawling terhadap url yang diberkan dan hasilnya disimpan pada sebuah scalar
    my $RESULT=`wget -qO- --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36" $_[0]`;
   
   
    my $dom = Mojo::DOM->new;
    $dom->parse($RESULT);
    my @base_url=$dom->find('a._2xS5-_VI')->each;
    my $num=0;
    my $len=scalar @base_url;

    for my $dd (@base_url) {
        my $counter=1;
        my $flag=0;
        $num++;
        do{
            if(exists $proc_uri{$target_url.$dd->attr->{href}.'?page='.$counter}){
                print "skip \n";
                $counter++;
                next;
            }
            print $num." :: ".$len." <> scraping :: ".$target_url.$dd->attr->{href}.'?page='.$counter;
            print "\n";
            $flag=getPage($target_url.$dd->attr->{href}.'?page='.$counter);
            system "echo ".$target_url.$dd->attr->{href}."?page=$counter >> ../../data/links/proc.seed";
            # system "echo ".$target_url.$dd->attr->{href}." >> ../../data/links/target.seed";
            waitInputTimeOut(2);
            $counter++;
        }while($flag);
    }
}

sub getPage{
    my $uri=$_[0];
    my $RESULT=`wget -qO- --user-agent="Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36" $uri`;
    my $dom = Mojo::DOM->new;
    $dom->parse($RESULT);

    if($dom->find('span.aktrOFEu')->each){
        return 0;
    }else{
        my $container = Mojo::DOM->new;

        # get container item shop 
        my @raw=$dom->find('._1sn05YIP._1_VpdN3e')->each;
        $container->parse($raw[0]);
        
        # get counter item in web nav 
        my @num=$container->find('._1lUX-bZg span strong')->each;
        my @page=$container->find('._33JN2R1i')->each;
        my $flag=0;
        # if counter web same with page div selector then 
        # just use one 
        if($num[2]=~/(\d+)/ == scalar @page){
            $flag=1;
        }
        for my $cards (@page){
            my $card= Mojo::DOM->new;
            $card->parse($cards);
            if($card->find('._2wY6y7fV')->each){
                my $mirrorCard=Mojo::DOM->new;
                $mirrorCard->parse($cards);
                
                for my $uri ($mirrorCard->find('._27sG_y4O a')->each){
                    # push @urls,$uri->attr->{href};
                    print("div ->> \n");
                    for my $url($uri->attr->{href}){
                        system "echo $url >> ../../data/links/link.seed";
                    }
                }
            }
        }

        if($flag){
            for my $cards($container->find('.ta-product')->each){
               my $card= Mojo::DOM->new;
                $card->parse($cards);
                print($card);
                print("\n");
                print("\n");
                if($card->find('._2wY6y7fV')->each){
                  for my $uri ($container->find('div.ta-product-wrapper>a')->each){
                        # push @urls,$uri->attr->{href};
                        print("ta-product ->> \n");
                        for my $url($uri->attr->{href}){
                            system "echo $url >> ../../data/links/link.seed";
                        }
                    }
                }
            }
        }
        return 1;
    }
}



sub waitInputTimeOut{
    my $answer;
    my $flag=0;
    	do{
    		print('flag : '.+$flag."\n");
    		eval {
                my $count = $_[0];
                local $SIG{ALRM} = sub {
                    # print counter and set alaram again
                    if (--$count) { print "$count\n"; alarm 1 } 

                    # no more waiting
                    else { die "timeout getting the input \n" }
                };

                # alarm every second
                alarm 1;
                my $tmp = <STDIN>;
                print('len '. $tmp);
                if(length($tmp)!=0){
                    print('temp  : '.$tmp."\n");
                    $flag=$tmp;
                }else{
                    $flag=0;
                }
                $answer=$flag;
                alarm 0;
                chomp $answer;
    	    }
        }while($flag!=0);
}