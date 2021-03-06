require 'ucsimc/trivial_xml'
require 'ucsimc/managed_object'

module Ucsimc
  class ConfigResolveClass < TrivialXml
    attr_accessor :action, :action_property, :inner_content, :req, :classes
    attr_reader :cookie
    
    def initialize
      xml_opts = {
        :inner => "inFilter",
      }
      super xml_opts
    end
    
    def request cookie, opts
      fail unless cookie.is_a? String
      fail unless opts.is_a? Hash
      fail unless opts[:in_class].is_a? String
      @action = "configResolveClass"
      @action_properties = {:cookie => cookie, :classId => opts[:in_class], :inHierarchical => "false"}
      easy_xml
    end
    
    def response resp
      mo = Ucsimc::ManagedObject.new(easy_response(resp))
      mo
    end
    
  end
end