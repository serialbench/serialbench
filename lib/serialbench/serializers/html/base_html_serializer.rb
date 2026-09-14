# frozen_string_literal: true

require_relative '../base_serializer'

module Serialbench
  module Serializers
    module Html
      class BaseHtmlSerializer < BaseSerializer
        def self.format
          :html
        end

        def capabilities
          super | Set.new(%i[dom parse generate])
        end

        def features
          {
            html5: supports?(:html5),
            xpath: supports?(:xpath)
          }
        end

        def generate(data)
          data.is_a?(Hash) ? from_hash(data) : serialize_document(data)
        end

        def from_hash(hash)
          rows = hash.flat_map do |key, value|
            case value
            when Hash then value.map { |k, v| "<tr><td>#{k}</td><td>#{v}</td></tr>" }
            else ["<tr><td>#{key}</td><td>#{value}</td></tr>"]
            end
          end
          serialize_document(parse("<html><body><table>#{rows.join}</table></body></html>"))
        end
      end
    end
  end
end
