require 'ribimaybe'

module Pat
  class ListMatcher
    attr_reader :list, :pointer

    include Ribimaybe::Maybe

    def initialize(list, pointer)
      @list = list
      @pointer = pointer
    end
  end

  class WholeListMatcher < ListMatcher
    def extract
      Maybe(@list)
    end
  end

  class NodeMatcher < ListMatcher
    def extract
      Maybe(@list.fetch(@pointer, nil))
    end
  end

  class PartialMatcher < ListMatcher
    def extract
      Maybe(@list[@pointer..-1])
    end
  end
end
