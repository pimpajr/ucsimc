require 'ucsimc/trivial_xml'
require 'ucsimc/managed_object'

module Ucsimc
  class ConfigConfMo < TrivialXml
    attr_accessor :action, :action_property, :inner_content, :req, :classes
    attr_reader :cookie
    
    def initialize
      xml_opts = {
        :inner => "inConfig",
      }
      super xml_opts
    end
    
    def request cookie, opts
      fail unless cookie.is_a? String
      fail unless opts.is_a? Hash
      fail unless opts[:dn].is_a? String
      fail unless opts[:mo_class].is_a? String
      fail unless opts[:class_opts].is_a? Hash
      @action = "configConfMo"
      @action_properties = {:cookie => cookie, :dn => opts[:dn], :inHierarchical => "false" }
      @inner_id = opts[:mo_class]
      @inner_opt = opts[:class_opts]
      easy_xml
    end
    
    def response resp
      mo = Ucsimc::ManagedObject.new(easy_response(resp))
      mo
    end
    
  end
end