require 'date'
require_relative 'parser_utils'

module NipperParser

  # SecurityAudit parses the 'Security Audit' part including all it's sections.
  #   Security Audit part contains the following sections:
  #     - introduction
  #     - findings
  #     - Conclusions
  #     - Recommendations
  #     - Mitigation Classification
  #
  # @example Basic Usage
  #   require 'nokogiri'
  #   require 'pp'
  #   config = Nokogiri::XML open(ARGV[0])
  #   security_audit = NipperParser::SecurityAudit.new(config)
  #   pp security_audit.introduction.class
  #   pp security_audit.introduction.index
  #   pp security_audit.introduction.title
  #   pp security_audit.introduction.devices
  # @example Dealing with findings
  #   finding = security_audit.findings[0]
  #   pp finding.class
  #   pp finding.index
  #   pp finding.title
  #   pp finding.ref
  #   pp finding.affected_devices
  #   pp finding.finding
  #   pp finding.impact
  #   pp finding.recommendation
  # @example Dealing with report summaries
  #   pp security_audit.conclusions.class
  #   pp security_audit.conclusions.per_device
  #   pp security_audit.conclusions.list_critical
  #   pp security_audit.recommendations.class
  #   pp security_audit.recommendations.list
  #   pp security_audit.mitigation_classification.class
  #   pp security_audit.mitigation_classification.list_by.fixing[:involved]
  #   pp security_audit.mitigation_classification.list_by.fixing[:involved][0].rating[:rating]
  #   pp security_audit.mitigation_classification.list_by.rating[:high]
  #   pp security_audit.mitigation_classification.list_by.rating[:high][0].rating[:fix]
  #   pp security_audit.mitigation_classification.statistics.class
  #   pp security_audit.mitigation_classification.statistics.critical
  #   pp security_audit.mitigation_classification.statistics.quick
  #   pp security_audit.mitigation_classification.statistics.report
  #
  # @param config [Nokogiri::XML] parsed XML
  # @attr_reader title the report title
  # @attr_reader config a parsed XML [Nokogiri::XML] object
  class SecurityAudit
    include ParserUtils

    # Skeleton for SecurityAudit parts

    Introduction = Struct.new(
        # introduction's index
        :index,
        :title, :ref, :date, :devices,
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
        :list_by, :statistics
    )
    ListBy = Struct.new(
         :fixing,
         :rating, :all
    )
    Statistics = Struct.new(
         :findings,
         :critical,
         :high,
         :medium,
         :low,
         :informational,
         :quick,
         :planned,
         :involved,
         :report
    )

    attr_reader :config, :title

    # @param config [Nokogiri::XML::Document]
    def initialize(config)
      part    = config.xpath("//report/part[@ref='SECURITYAUDIT']")
      @config = part[0].elements
      @title  = part[0].attributes['title'].text

      introduction
      findings
    end

    # Introduction of the Security Audit report
    def introduction
      intro = @config[0]
      attribute = attributes(intro)
      index     = attribute.index
      title     = attribute.title
      reference = attribute.ref
      date      = Date.parse(intro.elements[0].text).to_s
      devices   = generate_table(intro.elements[1].elements)
      security_issue_overview = {}
      intro.elements[2].elements[1..4].map do |issue|
        security_issue_overview[issue['title']] = issue.text
      end
      rating    = generate_table(intro.elements[3].elements[2].elements[1].elements)

      Introduction.new(
          index, title, reference, date, devices,
          security_issue_overview, rating
      )
    end

    # Parse findings from given configurations
    # @return [Array<Finding>]
    def findings
      findings = @config.to_a.clone
      findings.shift  # pop first item, the introduction
      findings.pop(3) # pop last 3 item, conclusion, recommendations, Mitigation Classification

      @findings = findings.map do |finding|
        Finding.new(
            attributes(finding).index,
            attributes(finding).title,
            attributes(finding).ref,
            finding.elements[0]&.elements[0].elements.map(&:attributes),            # affected_devices
            rating_table(finding.elements[0].elements[1].elements),                 # Rating table
            finding.elements[2]&.elements&.first(2).map(&:text).join("\n"),         # finding
            finding.elements[3]&.elements&.text,                                    # impact
            finding.elements[4]&.elements&.text,                                    # ease
            finding.elements[5]&.elements&.text                                     # recommendation
        )
      end
    end

    # Conclusions
    def conclusions
      conc = @config.search("section[@ref='SECURITY.CONCLUSIONS']")[0]
      index     = attributes(conc).index
      title     = attributes(conc).title
      reference = attributes(conc).ref
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
      recom = @config.search("section[@ref='SECURITY.RECOMMENDATIONS']")[0]
      index     = attributes(recom).index
      title     = attributes(recom).title
      reference = attributes(recom).ref
      list      = generate_table(recom.elements[1].elements)

      Recommendations.new(
          index, title, reference,
          list
      )
    end

    def mitigation_classification
      @mitigation = @config.search("section[@ref='SECURITY.MITIGATIONS']")[0]  # @config[-1]

      index     = attributes(@mitigation).index
      title     = attributes(@mitigation).title
      reference = attributes(@mitigation).ref
      MitigationClassification.new(
          index, title, reference,
          list_by,
          statistics
      )

    end

    private
    # list_by list different type of mitigation, by fixing type, and by rating type.
    #
    # @example:
    #   list_by.fixing              # @return [Hash]
    #   list_by.fixing[:quick]      # @return [Array<Findings>]
    #   list_by.rating              # @return [Hash]
    #   list_by.rating[:critical]   # @return [Array<Findings>]
    #   list_by.all                 # @return [Hash]
    #
    # @return [ListBy]
    def list_by
      @fixing_lists = @mitigation.search('list')
      _by_fixing  = by_fixing   # @see by_fixing
      _by_rating  = by_rating   # @see by_rating
      fixing      = {quick: _by_fixing[0], planned: _by_fixing[1], involved: _by_fixing[2]}
      rating      = {critical: _by_rating[:critical], high: _by_rating[:high],
                     medium: _by_rating[:medium], low: _by_rating[:low],
                     informational: _by_rating[:informational]}
      _by_all     = {fixing: fixing, rating: rating}

      ListBy.new(
        _by_all[:fixing],
        _by_all[:rating],
        _by_all
      )
    end

    # finding_objects maps finding listitems text with the findings object
    def by_fixing
      findings = @findings.dup
      @fixing_lists.map do |_class|
        _class.search('listitem').map do |item|
          # if 'finding' reference = item mentioned index (extracted from text 'See section' ),
          # then return the finding object
          findings.select{|finding| finding.index == item.text.match(/\d+\.\d+/).to_s.to_f}[0]
        end
      end
    end

    # search in all finding by rating
    def by_rating
      findings = @findings.dup
      rating = {critical: nil, high: nil, medium: nil, low: nil, informational: nil}
      rating.keys.each do |rate|
        rating[rate] = findings.select {|finding| finding.rating[:rating].downcase == rate.to_s}
      end

      rating
    end

    # mitigation statistics regarding to number of:
    #  - findings
    #  - findings by rating
    #  - findings by fixing
    # @return [Statistics]
    def statistics
      findings = @findings.size
      ratings = {critical: nil, high: nil, medium: nil, low: nil, informational: nil}
      ratings.keys.each do |rating|
        ratings[rating] = {total: list_by.rating[rating].size,
                           perce: ( (list_by.rating[rating].size/@findings.size.to_f) * 100.0 ).round(2)}
      end
      fixing = {quick: nil, involved: nil, planned: nil}
      fixing.keys.each do |fix|
        fixing[fix] = {total: list_by.fixing[fix].size,
                       perce: ( (list_by.fixing[fix].size/@findings.size.to_f) * 100.0 ).round(2)}
      end
      report   = {ratings: ratings, fixing: fixing}
      Statistics.new(
          findings,
          ratings[:critical],
          ratings[:high],
          ratings[:medium],
          ratings[:low],
          ratings[:informational],
          fixing[:quick],
          fixing[:involved],
          fixing[:planned],
          report
      )
    end
  end
end



if __FILE__ == $0
  require 'nokogiri'
  require 'pp'
  config = Nokogiri::XML open(ARGV[0])
  security_audit = NipperParser::SecurityAudit.new(config)
  pp security_audit.introduction.class
  pp security_audit.introduction.index
  pp security_audit.introduction.title
  pp security_audit.introduction.rating
  pp security_audit.introduction.security_issue_overview
  pp security_audit.introduction.ref
  pp security_audit.introduction.devices
  finding = security_audit.findings[0]
  pp finding.class
  pp finding.index
  pp finding.title
  pp finding.rating
  pp finding.ref
  pp finding.affected_devices
  pp finding.finding
  pp finding.impact
  pp finding.recommendation
  pp security_audit.introduction
  pp security_audit.conclusions.class
  pp security_audit.conclusions.per_device
  pp security_audit.conclusions.list_critical
  pp security_audit.recommendations.class
  pp security_audit.recommendations.list
  pp security_audit.mitigation_classification.class
  pp security_audit.mitigation_classification.list_by.fixing[:involved]
  pp security_audit.mitigation_classification.list_by.fixing[:involved][0].rating[:rating]
  pp security_audit.mitigation_classification.list_by.rating[:high]
  pp security_audit.mitigation_classification.list_by.rating[:high][0].rating[:fix]
  pp security_audit.mitigation_classification.statistics.class
  pp security_audit.mitigation_classification.statistics.findings
  pp security_audit.mitigation_classification.statistics.report
end
