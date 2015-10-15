module Ucsimc
  class Connection
    attr_accessor :user, :host, :aaa, :cookie
        
    def initialize user, pass, host
      @user = user
      @pass = pass
      @host = host
      @aaa = create_aaalogin @user, @pass
      @cookie = get_cookie @aaa
    end
        
    def get_cookie aaa
      require 'rest-client'
      ucs = RestClient::Resource.new "https://#{@host}", :verify_ssl => false
      resp = ucs['xmlIM'].post aaa.to_xml
      resp_doc = Nokogiri::XML resp
      if resp_doc.root.attribute "outCookie"
        cookie = resp_doc.root.attribute("outCookie").value
      else
        abort "There was a problem authenticating. %s is reporting Error Code:%d %s" % [@host,
                                                                          resp_doc.root.attribute("errorDescr"),
                                                                          resp_doc.root.attribute("errorCode")]
      end
      cookie
    end
        
    def create_aaalogin user, pass
      require 'nokogiri'
      doc = Nokogiri::XML::Document.new
      doc = doc.create_element "aaaLogin", :inName => user, :inPassword => pass 
      doc
    end
    

    
  end
end
