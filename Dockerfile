# Use the official Ruby image with your desired version
FROM ruby:3.1.2

# Set environment variables
ENV RAILS_ENV=production \
    RAILS_SERVE_STATIC_FILES=true \
    DATABASE_URL=cockroachdb://samuel:dccg90KTK5v92mRVu_L3bQ@div-tracker-14421.5xj.gcp-us-central1.cockroachlabs.cloud:26257/defaultdb?sslmode=verify-full


# Install essential Linux packages
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    nodejs \
    npm \
    && npm install -g yarn 



# Set working directory in the container
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install Ruby dependencies
RUN gem install bundler && bundle install --jobs 20 --retry 5
RUN   npm i -D daisyui@latest

RUN apt-get update && apt-get install -y \
  postgresql-client \
  libpq-dev

#DB
RUN curl --create-dirs -o $HOME/.postgresql/root.crt 'https://cockroachlabs.cloud/clusters/b0313d8c-005f-4347-bc27-63c34334c6c8/cert'

#RUN export DATABASE_URL='cockroachdb://samuel:dccg90KTK5v92mRVu_L3bQ@div-tracker-14421.5xj.gcp-us-central1.cockroachlabs.cloud:26257/defaultdb?sslmode=verify-full'
# Copy the rest of the application code
COPY . .

# Copy Tailwind CSS file into the assets pipeline
#COPY tailwind.css ./app/assets/stylesheets/

# Precompile assets
RUN bundle exec rails assets:precompile

# Expose port 3000 to the outside world
EXPOSE 3000

# Start the Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
