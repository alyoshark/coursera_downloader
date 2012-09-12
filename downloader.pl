use strict;
use Data::Dumper;

open(INPUT, "<source.html");
my $all_lines = "";

# Merge everything into one single line
while (my $line = <INPUT>)
{
    chomp($line);
    $all_lines = $all_lines . $line;
}
close(INPUT);

# Get all the tags with lecture ids
# and break into lines
my @items = ($all_lines =~ /a data-lecture-id=.*?\/a>/g);
#print Dumper(\@items);

# Get title and file urls, then form a hash
my %title2url;
my $title = "";
my $url = "";
foreach my $item (@items)
{
    print $item, "\n";
    ($url, $title) = ($item =~ m/data-lecture-view-link=\"(.+?)\".+lecture-link\"\>(.+?)<i /);
    $url   =~ s/view/download\.mp4/g;             # Change from view to download
    $title =~ s/(.+) \(.*\)/$1/;                  # Remove the duration
    $title =~ s/(&amp;)|:|\?|-|\(|\)|!//g;        # Remove special symbols
    $title =~ tr/A-Z/a-z/;                        # Make all letters lower case
    $title =  join("-", split(/\s+|-/, $title));  # Link words with hyphen
    $title = $title . ".mp4";                     # Append the .mp4
    $title2url{$title} = $url;
}
print Dumper(\%title2url);

# Ready to download!
foreach $title (%title2url)
{
    `wget --load-cookies=cookies.txt "$title2url{$title}" -O "$title"`;
}
