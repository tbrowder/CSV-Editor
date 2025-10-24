use v6.d;
use Test;
use JSON::Fast;
use MONKEY-TYPING;

# simple META presence test
plan 1;

ok 'META6.json'.IO.e, 'META6.json exists';
