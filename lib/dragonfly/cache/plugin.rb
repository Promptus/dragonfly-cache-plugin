# frozen_string_literal: true

require 'openssl'
require "dragonfly"
require_relative "local"

module Dragonfly
  module Cache
    class Plugin
      
      def call(app, options = {})
        public_path = options[:public_path]
        cache_path  = options[:cache_path] || 'dragonfly-cache'
        app.env[:cache_plugin] = Dragonfly::Cache::Local.new(public_path: public_path, cache_path: cache_path)
        
        app.server.before_serve do |job, env|
          app.env[:cache_plugin].store(job)
        end

        app.define_url do |app, job, opts|
          app.env[:cache_plugin].url_for(app, job, opts)
        end
      end

    end
  end
end

Dragonfly::App.register_plugin(:dragonfly_cache) { Dragonfly::Plugin::Cache.new }
