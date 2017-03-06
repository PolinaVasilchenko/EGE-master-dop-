# Copyright © 2013 Alexander S. Klenin
# Licensed under GPL version 2 or later.
# http://github.com/klenin/EGE
package EGE::Russian;

use strict;
use warnings;
use utf8;

use EGE::Random;

our @alphabet = split '', 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ';

sub join_comma_and { join(', ', @_[0 .. $#_ - 1]) . ' и ' . $_[-1] }

sub different {
    my ($cache, $items, $count) = @_;
    unless ($$cache) {
        $$cache = {};
        push @{$$cache->{substr($_, 0, 1)}}, $_ for @$items;
    }
    map rnd->pick(@{$$cache->{$_}}), rnd->pick_n($count, keys %$$cache);
}

1;
