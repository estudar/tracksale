class TestTracksaleDummyClient < Minitest::Test
  def setup
    Tracksale.configure { |c| c.force_dummy_client }
  end

  def test_campaign_all_dummy
    assert Tracksale::Campaign.all.is_a? Array
    assert_equal [], Tracksale::Campaign.all
  end

  def test_campaign_find_by_name_dummy
    assert_nil Tracksale::Campaign.find_by_name('foobar')
  end

  def test_campaign_dispatch_dummy
    assert_equal Hash.new, Tracksale::Campaign.schedule_dispatch('code','body')
  end

  def test_allow_explict_response
    response = Object.new
    response.send :define_singleton_method, :success?, proc {true}
    Tracksale::DummyClient.response=response

    assert_equal response,Tracksale::Campaign.schedule_dispatch('code','body')

    Tracksale::DummyClient.response=nil # revert to default
  end
end
