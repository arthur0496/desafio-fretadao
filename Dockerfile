FROM ruby:2.7

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -

RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && apt-get install -y build-essential \
                                              libpq-dev \
                                              nodejs\
                                              yarn

WORKDIR /challenge

COPY . /challenge

RUN bundle install 
