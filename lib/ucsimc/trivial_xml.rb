#require 'ucsimc'
require 'nokogiri'
module Ucsimc
  class TrivialXml
    #attr_accessor :action, :action_properties, :filter, :filter_operator
    #attr_reader :xml
    
    def initialize opts
      @inner = opts[:inner]
      @inner_id = opts[:inner_id]
      #@inner_opts = opts[:inner_opts]
      
    end
    
    def easy_xml
      xml = Nokogiri::XML::Builder.new do |xml|
        xml.send(@action, @action_properties) do |inner|
          if @inner
            if @inner_id && @inner_content #&& !@inner_opts
              inner.send(@inner) do |deeper|
                @inner_content.each do |inner_con|
                  deeper.send(@inner_id, "value=\"#{inner_con}\"", {})
                end
              end
            elsif @inner_id && @inner_opts #&& !@inner_content
              inner.send(@inner) do |deeper|
                deeper.send(@inner_id, @inner_opts)
              end
            else
              raise "One of these is missing:\ninner: %s\ninner_id:  %s\ninner_opts: %s\n" % [@inner, @inner_id, @inner_opts]
            end
          end
        end
      end
      xml.doc.root.to_xml
    end
  
    def easy_response resp
      resp_doc = Nokogiri::XML resp
      if resp_doc.root.attribute "errorCode"
        abort "There was a problem with %s. %s is reporting Error Code:%d %s" % [@action,
                                                                                 @host,
                                                                                 resp_doc.root.attribute("errorCode").value,
                                                                                 resp_doc.root.attribute("errorDescr").value]
      else
        resp_doc
      end
    end
    
  
      
  end
end

