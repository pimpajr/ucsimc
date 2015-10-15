require 'nokogiri'

class Ucsimc::TrivialXml
  attr_accessor :action, :action_properties, :filter, :filter_operator
  attr_reader :xml
  
  def initialize opts
    @opts = opts
    @action = @opts[:action]
    @action_properties = @opts[:action_properties]
    @filter = @opts[:filter]
    @filter_operator = @opts[:filtered_operator]
  end
  
  def easy_xml
    xml = Nokogiri::XML::Builder.new do |xml|
      xml.send(@action, @action_properties) do |inner|
        if @filter && @filter_operator
          inner.send(:"inFilter") do |filter|
            filter.send(@filter_operator, @filter)
          end
        elsif @filter
          raise "Filter is set to %s but filter operator is missing" % @filter
        elsif @filter_operator
          raise "Filter operator is set to %s but filter is missing" % @filter_operator
        end
      end
    end
    xml.doc.root.to_xml
  end
    
end