module CMS
  module Routes
    class Point < Base
      before do
        protect!
        @path = :point
      end

      get '/point' do
        @current_point = Controllers::Point.get(params)
        if @current_point.nil?
          flash.error = "El punt no existeix"
          redirect '/points'
        else
          haml :'point/view'
        end
      end

      get '/points' do
        haml :'point/all'
      end

      get '/point/create' do
        haml :'point/create'
      end

      post '/point/create' do
        if Controllers::Point.create(params)
          flash.success = "POI creat amb èxit"
          redirect '/points'
        else
          flash.error = "No s'ha pogut crear el punt"
          redirect '/point/create'
        end
      end

      post '/point/destroy' do
        if Controllers::Point.destroy(params)
          flash.success = "POI esborrat amb èxit"
        else
          flash.error = "No s'ha pogut esborrar el punt"
        end
        redirect '/points'
      end

      post '/point/publish' do
        if Controllers::Point.publish(params)
          flash.success = "POI publicat amb èxit"
        else
          flash.error = "No s'ha pogut publicar el punt"
        end
        redirect '/points'
      end

      post '/point/unpublish' do
        if Controllers::Point.unpublish(params)
          flash.success = "POI ocultat amb èxit"
        else
          flash.error = "No s'ha pogut ocultar el punt"
        end
        redirect '/points'
      end

      post '/point/up' do
        Controllers::Point.up(params)
        redirect '/points'
      end

      post '/point/down' do
        Controllers::Point.down(params)
        redirect '/points'
      end

      get '/point/edit' do
        @current_point = Controllers::Point.get(params)
        if @current_point.nil?
          redirect '/points'
        end

        haml :'point/edit'
      end

      post '/point/edit' do
        if Controllers::Point.edit(params)
          flash.success = "POI actualitzat amb èxit"
          redirect '/points'
        else
          flash.error = "No s'ha pogut actualitzar el punt"
          redirect_back
        end
      end

      get '/point/multimedia/edit' do
        @current_point = Controllers::Point.get(params)
        if @current_point.nil?
          redirect '/points'
        end

        haml :'point/multimedia/edit'
      end

      post '/point/multimedia/edit' do
        point_id = params['point']

        unless Controllers::Point.edit_multimedia(params)
          flash.error = "No s'ha pogut modificar la relació"
        end
        redirect "/point/multimedia/edit?id=#{point_id}"
      end

      post '/point/multimedia/up' do
        point_id = params['point']
        unless Controllers::Point.multimedia_up(params)
          flash.error = "No s'ha pogut moure el multimèdia"
        end
        redirect "/point/multimedia/edit?id=#{point_id}"
      end

      post '/point/multimedia/down' do
        point_id = params['point']
        unless Controllers::Point.multimedia_down(params)
          flash.error = "No s'ha pogut moure el multimèdia"
        end
        redirect "/point/multimedia/edit?id=#{point_id}"
      end

      get '/point/extra/edit' do
        @current_point = Controllers::Point.get(params)
        haml :'point/extra/edit'
      end

      post '/point/extra/edit' do
        unless Controllers::Point.edit_extra(params)
          flash.error = "No s'ha pogut modificar la relació"
        end
        redirect "/point/extra/edit?id=#{params['point']}"
      end

      post '/point/extra/up' do
        unless Controllers::Point.extra_up(params)
          flash.error = "No s'ha pogut moure el multimèdia"
        end
        redirect "/point/extra/edit?id=#{params['point']}"
      end

      post '/point/extra/down' do
        unless Controllers::Point.extra_down(params)
          flash.error = "No s'ha pogut moure el multimèdia"
        end
        redirect "/point/extra/edit?id=#{params['point']}"
      end
    end
  end
end
