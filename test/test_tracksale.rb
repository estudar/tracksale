require 'minitest/autorun'
require 'tracksale'

class TracksaleTest < Minitest::Test
  def test_configure
    Tracksale.configure do |config|
      config.key = 'foobar'
    end

    assert_equal 'foobar',Tracksale::Client.new.key
  end
end
