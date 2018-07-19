require 'minitest/autorun'
require 'webmock/minitest'
require 'tracksale'

class TestTracksaleCampaign < Minitest::Test
  def setup
    Tracksale.configure { |c| c.key = 'foobar'; c.force_dummy_client(false) }

    stub_request(:get, 'http://api.tracksale.co/v2/campaign')
      .with(headers: { 'authorization' => 'bearer foobar' })
      .to_return(body: '[{"name":"random - name",' \
      '"code":1234, "detractors":1,' \
      '"passives":2, "promoters":3 }]',
    headers: { content_type: 'application/json' }, status: 200)

    stub_dispatch(121, 200, '{ "msg": "scheduled" }')
    stub_dispatch(123, 400, '{ "error": "Invalid Time"}')
    stub_dispatch(124, 500, '{ "foo": "bar"}')
  end

  def stub_dispatch(code, status, body)
    url = 'http://api.tracksale.co/v2/campaign/' + code.to_s + '/dispatch'
    stub_request(:post, url)
      .with(headers: { 'authorization' => 'bearer foobar',
      'content-type' => 'application/json' }, body: '"foo"')
      .to_return(body: body,
      headers: { content_type: 'application/json' }, status: status)
  end

  def test_dispatch_successful
    dispatch = Tracksale::Campaign.schedule_dispatch(121, 'foo')
    assert_equal dispatch['msg'], 'scheduled'
  end

  def test_dispatch_inavlid_params_error
    error = assert_raises ArgumentError do
      Tracksale::Campaign.schedule_dispatch(123, 'foo')
    end
    assert_match(/Invalid Time/, error.message)
  end

  def test_dispatch_server_error
    error = assert_raises Net::HTTPFatalError do
      Tracksale::Campaign.schedule_dispatch(124, 'foo')
    end
    assert_match(/500/, error.message)
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
