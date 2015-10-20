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
      fail unless opts.is_a? Hash
      @user = opts[:user]
      @pass = opts[:password]
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
      result = aaa.aaalogin_response @resp
      parse_aaa result, "login"
    end
    
    def refresh
      aaa = aaa_auth
      @req = aaa.aaarefresh @user, @pass, @cookie
      do_post
      result = aaa.aaarefresh_response @resp
      parse_aaa result, "refresh"
    end
    
    def logout
      aaa = aaa_auth
      @req = aaa.aaalogout @cookie
      do_post
      result = aaa.aaalogout_response @resp
      parse_aaa result, "logout"
    end
    
    def build_connect
      @rest = RestClient::Resource.new "https://#{@host}/xmlIM", :verify_ssl => @insecure
    end
    
    def do_post
      @resp = @rest.post @req
    end
    
    def do_post_extended api_method, opts
      req = api_method.request @cookie, opts
      resp = @rest.post req
      mo = api_method.response resp
      until mo.mo[:error].nil?
        mo.mo.each { |error,number|
          number.each { |erno,erdesc|
            case erno
            when /547/
              
              # Checking for Session state in index 1
              # raise error if it's not an expired
              # session, if expired refresh and redo
              # request
              
              auth_fail = erdesc.split(":")
              if auth_fail[1]
                case auth_fail[1]
                when /Session not authenticated/
                  refresh
                  req = api_method.request @cookie, opts
                  resp = @rest.post req
                  mo = api_method.response resp
                else
                  raise "%s %s"  % [erno, erdesc]
                end
                
              else
                raise "%s %s"  % [erno, erdesc]
              end
            else
              raise "%s %s"  % [erno, erdesc]
            end
          }
        }
      end
      @out_dn = mo.mo
    end
    
    def parse_aaa result, step
      case result
      when Hash
        if result[:error]
          result.each { |error,number|
            number.each { |erno,erdesc|
              puts "\# %s failed \# Error code: %d Description: %s" % [step,erno,erdesc]
            }
          }
          exit
        end   
      else
        case step
        when /login/
          @cookie = result
        when /logout/
          puts "Logout %s" % result
          exit
        when /refresh/
          @cookie = result
        end
      end
    end
    
    def resolve_class
      case @in_class
      when Hash
        opts = {:in_class => @in_class.keys}
        r_class = Ucsimc::ConfigResolveClasses.new
      when String
        opts = {:in_class => @in_class}
        r_class = Ucsimc::ConfigResolveClass.new
      when Array
        opts = {:in_class => @in_class}
        r_class = Ucsimc::ConfigResolveClasses.new
      else 
        raise "in_class needs to be Hash, String, or Array got %s instead" % @in_class.class
      end
      do_post_extended r_class, opts
    end 
    
    def resolve_children
      fail unless @in_class.is_a? String
      fail unless @in_dn.is_a? String
      opts = {:in_class => @in_class,
              :in_dn => @in_dn
      }
      test = Ucsimc::ConfigResolveChildren.new
      do_post_extended test, opts
    end
    
    def resolve_dn
      fail unless @in_dn.is_a? String
      opts = {:in_dn => @in_dn}
      crd = Ucsimc::ConfigResolveDn.new
      do_post_extended crd, opts
    end
    
    def config_mo
      fail unless @in_dn.is_a? Hash
      fail unless @in_class.is_a? String
      conf = {}
      ccm = Ucsimc::ConfigConfMo.new
      @in_dn.each { |dn,options|
        opts = {:dn => dn,
                :mo_class => @in_class,
                :class_opts => options
        }
        do_post_extended ccm, opts
      }
    end
    
  end
end
