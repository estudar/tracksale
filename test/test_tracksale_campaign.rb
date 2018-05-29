require 'minitest/autorun'
require 'webmock/minitest'
require 'tracksale'

class TracksaleCampaignTest < Minitest::Test
  def setup
    Tracksale.configure do |config|
      config.key = 'foobar'
    end

    stub_request(:get, "http://api.tracksale.co/v2/campaign").
      with(headers: { 'authorization' => 'bearer foobar' }).
      to_return(body: "[{\"name\":\"random - name\"}]", headers: {content_type: 'application/json'}, status: 200)
  end

  def test_return_right_amount_of_items
    assert_equal 1, Tracksale::Campaign.all.size
    assert_equal 1, Tracksale::Campaign.find_by_name('random - name').size
    assert_equal 0, Tracksale::Campaign.find_by_name('random - another name').size
  end
end
