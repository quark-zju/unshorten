require 'net/http'
require 'net/https'
require 'uri'

# Get original URLs from shortened ones.
class Unshorten

  # Cache entities limit
  CACHE_SIZE_LIMIT = 1024

  # Default options for unshorten
  DEFAULT_OPTIONS = {
    :max_level => 10,
    :timeout => 2,
    :short_hosts => Regexp.union('url', /^[^.]{1,6}\.[^.]{1,2}$/i),
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
    #                                        host matches this regexp. Set to false
    #                                        to follow all redirects.
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

    def mix_options(old, *new) #:nodoc:
      options = old.dup
      new.each { |n| n.each { |k, v| options[k] = v } }
      options
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

      uri = URI.parse(url) rescue nil

      return url if uri.nil?
      return url if options[:short_hosts] != false and not uri.host =~ options[:short_hosts]

      http = Net::HTTP.new(uri.host, uri.port)
      http.read_timeout = options[:timeout]
      http.use_ssl = true if uri.scheme == "https"

      response = http.request_head(uri.path.empty? ? '/' : uri.path) rescue nil

      if response.is_a? Net::HTTPRedirection and response['location'] then
        expire_cache if @@cache.size > CACHE_SIZE_LIMIT
        @@cache[url] = follow(response['location'], options, level + 1)
      else
        url
      end
    end

  end

end

# vim:et:ts=2 sw=2

