# Use the official Ruby image with your desired version
FROM ruby:3.1.2

# Set environment variables
ENV RAILS_ENV=development \
    RAILS_SERVE_STATIC_FILES=true

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
