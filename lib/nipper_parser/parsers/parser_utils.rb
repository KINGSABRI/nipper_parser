module NipperParser

  # ParserUtils is a helper module for parsers' quick and dirty operations.
  module ParserUtils
    
    # generate_table takes the table elements to parses it
    # @param elements [Nokogiri::XML::Element]
    # @return [Hash]
    def generate_table(elements)
      headers = elements[0].elements.map{|header| header.text.downcase.tr(' ', '_').to_sym}
      body    = elements[1].elements.map{|e1| e1.elements.map{|e2| e2.text}}

      body.map{|element| headers.zip(element).to_h}
    end

    Attribute = Struct.new(:index, :title, :ref)
    # @param attr [Nokogiri::XML::Element] attributes
    # @return [Hash<Attribute>]
    def attributes(attr)
      Attribute.new(
          attr.attributes['index'].text,
          attr.attributes['title'].text,
          attr.attributes['ref'].text
      )
    end

  end
end
