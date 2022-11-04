# frozen_string_literal: true

require 'openssl'
require "dragonfly"

module Dragonfly
  module Cache
    class Plugin
      
      def call(app, options = {})
        public_path = options[:public_path]
        raise ::Dragonfly::Cache::ConfigurationError, 'public_path does not exist' unless File.exists?(public_path)
        options[:adapter] ||= :url_format

        app.env[:cache_plugin] = if options[:adapter].to_sym == :local
          cache_path  = options[:cache_path] || 'dragonfly-cache'
          Dragonfly::Cache::Adapter::Local.new(
            public_path: public_path,
            cache_path: cache_path
          )
        elsif :url_format
          Dragonfly::Cache::Adapter::UrlFormat.new(
            public_path: public_path,
            url_format: app.server.url_format
          )
        else
          raise ::Dragonfly::Cache::ConfigurationError, "Adapter #{options[:adapter]} is invalid"
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
