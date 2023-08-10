# frozen_string_literal: true

class ActiveRecord::ConnectionAdapters::ConnectionPool
  prepend ::ActiveRecord::ShortLease::ConnectionPoolEnforcer
end