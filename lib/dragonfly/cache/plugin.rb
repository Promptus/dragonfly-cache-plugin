# frozen_string_literal: true

require 'openssl'
require "dragonfly"
require_relative "local"

module Dragonfly
  module Cache
    class Plugin
      
      def call(app, options = {})
        public_path = options[:public_path]
        raise 'public_path does not exist' unless File.exists?(public_path)

        app.env[:cache_plugin] = if options[:adapter].to_sym == :local
          cache_path  = options[:cache_path] || 'dragonfly-cache'
          Dragonfly::Cache::Adapter::Local.new(
            public_path: public_path,
            cache_path: cache_path
          )
        else
          Dragonfly::Cache::Adapter::UrlFormat.new(
            public_path: public_path,
            url_format: app.server.url_format
          )
        end
        
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
