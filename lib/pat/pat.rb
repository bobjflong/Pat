require 'whittle'
require 'ribimaybe'

module Pat
  class MatchFetcher
    include Ribimaybe::Maybe

    def self.from_list(ary, ans)
      pointer = -1
      MatchFetcher.new(
        ans.merge(ans) do |key, val|
          res = val.call(ary, pointer)
          pointer = res.pointer
          res.extract
        end
      )
    end

    def initialize(values)
      @values = values
    end

    def method_missing(ident)
      @values.fetch(ident, Nothing)
    end
  end

  class ::Ribimaybe::Maybe::Just
    def run(*values)
      values.map do |value|
        value.map { |v| @value = @value.curry.(v) }
      end.last
    end
  end

  class ::Array
    def pat(pattern)
      parsed_grammar = Pat::Cache.lookup(pattern) { (Grammar.new).parse(pattern) }
      yield (MatchFetcher.from_list(self, parsed_grammar))
    end
  end

  class Grammar < Whittle::Parser

    class NonUniqueVariables < StandardError; end

    extend ::Ribimaybe::Maybe

    rule(":")
    rule("@")

    rule(:name => /[_a-zA-Z]+/).as { |val| val.to_sym }

    rule(:full) do |r|

      r[:name, "@", :full].as do |a, _, rest|
        check_for_dupes!(a, rest)
        {
          a => ->(*args) do
            Pat::WholeListMatcher.new(*args)
          end
        }.merge(rest)
      end

      r[:name, ":", :name].as do |a, _, b|
        check_for_dupes!(a, b)
        {
          a => ->(list, pointer) do
            Pat::NodeMatcher.new(list, pointer + 1)
          end,
          b => ->(list, pointer) do
            Pat::PartialMatcher.new(list, pointer + 1)
          end
        }
      end

      r[:name, ":", :full].as do |a, _, rest|
        check_for_dupes!(a, rest)
        {
          a => ->(list, pointer) do
            Pat::NodeMatcher.new(list, pointer + 1)
          end
        }.merge(rest)
      end
    end

    start(:full)

    private

    def self.check_for_dupes!(x, y)
      if y.is_a?(Hash)
        raise NonUniqueVariables if y.include?(x)
      else
        raise NonUniqueVariables if x == y
      end
    end
    private_class_method :check_for_dupes!
  end
end
