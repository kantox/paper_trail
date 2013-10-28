require 'singleton'

module PaperTrail
  class Config
    include Singleton
    attr_accessor :enabled, :timestamp_field, :serializer, :version_limit
    attr_accessor :redis_host, :redis_port, :redis_db, :redis, :redis_enabled

    def initialize
      @enabled         = true # Indicates whether PaperTrail is on or off.
      @timestamp_field = :created_at
      @serializer      = PaperTrail::Serializers::Yaml
      @redis_enabled   ||= true
      if @redis_enabled
        @redis_db        ||= 15
        @redis_host      ||= 'localhost'
        @redis_port      ||= 6379
        @redis = Redis.new(:host => @redis_host, :port => @redis_port, :db => @redis_db)
      end
    end

    def redis_it(object)
      @redis.lpush 'versions', object.to_json if @redis_enabled
    end
  end
end
