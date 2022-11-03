# frozen_string_literal: true

require 'openssl'
require "dragonfly"
require_relative "cache/version"
require_relative "cache/local"

module Dragonfly
  module Plugin
    module Cache
      class Error < StandardError; end
      # Your code goes here...
    end
  end
end
