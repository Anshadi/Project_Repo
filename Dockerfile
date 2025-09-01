FROM ubuntu:22.04 AS build

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip libglu1-mesa \
    && rm -rf /var/lib/apt/lists/*

# Create user and directories
RUN useradd -m flutteruser && \
    mkdir -p /usr/local/flutter /app && \
    chown flutteruser:flutteruser /usr/local/flutter /app

USER flutteruser

# Install specific Flutter version
RUN git clone https://github.com/flutter/flutter.git -b 3.13.6 /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:${PATH}"

WORKDIR /app

# Copy and build
COPY --chown=flutteruser pubspec.* ./
RUN flutter pub get

COPY --chown=flutteruser . .
RUN flutter build web --release

FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
