# Copyright © 2014 Darya D. Gornak
# Licensed under GPL version 2 or later.
# http://github.com/klenin/EGE

package EGE::Gen::Db::Db03;
use base 'EGE::GenBase::SingleChoice';

use strict;
use warnings;
use utf8;

use EGE::Random;
use EGE::Prog qw(make_expr make_block);
use EGE::Prog::Lang;
use EGE::Html;
use EGE::SQL::Table;
use EGE::Russian::Product;
use EGE::Russian::Time;
use EGE::SQL::Queries;
use EGE::SQL::RandomTable qw(create_table);

sub trivial_update {
    my ($self) = @_;
    my $products = EGE::SQL::RandomTable::create_table(column => 6, row => 8);
    my $old_products_text = $products->table_html;
    my ($cond, $update);
    my ($m1, $m2, $m3, $m4) = rnd->shuffle(@{$products->{fields}}[1 .. 5]);
    my ($l, $r) = map $products->fetch_val($_), ($m2, $m3);
    my $e = make_expr([ rnd->pick('>', '<', '<=', '>='), $m1, $m4 ]);
    $update = EGE::SQL::Update->new($products, make_block ([ '=', $m2, $l, '=', $m3, $r ]), $e);
    $update->run;
    my $select = EGE::SQL::Select->new($products, [], make_expr([ rnd->pick('>', '<', '<=', '>='), $m2,  $m4]));
    $self->{text} = sprintf
        "Дана таблица <tt>%s</tt>: \n%s\n" .
        'Сколько записей в этой таблицы будут удовлетворять запросу %s<br/> после выполнения запроса %s?',
        $products->name, $old_products_text, $select->text_html_tt, $update->text_html_tt;
    my $ans = $select->run->count;
    $self->variants($ans, rnd->pick_n(3, grep $_ != $ans, 1 .. $products->count));
}

1;
