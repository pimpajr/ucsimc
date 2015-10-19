require 'ucsimc'

module Ucsimc
  class ManagedObject
    attr_accessor :mo

    def initialize data
      #fail unless xml_doc.is_a? Nokogiri::XML::Document
      @mo = parse_doc data
    end
    
    def parse_doc data
      case data
      when Nokogiri::XML::Document
        xml_doc = data.root.children.children
        attr_prep = {}
        xml_doc.each { |element|
          case element
          when Nokogiri::XML::Element
            dn = element.attribute("dn").value
            attr_prep[dn] ||= {}
            element.attributes.each { |key,at|
              attr_prep[dn][key] = at.value            
            }
          end
        }
        attr_prep
      when Hash
        data
      else
        raise "Data of unexpected type %s. Allowed types Nokogiri::XML::Document and Hash." % data.class
      end
    end
    
  end
end