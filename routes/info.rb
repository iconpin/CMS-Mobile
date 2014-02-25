module CMS
  module Routes
    class Info < Base
      before do
        @path = :info
      end

      get '/info' do
        @info = Models::Info.first
        if @info.nil?
          flash.info = "Encara no s'ha afegit informació al sistema"
          redirect 'info/edit'
        end
        haml :'info/view'
      end

      get '/info/edit' do
        @info = Models::Info.first || Models::NoInfo.new
        haml :'info/edit'
      end

      post '/info/edit' do
        info = Models::Info.first_or_create
        success = info.update({
          :text => params['text']
        })
        if success
          flash.success = "Informació actualitzada amb èxit"
          redirect '/info'
        else
          flash.error = "Informació no actualitzada"
          redirect '/info/edit'
        end
      end
    end
  end
end
