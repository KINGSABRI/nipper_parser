module NipperParser

  # FilteringComplexity parses the 'Filtering Complexity' part.
  #   Filtering Complexity part contains the following sections:
  #     - introduction
  #     - Observations
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
    include ParserUtils

    # Skeleton for SecurityAudit parts

    Introduction = Struct.new(
        :index,
        :title, :ref, :devices,
        :security_issue_overview, :rating
    )

    Observation = Struct.new(
        :index, :title, :ref, :overview,
        :affected_devices, :false_positive
    )

    attr_reader :config, :title

    # @param config [Nokogiri::XML::Document]
    def initialize(config)
      part    = config.xpath("//report/part[@ref='COMPLEXITY']")
      unless part.empty?
        @config = part[0].elements
        @title  = part[0].attributes['title'].text
      end            
    end

    # Introduction of the Security Audit report
    def introduction
      intro = @config[0]
      attribute = attributes(intro)
      index     = attribute.index
      title     = attribute.title
      reference = attribute.ref
      devices   = generate_table(intro.elements[1].elements)

      Introduction.new(index, title, reference, devices)
    end

    # observations parses observations
    #
    # @return [Array<Observation>]
    def observations
      obs = @config.to_a.clone
      obs.shift   # pop first item, the introduction
      @observations = obs.map do |observation|

        Observation.new(
            attributes(observation).index,
            attributes(observation).title,
            attributes(observation).ref,
            observation.elements[0].text.strip,      # overview
            affected_devices(observation),           # affected_devices
            false                                    # observation can be marked as a false positive
        )
      end

    end

    # List all false positive observations
    #
    # @return [Array<Observation>]
    def false_positive
      observations.select(&:false_positive)
    end

    private
    AffectedDevice = Struct.new(
        :index, :title, :ref,
        :details, :details_tables
    )
    # affected_devices parses affected devices from give Observation object. @see #observations
    #
    # @param observation [Nokogiri::XML::Element]
    # @return [Array<AffectedDevices>]
    def affected_devices(observation)
      obs_devices = observation.elements
      obs_devices.shift  # pop first item, the overview

      obs_devices.map do |device|
        AffectedDevice.new(
            attributes(device).index,   #fixme affected device index should not be same as observation index
            attributes(device).title,
            attributes(device).ref,
            device.elements[0].text,                # details
            details_tables(device)                  # details tables
        )
      end
    end

    DetailsTable = Struct.new(
        :index, :title, :ref,
        :tables
    )
    # details_tables parses tables of affected devices from give device. @see #affected_devices
    #
    # @param device [Nokogiri::XML::Element]
    # @return [Array<AffectedDevices>]
    def details_tables(device)
      tables = device.elements
      tables.shift
      begin
        tables.map do |table|
          DetailsTable.new(
              attributes(table).index,
              attributes(table).title,
              attributes(table).ref,
              generate_table(table.elements)     # tables
          )
        end
      rescue
        # tables.map do |table|
        #   DetailsTable.new(
        #       nil, nil, nil,
        #       tables.xpath('listitem').map(&:text)
        #   )
        # end

        tables.xpath('listitem').map(&:text)
      end

    end

  end
end



if __FILE__ == $0
  require 'nokogiri'
  require 'pp'
  config = Nokogiri::XML open(ARGV[0])
  filter = NipperParser::FilteringComplexity.new(config)
  pp filter.introduction.class
  pp filter.introduction.index
end
