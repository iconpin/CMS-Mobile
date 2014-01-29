class CMS
  module Controllers
    class Multimedia
      def self.upload_image params
        file = params['file'][:tempfile]
        filename = params['file'][:filename]
        extension = File.extname(filename)
        name = params['name']
        description = params['description']

        image = Models::Image.new(
          :name => name,
          :description => description,
          :created_at => Time.now,
          :updated_at => Time.now
        )
        unless image.save  # Now we'll have and ID
          @flash.error = "No s'ha pogut desar la imatge"
        end

        image.path_tmp = File.join(TMP_DIR, "#{image.id}#{extension}")
        File.open(image.path_tmp, 'wb') do |f|
          f.write file.read
        end

        # If we're here, the upload was successful
        image.path = File.join(MULTIMEDIA_DIR, "/#{image.id}.jpg")
        if image.save
          @flash.success = "La imatge s'ha guardat amb èxit"
          Workers::ImageConverter.perform_async(image.id)  # First Sidekiq usage here!
          true
        else
          false
        end
      end

      def self.destroy params
        id = params['id']
        multimedia = Models::Multimedia.get(id)
        if multimedia.nil?
          @flash.error = "El multimedia especificat no existeix"
          false
        elsif multimedia.destroy
          @flash.success = "El multimedia s'ha esborrat amb èxit"
          true
        else
          @flash.error = "El multimedia especificat no s'ha pogut eliminar"
          false
        end
      end
    end
  end
end
