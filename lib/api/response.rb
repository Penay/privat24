require 'xmlsimple'
module API
  class Response
    def initialize(xml)
      @response = XmlSimple.xml_in(xml)
    end

  end
end