package Language::Homespring::Salmon;

$VERSION = 0.02;

use warnings;
use strict;

sub new {
	my $class = shift;
	my $self = bless {}, $class;

	my $options = shift;
	$self->{interp}		= $options->{interp};
	$self->{value}		= $options->{value} || 'homeless';
	$self->{upstream}	= $options->{upstream} || 0;
	$self->{mature}		= $options->{mature} || 0;
	$self->{location}	= $options->{location};
	$self->{time_at_node}	= 0;

	return $self;
}

sub move {
	my ($self) = @_;

	$self->{time_at_node}++;

	# see if we can leave the current node

	return if (($self->{location}->{node_name} eq 'marshy') && ($self->{time_at_node} == 1));
	return if (($self->{location}->{node_name} eq 'shallows') && ($self->{mature}) && ($self->{time_at_node} == 1));
	return if (($self->{location}->{node_name} eq 'rapids') && (!$self->{mature}) && ($self->{time_at_node} == 1));

	return if (($self->{location}->{node_name} eq 'net') && ($self->{mature}));
	return if (($self->{location}->{node_name} eq 'current') && (!$self->{mature}));

	# see if we can enter the next one

	my $dest;
	if ($self->{upstream}){
		if (scalar(@{$self->{location}->{child_nodes}})){
			$dest = @{$self->{location}->{child_nodes}}[0];
		}else{
			$dest = undef;
		}
	}else{
		$dest = $self->{location}->{parent_node};
	}

	if (defined($dest)){

	#	return if (($dest->{node_name} eq 'force field') && ($self->{location}->{power}));
	#	return if (($dest->{node_name} eq 'bridge') && ($self->{location}->{destroyed}));

	#	return if (($dest->{node_name} eq 'pump') && (!$self->{location}->{power}));
	#	return if (($dest->{node_name} eq 'fear') && ($self->{location}->{power}));

	#	return if (($dest->{node_name} eq 'lock') && ($self->{location}->{power}) && (!$self->{upstream}));
	#	return if (($dest->{node_name} eq 'inverse lock') && (!$self->{location}->{power}) && (!$self->{upstream}));

		$self->{location} = $dest;

		$self->{time_at_node} = 0;
	}else{

		# if there's nowhere to go, 
		# either spawn or print

		if ($self->{upstream}){
			$self->spawn();
		}else{
			$self->output();
		}
	}

}

sub spawn {
	my ($self) = @_;
	my $value = ($self->{location}->{spring})?$self->{location}->{node_name}:'UNKNOWN!!';
	my $new_salmon = new Language::Homespring::Salmon({
		'interp' => $self->{interp},
		'value' => $value,
		'upstream' => 0,
		'mature' => 0,
		'location' => $self->{location},
	});
	push @{$self->{interp}->{new_salmon}}, $new_salmon;
	$self->{upstream} = 0;
	$self->{mature} = 1;
}

sub output {
	my ($self) = @_;
	$self->{interp}->{output} .= $self->{value};
	$self->kill();
}

sub kill {
	my ($self) = @_;
	$self->{value} = 'DEAD';
	@{$self->{interp}->{salmon}} = grep{
		$_ ne $self
	}@{$self->{interp}->{salmon}};
}

1;

