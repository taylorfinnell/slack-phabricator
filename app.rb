require 'json'

Dotenv.load

class App < Sinatra::Application
  def self.notifier
    @notifier ||= Slack::Notifier.new(ENV['SLACK_WEBHOOK_URL'],
                                      username: 'code-review-bot')
  end

  Phabulous.configure do |config|
    config.host = ENV['PHABRICATOR_HOST']
    config.user = ENV['PHABRICATOR_USER']
    config.cert = ENV['PHABRICATOR_CERT']
  end
  Phabulous.connect!

  post '/slack-phabricator' do
    feed = Phabulous::Feed.new(params)

    objectPHID = feed.data["objectPHID"]
    revision = Phabulous.revisions.find(objectPHID)

    if revision
      message = feed.text
      channel = "#code-review"

      message = "#{message} <a href='#{revision.uri}'>View #{revision.differential_id} (reviewers: #{revision.reviewers.map { |r| "@#{r.name}" }.join(', ')})</a>"
      message = Slack::Notifier::LinkFormatter.format(message)

      App.notifier.ping(message, channel: channel)
    end

    status 200
  end
end
