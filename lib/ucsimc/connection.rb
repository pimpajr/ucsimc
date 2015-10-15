module Ucsimc
  class Connection
    attr_accessor :user, :pass, :host
        
    def initialize user, pass, host
      @user = user
      @pass = pass
      @host = host
      login @user, @pass
    end
        
    def login host, doc
      ucs = RestClient.new("https://#{host}")
      resp = ucs['xmlIM'].post doc.to_xml
      resp_doc = Nokogiri::XML(resp)
      if resp_doc.root.attribute("outCookie")
        cookie = resp_doc.root.attribute("outCookie")
      else
        abort "There was a problem authenticating. %s is reporting Error Code:%d %s" % [@host,
                                                                          resp_doc.root.attribute("errorDescr"),
                                                                          resp_doc.root.attribute("errorCode")]
      end
      cookie
    end
        
    def login_doc user, pass
      doc = Nokogiri::XML::Document.new
      doc = doc.create_element "aaaLogin", :inName => user, :inPassword => pass 
      doc
    end
  end
end
