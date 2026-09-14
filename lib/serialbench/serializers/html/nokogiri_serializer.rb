# frozen_string_literal: true

require_relative 'base_html_serializer'

module Serialbench
  module Serializers
    module Html
      class NokogiriSerializer < BaseHtmlSerializer
        def name
          'nokogiri'
        end

        def capabilities
          super | Set.new(%i[xpath html5])
        end

        def parse(html_string)
          require 'nokogiri'
          Nokogiri::HTML5(html_string)
        end

        def xpath_query(document, expression)
          document.xpath(expression).size
        end

        def serialize_document(document)
          document.to_html
        end

        def available?
          return @available if defined?(@available)

          @available = begin
            require 'nokogiri'
            Nokogiri::HTML5('<p>probe</p>')
            true
          rescue StandardError, LoadError => e
            warn "#{name} unavailable: #{e.class}: #{e.message}"
            false
          end
        end

        def version
          return 'unknown' unless available?

          require 'nokogiri'
          Nokogiri::VERSION
        end

        def library_require_name
          'nokogiri'
        end
      end
    end
  end
end
