require 'ucsimc/trivial_xml'
require 'ucsimc/managed_object'

module Ucsimc
  class ConfigConfMo < TrivialXml
    attr_accessor :action, :action_property, :inner_content, :req, :classes
    attr_reader :cookie
    
    def initialize cookie
      @cookie = cookie
      xml_opts = {
        :inner => "inConfig",
      }
      super xml_opts
    end
    
    def request dn, mo_class, class_opts
      @action = "configConfMo"
      @action_properties = {:cookie => @cookie, :dn => dn, :inHierarchical => "false" }
      @inner_id = mo_class
      @inner_opt = class_opts
      easy_xml
    end
    
    def response resp
      mo = Ucsimc::ManagedObject.new(easy_response(resp))
      mo
    end
    
  end
end