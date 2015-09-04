require 'net/http'
require 'net/https'
require 'uri'
require 'version'

# Get original URLs from shortened ones.
module Unshorten
  # Cache entities limit
  CACHE_SIZE_LIMIT = 1024

  # Default options for unshorten
  DEFAULT_OPTIONS = {
      :max_level => 10,
      :timeout => 2,
      :short_hosts => false,
      :short_urls => /^(?:https?:)?\/*[^\/]*\/*[^\/]*$/,
      :follow_codes => [302, 301],
      :use_cache => true,
      :add_missing_http => true
  }

  @@cache = { }

  class << self

    # Unshorten a URL
    #
    # @param url [String] A shortened URL
    # @param options [Hash] A set of options
    # @option options [Integer] :max_level Max redirect times
    # @option options [Integer] :timeout Timeout in seconds, for every request
    # @option options [Regexp]  :short_hosts Hosts that provides short url
    #                                        services, only send requests if
    #                                        host matches this regexp. Set to
    #                                        nil to follow all redirects.
    # @option options [Regexp]  :short_urls  URLs that looks like a short one.
    #                                        Only send requests when the URL
    #                                        match this regexp. Set to nil to
    #                                        follow all redirects.
    # @option options [Array]   :follow_codes An array of HTTP status codes
    #                                         (intergers). Only follow a
    #                                         redirect if the response HTTP
    #                                         code matches one item of the
    #                                         array.
    # @option options [Boolean] :use_cache Use cached result if available
    # @option options [Boolean] :add_missing_http add 'http://' if missing
    # @see DEFAULT_OPTIONS
    #
    # @return Original url, a url that does not redirect
    def unshorten(url, options = {})
      DEFAULT_OPTIONS.each { |k, v| (options[k] = v) unless options.has_key? k }

      follow(url, options)
    end

    alias :'[]' :unshorten

    private

    def expire_cache #:nodoc:
      @@cache = { }
    end

    def add_missing_http(url) #:nodoc:
      if url =~ /^https?:/i
        url
      else
        "http://#{url}"
      end
    end

    def follow(url, options = DEFAULT_OPTIONS, level = 0) #:nodoc:
      url = add_missing_http(url) if options[:add_missing_http]

      return @@cache[url] if options[:use_cache] and @@cache[url]
      return url if level >= options[:max_level]
      return url if options[:short_urls] && ! (url =~ options[:short_urls])
      uri = URI.parse(url) rescue nil

      return url if uri.nil?
      return url if options[:short_hosts] && ! (uri.host =~ options[:short_hosts])

      http = Net::HTTP.new(uri.host, uri.port)
      http.open_timeout = options[:timeout]
      http.read_timeout = options[:timeout]
      http.use_ssl = true if uri.scheme == 'https'

      path = uri.path
      path = '/' if !path || path.empty?
      path += "?#{uri.query}" if uri.query
      response = http.request_head(path) rescue nil

      if response.is_a?(Net::HTTPRedirection) && options[:follow_codes].include?(response.code.to_i) && response['location'] then
        expire_cache if @@cache.size > CACHE_SIZE_LIMIT
        location = URI.encode(response['location'])
        location = (uri + location).to_s if location
        @@cache[url] = follow(location, options, level + 1)
      else
        url
      end
    end

  end

end

# vim:et:ts=2 sw=2
