require 'test_helper'

class ShortUrlTest < ActiveSupport::TestCase
  test "should shorten url to a string of length 6 and assign it to shorty" do
    short_url = ShortUrl.new(original_url: "http://exampleurl.com")
    assert_equal nil,short_url[:shorty]

    short_url.shorten
    assert_not_equal nil,short_url[:shorty]
    assert_equal 6,short_url[:shorty].length
  end

  test "should calculate visits count of a url" do
    short_url = ShortUrl.create!(original_url: "http://blah.com")
    ShortVisit.create!(short_url_id: short_url.id)
    assert_equal 0,short_url.visits_count

    short_url.calculate_visits_count
    assert_equal 1,short_url.visits_count
  end
end
