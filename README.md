# Cheese Mouse System

A CMS.

## What it does

- Transcoding of multimedia (audio, video, images)
- Management of PoI data

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

## Development

To run the app:

```
$ rerun 'rackup -p PORT -o HOST'
```

To start sidekiq:

```
$ bundle exec sidekiq -r ./app.rb
```

## Deployment

TODO

## Project structure

- `app.rb`: main Sinatra application
- `models`: application models
- `routes`: Sinatra apps that are mounted in `app.rb`
- `views`: HAML views
- `workers`: sidekiq workers
- `utils`: helper modules
