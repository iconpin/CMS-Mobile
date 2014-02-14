module CMS
  module Routes
    class Multimedia < Base
      before do
        @path = :multimedia
      end

      get '/image/create' do
        protect!

        haml :'multimedia/image/create'
      end

      post '/image/create' do
        protect!

        if Controllers::Multimedia.upload_image(params)
          flash.success = "Imatge creada amb èxit"
          redirect '/multimedias'
        else
          flash.error = "No s'ha pogut crear la imatge"
          redirect '/image/create'
        end
      end

      get '/video/create' do
        protect!

        haml :'multimedia/video/create'
      end

      post '/video/create' do
        protect!

        if Controllers::Multimedia.upload_video(params)
          flash.success = "Vídeo creat amb èxit"
          redirect '/multimedias'
        else
          flash.error = "No s'ha pogut crear el vídeo"
          redirect '/video/create'
        end
      end

      get '/multimedias' do
        protect!

        @multimedia_list = Models::Multimedia.all
        haml :'multimedia/all'
      end

      post '/multimedias/publish' do
        protect!

        if Controllers::Multimedia.publish(params)
          flash.success = "Multimèdia publicat amb èxit"
        else
          flash.error = "No s'ha pogut publicar el multimèdia"
        end
        redirect '/multimedias'
      end

      post '/multimedias/unpublish' do
        protect!

        if Controllers::Multimedia.unpublish(params)
          flash.success = "Multimèdia ocultat amb èxit"
        else
          flash.error = "No s'ha pogut ocultar el multimèdia"
        end
        redirect '/multimedias'
      end

      post '/multimedias/destroy' do
        protect!

        if Controllers::Multimedia.destroy(params)
          flash.success = "Multimedia destruït amb èxit"
        else
          flash.error = "No s'ha pogut destruir el multimedia"
        end
        redirect '/multimedias'
      end

      get '/multimedia' do
        protect!

        @current_multimedia = Models::Multimedia.get(params['id'])
        if @current_multimedia.nil?
          flash.error = "El multimèdia especificat no existeix"
          redirect '/multimedias'
        end

        haml :'multimedia/view'
      end

      get '/multimedia/edit' do
        protect!

        @current_multimedia = Models::Multimedia.get(params['id'])
        if @current_multimedia.nil?
          flash.error = "El multimèdia especificat no existeix"
          redirect '/multimedias'
        end

        haml :'multimedia/edit'
      end

      post '/multimedia/edit' do
        protect!

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
