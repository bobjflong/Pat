require 'whittle'

class Pattern < Whittle::Parser
  rule(":")
  rule("@")

  rule(:name => /[a-zA-Z]+/).as { |val| val.to_sym }

  rule(:full) do |r|
    
    r[:name, "@", :full].as { |a, _, rest| {
        a => Proc.new { |list, pointer| [pointer, list] }
      }.merge(rest)
    }

    r[:name, ":", :name].as { |a, _, b| { 
        a => Proc.new { |list, pointer| [pointer+1, list[pointer + 1]] },
        b => Proc.new { |list, pointer| [pointer+1, list[pointer + 1..-1]] }
      }
    }

    r[:name, ":", :full].as { |a, _, rest| {
        a => Proc.new { |list, pointer| [pointer+1, list[pointer + 1]] }
      }.merge(rest)
    }
  end

  start(:full)
end

class Array
  define_method('pat') do |pattern, &block|
    ans = (Pattern.new).parse(pattern)
    pointer = -1
    block.call(ans.merge(ans) do |key, val|
      res = val.call(self, pointer)
      pointer = res[0]
      res[1]
    end)
  end
end

[1,2,3,4,5].pat('full@x:y:z:xs') do |vals|
  puts vals[:x].to_s
  puts vals[:y].to_s
  puts vals[:z].to_s
  puts vals[:xs].to_s
  puts vals[:full].to_s
end
