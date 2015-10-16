require 'ucsimc/trivial_xml'
require 'ucsimc/managed_object'

module Ucsimc
  class ConfigResolveParent < TrivialXml
    attr_accessor :action, :action_property, :inner_content, :req, :classes
    attr_reader :cookie
    
    def initialize cookie
      @cookie = cookie
      xml_opts = {}
      super xml_opts
    end
    
    def request dn
      @action = "configResolveParent"
      @action_properties = {:cookie => @cookie, :dn => dn, :inHierarchical => "false" }
      #@inner_opt = classes
      easy_xml
    end
    
    def response resp
      mo = Ucsimc::ManagedObject.new(easy_response(resp))
      mo
    end
    
  end
end