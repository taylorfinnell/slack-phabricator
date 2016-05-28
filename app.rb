require 'env'

class App < Grape::API
  post '/slack-phabricator' do
    feed = Phabulous::Feed.new(params)

    objectPHID = feed.data["objectPHID"]
    revision = Phabulous.revisions.find(objectPHID)

    if revision
      puts "Got revision authored by #{revision.author.name}, "\
            "Reviewed by #{revision.reviewers.map(&:name).join(', ')}, "\
            "Summary is #{feed.text}"
    end

    status 200
  end
end
