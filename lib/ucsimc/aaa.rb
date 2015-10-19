require 'ucsimc/trivial_xml'

module Ucsimc
  class Aaa < TrivialXml
    attr_accessor :aaa_req
    
    def initialize
      opts = {}
      super opts
    end
    
    def parse_resp_doc resp, query
      case resp
      when Nokogiri::XML::Document
        parsed = resp.root.attribute(query).value
      when Hash
        parsed = resp
      end
      parsed
    end
    
    def aaalogin user, pass
      @action = 'aaaLogin'
      @action_properties = {:inName => user, :inPassword => pass}
      easy_xml
    end
    
    def aaalogin_response resp
      res_query = "outCookie"
      res = easy_response resp
      parse_resp_doc res, res_query
    end
    
    def aaalogout cookie
      @action = 'aaaLogout'
      @action_properties = {:inCookie => cookie}
      easy_xml
    end
    
    def aaalogout_response resp
      res_query = "outStatus"
      res = easy_response resp
      parse_resp_doc res, res_query
    end
    
    def aaarefresh user, pass, cookie
      @action = 'aaaRefresh'
      @action_properties = {:inName => user, :inPassword => pass, :inCookie => cookie}
      easy_xml
    end
    
    def aaarefresh_response resp
      res_query = "outCookie"
      res = easy_response resp
      parse_resp_doc res, res_query
    end
    
    
  end
end
