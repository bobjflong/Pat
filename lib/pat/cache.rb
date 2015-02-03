module Pat
  class Cache
    def self.lookup(pattern)
      Thread.current["Pat::Cache-#{pattern}"] ||= yield
    end
  end
end
