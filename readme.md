Pat
---

```ruby
[1,2,3,4,5].pat('x:y:z:xs') do |vals|
  puts vals[:x].to_s
  puts vals[:y].to_s
  puts vals[:z].to_s
  puts vals[:xs].to_s
end
```
