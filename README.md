# Beggar

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

[![Circle
CI](https://circleci.com/gh/thoughtbot/beggar.svg?style=svg&circle-token=07d9bd80401d852967891e169b8ef64ef36e649f)](https://circleci.com/gh/thoughtbot/beggar)

### What is beggar?

Beggar is a tool to help with getting pull request reviews. Once you have set up
Beggar on your repo, new pull requests will be posted to Beggar according to
their tags. These tags will also be used to determine which Slack room Beggar
will post to.

If the PR does not have a "Sign off" of "LGTM", it will be reposted to the same
rooms again after 30 minutes.

To make sure your PR goes to the correct place, your PR description should
include tags like `#rails #javascript #design`. Beggar will parse and send to
all the appropriate rooms!

Beggar also provides a web interface that allows you to view open PRs for your
group and filter them by tag. This makes it very easy to grab a pull request in
your downtime for whatever tag you prefer.

### Local Development

After you have cloned this repo, run this setup script to set up your machine
with the necessary dependencies to run and test this app:

    % ./bin/setup

It assumes you have a machine equipped with Ruby, Postgres, etc. If not, set up
your machine with [this script].

[this script]: https://github.com/thoughtbot/laptop

After setting up, you can run the application using [foreman]:

    % foreman start

If you don't have `foreman`, see [Foreman's install instructions][foreman]. It
is [purposefully excluded from the project's `Gemfile`][exclude].

[foreman]: https://github.com/ddollar/foreman
[exclude]: https://github.com/ddollar/foreman/pull/437#issuecomment-41110407

### Guidelines

Use the following guides for getting things done, programming well, and
programming in style.

* [Protocol](http://github.com/thoughtbot/guides/blob/master/protocol)
* [Best Practices](http://github.com/thoughtbot/guides/blob/master/best-practices)
* [Style](http://github.com/thoughtbot/guides/blob/master/style)
