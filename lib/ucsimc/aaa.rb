require 'ucsimc/trivial_xml'

module Ucsimc
  class Aaa < TrivialXml
    attr_accessor :aaa_req
    
    def initialize
      opts = {}
      super opts
    end
    
    
    def aaalogin user, pass
      @action = 'aaaLogin'
      @action_properties = {:inName => user, :inPassword => pass}
      easy_xml
    end
    
    def aaalogin_response resp
      res = easy_response resp
      res.root.attribute("outCookie").value
    end
    
    def aaalogout cookie
      @action = 'aaaLogout'
      @action_properties = {:inCookie => cookie}
      easy_xml
    end
    
    def aaalogout_response resp
      res = easy_response resp
      puts "Disconnection %s" % res.root.attribute("outStatus").value
      exit
    end
    
    def aaarefresh user, pass, cookie
      @action = 'aaaRefresh'
      @action_properties = {:inName => user, :inPassword => pass, :inCookie => cookie}
      easy_xml
    end
    
    def aaarefresh_response resp
      res = easy_response resp
      res.root.attribute("outCookie").value
    end
    
    
  end
end
