# frozen_string_literal: true

require 'openssl'
require "dragonfly"
require_relative "cache/version"
require_relative "cache/local"

module Dragonfly
  module Cache
    
  end
end

Dragonfly::App.register_plugin(:dragonfly_cache) { Dragonfly::Cache::Plugin.new }
