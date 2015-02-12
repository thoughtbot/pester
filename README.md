# Beggar

[![Circle
CI](https://circleci.com/gh/thoughtbot/beggar.svg?style=svg&circle-token=07d9bd80401d852967891e169b8ef64ef36e649f)](https://circleci.com/gh/thoughtbot/beggar)

### What is beggar?

Beggar is a tool to help with getting pull request reviews. Once you have set up
beggar on your repo, any new pull request will automatically be added to beggar.
It will also automatically be posted to the correct Slack room based on the tags
you've provided.

To make sure your PR goes to the correct place, your PR description should
include tags like #rails #javascript #design. Beggar will parse and send to all
the appropriate rooms!

Tags you can use currently:

* android
* angular
* code
* design
* ember
* haskell
* ios
* javascript
* objective-c
* rails
* react
* ruby
* swift

We have a web ui that will allow you to view open PRs. You can filter this by
tag: https://tbot.io/beggar

### How to use beggar for your project

Follow these instructions: http://tbot-beggar.herokuapp.com/pages/setup

### Getting Started

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
