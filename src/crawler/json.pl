use strict;
use JSON;
use Data::Dumper::Concise;

my $apps=`cat ../../data/src/1/data-google-play.json`;
# print $apps;
my $data = from_json($apps);
print Dumper \ %{$data};

