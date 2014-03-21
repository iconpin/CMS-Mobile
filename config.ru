require_relative 'app/app'

use Rack::ShowExceptions

run CMS::App
