lib = File.expand_path('..', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'nokogiri'
require 'nipper_parser/version'
require 'nipper_parser/parsers/parser_utils'
require 'nipper_parser/parsers/information'
require 'nipper_parser/parsers/security_audit'
require 'nipper_parser/parsers/vulnerability_audit'
require 'nipper_parser/parsers/filtering_complexity'

module NipperParser

  # Config opens nipper studio XML generated report and initially parses the XML file
  #
  # @example Basic usage
  #   nipper_parser = NipperParser::Config.open('nipper-network-devices.xml')
  #   pp nipper_parser.information.title
  #   pp nipper_parser.information.author
  #   pp nipper_parser.information.date
  #   pp nipper_parser.security_audit
  #   pp nipper_parser.security_audit.findings
  #   pp nipper_parser.security_audit.findings[0]
  #   pp nipper_parser.security_audit.findings[0].title
  #   pp nipper_parser.security_audit.findings[0].impact
  #   pp nipper_parser.security_audit.conclusions
  #   pp nipper_parser.security_audit.conclusions.per_device
  #   pp nipper_parser.security_audit.recommendations.list
  #   pp nipper_parser.security_audit.mitigation_classification
  #
  # @param file [File]
  # @attr_reader information [Information] object of Information parser
  # @attr_reader security_audit [SecurityAudit] object of SecurityAudit parser
  class Config
    # create an alias for new method.
    # just wanted to call open instead of #new method
    class << self
      alias_method :open, :new
    end

    # @!attribute #information for report general information section, it calls [Information] class
    attr_reader :information
    # @!attribute #security_audit for security audit section, it calls [SecurityAudit] class
    attr_reader :security_audit
    # @!attribute #vulnerability_audit for report vulnerability audit section, it calls [VulnerabilityAudit] class
    attr_reader :vulnerability_audit
    # @!attribute #filtering_complexity for report filtering complexity section, it calls [FilteringComplexity] class
    attr_reader :filtering_complexity

    def initialize(file)
      config_parsed = Nokogiri::XML(File.open(file))

      # instantiate all parsers
      @information           = Information.new(config_parsed)
      @security_audit        = SecurityAudit.new(config_parsed)
      @vulnerability_audit   = VulnerabilityAudit.new(config_parsed)
      @filtering_complexity  = FilteringComplexity.new(config_parsed)
    end
  end

end



if __FILE__ == $0
  require 'pp'
  nipper_parser = NipperParser::Config.open(ARGV[0])
  pp nipper_parser.information.title
  pp nipper_parser.information.author
  pp nipper_parser.information.date
  pp nipper_parser.security_audit.title
  pp nipper_parser.security_audit.introduction.security_issue_overview
  pp nipper_parser.security_audit.findings
  finding = nipper_parser.security_audit.findings[0]
  pp finding.class
  pp finding.title
  pp finding.impact
  pp finding.conclusions
  pp finding.conclusions.per_device
  pp finding.recommendations.list
  pp finding.mitigation_classification
  pp nipper_parser.vulnerability_audit.class
  pp nipper_parser.vulnerability_audit.title
  pp nipper_parser.vulnerability_audit.introduction
  pp nipper_parser.vulnerability_audit.introduction.excluded_devices
  cve = nipper_parser.vulnerability_audit.cves[0]
  pp cve.title
  pp cve.rating
  pp cve.summary
  pp cve.affected_devices
  pp cve.vendor_sec_advisories
  pp cve.references
  pp nipper_parser.vulnerability_audit.conclusions
  pp nipper_parser.vulnerability_audit.conclusions.list_critical
  pp nipper_parser.vulnerability_audit.recommendations
  pp nipper_parser.filtering_complexity
  pp nipper_parser.filtering_complexity.title
  pp nipper_parser.filtering_complexity.introduction
  pp nipper_parser.filtering_complexity.introduction.devices
  observations = nipper_parser.filtering_complexity.observations
  puts  "Number of observations: #{observations.size}"
  observation = observations[2]
  pp observation.title
  pp observation.index
  pp observation.ref
  pp observation.overview
  pp observation.affected_devices
  pp observation.affected_devices[0].title
  puts
  pp observation.affected_devices[0].details
  puts
  pp observation.affected_devices[0].details_tables[0].title
  pp observation.affected_devices[0].details_tables[0].tables

end
