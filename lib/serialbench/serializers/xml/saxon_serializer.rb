# frozen_string_literal: true

require_relative 'base_xml_serializer'
require 'open3'
require 'tmpdir'

module Serialbench
  module Serializers
    module Xml
      # Saxon-HE via its Java CLI: the reference XSLT 2.0/3.0 engine.
      # Cold-process semantics: every iteration is a full JVM + compile +
      # transform, so ips is comparable to leptris only end-to-end, never
      # per-transform — features record cold_process: true.
      class SaxonSerializer < BaseXmlSerializer
        def name
          'saxon-he'
        end

        def capabilities
          Set.new(%i[xslt xslt30])
        end

        def features
          { 'xslt_version' => '3.0', 'cold_process' => true }
        end

        def classpath
          jars = [ENV['SAXON_JAR'], ENV['XMLRESOLVER_JAR']].compact
          jars.empty? ? nil : jars.join(File::PATH_SEPARATOR)
        end

        def xslt_apply(source_xml, stylesheet)
          Dir.mktmpdir('saxonbench') do |dir|
            src = File.join(dir, 's.xml')
            xsl = File.join(dir, 's.xsl')
            File.write(src, source_xml)
            File.write(xsl, stylesheet)
            out, _err, _st = Open3.capture3('java', '-cp', classpath, 'net.sf.saxon.Transform',
                                            "-xsl:#{xsl}", "-s:#{src}")
            raise Error, "saxon transform failed: #{out}#{_err}"[0, 200] unless _st.success?

            out
          end
        end

        def available?
          return @available if defined?(@available)

          @available = begin
            cp = classpath
            raise LoadError, 'SAXON_JAR / XMLRESOLVER_JAR not set' unless cp

            out, _err, st = Open3.capture3('java', '-cp', cp, 'net.sf.saxon.Version')
            raise LoadError, 'java failed' unless st.success?

            true
          rescue StandardError, LoadError => e
            warn "#{name} unavailable: #{e.class}: #{e.message}"
            false
          end
        end

        def version
          return 'unknown' unless available?

          out, = Open3.capture3('java', '-cp', classpath, 'net.sf.saxon.Version')
          out[/Saxon-HE (\S+)/, 1] || out.strip[0, 40]
        end
      end
    end
  end
end
