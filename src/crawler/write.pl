use strict;
use JSON::XS;
use Data::Dumper::Concise;

my $apps=`cat ./google-play-data/ANDROID_WEARReviews.crw.json`;
$apps = qq#$apps#;
print $apps;
# my $data = JSON::XS::decode_json($apps);
# print Dumper \ %{$data};