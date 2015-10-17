require 'ucsimc/aaa'
require 'ucsimc/config_resolve_class'
require 'ucsimc/config_resolve_classes'
require 'ucsimc/config_resolve_children'
require 'ucsimc/config_resolve_dn'
require 'ucsimc/config_resolve_parent'
require 'ucsimc/config_conf_mo'
require 'rest-client'

module Ucsimc
  class Connection
    attr_accessor :user, :host, :in_class, :in_dn
    attr_reader :connection, :cookie, :out_dn, :resp
        
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
    
    def set_attributes object, attribute
      instance_variable_set("@" + attribute, object.mo)
      instance_variable_get("@" + attribute)
      self.class.send(:attr_accessor, attribute.to_sym)
      @resp = nil
    end
    
    def resolve_class
      #@classid = "fabricVlan"
      case @in_class
      when Hash
        r_class = Ucsimc::ConfigResolveClasses.new @cookie
        @req = r_class.request @in_class.keys
      else
        r_class = Ucsimc::ConfigResolveClass.new @cookie
        @req = r_class.request @in_class
      end
      do_post
      obj = r_class.response @resp
      @out_dn = obj.mo
      
    end 
    
    def resolve_classes
      fail unless @in_class.is_a? Array
      test = Ucsimc::ConfigResolveClasses.new @cookie
      @req = test.request @in_class
      do_post
      obj = test.response @resp
      @out_dn = obj.mo
    end
    
    def resolve_children
      test = Ucsimc::ConfigResolveChildren.new @cookie
      @req = test.request @in_class, @in_dn
      do_post
      obj = test.response @resp
      @out_dn = obj.mo
      #set_attributes obj, @classid
    end
    
    def resolve_dn
      test = Ucsimc::ConfigResolveDn.new @cookie
      @req = test.request @in_dn
      do_post
      obj = test.response @resp
      @out_dn = obj.mo
    end
    
    def config_mo
      a = {}
      test = Ucsimc::ConfigConfMo.new @cookie
      @fabricVlan.each do |key,hash|
        a[key] = test.request key, "fabricVlan", hash
      end
      a
    end
    
  end
end
