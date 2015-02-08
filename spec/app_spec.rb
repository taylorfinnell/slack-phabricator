require 'spec_helper'

describe App do
  def app
    App
  end

  before do
    @params = {
      data: 'some feed message',
      text: 'hi'
    }

    @reviewers = [Phabulous::User.new(userName: 'test')]
    @author = Phabulous::User.new(userName: 'author')
    @revision = Phabulous::Revision.new(uri: 'http://test.com', id: 1)
    @feed = double('feed', text: 'hi', data: {"objectPHID" => "PHID"})

    expect(Phabulous::Feed).to receive(:new).and_return(@feed)

    expect(Phabulous.revisions).to receive(:find).and_return(@revision)
    expect(@revision).to receive(:author).and_return(@author)
    expect(@revision).to receive(:reviewers).and_return(@reviewers)
  end

  it 'should send a slack notification to the author and reviewers' do
    (@reviewers + [@author]).each do |recipient|
      expect_any_instance_of(Slack::Notifier).to receive(:ping).with(anything(), channel: "@#{recipient.name}")
    end

    post 'slack-phabricator', @params

    expect(last_response).to be_ok
  end
end
