FROM cirrusci/flutter:stable
WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web
