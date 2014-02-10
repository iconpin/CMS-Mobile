# Cheese Mouse System

A CMS.

## What it should do?

- Transcoding of multimedia (audio, video, images)
- Allows management of PoI data

## Ruby dependencies

- sinatra
- data\_mapper
- warden
- haml
- streamio-ffmpeg
- mini\_magick
- sidekiq

## Front-end stuff

Distributed with the application.

- Twitter Bootstrap
- nod.js (for validation)

## System dependencies

- Application tested with Ruby 2.0 and 2.1.
- SQL DB (defaults to SQLite3)
- Redis (needed by Sidekiq for background asynchronous processing)

## Deployment

TODO

## Project structure

- `app.rb` contains the main Sinatra application
- `views`
- `templates`
- `workers`
- `utils`
