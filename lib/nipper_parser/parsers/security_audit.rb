require 'date'

module NipperParser

  # SecurityAudit parses the 'Security Audit' section 
  #
  # @example Basic Usage
  #   require 'nokogiri'
  #   require 'pp'
  #   config = Nokogiri::XML open(ARGV[0])
  #   security_audit = NipperParser::SecurityAudit.new(config)
  #   pp security_audit.introduction.index
  #   pp security_audit.introduction.title
  #   pp security_audit.introduction.devices
  # @example Dealing with findings
  #   finding = security_audit.findings[1]
  #   pp finding.index
  #   pp finding.title
  #   pp finding.ref
  #   pp finding.affected_devices
  #   pp finding.finding
  #   pp finding.impact
  #   pp finding.recommendation
  # @example Dealing with report summaries
  #   pp security_audit.conclusions
  #   pp security_audit.conclusions.per_device
  #   pp security_audit.conclusions.list_critical
  #   pp security_audit.recommendations.list
  # 
  # @param config [Nokogiri::XML] parsed XML
  # @attr_reader title the report title
  # @attr_reader config a parsed XML [Nokogiri::XML] object
  class SecurityAudit
    include ParserUtils

    # Skeleton for SecurityAudit parts
    Introduction = Struct.new(
        :index, :title, :ref, :date, :devices,
        :security_issue_overview, :rating
    )
    Finding = Struct.new(
        :index, :title, :ref,
        :affected_devices, :rating,
        :finding, :impact, :ease, :recommendation
    )
    Conclusion = Struct.new(
        :index, :title, :ref,
        :per_device, :per_rating,
        :list_critical, :list_high,
        :list_medium, :list_low, :list_info
    )
    Recommendations = Struct.new(
        :index, :title, :ref,
        :list
    )
    MitigationClassification = Struct.new(
        :index, :title, :ref,
        :per_device, :per_rating
    )


    attr_reader :config, :title

    def initialize(config)
      @config = config.xpath("//report/part[@ref='SECURITYAUDIT']")[0].elements
      @title  = @config[0].elements[1].attributes['title'].text
    end

    def introduction
      intro = @config[0]
      index     = attributes(intro).index
      title     = attributes(intro).title
      reference = attributes(intro).ref
      date      = Date.parse(intro.elements[0].text).to_s
      # devices   = intro.elements[1].elements[1].elements.map do |device|
      #   { device: device.elements[0].text,
      #     name: device.elements[1].text,
      #     os: device.elements[2].text
      #   }
      # end
      devices = generate_table(intro.elements[1].elements)
      security_issue_overview = intro.elements[2].elements[1..4].map do |issue|
        {issue['title'] => issue.text}
      end
      rating    = intro.elements[3].elements[2].elements[1].map do |rate|
        {rate.elements[0].text => rate.elements[1].text}
      end

      Introduction.new(
          index, title, reference, date, devices,
          security_issue_overview, rating
      )
    end

    # Parse findings from given configurations
    def findings
      findings = @config.to_a.clone
      findings.shift  # pop first item, the introduction
      findings.pop(3) # pop last 3 item, conclusion, recommendations, Mitigation Classification

      findings.map do |finding|
        Finding.new(
            attributes(finding).index,
            attributes(finding).title,
            attributes(finding).ref,
            finding.elements[0].elements[0].elements.map(&:attributes),            # affected_devices
            finding.elements[0].elements[1].elements.map{|r| {r.name => r.text}},  # rating
            finding.elements[2].elements.first(2).map(&:text),                     # finding
            finding.elements[3].elements.text,                                     # impact
            finding.elements[4].elements.text,                                     # ease
            finding.elements[5].elements.text                                      # recommendation
        )
      end
    end

    # Conclusions
    def conclusions
      conc = @config[-3]
      index     = attributes(conc).index
      title     = attributes(conc).title
      reference = attributes(conc).ref
      # per_device = conc.elements[1].elements[1].elements.map do |device|
      #   { device: device.elements[0].text,
      #     name: device.elements[1].text,
      #     issues: device.elements[2].text,
      #     highest_rating: device.elements[3].text
      #   }
      # end
      per_device = generate_table(conc.elements[1].elements)
      per_rating = {
          critical: conc.elements[3].elements.map(&:text),
          high:     conc.elements[5].elements.map(&:text),
          medium:   conc.elements[7].elements.map(&:text),
          low:      conc.elements[9].elements.map(&:text),
          info:     conc.elements[11].elements.map(&:text)
      }

      Conclusion.new(
          index, title, reference, per_device, per_rating,
          per_rating[:critical], per_rating[:high],
          per_rating[:medium], per_rating[:low], per_rating[:info],
      )
    end

    # Recommendations
    def recommendations
      recom = @config[-2]
      index     = attributes(recom).index
      title     = attributes(recom).title
      reference = attributes(recom).ref
      list      = generate_table(recom.elements[1].elements)

      Recommendations.new(
          index, title, reference,
          list
      )
    end

    # TODO: implement
    def mitigation_classification
      mitigation = @config[-1]
      index     = attributes(mitigation).index
      title     = attributes(mitigation).title
      reference = attributes(mitigation).ref

      MitigationClassification.new(
          index, title, reference,
      )

    end

  end
end



if __FILE__ == $0
  require 'nokogiri'
  require 'pp'
  require_relative 'parser_utils'
  config = Nokogiri::XML open(ARGV[0])
  security_audit = NipperParser::SecurityAudit.new(config)
  # pp security_audit.introduction.index
  # pp security_audit.introduction.title
  # pp security_audit.introduction.ref
  # pp security_audit.introduction.devices
  # finding = security_audit.findings[1]
  # pp finding.index
  # pp finding.title
  # pp finding.ref
  # pp finding.affected_devices
  # pp finding.finding
  # pp finding.impact
  # pp finding.recommendation
  # pp security_audit.introduction
  # pp security_audit.conclusions
  # pp security_audit.conclusions.per_device
  # pp security_audit.conclusions.list_critical
  # pp security_audit.recommendations.list
end
