require 'ucsimc'


module Ucsimc
  class ManagedObject
    attr_accessor :mo


    
    def initialize xml_doc
      
      @mo = parse_doc xml_doc

      
    end
    
    def parse_doc xml_doc
      xml_doc = xml_doc.root.children.children
      attr_prep = {}
      xml_doc.each do |element|
        case element
        when Nokogiri::XML::Element
          dn = element.attribute("dn").value
          attr_prep[dn] ||= {}
          element.attributes.each do |key,at|
            attr_prep[dn][key] = at.value            
          end
        end
      end
      attr_prep
    end
    
  end
end