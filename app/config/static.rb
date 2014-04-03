module CMS
  module Static
    AUGMENTED_REALITY = {
      1 => "ARImages/aymeric/aymeric.jpg",
      2 => "ARImages/masia/masia.jpg",
      3 => "ARImages/mercat/mercat.jpg",
      4 => "ARImages/ajuntament/ajuntament.jpg",
      5 => "ARImages/institut/institut.jpg",
      6 => "ARImages/teatre/teatre.jpg",
      7 => "ARImages/magatzem/magatzem.jpg",
      8 => "ARImages/banc/banc.jpg",
      9 => "ARImages/caixa/caixa.jpg",
      10 => "ARImages/confiteria/confiteria.jpg",
      16 => "ARImages/quadra/quadra.jpg",
      17 => "ARImages/ventallo/ventallo.jpg",
      18 => "ARImages/estacio/estacio.jpg"
    }

    POI_XML_DATA = {
      :after => 18,
      :data => %(
        <PoI NameId="XEMENEIES">
          <textMultimedia type="short" TitleId="XEMENEIES" DescriptionID="XEMENEIES" imagePath="borrable">
          </textMultimedia>
          <textMultimedia type="large" TitleId="XEMENEIES" DescriptionID="XEMENEIES" imagePath="borrable">
          </textMultimedia>
          <GPSPoint latitude="41.565561" longitude="2.007657"></GPSPoint>
          <RA has="true" imagePath="XEMENEIES"></RA>
        </PoI>
        <Text id="XEMENEIES" cat="Xemeneies RA" cast="Inicio" ang="Home"></Text>
      )
    }

    EXTRA_XML_DATA = %(

      <Text 	id="HomeButtonName"
          cat="Inici"
          cast="Inicio"
          ang="Home">
      </Text>
      <Text 	id="MapButtonName"
          cat="Mapa"
          cast="Mapa"
          ang="Map">
      </Text>
      <Text 	id="POIButtonName"
          cat="Punts d'interès"
          cast="Puntos de interes"
          ang="Points of interest">
      </Text>
      <Text 	id="RAButtonName"
          cat="Realitat augmentada"
          cast="Realidad augmentada"
          ang="Augmented reality">
      </Text>
      <Text 	id="GameButtonName"
          cat="Extres"
          cast="Quieres un caramelo?"
          ang="Wana play?">
      </Text>
      <Text 	id="mnactecPhone"
          cat="93 736 89 66"
          cast="93 736 89 66"
          ang="93 736 89 66">
      </Text>
      <Text 	id="mnactecEMAIL"
          cat="info.mnactec@gencat.cat?"
          cast="info.mnactec@gencat.cat?"
          ang="info.mnactec@gencat.cat?">
      </Text>
      <Text 	id="mnactecStreet"
          cat="Rambla d'ègara, 270
08221 Terrassa"
          cast="Rambla d'ègara, 270
08221 Terrassa"
          ang="Rambla d'ègara, 270
08221 Terrassa">
      </Text>
      <Text 	id="mnactecHours"
          cat="Horari d'hivern (1/9 - 30/6)
Dimarts a divendres de 10 a 19 h
Dissabtes, diumenges i festius de 10 a 14.30 h

Horari d'estiu (1/7 - 31/8)
Dimarts a diumenge de 10 a 14.30"
          cast="Horari d'hivern (1/9 - 30/6)
Dimarts a divendres de 10 a 19 h
Dissabtes, diumenges i festius de 10 a 14.30 h

Horari d'estiu (1/7 - 31/8)
Dimarts a diumenge de 10 a 14.30"
          ang="Horari d'hivern (1/9 - 30/6)
Dimarts a divendres de 10 a 19 h
Dissabtes, diumenges i festius de 10 a 14.30 h

Horari d'estiu (1/7 - 31/8)
Dimarts a diumenge de 10 a 14.30">
      </Text>
      <Text id="mnactecMuseum"
        cat="El Museu de la Ciència i de la Tècnica de Catalunya (mNACTEC) mostra l'evolució dels avenços científics i tècnics a Catalunya i, particularment, la seva aplicació industrial. Té 22.000 m2 de superfície total, dels quals 11.000 m2 corresponen a l'antiga nau de producció, de planta rectangular, del Vapor Aymerich, Amat i Jover. En aquesta gran sala s'hi troben avui les exposicions Enérgeia, La Fàbrica Tèxtil, Homo Faber, El Transport, l'Enigma del ordinador i CERN: Explorant els inicis del univers, entre moltes altres!\n \nPots visitar el museu de dimarts a divendres de 10 a 19 h i dissabtes, diumenges i festius de 10 a 14.30 h.\n \nA més, hi ha un seguit de dies de l'any que pots fer-ho gratuïtament: l'últim dimarts de mes (d'octubre a juny), per Sant Jordi (23 d'abril), durant la Fira Modernista de Terrassa (segon cap de setmana de maig), el Dia Internacional dels Museus (18 de maig), el dilluns de Festa Major de Terrassa (primer dilluns de juliol), la Diada Nacional de Catalunya (11 de setembre) i durant les Jornades Europees del Patrimoni (darrer cap de setmana de setembre).\n \nPer conèixer a fons el mNACTEC consulta la nostra web www.mnactec.cat." cast="" ang="">
      </Text>
      <Text 	id="ajuntamentText"
          cat="Telèfon: 93 739 70 00
Adreça: Raval Montserrat, 14,
        08221 Terrassa, Barcelona

Amb més de 216.000 habitants, Terrassa poseseix un ric patrimoni cultural i artístic al bell mig d'un paisatge dominat pel Parc Natural de Sant Llorenç. La Seu d'Ègara, situada al costat del parc de Vallparadís on s'han fet importants troballes paleontològiques, la Torre del Palau i el Castell-Cartoixa configuren el seu patrimoni medieval.

Un salt en el temps ens porta a l'època del Modernisme i a la industrialització: Vapor Aymeric, Amat i Jover (actual mNACTEC), Masia Freixa, Casa Alegre de Sagrera..."
          cast="Telèfon: 93 739 70 00
Adreça: Raval Montserrat, 14,
        08221 Terrassa, Barcelona

Amb més de 216.000 habitants, Terrassa poseseix un ric patrimoni cultural i artístic al bell mig d'un paisatge dominat pel Parc Natural de Sant Llorenç. La Seu d'Ègara, situada al costat del parc de Vallparadís on s'han fet importants troballes paleontològiques, la Torre del Palau i el Castell-Cartoixa configuren el seu patrimoni medieval.

Un salt en el temps ens porta a l'època del Modernisme i a la industrialització: Vapor Aymeric, Amat i Jover (actual mNACTEC), Masia Freixa, Casa Alegre de Sagrera..."
          ang="Telèfon: 93 739 70 00
Adreça: Raval Montserrat, 14,
        08221 Terrassa, Barcelona

Amb més de 216.000 habitants, Terrassa poseseix un ric patrimoni cultural i artístic al bell mig d'un paisatge dominat pel Parc Natural de Sant Llorenç. La Seu d'Ègara, situada al costat del parc de Vallparadís on s'han fet importants troballes paleontològiques, la Torre del Palau i el Castell-Cartoixa configuren el seu patrimoni medieval.

Un salt en el temps ens porta a l'època del Modernisme i a la industrialització: Vapor Aymeric, Amat i Jover (actual mNACTEC), Masia Freixa, Casa Alegre de Sagrera...">
      </Text>
      <Text 	id="creditsTitle"
          cat="CRÈDITS"
          cast="CRÈDITS"
          ang="CRÈDITS">
      </Text>
      <Text 	id="aqui"
          cat="Ets aquí"
          cast="tas aqui"
          ang="u'r here">
      </Text>
      <Text 	id="muncuTextIdIntro"
          cat="Sóc Lluís Muncunill i et portaré a fer una ruta per l'itinerari industrial"
          cast="tas aqui"
          ang="u'r here">
      </Text>
      <Text 	id="muncuTextMap"
      cat="Navega per cada punt d’interès de l’aplicació i fes doble clic a les icones"
          cast="tas aqui"
          ang="u'r here">
      </Text>
      <Text 	id="muncuTextMapRA"
      cat="Fes doble clic i visita cada punt amb Realitat Augmentada del mapa!"
          cast="tas aqui"
          ang="u'r here">
      </Text>
      <Text 	id="muncuTextRA"
      cat="Realitat Augmentada! Busca els marcadors al terra i enquadra el teu voltant!"
          cast="tas aqui"
          ang="u'r here">
      </Text>
      <Text 	id="muncuTextRAVapor"
          cat="Atenció: entra al pati del museu, situa't al marcador i enquadra!"
          cast="tas aqui"
          ang="u'r here">
      </Text>
      <Text 	id="muncuTextRAEspecialOne"
          cat="Puja al mirador del museu, busca el marcador i enquadra el teu voltant!"
          cast="tas aqui"
          ang="u'r here">
      </Text>
      <Text 	id="muncuTextExtraList"
          cat="Vols saber-ne més?"
          cast="tas aqui"
          ang="u'r here">
      </Text>
      <Text 	id="muncuTextPoIList"
          cat="Els Punts d'Interès amb l'icona de l'ull, disposen de Realitat Augmentada"
          cast="tas aqui"
          ang="u'r here">
      </Text>
  <Text 	id="ajuntamentScreenBlock"
    cat="Ajuntament de Terrassa\nRaval de Montserrat, 14\n08221\nTel: 93 739 70 00\n \nOficina de Turisme\nMasia Freixa - Parc de Sant Jordi\nPl. Freixa i Argemí, 11\n08224\nTel: 93 739 70 19\n \n \n \nTerrassa és una ciutat universitària i industrial amb un ric patrimoni cultural i artístic. Està situada a 20 minuts de la ciutat de Barcelona i a 25 minuts en cotxe de l’aeroport del Prat. La ciutat té més de 216.000 habitants i està dominada pel paisatge del parc natural de Sant Llorenç del Munt i l’Obac.\n \nGràcies al ric patrimoni que té la ciutat, pots viatjar en la història catalana. La Seu d’Ègara -on s’hi han fet importants troballes paleontològiques-, la Torre del Palau i el Castell Cartoixa de Vallparadís, configuren el seu patrimoni medieval.\n \nUn salt en el temps ens porta a l’època del modernisme i la industrialització, on el sector tèxtil, especialitzat en la indústria de la llana, va impulsar la creació del que és avui un patrimoni únic en el seu gènere a Catalunya. Les antigues fàbriques i vapors, els habitatges, els magatzems, les xemeneies... et permetran conèixer de prop l’arquitectura, les arts, l’estil de vida del segle XIX i començaments del segle XX, com el Vapor Aymerich, Amat i Jover (actual mNACTEC), la Masia Freixa, la Casa Alegre de Sagrera...\n \nEl Festival de Jazz, la Fira Modernista, l’hoquei, les temporades de dansa, música i teatre, les exhibicions castelleres o el golf, completen una àmplia oferta per gaudir d’una ciutat dinàmica i de serveis."
      cast=""
      ang="">
  </Text>
      <Text 	id="credits1"
          cat="Organització"
          cast=""
          ang="">
      </Text>
      <Text 	id="credits1content"
          cat="Museu de la Ciència i de la Tècnica de Catalunya (mNACTEC) i Ajuntament de Terrassa"
          cast=""
          ang="">
      </Text>
      <Text 	id="credits2"
          cat="Idea i direcció"
          cast=""
          ang="">
      </Text>
      <Text 	id="credits2content"
          cat="Exposicions, projectes, acció educativa (mNACTEC)"
          cast=""
          ang="">
      </Text>
      <Text 	id="credits3"
          cat="Guió i assessorament"
          cast=""
          ang="">
      </Text>
      <Text 	id="credits3content"
          cat="Eusebi Casanelles
Domènec Ferran
Teresa Llordés
Conxa Bayó
Evaristo Gonzalez
Josep Dalmau
Abel Gálvez"
          cast=""
          ang="">
      </Text>
      <Text 	id="credits4"
          cat="Coordinació"
          cast=""
          ang="">
      </Text>
      <Text 	id="credits4content"
          cat="Anna Verdaguer
Gisela Gonzalo"
          cast=""
          ang="">
      </Text>
      <Text 	id="credits5"
          cat="Desenvolupament de l'aplicació"
          cast=""
          ang="">
      </Text>
      <Text 	id="credits5content"
          cat="Fundació i2cat"
          cast=""
          ang="">
      </Text>
      <Text 	id="credits6"
          cat="Coordinació (i2cat)"
          cast=""
          ang="">
      </Text>
      <Text 	id="credits6content"
          cat="Sergi Fernández
Mercè López
Núria Campreciós"
          cast=""
          ang="">
      </Text>
      <Text 	id="credits7"
          cat="Desenvolupament tècnic (i2cat)"
          cast=""
          ang="">
      </Text>
      <Text 	id="credits7content"
          cat="Marc Fernández Vanaclocha
Ignacio Contreras Pinilla"
          cast=""
          ang="">
      </Text>
      <Text 	id="credits8"
          cat="Disseny Gràfic"
          cast=""
          ang="">
      </Text>
      <Text 	id="credits8content"
          cat="Edu Solé"
          cast=""
          ang="">
      </Text>
      <Text 	id="credits9"
          cat="Guió i textos"
          cast=""
          ang="">
      </Text>
      <Text 	id="credits9content"
          cat="Eusebi Casanelles
Domènec Ferran
Joan Mallarach"
          cast=""
          ang="">
      </Text>
      <Text 	id="credits10"
          cat="Vídeos"
          cast=""
          ang="">
      </Text>
      <Text 	id="credits10content"
          cat="Guió i realització: Joan Mallarach
Edició: Rita Solà
Veus: Àfrica Victory i Jan Canosa
Producció: La Cofradia de Gràcia"
          cast=""
          ang="">
      </Text>
      <Text 	id="credits11"
          cat="Fotografies"
          cast=""
          ang="">
      </Text>
      <Text 	id="credits11content"
          cat="Arxiu Tobella
Arxiu Municipal
Arxiu Teresa Llordés
Arxiu Rafel Comas"
          cast=""
          ang="">
      </Text>
      <Text 	id="credits12"
          cat="Agraïments"
          cast=""
          ang="">
      </Text>
      <Text 	id="credits12content"
          cat="INS Torre del Palau
Família Barata i Salvans
Toni Verdaguer
Pawel Antas
Anna Fernandez
Marta Terès"
          cast=""
          ang="">
      </Text>
    )
  end
end
