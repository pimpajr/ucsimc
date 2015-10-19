require 'nokogiri'
module Ucsimc
  class TrivialXml
    
    def initialize opts
      fail unless opts.is_a? Hash
      @inner = opts[:inner]
      @inner_id = opts[:inner_id]      
    end
    
    def easy_xml
      xml = Nokogiri::XML::Builder.new do |xml|
        xml.send(@action, @action_properties) do |inner|
          if @inner
            case @inner_opt
            when Array
              fail unless @inner_id.is_a? String
              inner.send(@inner) do |deeper|
                @inner_opt.each do |value|
                  deeper.send(@inner_id, :value => value)
                end
              end              
            when Hash
              fail unless @inner_id.is_a? String
              inner.send(@inner) do |deeper|
                deeper.send(@inner_id, @inner_opt)
              end
            when nil
              inner.send(@inner)
            end
          end
        end
      end
      xml.doc.root.to_xml
    end
  
    def easy_response resp
      resp_doc = Nokogiri::XML resp
      if resp_doc.root.attribute "errorCode"
        error_hash = { :error => {resp_doc.root.attribute("errorCode").value => resp_doc.root.attribute("errorDescr").value}}
        #abort "There was a problem with the request. The API is reporting Error Code: %d %s" % [resp_doc.root.attribute("errorCode").value,
        #                                                                                        resp_doc.root.attribute("errorDescr").value]
        error_hash
      else
        resp_doc
      end
    end
    
  
      
  end
end

