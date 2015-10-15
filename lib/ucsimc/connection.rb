module Ucsimc
  class Connection
    attr_accessor :user, :host, :aaa
    attr_reader :connection, :cookie
        
    def initialize user, pass, host
      @user = user
      @pass = pass
      @host = host
      @action = "login"
      create_aaa
      build_connect
      get_cookie
    end
        
    def get_cookie
      resp = @connection['xmlIM'].post @aaa.to_xml
      resp_doc = Nokogiri::XML resp
      if resp_doc.root.attribute "outCookie"
        @cookie = resp_doc.root.attribute("outCookie").value
      else
        abort "There was a problem authenticating. %s is reporting Error Code:%d %s" % [@host,
                                                                          resp_doc.root.attribute("errorCode").value,
                                                                          resp_doc.root.attribute("errorDescr").value]
      end
    end
    
    def build_connect
      require 'rest-client'
      @connection = RestClient::Resource.new "https://#{@host}", :verify_ssl => false
    end
        
    def create_aaa
      require 'nokogiri'
      doc = Nokogiri::XML::Document.new
      case @action
      when /login/
        @aaa = doc.create_element "aaaLogin", :inName => @user, :inPassword => @pass
      when /refresh/
        @aaa = doc.create_element "aaaRefresh", :inName => @user, :inPassword => @pass, :inCookie => @cookie
      when /logout/
        @aaa = doc.create_element "aaaLogout", :inCookie => @cookie
      end
       
    end
    
    def refresh
      @action = "refresh"
      create_aaa
      resp = @connection['xmlIM'].post @aaa.to_xml
      resp_doc = Nokogiri::XML(resp)
      if resp_doc.root.attribute "outCookie"
        @cookie = resp_doc.root.attribute("outCookie").value
      else
        abort "There was a problem authenticating. %s is reporting Error Code:%d %s" % [@host,
                                                                                resp_doc.root.attribute("errorCode").value,
                                                                                resp_doc.root.attribute("errorDescr").value]
      end
    end
    
    def logout
      @action = "logout"
      create_aaa
      resp = @connection['xmlIM'].post @aaa.to_xml
      resp_doc = Nokogiri::XML(resp)
      if resp_doc.root.attribute("outStatus")
        puts "Disconnection %s" % resp_doc.root.attribute("outStatus").value
        exit
      else
        abort "%s is reporting Error Code:%d %s" % [@host,
                                                    resp_doc.root.attribute("errorCode").value,
                                                    resp_doc.root.attribute("errorDescr").value]
      end
      
    end
    
  end
end
