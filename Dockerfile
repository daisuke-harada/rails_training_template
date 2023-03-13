FROM ruby:3.1.3

RUN gem install "bundler:~>2.0" --no-document && \
  gem update --system && \
  gem cleanup

# Web dependencies

RUN apt-get update -qq && \
  apt-get install -y build-essential libpq-dev vim mariadb-client

# Web
WORKDIR /web
COPY ./Gemfile* /web/
RUN bundle install --jobs $(nproc) --retry 5
COPY . /web

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0"]
