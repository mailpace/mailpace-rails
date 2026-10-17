# frozen_string_literal: true

require 'delegate'
require 'json'
require 'net/http'

module Mailpace
  # The value returned by Mailpace::DeliveryMethod#deliver!.
  #
  # Because the delivery method sets `return_response: true`, Mail hands this
  # object back from `mail.deliver!` / `deliver_now!`. It mirrors the public
  # interface of the HTTParty::Response this gem used to return, so that
  # removing the httparty dependency does not change what callers can do with
  # the result: `res['id']`, `res.parsed_response`, `res.code`, `res.body`,
  # `res.headers` and the `*?` status helpers all keep working.
  #
  # Not carried over from HTTParty::Response: `#request` (an HTTParty::Request)
  # and Marshal support (`_dump` / `_load`).
  class Response
    # Presents the parsed headers the way HTTParty did: case-insensitive lookup
    # with joined values (`headers['Content-Type']` => "application/json").
    class Headers < ::SimpleDelegator
      include ::Net::HTTPHeader

      def initialize(values = {})
        @header = {}
        values.each_pair do |key, value|
          Array(value).each { |sub_value| add_field(key, sub_value) }
        end
        super(@header)
      end
    end

    attr_reader :response, :body, :headers

    def initialize(response)
      @response = response
      @body = response.body
      @headers = Headers.new(response.to_hash)
      @parsed_response = parse(@body)
    end

    def parsed_response
      @parsed_response
    end

    def code
      response.code.to_i
    end

    def http_version
      response.http_version
    end

    def nil?
      response.nil? || body.nil? || body.empty?
    end

    def to_s
      body.to_s
    end

    def to_hash
      parsed_response
    end

    def [](key)
      parsed_response[key] if parsed_response.respond_to?(:[])
    end

    def inspect
      "#<#{self.class} code=#{code} parsed_response=#{parsed_response.inspect}>"
    end

    def method_missing(name, *args, &block)
      return parsed_response.send(name, *args, &block) if parsed_response.respond_to?(name)

      super
    end

    def respond_to_missing?(name, include_private = false)
      parsed_response.respond_to?(name, include_private) || super
    end

    # HTTParty defines a predicate per HTTP status class (ok?, created?,
    # not_found?, server_error?, ...). Rebuild the same set from Net::HTTP's
    # tables so status checks keep working.
    ::Net::HTTPResponse::CODE_CLASS_TO_OBJ.merge(::Net::HTTPResponse::CODE_TO_OBJ).each do |_code, klass|
      name = klass.name.sub('Net::HTTP', '')
      name = "#{name.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase}?"

      define_method(name) { klass === response }
    end

    private

    def parse(body)
      JSON.parse(body.to_s)
    rescue JSON::ParserError
      nil
    end
  end
end
