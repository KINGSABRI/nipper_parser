module NipperParser

  # VulnerabilityAudit parse the 'Vulnerability Audit' part.
  #   Vulnerability Audit part contains the following sections:
  #     - introduction
  #     - CVEs
  #     - Conclusions
  #     - Recommendations
  #
  #
  #
  #
  class VulnerabilityAudit
    include ParserUtils

    # Skeleton for SecurityAudit parts
    Introduction = Struct.new(
        :index, :title, :ref, :date, :devices,
        :security_issue_overview, :rating
    )
    CVE = Struct.new(
        :index, :title, :ref,
        :rating, :summary, :affected_devices,
        :vendor_sec_advisories, :references
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

    attr_reader :config, :title

    def initialize(config)
      @config = config.xpath("//report/part[@ref='VULNAUDIT']")[0].elements
      @title  = @config[0].elements[1].attributes['title'].text
    end

    # CVEs
    def cves
      cves = @config.to_a.clone
      cves.shift  # pop first item, the introduction
      cves.pop(2) # pop last 2 item, conclusion, recommendations

      cves.map do |cve|
        CVE.new(
            attributes(cve).index,
            attributes(cve).title,
            attributes(cve).ref,
            cve.elements[0],                                            # FIXME
            cve.elements[1].elements.text,                      # summary
            cve.elements[2].elements[1].elements.map(&:text),   # affect_devices
            cve.elements[3].elements[1].elements.map(&:text),   # vendor_sec_advisories
            cve.elements[4].elements[1].elements.map(&:text),   # references
        )
      end

    end

    # Conclusions
    def conclusions
      conc = @config[-2]
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
      recom = @config[-1]
      index     = attributes(recom).index
      title     = attributes(recom).title
      reference = attributes(recom).ref
      list      = generate_table(recom.elements[1].elements)

      Recommendations.new(
          index, title, reference,
          list
      )
    end

  end
end
