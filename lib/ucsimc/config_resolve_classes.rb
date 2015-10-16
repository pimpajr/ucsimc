require 'ucsimc/trivial_xml'

module Ucsimc
  class ConfigResolveClasses < TrivialXml
    attr_accessor :action, :action_property, :inner_content, :req, :classes
    attr_reader :cookie
    
    def initialize
      xml_opts = {
        :inner => "inIds",
        :inner_id => "Id",
      }
      super xml_opts
    end
    
    def request cookie, classes
      @action = "configResolveClasses"
      @action_properties = {:cookie => cookie, :inHierarchical => "false" }
      @inner_opt = classes
      easy_xml
    end
    
    def response resp
      easy_response resp
    end
    
  end
end