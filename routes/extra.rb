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
    end
  end
end
