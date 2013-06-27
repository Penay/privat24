require 'net/http'
require "uri"
require 'builder'
module API
  class Request

    attr_accessor :response
    def initialize(options={})
      #@request = Builder::XmlMarkup.new(indent: 2)
      #+ course_id.to_s)
    end

    def exchange(course_id)
      @uri = URI.parse(API::Config::ADRESSES[:exchange] + course_id.to_s)
      API::Response.new(self.request(@uri).body)
    end

    def request(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
    end

  end
end
