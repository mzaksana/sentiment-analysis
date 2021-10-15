use strict;
use warnings;
use Lingua::EN::Bigram;
use Data::Dumper::Concise;
use JSON;
use utf8;
use Encode;
use Devel::Peek':opd=UTF8';

my %stopWord;
my %data;
my %dataTheasaurus;
my %theasaurus;

my %emoticon;
my %emoticon_lex;

my %positive;
my %negative;

my %totalData;
my %s;
my $ngrams = Lingua::EN::Bigram->new;
my $threshold=0.4;
my %class=(0=>'one',1=>'two',2=>'three',3=>'four',4=>'five');
main();

sub main{
    # loadStopWord();
    loadEmoticon();
    loadTheasaurus();
    loadSourceData();
    genFeatures();
}

sub display{
    for my $nGrams (1..3){
        for my $index(keys %dataTheasaurus){
            print "size $index - $nGrams : \t";
            print scalar keys %{$dataTheasaurus{$index}{$nGrams}};
            print "\n";
        }
    }
}
sub genFeatures{
    open(my $file,'>',"./../../data/data-set/test.csv");
    # print $file 'one1,one2,one3,two1,two2,two3,three1,three2,three3,four1,four2,four3,five1,five2,five3,positive,negative,class'."\n";
    print $file 'one1,one2,one3,two1,two2,two3,three1,three2,three3,four1,four2,four3,five1,five2,five3,positive,negative,emot1,emot2,emot3,emot4,emot5,emotPositive,emotNegative,class'."\n";

    for my $row (0..4){
        # print "row :: $row\n";
        # print "text:\t";
        $s{$row}=0;
        for my $nGrams (1..3){
            # print "nGrams :: $nGrams\n";

            for my $line (split "\n",$data{$row}){
                # print $line."\n";
                my @comment = split "::",$line;
                # print $comment[0]."\n";
                # print $comment[1]."\n";
                # print $comment[2]."\n";
                my $comment=$comment[2];
                $comment[2]=cleanStr($comment[2]);
                # $comment[1]=removeStopwrod($comment[1]);
                                
                $s{$row}++;
                $ngrams->text($comment[2]);
                my $text = join "\n",$ngrams->ngram($nGrams);
                if(length($text)!=0){
                    # print "text: \t ";
                    my $val="";
                    $val.=calc($text,0,1).",";
                    $val.=calc($text,0,2).",";
                    $val.=calc($text,0,3).",";
                    $val.=calc($text,1,1).",";
                    $val.=calc($text,1,2).",";
                    $val.=calc($text,1,3).",";
                    $val.=calc($text,2,1).",";
                    $val.=calc($text,2,2).",";
                    $val.=calc($text,2,3).",";
                    $val.=calc($text,3,1).",";
                    $val.=calc($text,3,2).",";
                    $val.=calc($text,3,3).",";
                    $val.=calc($text,4,1).",";
                    $val.=calc($text,4,2).",";
                    $val.=calc($text,4,3).",";

                    $val.=positive($text).",";
                    $val.=negative($text).",";
                    $val.=calcEmot($comment,0).",";
                    $val.=calcEmot($comment,1).",";
                    $val.=calcEmot($comment,2).",";
                    $val.=calcEmot($comment,3).",";
                    $val.=calcEmot($comment,4).",";
                    $val.=calcEmoticon($comment).",";
                    $val.=calcEmoticon($comment).",";
                    # data yang semua 0 di skip
                    if($val=~m/0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,/){
                    # if($val=~m/0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,/){
                        next;
                    }
                    print $file "$val$class{$row}\n";
                    print "$val$class{$row}\n";
                }
            }
        }
    }    
    close $file;
}
# data , class ,n-grams 
sub calc{
    my $val=0;
    my @string=split "\n",$_[0];
    for my $line (@string){
        if(exists ${theasaurus}{$_[1]}{$_[2]}{$line}){
            $val++;
        }
    }
    return $val/scalar @string;
}
sub calcEmot{
    my $str=$_[0];
    my $val=0;
    my $emot=0;
    # my $ligne = decode_utf8 $str;
    my $ligne =$str;
    if ($ligne =~ m/\p{Block: Emoticons}/) {
        for my $c (split //, $ligne) { 
            $emot++;
            if(exists $emoticon{$_[1]}{$c}){
                $val++;
            }
        }
    }
    if($emot==0){
        return 0;
    }
    return $val/$emot;
}
# for 
sub calcEmoticon{
    my $str=$_[0];
    my $val=0;
    my $emot=0;
    # my $ligne = decode_utf8 $str;
    my $ligne =$str;
    if ($ligne =~ m/\p{Block: Emoticons}/) {
        for my $c (split //, $ligne) { 
            $emot++;
            my $aa=dump_as_str($c);
            $aa=~/\[UTF8 (".*?")\]/;
            if(exists $emoticon_lex{$1}){
                $val++;
            }
        }
    }
    if($emot==0){
        return 0;
    }
    return $val/$emot;
}

sub positive{
    my $val=0;
    my @string=split "\n",$_[0];
    for my $line (@string){
        if(exists ${positive}{$line}){
            $val++;
        }
    }
    return $val/scalar @string;
}

sub negative{
    my $val=0;
    my @string=split "\n",$_[0];
    for my $line (@string){
        if(exists $positive{$line}){
            $val++;
        }
    }
    return $val/scalar @string;
}

# ganti source path untuk test dan training
sub loadSourceData{
    my $data0=`cat ../../data/data-model/test/0/*`;  
    my $data1=`cat ../../data/data-model/test/1/*`;  
    my $data2=`cat ../../data/data-model/test/2/*`;  
    my $data3=`cat ../../data/data-model/test/3/*`;  
    my $data4=`cat ../../data/data-model/test/4/*`;  
    $data{0}=(qq#$data0#);
    $data{1}=(qq#$data1#);
    $data{2}=(qq#$data2#);
    $data{3}=(qq#$data3#);
    $data{4}=(qq#$data4#);
}

sub loadTheasaurus{
    for my $cat (0..4){
        for my $n (1..3){
            my @data=split "\n",`cat ../../data/thesaurus/$cat/texts/$cat-$n.dat`;
            for my $line (@data){
                my @text=split "\t",$line;
                if(exists$theasaurus{$cat}{$n}{$text[0]}){
                    $theasaurus{$cat}{$n}{$text[0]}++;
                }else{
                    $theasaurus{$cat}{$n}{$text[0]}=1;
                }
            }
        }
    }
    
    # positive 
    my @dataP=split "\n",`cat ../../data/thesaurus/positiv-negative/texts/positive.txt`;
    for my $plus (@dataP){
        $positive{$plus}=1;
    }
    # negative 
    my @dataN=split "\n",`cat ../../data/thesaurus/positiv-negative/texts/negative.txt`;
    for my $min (@dataN){
        $negative{$min}=1;
    }
}

sub loadEmoticon{
    for my $index (0..4){
        my @data=split "\n",`cat ../../data/thesaurus/$index/emoticons/emoticons.dat`;
        for my $key(@data){
            my @tmp=split " ",$key;
            my $ad=decode_utf8 $tmp[0];
            $emoticon{$index}{$ad}=$tmp[1];
        }
    }

    my $dataEmot=`cat ../../data/thesaurus/positiv-negative/emoticons/emoji-sentiment-data.stable.json`;
    my $tmpHash = qq#$dataEmot#;
    my @aemoticon_lex=from_json($tmpHash);

    for my $line (@{$aemoticon_lex[0]}){
	    my $em=$line->{'sequence'};
        my $emot='"\x{'.lc $em.'}"';
        $emoticon_lex{$emot}=1;
    }
}

sub loadStopWord{
    my $stopWordList = `cat ../../data/util/stopWords.txt`;
    for my $str ( split "\n" ,$stopWordList){
        $stopWord{$str}=1;
    }
}

sub removeStopwrod{
    if (length($_[0])<=1){
        return "";
    }
    my $string="";
    my $flag=0;
    for my $str (split " ",$_[0]){
        if(exists $stopWord{$str}){
            next;
        }

        if($flag++!=0){
            $string.=" ";
        }
        $string.=$str;
    }
    return $string;
}

sub cleanStr{
    my $str = $_[0];
    # $dot= quotemeta '.';
    $str =~ s/>/ /g;
    $str =~ s/&(.*?)/ /g;
    $str =~ s/[\s,\n,'']&(.*?);/ /g;
    $str =~ s/[\:\]\|\[\@\#\$\%\*\&\,\/\\\(\)\;"]+/ /g;
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
    # $str =~ s/[,!.]//g;

    return $str;
}

# https://www.perlmonks.org/?node_id=746398
sub dump_as_str{
    my $str;

    # redirect STDERR temporarily
    open(my $ORIGSTDERR, ">&", STDERR)
        and close(STDERR)
        and open(STDERR, ">", \$str)
        or die($!);

    #-----------------------------------------------------
    #revision to suppress warnings - see bug report #63498
    #-----------------------------------------------------
    #Dump($_[0]);
    {
       no warnings 'uninitialized';
       Dump($_[0]);
    }

    # restore STDERR
    open(STDERR, ">&=" . fileno($ORIGSTDERR))
        or die($!);

    return $str;
}