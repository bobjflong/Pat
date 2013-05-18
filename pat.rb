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
        a => Proc.new { |list, pointer| list[pointer]},
        b => Proc.new { |list, pointer| list[pointer..-1]}
      }
    }

    r[:name, ":", :full].as { |a, _, rest| {
        a => Proc.new { |list, pointer| list[pointer]}
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
      pointer += 1
      val.call(self, pointer)
    end)
  end
end
