# frozen_string_literal: true

require "async"

RSpec.describe ActiveRecord::ShortLease do
  def active_connection?
    ActiveRecord::Base.connection_pool.active_connection?
  end

  def in_use_count
    ActiveRecord::Base.connection_pool.connections.count(&:in_use?)
  end

  def exec_query(query)
    ActiveRecord::Base.connection.execute(query)
  end

  before do
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActiveRecord::Base.logger.level = Logger::DEBUG
    ActiveRecord::Base.establish_connection(
      adapter: 'postgresql',
      host: 'localhost',
      username: ENV['POSTGRES_USER'],
      password: ENV['POSTGRES_PASSWORD'],
      database: ENV['POSTGRES_DB'],
      pool: 5,
      checkout_timeout: 20
    )
  end

  it "has a version number" do
    expect(ActiveRecord::ShortLease::VERSION).not_to be nil
  end

  it "does something useful" do
    puts "a: #{}"
    ActiveRecord::Base.transaction do
      puts "b: #{in_use_count}"
      puts "c: #{in_use_count}"
      exec_query(
        "SELECT pg_sleep(1)"
      )
      puts "d: #{in_use_count}"
    end
    puts "e: #{in_use_count}"
  end

  it "does something else" do
    ActiveRecord::ShortLease.explicit_connections_only do
      Async { |task| 
        10.times.map {
          task.async {
            ActiveRecord::ShortLease.safe_checkout { ActiveRecord::Base.connection.execute "SELECT pg_sleep(1);" }
          }
        }.map(&:wait)
      }.wait
    end
  end
end
