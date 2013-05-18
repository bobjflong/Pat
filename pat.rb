 require 'whittle'

class Pattern < Whittle::Parser
  rule(":")
  rule("@")

  rule(:name => /[a-zA-Z]+/).as { |val| val.to_sym }

  rule(:full) do |r|
    
    r[:name, "@", :full].as { |a, _, rest| {
        a => Proc.new { |list| list }
      }.merge(rest)
    }

    r[:name, ":", :name].as { |a, _, b| { 
        a => Proc.new { |list| list[0]},
        b => Proc.new { |list| list[1..-1]}
      }
    }
  end

  start(:full)
end

class Array
  define_method('pat') do |pattern, &block|
    ans = (Pattern.new).parse(pattern)
    block.call(ans.merge(ans) do |key, val|
      val.call(self)
    end)
  end
end

[1,2,3].pat('y@x:xs') do |vals|
  puts vals[:x].to_s
  puts vals[:xs].to_s
  puts vals[:y].to_s
end
