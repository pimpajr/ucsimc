require 'ucsimc/trivial_xml'

module Ucsimc
  class ConfigResolveDn < TrivialXml
    attr_accessor :action, :action_property, :inner_content, :req, :classes
    attr_reader :cookie
    
    def initialize cookie
      @cookie = cookie
      xml_opts = {}
      super xml_opts
    end
    
    def request dn
      @action = "configResolveDn"
      @action_properties = {:cookie => @cookie, :dn => dn, :inHierarchical => "false" }
      #@inner_opt = classes
      easy_xml
    end
    
    def response resp
      easy_response resp
    end
    
  end
end