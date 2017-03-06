# Copyright © 2010-2012 Alexander S. Klenin
# Copyright © 2012 V. Kevroletin
# Licensed under GPL version 2 or later.
# http://github.com/klenin/EGE
package EGE::Gen::EGE::B12;
use base 'EGE::GenBase::DirectInput';

use strict;
use warnings;
use utf8;

use EGE::Random;
use EGE::Html;
use EGE::Russian::Sports;

use List::Util 'min';

sub search_query {
    my ($self) = @_;
    my ($item1, $item2) = rnd->pick_n(2, @EGE::Russian::Sports::sports);
    my ($item1_cnt, $item2_cnt) = map { 10 * rnd->in_range(200, 999) } 1, 2;
    my $both_cnt = 10 * rnd->in_range(100, int min($item1_cnt, $item2_cnt) / 20);

    my @variants = (
        [ "$item1 | $item2", $item1_cnt + $item2_cnt - $both_cnt ],
        [ $item1, $item1_cnt ],
        [ $item2, $item2_cnt ],
        [ "$item1 &amp; $item2", $both_cnt ]);

    my $correct = splice @variants, rnd->in_range(0, 3), 1;
    $self->{correct} = $correct->[1];

    my $table = html->table([
        html->row('th', '<b>Запрос</b>', '<b>Найдено страниц (в тысячах)</b>'),
        map html->row('td', @$_), @variants
        ], { border => 1, html->style(text_align => 'center') });
    $self->{text} =
        'В языке запросов поискового сервера для обозначения логической операции «ИЛИ» ' .
        'используется символ «|», а для логической операции «И» – символ «&amp;». ' .
        'В таблице приведены запросы и количество найденных по ним страниц некоторого ' .
        "сегмента сети Интернет. $table " .
        'Какое количество страниц (в тысячах) будет найдено по запросу<br/>' .
        "<i><b>$correct->[0]?</b></i><br/> " .
        'Считается, что все запросы выполнялись практически одновременно, так что набор ' .
        'страниц, содержащих все искомые слова, не изменялся за время выполнения запросов.';
}

1;
