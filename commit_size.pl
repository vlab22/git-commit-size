#!/usr/bin/perl
foreach my $rev (`git rev-list --all --pretty=oneline`) {
  my $tot = 0;
  ($sha = $rev) =~ s/\s.*$//;
  my ( $rev_desc ) = $rev=~ /( .*)\s*$/;
  $rev_desc =~ s/^\s+|\s+$//g;
  foreach my $blob (`git diff-tree -r -c -M -C --no-commit-id $sha`) {
    $blob = (split /\s/, $blob)[3];
    next if $blob == "0000000000000000000000000000000000000000"; # Deleted
    my $size = `echo $blob | git cat-file --batch-check`;
    $size = (split /\s/, $size)[2];
    $tot += int($size);
  }
  my $revn = substr($rev, 0, 40);
  if ($tot > 1000000) {
	$mb_tot = $tot / 1024 / 1024;
	$mb_tot_str = sprintf('%.2f', $mb_tot);
    print "$mb_tot_str Mb $rev_desc $revn " . `git show --pretty="format:" --name-only $revn | wc -l`  ;
  }
}
