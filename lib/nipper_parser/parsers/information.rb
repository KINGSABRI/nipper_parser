module NipperParser
  class Information
    # include ParserUtils

    # Information parses the 'Information' part
    #
    # @example Basic Usage
    #   require 'nokogiri'
    #   require 'pp'
    #   config = Nokogiri::XML open(ARGV[0])
    #   pp information.title
    #   pp information.author
    #   pp information.date
    #   pp information.version
    #   pp information.devices
    # 
    # @param config [Nokogiri::XML] parsed XML
    # @attr_reader config [Nokogiri::XML] parsed XML object
    # @attr_reader title [Sting] report title
    # @attr_reader author [Sting] report author
    # @attr_reader date [Sting] report generation date
    # @attr_reader version [Sting] Nipper Studio version
    # @attr_reader the tested devices
    attr_reader :config, :title, :author, :date, :version, :devices

    # @config The configuration [File]
    def initialize(config)
      @config  = config.xpath('//information')[0]
      @title   = @config.elements[0].text
      @author  = @config.elements[1].text
      @date    = @config.elements[2].text
      @version = @config.elements[3].elements[3].text
      @devices = parse_devices
    end

    # parse_devices parse first devices list of the report
    # @return [Array<Hash{Symbol => String}>]
    def parse_devices
      @config.xpath('devices')[0].elements.map do |device|
        {
            name: device.attributes['name'].text,
            type: device.attributes['type'].text,
            os:   device.attributes['os'].text
        }
      end
    end

  end
end



if __FILE__ == $0
  require 'nokogiri'
  require_relative 'parser_utils'
  require 'pp'
  config = Nokogiri::XML open(ARGV[0])
  information = NipperParser::Information.new(config)
  pp information.title
  pp information.author
  pp information.date
  pp information.version
  pp information.devices
  pp information.devices[0].name
end
