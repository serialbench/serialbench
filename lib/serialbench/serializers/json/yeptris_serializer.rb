# frozen_string_literal: true

require_relative 'base_json_serializer'

module Serialbench
  module Serializers
    module Json
      # Yeptris JSON side: parsing only — no dump in 0.2.x
      class YeptrisSerializer < BaseJsonSerializer
        def name
          'yeptris-json'
        end

        def parse(json_string)
          require 'yeptris'
          Yeptris::JSON.load(json_string)
        end

        def capabilities
          Set.new(%i[dom parse])
        end

        def available?
          return @available if defined?(@available)

          @available = begin
            require 'yeptris'
            Yeptris::JSON.load('{"probe":true}')
            true
          rescue StandardError, LoadError
            false
          end
        end

        def version
          return 'unknown' unless available?

          require 'yeptris'
          Yeptris::VERSION
        end

        def library_require_name
          'yeptris'
        end
      end
    end
  end
end
