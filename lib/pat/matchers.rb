require 'ribimaybe'

module Pat
  class ListMatcher
    attr_reader :list, :pointer

    include Ribimaybe::Maybe

    def initialize(list, pointer)
      @list = list
      @pointer = pointer
    end

    private

    def maybe(x)
      return Nothing if is_blank?(x)
      Maybe(x)
    end

    def is_blank?(x)
      x.nil? || (x.is_a?(Array) && x.empty?)
    end
  end

  class WholeListMatcher < ListMatcher
    def extract
      maybe(@list)
    end
  end

  class NodeMatcher < ListMatcher
    def extract
      maybe(@list.fetch(@pointer, nil))
    end
  end

  class PartialMatcher < ListMatcher
    def extract
      maybe(@list[@pointer..-1])
    end
  end
end
