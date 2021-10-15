open my $fh, "<:encoding(UTF-8)", "../../data/src/4/data-google-play.data" or die "Could not open $filename: $!";

while (my $ligne = <$fh>) {
    # print $ligne."\n";
    if ($ligne =~ m/\p{Block: Emoticons}/) {
        for my $c (split //, $ligne) { 
            if ($c =~ m/\p{Block: Emoticons}/) {
                my @tmp=split "::",$ligne;
                print $tmp[2]."\t$c\n";
            }
        }   
    }
}