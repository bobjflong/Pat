Pat
---

Pat is a tool for safe array operations in Ruby. Basically it is pattern matching + applicative
functors (which are provided by the Ribimaybe gem).

Example: safely add the head of a list to the second item in the list

```ruby

using Pat::Extensions

[1,2,3].pat('x:y:_') do |v|
  Just do |x,y|
    x + y
  end.run(v.x, v.y)
end

# => Just(3)
```

If the list is unsuitable, the whole operation fails gracefully without manual error handling:


```ruby
[1].pat('x:y:_') do |v|
  Just do |x,y|
    x + y
  end.run(v.x, v.y)
end

# => Nothing
```
