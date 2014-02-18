module CMS
  module Routes
    class Extra < Base
      before do
        @path = :extra
      end

      get '/extras' do
        protect!

        haml :'extra/all'
      end
    end
  end
end
