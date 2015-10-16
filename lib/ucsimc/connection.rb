require 'ucsimc/aaa'
require 'ucsimc/config_resolve_classes'
require 'rest-client'

module Ucsimc
  class Connection
    attr_accessor :user, :host, :aaa, :classes, :action, :action_properties
    attr_reader :connection, :cookie
        
    def initialize opts
      @user = opts[:user]
      @pass = opts[:pass]
      @host = opts[:host]
      @inHierarchical = opts[:inHierarchical]
        
      build_connect
      login
    end
    
    def aaa_auth
      Ucsimc::Aaa.new
    end
    
    def login
      aaa = aaa_auth
      @req = aaa.aaalogin @user, @pass
      do_post
      @cookie = aaa.aaalogin_response @resp
    end
    
    def refresh
      aaa = aaa_auth
      @req = aaa.aaarefresh @user, @pass, @cookie
      do_post
      @cookie = aaa.aaarefresh_response @resp
    end
    
    def logout
      aaa = aaa_auth
      @req = aaa.aaalogout @cookie
      do_post
      aaa.aaalogout_response @resp
    end
    
    def build_connect
      @rest = RestClient::Resource.new "https://#{@host}/xmlIM", :verify_ssl => @insecure
    end
    
    def do_post
      @resp = @rest.post @req
    end
    
    def resolve_classes
      @classes = ["equipmentChassis", "computePhysical"]
      test = Ucsimc::ConfigResolveClasses.new
      @req = test.request @cookie, @classes
    end
  end
end
