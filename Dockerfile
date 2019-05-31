FROM ruby:2.2.3

RUN apt-get update -qq && \
  apt-get install -y build-essential && \
  apt-get install -y libpq-dev && \
  apt-get install -y libxml2-dev libxslt1-dev && \
  apt-get install -y libqt4-webkit libqt4-dev xvfb && \
  apt-get install -y nodejs

COPY . /app
WORKDIR /app
RUN bundle install
