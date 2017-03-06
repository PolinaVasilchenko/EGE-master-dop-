# Copyright © 2015 Anton Kim
# Licensed under GPL version 2 or later.
# http://github.com/klenin/EGE
package EGE::Gen::Alg::Sorting;
use base 'EGE::GenBase::Sortable';

use strict;
use warnings;
use utf8;

use EGE::Html;
use EGE::Random;
use EGE::Prog::Alg;
use EGE::Prog;

sub sort_line {
    # Не используется construct, потому что на Basic'е end выглядят по-разному.
    my ($self) = @_;
    $self->{text} =
        'Отсортируйте строки таким образом, чтобы они образовали алгоритм сортировки ' .
        'массива <code>a</code> длиной <code>n</code>. ' .
        '<p><i>Примечание 1.</i> Начало и конец условных операторов и операторов цикла должны иметь одинаковый цвет, ' .
        'недопустимо использовать начало и конец разного цвета, даже если они имеют одинаковый текст.</p>' .
        '<p><i>Примечание 2.</i> Индексация массивов на всех языках начинается с <code>0</code> и ' .
        'заканчивается <code>n - 1</code>.</p>';

    my $b = rnd->pick(values %EGE::Prog::Alg::sortings);
    my @colors = rnd->shuffle(qw(blue fuchsia green maroon navy olive purple red silver teal yellow));
    my @langs = qw(Basic C Alg Pascal);
    for my $lang (@langs) {
        my $code = EGE::Prog::make_block($b)->to_lang_named($lang, {
                html => {
                    coloring => [ @colors ],
                    lang_marking => 1,
                },
                body_is_block => 1,
                lang_marking => 1,
                unindent => 1,
            });
        my @cur_v = split '\n', $code;
        $self->{variants}->[$_] .= $cur_v[$_] for 0 .. scalar(@cur_v) - 1;
    }
    $self->{correct} = [ 0 .. (@{$self->{variants}} - 1) ];
    $self->{options} = { map { $_ => EGE::Prog::lang_names->{$_} } @langs };
    1;
}
1;
