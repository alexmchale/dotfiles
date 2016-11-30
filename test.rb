#!/usr/bin/env ruby

if true
  foo = 1
end

if false
  bar = 2
end

begin
  fizz = 3
rescue
  fuzz = 4
end

begin
  fail "wtf"
  beep = 5
rescue => e
  honk = 6
end

p [ foo, bar, fizz, fuzz, beep, honk ]
