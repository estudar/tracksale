require 'minitest/autorun'
require 'webmock/minitest'
require 'tracksale'

class TracksaleCampaignTest < Minitest::Test
  def setup
    Tracksale.configure { |c| c.key = 'foobar' }

    stub_request(:get, 'http://api.tracksale.co/v2/campaign')
      .with(headers: { 'authorization' => 'bearer foobar' })
      .to_return(body: '[{"name":"random - name",' \
                      '"code":1234,' \
                      '"detractors":1,' \
                      '"passives":2,' \
                      '"promoters":3 }]',
                 headers: { content_type: 'application/json' }, status: 200)
  end

  def test_return_right_amount_of_items
    assert_equal 1, Tracksale::Campaign.all.size
    assert !subject.nil?
    assert Tracksale::Campaign.find_by_name('random - another name').nil?
  end

  def test_find_return_a_campaign
    assert subject.is_a? Tracksale::Campaign
  end

  def test_campaign_has_a_name
    assert subject.respond_to? :name
    assert_equal 'random - name', subject.name
  end

  def test_campaign_has_a_code
    assert subject.respond_to? :code
    assert_equal 1234, subject.code
  end

  def test_campaign_scores
    campaign = subject
    assert campaign.respond_to? :score
    expected_score = { detractors: 1, passives: 2, promoters: 3 }
    assert_equal expected_score, campaign.score
  end

  def test_all_returns_campaigns
    assert Tracksale::Campaign.all.first.is_a? Tracksale::Campaign
  end

  private

  def subject
    Tracksale::Campaign.find_by_name('random - name')
  end
end
