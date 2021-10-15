use strict;
use warnings;
use Lingua::EN::Bigram;
use Data::Dumper::Concise;
use Encode;
use utf8;


my %stopWord;
my %data;
my %dataTheasaurus;
my %emoticon;
my %totalData;
my %s;
my $ngrams = Lingua::EN::Bigram->new;
my $threshold=0.4;

main();
sub initVal{
    $emoticon{'max'}{0}=0;
    $emoticon{'max'}{1}=0;
    $emoticon{'max'}{2}=0;
    $emoticon{'max'}{3}=0;
    $emoticon{'max'}{4}=0;
}
sub main{
    # loadStopWord();
    loadSourceData();
    genNgrams();
    normalizeData();
    normalizeEmoticon();
    makeTheasaurus();
    makeTheasaurusEmoticon();
}

sub makeTheasaurusEmoticon{
    for my $index (0 .. 4){
        open(my $data,'>:encoding(UTF-8)',"./../../data/thesaurus/$index/emoticons/emoticons.dat");
        for my $key (keys %{$emoticon{$index}}){
            my $normalize=$emoticon{$index}{$key}/$emoticon{'max'}{$index};
            print $data "$key\t$emoticon{$index}{$key}\t$normalize\t$emoticon{'max'}{$index}\n";
            # print "$key\t$emoticon{$index}{$key}\t$normalize\t$emoticon{'max'}{$index}\n";
        }
        close $data;
    }
}

sub makeTheasaurus{
    my @keys=keys %dataTheasaurus;
    for(my $index=0;$index<scalar @keys;$index++){
        for my $nGrams (1..3){
            open(my $data,'>',"./../../data/thesaurus/$index/texts/$index-$nGrams.dat");

            for my $key (keys %{$dataTheasaurus{$index}{$nGrams}}){
                my $normalize=$dataTheasaurus{$index}{$nGrams}{$key}/$totalData{$index}{$nGrams};
                print $data "$key\t$dataTheasaurus{$index}{$nGrams}{$key}\t$normalize\t$totalData{$index}{$nGrams}\n";
            }
            close $data;
        }
    }
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
sub normalizeData{
    my @keys=keys %dataTheasaurus;
    for my $nGrams (1..3){
        for(my $index=0;$index<scalar @keys-1;$index++){
            for(my $i=$index+1;$i<scalar @keys;$i++){
                for my $key (keys %{$dataTheasaurus{$index}{$nGrams}}){
                    if(exists $dataTheasaurus{$i}{$nGrams}{$key}){
                        my $val1 = $dataTheasaurus{$index}{$nGrams}{$key}/$totalData{$index}{$nGrams};
                        my $val2 = $dataTheasaurus{$i}{$nGrams}{$key}/$totalData{$i}{$nGrams};

                        my $flag = $val1>$val2?$val1/$val2:$val2/$val1;
                        if($flag > $threshold){
                            # print "del\t$dataTheasaurus{$index}{$nGrams}{$key}\t$dataTheasaurus{$i}{$nGrams}{$key}";
                            # print "\n";
                            delete $dataTheasaurus{$index}{$nGrams}{$key};
                            delete $dataTheasaurus{$i}{$nGrams}{$key};
                        }else{
                            if($val1 > $val2){
                            print "\n";
                                # print "\t$dataTheasaurus{$i}{$nGrams}{$key}";
                                # print "\n";
                                delete $dataTheasaurus{$i}{$nGrams}{$key};
                            }else{
                                # print "\t$dataTheasaurus{$index}{$nGrams}{$key}";
                                # print "\n";
                                delete $dataTheasaurus{$index}{$nGrams}{$key};                    
                            }
                        }
                    }
                }
            }
        }
    }
}
sub normalizeEmoticon{
    my @keys=keys %emoticon;
    my $max = scalar @keys;

    for(my $i=0; $i<$max-1;$i++){
        for(my $j=$i+1; $j<$max-1;$j++){
            # print "loop > : $i :: $j\n";
            for my $emot (keys %{$emoticon{$i}}){
                # print "iterate 1 : $emot\n";

                if(exists $emoticon{$j}{$emot}){
                    my $val1 = $emoticon{$i}{$emot}/$emoticon{'max'}{$i};
                    my $val2 = $emoticon{$j}{$emot}/$emoticon{'max'}{$j};

                    my $flag = $val1>$val2?$val1/$val2:$val2/$val1;
                    if($flag > $threshold){
                        # print "del\t$emoticon{$i}{$emot}\t$emoticon{$j}{$emot}";
                        # print "\n";
                        delete $emoticon{$i}{$emot};
                        delete $emoticon{$j}{$emot};
                    }else{
                        if($val1 > $val2){
                            # print "\t$emoticon{$j}{$emot}";
                            print "\n";
                            delete $emoticon{$j}{$emot};
                        }else{
                            # print "\t$emoticon{$i}{$emot}";
                            print "\n";
                            delete $emoticon{$i}{$emot};
                        }
                    }
                }
            }
        }
    }
}
sub genNgrams{

    for my $row (0..4){
        print "row :: $row\n";
        $s{$row}=0;
        for my $nGrams (1..3){
            print "nGrams :: $nGrams\n";

            for my $line (split "\n",$data{$row}){
                my @comment = split "::",$line;
                # print $comment[0]."\n";
                # print $comment[1]."\n";
                # print $comment[2]."\n";
                if (!exists $comment[1]){
                    next;
                }
                parseEmoticon($comment[1],$row);
                $comment[1]=cleanStr($comment[1]);
                # $comment[1]=removeStopwrod($comment[1]);
                if(length($comment[1])<=0){
                    next;
                }
              
                $s{$row}++;
                $ngrams->text($comment[1]);
                my $text = join "\n",$ngrams->ngram($nGrams);
                if(length($text)>=1){
                    insert($row,$nGrams,$text);
                }
            }
        }
    }    
}
sub insert{
    foreach my $word (split "\n",$_[2]){
        $word=cleanStr($word);
        if(exists $dataTheasaurus{$_[0]}{$_[1]}{$word}){
            $dataTheasaurus{$_[0]}{$_[1]}{$word}++;
        }else{
            $dataTheasaurus{$_[0]}{$_[1]}{$word}=1;
        }
        if(exists $totalData{$_[0]}{$_[1]}){
            if($totalData{$_[0]}{$_[1]}<$dataTheasaurus{$_[0]}{$_[1]}{$word}){
                $totalData{$_[0]}{$_[1]}=$dataTheasaurus{$_[0]}{$_[1]}{$word};
            }
        }else{
            $totalData{$_[0]}{$_[1]}=1;                
        }
    } 
}
sub loadSourceData{
    my $data0=`cat ../../data/data-thesaurus/0/*`;
    my $data1=`cat ../../data/data-thesaurus/1/*`;
    my $data2=`cat ../../data/data-thesaurus/2/*`;
    my $data3=`cat ../../data/data-thesaurus/3/*`;
    my $data4=`cat ../../data/data-thesaurus/4/*`;
    $data{0}=(qq#$data0#);
    $data{1}=(qq#$data1#);
    $data{2}=(qq#$data2#);
    $data{3}=(qq#$data3#);
    $data{4}=(qq#$data4#);
}
sub loadStopWord{
    my $stopWordList = `cat ../../data/util/stopWords.txt`;
    for my $str ( split "\n" ,$stopWordList){
        $stopWord{$str}=1;
    }
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
    # $str =~ s/[,!.]//g;sub remove_stopwrod{

    return $str;
}
sub removeStopwrod{
    if (length($_[0])<=1 or $_[0] eq "-"){
        return "";
    }
    my $string="";
    my $flag=0;
    for my $str (split " ",$_[0]){
        if(exists $stopWord{$str}){
            print "remove : $str\n";
            next;
        }

        if($flag++!=0){
            $string.=" ";
        }
        $string.=$str;
    }
    return $string;
}

sub parseEmoticon{
    if($_[0] eq "-"){
        return;
    }
    my $ligne = decode_utf8 $_[0];
    if ($ligne =~ m/\p{Block: Emoticons}/) {
        for my $c (split //, $ligne) { 
            if ($c =~ m/\p{Block: Emoticons}/) {
                my @tmp=split "::",$ligne;
                # print "$c\n";
                if(exists $emoticon{$_[1]}{$c}){
                    $emoticon{$_[1]}{$c}++;
                    if($emoticon{'max'}{$_[1]}<$emoticon{$_[1]}{$c}){
                        $emoticon{'max'}{$_[1]}=$emoticon{$_[1]}{$c};
                    }
                }else{
                    $emoticon{$_[1]}{$c}=1;
                    if( $emoticon{'max'}{$_[1]}==0){
                        $emoticon{'max'}{$_[1]}=1;
                    }
                }
            }
        }   
    }
}