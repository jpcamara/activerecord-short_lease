# frozen_string_literal: true

require "fiber"
require "active_record"
require "after_commit_everywhere"
require_relative "short_lease/version"
require_relative "short_lease/connection_pool_enforcer"

require "active_support/lazy_load_hooks"

ActiveSupport.on_load(:active_record) do
  require_relative "short_lease/include"
end

# ActiveRecord::Base.connection_pool.connections.each { |conn|
#   ActiveRecord::Base.connection_pool.checkin(conn) if conn.in_use?
# }; nil

# ActiveRecord::Base.connection_pool.connections.select { |conn| conn.owner == Thread.current }.each { |conn|
#   ActiveRecord::Base.connection_pool.checkin(conn) if conn.in_use?
# }; nil

# ActiveRecord::ShortLease.explicit_connections_only do
#   Async { |task| 
#     10.times.map {
#       task.async {
#         ActiveRecord::ShortLease.explicit_connections_only do
#           ActiveRecord::ShortLease.safe_checkout { 
#             ActiveRecord::Base.connection.execute "SELECT pg_sleep(1);" 
#           }
#         end
#       }
#     }.map(&:wait)
#   }.wait
# end; nil

module ActiveRecord
  module ShortLease
    class Error < StandardError; end
    
    def self.explicit_connections_only
      was = Fiber[:short_lease_connections]
      if AfterCommitEverywhere.in_transaction?
        raise 'ActiveRecord::Base.explicit_connections_only cannot be used in a transaction'
      end
      ActiveRecord::Base.connection_handler.clear_active_connections!
      Fiber[:short_lease_connections] = true
      yield
    ensure
      Fiber[:short_lease_connections] = was
    end

    def self.safe_checkout
      was = ActiveSupport::IsolatedExecutionState[:short_lease_safe_checkout]
      ActiveSupport::IsolatedExecutionState[:short_lease_safe_checkout] = true
      yield
    ensure
      ActiveSupport::IsolatedExecutionState[:short_lease_safe_checkout] = was
      ActiveRecord::Base.connection_handler.clear_active_connections!
    end
  end
end
