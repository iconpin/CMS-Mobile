module CMS
  module Routes
    class Multimedia < Base
      before do
        protect!
        @path = :multimedia
      end

      get '/image/create' do
        haml :'multimedia/image/create'
      end

      post '/image/create' do
        if Controllers::Image.upload(params)
          flash.success = "Imatge creada amb èxit"
          redirect '/multimedias'
        else
          flash.error = "No s'ha pogut crear la imatge"
          redirect '/image/create'
        end
      end

      get '/video/create' do
        haml :'multimedia/video/create'
      end

      post '/video/create' do
        if Controllers::Video.upload(params)
          flash.success = "Vídeo creat amb èxit"
          redirect '/multimedias'
        else
          flash.error = "No s'ha pogut crear el vídeo"
          redirect '/video/create'
        end
      end

      get '/audio/create' do
        haml :'multimedia/audio/create'
      end

      post '/audio/create' do
        if Controllers::Audio.upload(params)
          flash.success = "Locució creada amb èxit"
          redirect '/multimedias'
        else
          flash.error = "No s'ha pogut crear la locució"
          redirect '/audio/create'
        end
      end

      get '/multimedias' do
        @multimedia_list = Models::Multimedia.all
        haml :'multimedia/all'
      end

      post '/multimedias/publish' do
        if Controllers::Multimedia.publish(params)
          flash.success = "Multimèdia publicat amb èxit"
        else
          flash.error = "No s'ha pogut publicar el multimèdia"
        end
        redirect '/multimedias'
      end

      post '/multimedias/unpublish' do
        if Controllers::Multimedia.unpublish(params)
          flash.success = "Multimèdia ocultat amb èxit"
        else
          flash.error = "No s'ha pogut ocultar el multimèdia"
        end
        redirect '/multimedias'
      end

      post '/multimedias/destroy' do
        if Controllers::Multimedia.destroy(params)
          flash.success = "Multimedia destruït amb èxit"
        else
          flash.error = "No s'ha pogut destruir el multimedia"
        end
        redirect '/multimedias'
      end

      get '/multimedia' do
        @current_multimedia = Models::Multimedia.get(params['id'])
        if @current_multimedia.nil?
          flash.error = "El multimèdia especificat no existeix"
          redirect '/multimedias'
        end

        haml :'multimedia/view'
      end

      get '/multimedia/edit' do
        @current_multimedia = Models::Multimedia.get(params['id'])
        if @current_multimedia.nil?
          flash.error = "El multimèdia especificat no existeix"
          redirect '/multimedias'
        end

        haml :'multimedia/edit'
      end

      post '/multimedia/edit' do
        multimedia_id = params['id']

        unless Controllers::Multimedia.edit(params)
          flash.error = "No s'ha pogut editar el multimèdia"
          redirect "/multimedia/edit?id=#{multimedia_id}"
        else
          redirect "/multimedia?id=#{multimedia_id}"
        end
      end
    end
  end
end
