package Language::Homespring::Node;

$VERSION = 0.01;

use warnings;
use strict;

sub new {
	my $class = shift;
	my $self = bless {}, $class;

	my $options = shift;
	$self->{parent_node}	= $options->{parent_node} || undef;
	$self->{node_name}	= $options->{node_name} || '';
	$self->{child_nodes}	= [];

	return $self;
}

sub add_child {
	my ($self, $child) = @_;
	push @{$self->{child_nodes}}, $child;
}

