# Pester

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

[![Circle CI](https://circleci.com/gh/thoughtbot/pester/tree/master.svg?style=svg&circle-token=07d9bd80401d852967891e169b8ef64ef36e649f)](https://circleci.com/gh/thoughtbot/pester/tree/master)

[![Code Climate](https://codeclimate.com/repos/5646125569568073e50002ca/badges/ed7a06e73f8d74dfc911/gpa.svg)](https://codeclimate.com/repos/5646125569568073e50002ca/feed)

### What is Pester?

Pester is a tool to help with getting pull request reviews. Once you have set up
Pester on your repo, new pull requests will be posted to Pester according to
their tags. These tags will also be used to determine which Slack room Pester
will post to.

If the PR does not have a "Sign off" of "LGTM", it will be reposted to the same
rooms again after 30 minutes. The time threshold to repost can be configured
using the ENV var, `REPOST_THRESHOLD`.

To make sure your PR goes to the correct place, your PR description should
include tags like `#rails #javascript #design`. Pester will parse and send to
all the appropriate rooms!

Pester also provides a web interface that allows you to view open PRs for your
group and filter them by tag. This makes it very easy to grab a pull request in
your downtime for whatever tag you prefer.

### Authentication

Pester uses GitHub teams for controlling access to the web interface. When
setting up the app, you should set the `GITHUB_TEAM_ID` environment variable to
the team id that will have access.

There is no User model and users are not tracked in anyway.

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

## Contributing

See the [CONTRIBUTING] document.
Thank you, [contributors]!

  [CONTRIBUTING]: CONTRIBUTING.md
  [contributors]: https://github.com/thoughtbot/pester/graphs/contributors


### Guidelines

Use the following guides for getting things done, programming well, and
programming in style.

* [Protocol](http://github.com/thoughtbot/guides/blob/master/protocol)
* [Best Practices](http://github.com/thoughtbot/guides/blob/master/best-practices)
* [Style](http://github.com/thoughtbot/guides/blob/master/style)

## License

Pester is Copyright (c) 2015 thoughtbot, inc.
It is free software, and may be redistributed
under the terms specified in the [LICENSE] file.

  [LICENSE]: LICENSE.md

## About

Pester is maintained by [Jason Draper], [Christian Reuter], and [Melissa Xie].

  [Jason Draper]: http://github.com/drapergeek
  [Christian Reuter]: http://github.com/creuter
  [Melissa Xie]: https://github.com/mxie

![thoughtbot](https://thoughtbot.com/logo.png)

Pester is maintained and funded by thoughtbot, inc.
The names and logos for thoughtbot are trademarks of thoughtbot, inc.

We love open source software!
See [our other projects][community]
or [hire us][hire] to help build your product.

  [community]: https://thoughtbot.com/community?utm_source=github
  [hire]: https://thoughtbot.com/hire-us?utm_source=github
