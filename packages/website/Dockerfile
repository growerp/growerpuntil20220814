#Stage 1 - Install dependencies and build the app
FROM debian:latest AS build-env

# Install flutter dependencies
RUN apt-get update && \
    apt-get install -y curl git wget zip unzip libgconf-2-4 gdb libstdc++6 \
        libglu1-mesa fonts-droid-fallback lib32stdc++6 python3 nano && \
    apt-get clean

# Clone the flutter repo
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter && \
    /usr/local/flutter/bin/flutter doctor -v

ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# set flutter channel
RUN flutter channel stable && flutter upgrade

# Copy files to container and build
# RUN mkdir /usr/local/
RUN git clone https://github.com/growerp/growerp-website.git /usr/local/growerp && \
    cd /usr/local/growerp && git fetch
WORKDIR /usr/local/growerp
RUN /usr/local/flutter/bin/flutter build web --release

# Stage 2 - Create the run-time image
FROM nginx
COPY --from=build-env /usr/local/growerp/build/web /usr/share/nginx/html
EXPOSE 80
