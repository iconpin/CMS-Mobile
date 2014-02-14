require_relative 'app'

use Rack::ShowExceptions

run CMS::App
