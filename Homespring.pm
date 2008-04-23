package Language::Homespring;

$VERSION = 0.01;

use strict;
use warnings;

use Language::Homespring::Node;

sub new {
	my $class = shift;
	my $self = bless {}, $class;

	my $options = shift;
	$self->{root_node} = undef;

	return $self;	
}

sub parse {
	my ($self, $source) = @_;

	my @tokens = 
		map{s/(\.$)|(^\.)/\n/g; $_}
		map{s/\. / /g; $_}
		map{s/ \././g; $_}
		split /(?:(?<!\.) (?!\.))|(?:\n(?!\.))/, $source;

	#print((join '|', @tokens)."\n\n");

	$self->{root_node} = new Language::Homespring::Node({'node_name' => shift @tokens});
	my $parent = $self->{root_node};

	for my $token(@tokens){
		if ($token){
			my $new_node = new Language::Homespring::Node({
				'node_name' => $token,
				'parent_node' => $parent,
			});
			$parent->add_child($new_node);
			$parent = $new_node;
		}else{
			if (defined $parent->{parent_node}){
				$parent = $parent->{parent_node};
			}
		}
	}
}

__END__

=head1 NAME

Language::Homespring - Perl interpreter for "Homespring"

=head1 SYNOPSIS

  use Language::Homespring;

  my $hs = new Language::Homespring();
  $hs->parse("bear hatchery Hello,. World ..\n powers");

=head1 DESCRIPTION

This module is a basic parser for the Homespring language.
At the moment it can only parse programs into trees.
The interpreter (and Language::Homespring::Salmon class)
need writing.

=head1 AUTHOR

Copyright (C) 2003 Cal Henderson <cal@iamcal.com>

Homespring is Copyright (C) 2003 Jeff Binder

=head1 SEE ALSO

L<perl>

http://home.fuse.net/obvious/hs.html

=cut
