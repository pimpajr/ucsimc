require 'ucsimc/trivial_xml'

module Ucsimc
  class Aaa < TrivialXml
    attr_accessor :aaa_req
    
    def initialize
      #@user = opts[:user]
      #@pass = opts[:pass]
      #@cookie ||= opts[:cookie]
      #@token ||= opts[:token]
      #super opts
    end
    
    def login
      @action = 'aaaLogin'
      @action_properties = {:inName => @user, :inPassword => @pass}
      @req = easy_xml
    end
    
    def logout
      @action = 'aaaLogout'
      @action_properties = {:inCookie => @cookie}
      @req = easy_xml.doc.root.to_xml
    end
    
    def refresh
      @action = 'aaaRefresh'
      @action_properties = {:inName => @user, :inPassword => @pass, :inCookie => @cookie}
      @req = easy_xml.doc.root.to_xml
    end
    
    
  end
end
