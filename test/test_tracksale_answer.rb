require 'minitest/autorun'
require 'webmock/minitest'
require 'tracksale'

class TestTracksaleAnswer < Minitest::Test
  def setup
    Tracksale.configure { |c| c.key = 'foobar'; c.force_dummy_client(false) }

    body_for_campaign = '[{"name":"random - name",' \
    '"code":7, "detractors":1,' \
    '"passives":2, "promoters":3 }]'

    stub_request(:get, 'http://api.tracksale.co/v2/campaign/7')
      .with(headers: { 'authorization' => 'bearer foobar' })
      .to_return(body: body_for_campaign,
                 headers: { content_type: 'application/json' }, status: 200)

    stub_request(:get, 'http://api.tracksale.co/v2/report/answer?tags=true&limit=' + Tracksale::Answer::LIMIT.to_s)
      .with(headers: { 'authorization' => 'bearer foobar' })
      .to_return(body: '[{
        "time": 1532611646,
        "type": "Email",
        "name": "Um Dois Tres Quatro",
        "email": "emailaleatorio@gmail.com",
        "identification": null,
        "phone": null,
        "alternative_email": null,
        "alternative_phone": null,
        "nps_answer": 10,
        "last_nps_answer": null,
        "nps_comment": null,
        "campaign_name": "Campanha de Teste",
        "campaign_code": 7,
        "id": 11112222,
        "deadline": null,
        "elapsed_time": 116,
        "dispatch_time": null,
        "reminder_time": null,
        "status": "Não precisa contatar",
        "priority": "Nenhuma",
        "assignee": "Boris",
        "picture": null,
        "tags": [
            {
                "name": "test1",
                "value": "test2"
            },
            {
                "name": "test3",
                "value": "test4"
            }
        ],
        "categories": [],
        "justifications": [
            {
                "name": "{\"pt-br\":\"foo\"}",
                "children": [
                    "{\"pt-br\":\"bar\"}",
                    "{\"pt-br\":\"bar2\"}",
                    "{\"pt-br\":\"bar3\"}"
                ]
            }
       ]
    }
]',
                 headers: { content_type: 'application/json' }, status: 200)
  end

  def test_answer_tags
    assert subject.respond_to? :tags
    expected_tags = { 'test1' => 'test2', 'test3' => 'test4' }
    assert_equal expected_tags, subject.tags
  end

  def test_justifications
    assert subject.respond_to? :justifications
    expected_justifications = [{ 'foo' => %w[bar bar2 bar3] }]
    assert_equal expected_justifications, subject.justifications
  end

  def test_campaign
    assert subject.campaign.is_a? Tracksale::Campaign
  end

  def subject
    Tracksale::Answer.all.first
  end
end
