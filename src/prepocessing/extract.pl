use strict;
use JSON;
use Data::Dumper::Concise;

my $files = `ls ../crawler/google-play-data/`;
my $counter=0;
my @n1=(0,0,0,0,0);
my %comment;

for my $file (split "\n",$files){
    my $apps=`cat ../crawler/google-play-data/$file`;
    # print $file."\n";
    $apps = beauty(qq#$apps#,substr $file,0,length($file)-length("Reviews.crw.json"));
}


for my $key (keys %comment){
    open(my $data,'>',"../../data/src/".$key."/data-google-play.data");
    my $flag=0;
    for my $row (keys %{$comment{$key}}){
        if($flag++!=0){
            print $data ",\n";
        }
        print $data validatorData($comment{$key}{$row}{'score'})."::".validatorData($comment{$key}{$row}{'title'})."::".validatorData($comment{$key}{$row}{'text'});

    }
    close $data;
}


sub validatorData{
    if (length($_[0])==0){
        return "-"; 
    }
    return $_[0];    
}

sub beauty{
    my $app=$_[0];
    my $data =from_json($app);
  

    for my $dataN (@{%{$data}{$_[1]}}){
        for my $dataRow (@{$dataN}){
            my $score=%{$dataRow}{score};
            my $title=%{$dataRow}{title};
            my $text=%{$dataRow}{text};
            $title=~s/'//g;
            $text=~s/'//g;
            $n1[$score-1]++;
            my %tmp=('score'=>$score,'title'=>$title,'text'=>$text);

            $comment{$score-1}{%{$dataRow}{id}}=\%tmp;
        }

    }
}