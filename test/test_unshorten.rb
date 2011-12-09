# coding: utf-8

require 'test/unit'
require 'unshorten'

class UnshortenTest < Test::Unit::TestCase
    ORIGINAL_URL = 'http://dir.yahoo.com/Reference/Libraries/Library_and_Information_Science/Metadata/URIs___Universal_Resource_Identifiers/URLs___Uniform_Resource_Locators/URL_Shortening/'
    SHORTENED_URL = 'http://tinyurl.com/j'

    def test_unshorten_alias
        assert_equal ORIGINAL_URL, Unshorten[SHORTENED_URL, :use_cache => false]
    end

    def test_illegal_urls
        illegal_url = 'http://a汉字bc.那么/是非法的?url'
        assert_equal illegal_url, Unshorten.unshorten(illegal_url, :use_cache => false)
    end

    def test_option_max_level
        assert_equal SHORTENED_URL, Unshorten.unshorten(SHORTENED_URL, :max_level => 0, :use_cache => false)
    end

    def test_option_short_hosts
        assert_equal SHORTENED_URL, Unshorten.unshorten(SHORTENED_URL, :short_hosts => /jmp/, :use_cache => false)
    end

end
