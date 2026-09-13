# frozen_string_literal: true

require_relative 'base_yaml_serializer'

module Serialbench
  module Serializers
    module Yaml
      class YeptrisSerializer < BaseYamlSerializer
        def name
          'yeptris-yaml'
        end

        def parse(yaml_string)
          require 'yeptris'
          Yeptris::YAML.load(yaml_string)
        end

        def generate(object, _options = {})
          require 'yeptris'
          Yeptris::YAML.dump(object)
        end

        def stream_parse(yaml_string, &block)
          require 'yeptris'
          Yeptris::YAML.load_stream(yaml_string).each { |doc| block.call(:document, doc) }
        end

        def capabilities
          super | Set.new(%i[streaming])
        end

        def available?
          return @available if defined?(@available)

          @available = begin
            require 'yeptris'
            Yeptris::YAML.load('probe: true')
            true
          rescue StandardError, LoadError => e
            warn "#{name} unavailable: #{e.class}: #{e.message}"
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
