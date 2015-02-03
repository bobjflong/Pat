require 'benchmark'
require_relative '../lib/pat'

using Pat::Extensions

vars = []
100.times do
  vars << [*('a'..'z')].sample(5).join
end
vars = vars.join(':')

x = Benchmark.measure do
  [*(1..4000000)].pat(vars) { }
end

y = Benchmark.measure do
  ans = []
  for v in (1..4000000) do
    ans << v
  end
end

puts x

puts y
