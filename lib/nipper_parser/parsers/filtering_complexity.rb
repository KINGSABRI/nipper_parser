module NipperParser

  # FilteringComplexity parses the 'Filtering Complexity' part.
  #   Filtering Complexity part contains the following sections:
  #     - introduction
  #     - Findings
  #
  # @example Basic Usage:
  #   require 'nokogiri'
  #   require 'pp'
  #   config = Nokogiri::XML open(ARGV[0])
  #   vulnerability_audit = NipperParser::FilteringComplexity.new(config)
  #   pp FilteringComplexity.class
  #   pp FilteringComplexity.introduction
  #   pp FilteringComplexity.introduction.excluded_devices
  #   filter = FilteringComplexity.cves[0]
  #
  # @param config [Nokogiri::XML] parsed XML
  # @attr_reader title the report title
  # @attr_reader config a parsed XML [Nokogiri::XML] object
  class FilteringComplexity

  end
end
