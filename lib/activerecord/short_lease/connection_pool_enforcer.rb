# frozen_string_literal: true

module ActiveRecord
  module ShortLease
    module ConnectionPoolEnforcer
      def checkout
        puts "#{ActiveSupport::IsolatedExecutionState[:short_lease_safe_checkout]}"
        puts "#{Fiber[:short_lease_connections]}"
        
        if Fiber[:short_lease_connections] &&
          !ActiveSupport::IsolatedExecutionState[:short_lease_safe_checkout]
          raise "Call safe_checkout before checkout"
        end
        
        puts "Checking out a connection..."
        super
      end

      def checkin(...)
        puts "Checking in a connection..."
        super
      end
    end
  end
end