slack-phabricator
===

Notifies Slack about Phabricator changes.

Currently Noifies:

- Revision changes (open, close, update, comment, accept)



Uses [Phabulous](http://github.com/taylorfinnell/phabulous) for Phabricator access.

Setup
===

Set the following environment variables

PHABRICATOR_HOST=

PHABRICATOR_CERT=

PHABRICATOR_USER=


SLACK_WEBHOOK_URL=

SLACK_USERNAME=

Now you can deploy to heroku, or whatever you want.
