package Language::Homespring;

$VERSION = 0.01;

use strict;
use warnings;

use Language::Homespring::Node;
use Language::Homespring::Salmon;

sub new {
	my $class = shift;
	my $self = bless {}, $class;

	my $options = shift;
	$self->{root_node} = undef;
	$self->{salmon} = [];
	$self->{new_salmon} = [];

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

	$self->{root_node} = new Language::Homespring::Node({
		'interp' => $self,
		'node_name' => shift @tokens,
	});
	my $parent = $self->{root_node};

	for my $token(@tokens){
		if ($token){
			my $new_node = new Language::Homespring::Node({
				'interp' => $self,
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

sub tick {
	my ($self) = @_;
	my @nodes;

	print(('-'x50)."\n");

	# process snowmelts

	# process water

		# turn everything off
		$self->_set_all('water', 0);

		# water from springs
		@nodes = $self->_get_all_nodes();
		for (@nodes){
			$self->_water_downwards($_) if $_->{spring};
		}

	# process electricity

		# turn everything off
		$self->_set_recurse($self->{root_node}, 'power', 0);

		# process "powers"
		@nodes = $self->_get_nodes('powers');
		# $_->{power} = 'woo' for @nodes; return;
		$self->_power_downwards($_) for @nodes;

		# process "hydro power"
		@nodes = $self->_get_nodes('hydro power');
		for (@nodes){
			$self->_power_downwards($_) if $_->{water};
		}

		# process "power invert"
		@nodes = $self->_get_nodes('power invert');
		for (@nodes){
			$self->_power_downwards($_) if !$_->{power};
		}

	# process salmon

		$_->move() for (@{$self->{salmon}});
		push @{$self->{salmon}}, @{$self->{new_salmon}};
		$self->{new_salmon} = [];

	# process others

		@nodes = $self->_get_nodes('hatchery');
		for (@nodes){
			if ($_->{power}){
				my $salmon = new Language::Homespring::Salmon({'interp' => $self,'mature' => 1, 'upstream' => 1, 'location' => $_});
				push @{$self->{salmon}}, $salmon;
			}
		}

		@nodes = $self->_get_nodes('bear');
		for (@nodes){
			for my $salmon($_->get_salmon()){
				$salmon->kill() if $salmon->{mature};
			}
		}
}

sub _set_all {
	my ($self, $prop, $value) = @_;
	$self->_set_recurse($self->{root_node}, $prop, $value);
}

sub _set_recurse {
	my ($self, $node, $prop, $value) = @_;
	$node->{$prop} = $value;
	$self->_set_recurse($_, $prop, $value) for @{$node->{child_nodes}};
}

sub _get_nodes {
	my ($self, $name) = @_;
	return $self->_get_nodes_i($self->{root_node}, $name);
}

sub _get_nodes_i {
	my ($self, $node, $name) = @_;
	my @out = ();
	push @out, $node if ($node->{node_name} eq $name);
	push @out, $self->_get_nodes_i($_, $name) for @{$node->{child_nodes}};
	return @out;
}

sub _get_all_nodes {
	my ($self) = @_;
	return $self->_get_all_nodes_i($self->{root_node});
}

sub _get_all_nodes_i {
	my ($self, $node) = @_;
	my @out = ();
	push @out, $node;
	push @out, $self->_get_all_nodes_i($_) for @{$node->{child_nodes}};
	return @out;
}

sub _power_downwards {
	my ($self, $node) = @_;

	return if (!$node->{parent_node});

	$node->{parent_node}->{power} = 1;

	return if ($node->{parent_node}->{node_name} eq 'power invert');
	return if ($node->{parent_node}->{node_name} eq 'insulated');
	return if ($node->{parent_node}->{node_name} eq 'force field');
	return if (($node->{parent_node}->{node_name} eq 'bridge') && ($node->{parent_node}->{destroyed}));

	# TODO: "sense" and "switch"

	$self->_power_downwards($node->{parent_node});
}

sub _water_downwards {
	my ($self, $node) = @_;

	return if (!$node->{parent_node});

	$node->{parent_node}->{water} = 1;

	return if (($node->{parent_node}->{node_name} eq 'force field') && ($node->{parent_node}->{power}));
	return if (($node->{parent_node}->{node_name} eq 'bridge') && ($node->{parent_node}->{destroyed}));
	return if (($node->{parent_node}->{node_name} eq 'evaporates') && ($node->{parent_node}->{power}));

	$self->_water_downwards($node->{parent_node});
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
