# Multi-stage Dockerfile for Flutter Web (serving with nginx)

# --- Build Stage ---
FROM ghcr.io/cirruslabs/flutter:3.19.6 AS build
WORKDIR /app
COPY . .
RUN flutter pub get && flutter build web --release

# --- Serve Stage ---
FROM nginx:1.25-alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"] 