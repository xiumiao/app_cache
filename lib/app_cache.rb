require 'app_cache/version'
require 'app_cache/engine'
require 'app_cache/local_file_cache'
require "app_cache/railtie" if defined?(Rails)

module AppCache
  CACHE_TYPE_REDIS = 'redis'
  CACHE_TYPE_FILE = 'file'

  class << self
    attr_accessor :storage

    def new(cache_type, options = {})
      case cache_type
        when CACHE_TYPE_REDIS
          @storage = Redis.new(:url => options[:url])
        else
          @storage = AppCache::LocalFileCache.new(options[:file_path])
      end
      @storage
    end

    def sys_params_db
      h = {}
      AppCache::SystemParam.all.each do |sp|
        h.store(sp.param_code, sp.param_value)
      end
      return h
    end
  end
end