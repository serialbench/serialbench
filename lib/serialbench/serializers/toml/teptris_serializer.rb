# frozen_string_literal: true

require_relative 'base_toml_serializer'

module Serialbench
  module Serializers
    module Toml
      class TeptrisSerializer < BaseTomlSerializer
        def name
          'teptris'
        end

        def parse(toml_string)
          require 'teptris'
          Teptris::TOML.load(toml_string)
        end

        def generate(object, _options = {})
          require 'teptris'
          Teptris::TOML.dump(object)
        end

        def available?
          return @available if defined?(@available)

          @available = begin
            require 'teptris'
            Teptris::TOML.load("probe = true\n")
            true
          rescue StandardError, LoadError => e
            warn "#{name} unavailable: #{e.class}: #{e.message}"
            false
          end
        end

        def version
          return 'unknown' unless available?

          require 'teptris'
          Teptris::VERSION
        end

        def library_require_name
          'teptris'
        end
      end
    end
  end
end
