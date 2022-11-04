# frozen_string_literal: true

require 'openssl'
require "dragonfly"

module Dragonfly
  module Cache
  end
end

require_relative "cache/version"
require_relative "cache/adapter/base"
require_relative "cache/adapter/local"
require_relative "cache/adapter/url_format"

Dragonfly::App.register_plugin(:dragonfly_cache) { Dragonfly::Cache::Plugin.new }
