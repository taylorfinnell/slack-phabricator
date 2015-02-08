require 'json'

Dotenv.load

class App < Sinatra::Application
  def self.slack_username(phabricator_name)
    @user_map ||= JSON(ENV['USER_MAP'] || "{}")
    if @user_map
      @user_map[phabricator_name] || phabricator_name
    else
      phabricator_name
    end
  end

  def self.notifier
    @notifier ||= Slack::Notifier.new(ENV['SLACK_WEBHOOK_URL'],
                                      username: ENV['SLACK_USERNAME'] || 'slack-phabricator')
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
      ([revision.author] + revision.reviewers).each do |recepient|
        message = feed.text
        channel = "@#{App.slack_username(recepient.name)}"

        message = "#{message} <a href='#{revision.uri}'>View #{revision.differential_id}</a>"
        message = Slack::Notifier::LinkFormatter.format(message)

        App.notifier.ping(message, channel: channel)
      end
    end

    status 200
  end
end
