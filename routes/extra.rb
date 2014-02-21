module CMS
  module Routes
    class Extra < Base
      before do
        protect!
        @path = :extra
      end

      get '/extras' do
        haml :'extra/all'
      end

      get '/extra/create' do
        haml :'extra/create'
      end

      get '/extra' do
        @current_extra = Controllers::Extra.get(params)
        haml :'extra/view'
      end

      post '/extra/create' do
        if Controllers::Extra.create params
          flash.success = "Extra creat amb èxit"
          redirect '/extras'
        else
          flash.error = "No s'ha pogut crear l'extra"
          redirect '/extra/create'
        end
      end

      post '/extra/destroy' do
        if Controllers::Extra.destroy params
          flash.success = "Extra esborrat amb èxit"
        else
          flash.error = "No s'ha pogut esborrar l'extra"
        end
        redirect '/extras'
      end

      get '/extra/edit' do
        @current_extra = Controllers::Extra.get(params)
        haml :'extra/edit'
      end

      post '/extra/edit' do
        extra = Controllers::Extra.get(params)
        unless Controllers::Extra.edit(params)
          flash.error = "No s'ha pogut editar l'extra"
          redirect extra.edit_link
        else
          redirect extra.link
        end
      end

      get '/extra/multimedia/edit' do
        @current_extra = Controllers::Extra.get(params)
        haml :'extra/multimedia/edit'
      end

      post '/extra/multimedia/edit' do
        extra = Controllers::Extra.get(params)
        unless Controllers::Extra.edit_multimedia(params)
          flash.error = "No s'ha pogut editar l'extra"
          redirect extra.edit_multimedia_link
        else
          redirect extra.link
        end
      end
    end
  end
end
