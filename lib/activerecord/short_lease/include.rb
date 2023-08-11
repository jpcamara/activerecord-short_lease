# frozen_string_literal: true

module ActiveRecord
  module ConnectionAdapters
    class ConnectionPool
      prepend ::ActiveRecord::ShortLease::ConnectionPoolEnforcer
    end
  end
end
