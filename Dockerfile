FROM ruby:2.7

# RUN apt-get update -qq && apt-get install -y build-essential \
#                                               libpq-dev \
#                                               nodejs\
#                                               yarn

WORKDIR /challenge

COPY . /challenge

RUN bundle install 
