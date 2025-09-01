FROM ubuntu:22.04 AS build

# Install Flutter dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Create flutter user to avoid ownership issues
RUN useradd -m -s /bin/bash flutteruser && \
    mkdir -p /usr/local/flutter /app && \
    chown flutteruser:flutteruser /usr/local/flutter /app

# Switch to flutter user
USER flutteruser

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1 /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Create app directory and set working directory
WORKDIR /app

# Copy pubspec files first for better caching
COPY --chown=flutteruser:flutteruser pubspec.* ./
RUN flutter pub get

# Copy the rest of the files with proper ownership
COPY --chown=flutteruser:flutteruser . .

# Build web app
RUN flutter build web

# Switch back to root for nginx setup
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
