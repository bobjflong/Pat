Pat
---

```ruby
[1,2,3].pat('y@x:xs') do |vals|
  puts vals[:x].to_s  # => 1
  puts vals[:xs].to_s # => [2,3]
  puts vals[:y].to_s  # => [1,2,3]
end
```
