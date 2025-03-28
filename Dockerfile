# Use Ruby 1.9.3
FROM corgibytes/ruby-1.9.3

# Repair error with public key of jessie
RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://archive.debian.org/debian-security/ jessie/updates main\ndeb-src http://archive.debian.org/debian-security/ jessie/updates main" > /etc/apt/sources.list

# Update apt and install necessary dependencies
RUN apt-get update -qq && apt-get install -y --force-yes \
    build-essential \
    libpq-dev \
    nodejs \
    webp \
    xfonts-75dpi \
    xfonts-base \
    xvfb \
    libfontconfig \
    libjpeg-dev \
    libjpeg62-turbo-dev

# Set up the working directory for the app
ENV APP_HOME /code
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

# Install Bundler for Ruby 1.9.3 (required for managing gems)
RUN gem install bundler -v 1.17.3

# Copy Gemfile and Gemfile.lock into the container
COPY Gemfile /code/Gemfile
COPY Gemfile.lock /code/Gemfile.lock

# Install Ruby dependencies using Bundler
RUN bundle install --without development test

# Copy the rest of the app code
COPY . /code

# Set the default command to run the app
CMD ["rails", "server", "-b", "0.0.0.0"]
