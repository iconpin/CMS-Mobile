# Cheese Mouse System

A CMS.

## What it should do?

- Transcoding of multimedia (audio, video, images)
- Allows management of PoI data

## Ruby dependencies

- sinatra
- data\_mapper
- warden
- mustache
- streamio-ffmpeg
- mini\_magick
- sidekiq

## System dependencies

- Application tested with Ruby 2.0 and 2.1.
- SQL DB (defaults to SQLite3)
- Redis (needed by Sidekiq for background asynchronous processing)

## Deployment

TODO
