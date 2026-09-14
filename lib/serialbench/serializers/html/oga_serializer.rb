# frozen_string_literal: true

require_relative 'base_html_serializer'

module Serialbench
  module Serializers
    module Html
      class OgaSerializer < BaseHtmlSerializer
        def name
          'oga'
        end

        def parse(html_string)
          require 'oga'
          Oga.parse_html(html_string)
        end

        def serialize_document(document)
          document.to_xml
        end

        def available?
          return @available if defined?(@available)

          @available = begin
            require 'oga'
            Oga.parse_html('<p>probe</p>')
            true
          rescue StandardError, LoadError => e
            warn "#{name} unavailable: #{e.class}: #{e.message}"
            false
          end
        end

        def version
          return 'unknown' unless available?

          require 'oga'
          Oga::VERSION
        end

        def library_require_name
          'oga'
        end
      end
    end
  end
end
