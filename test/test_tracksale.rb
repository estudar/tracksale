require 'minitest/autorun'
require 'tracksale'

class TracksaleTest < Minitest::Test
  def test_configure_key
    Tracksale.configure do |config|
      config.key = 'foobar'
    end

    assert_equal 'foobar', Tracksale::Client.new.key
  end

  def test_configure_client
    Tracksale.configure {|c| c.force_dummy_client(false) } #default
    assert_equal Tracksale::Client, Tracksale.configuration.client
    Tracksale.configure {|c| c.force_dummy_client }
    assert_equal Tracksale::DummyClient, Tracksale.configuration.client
  end
end
