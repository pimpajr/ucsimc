require 'ucsimc/trivial_xml'

module Ucsimc
  class Aaa < TrivialXml
    attr_accessor :aaa_req
    
    
    def aaalogin
      @action = 'aaaLogin'
      @action_properties = {:inName => @user, :inPassword => @pass}
      @req = easy_xml
    end
    
    def aaalogin_response
      res = easy_response
      @cookie = res.root.attribute("outCookie").value
    end
    
    def aaalogout
      @action = 'aaaLogout'
      @action_properties = {:inCookie => @cookie}
      @req = easy_xml
    end
    
    def aaalogout_response
      res = easy_response
      puts "Disconnection %s" % res.root.attribute("outStatus").value
      exit
    end
    
    def aaarefresh
      @action = 'aaaRefresh'
      @action_properties = {:inName => @user, :inPassword => @pass, :inCookie => @cookie}
      @req = easy_xml
    end
    
    def aaarefresh_response
      res = easy_response
      @cookie = res.root.attribute("outCookie").value
    end
    
    
  end
end
