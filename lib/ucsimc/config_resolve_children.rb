require 'ucsimc/trivial_xml'

module Ucsimc
  class ConfigResolveChildren < TrivialXml
    attr_accessor :action, :action_property, :inner_content, :req, :classes
    attr_reader :cookie
    
    def initialize cookie
      @cookie = cookie
      xml_opts = {
        :inner => "inFilter",
      }
      super xml_opts
    end
    
    def request classid, indn
      @action = "configResolveChildren"
      @action_properties = {:cookie => @cookie, :classId => classid, :inDn => indn, :inHierarchical => "false" }
      #@inner_opt = classes
      easy_xml
    end
    
    def response resp
      easy_response resp
    end
    
  end
end