module Ucsimc
  class Connection
    attr_accessor :user, :host, :aaa, :cookie
        
    def initialize user, pass, host
      @user = user
      @pass = pass
      @host = host
      create_aaalogin
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
        
    def create_aaalogin
      require 'nokogiri'
      doc = Nokogiri::XML::Document.new
      @aaa = doc.create_element "aaaLogin", :inName => @user, :inPassword => @pass 
    end
    
    def create_refresh
      require 'nokogiri'
      doc = Nokogiri::XML::Document.new
      doc = doc.create_element "aaaRefresh", :inName => @user, :inPassword => @pass, :inCookie => @cookie
      doc
    end
    
    def refresh
      aaarefresh = create_refresh
      resp = @connection['xmlIM'].post aaarefresh.to_xml
      resp_doc = Nokogiri::XML(resp)
      if resp_doc.root.attribute "outCookie"
        @cookie = resp_doc.root.attribute("outCookie").value
      else
        abort "There was a problem authenticating. %s is reporting Error Code:%d %s" % [@host,
                                                                                resp_doc.root.attribute("errorCode").value,
                                                                                resp_doc.root.attribute("errorDescr").value]
      end
    end
    
    
    
  end
end
