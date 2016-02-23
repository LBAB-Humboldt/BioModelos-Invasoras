var _mapVisorModule = function() {

	var map, drawnItems, layerControl, modelOverlay, modelOverlay2, currentLayer, drawControl, reviewLayer, csvLayer, cluster,
		isEditOn = false,
		commentForm = '<div class="commentForm">' +
			'<input id="review_type" type="hidden">'+
           '<label><strong>Observación:</strong></label><br />' +
	       '<textarea rows="4" cols="30" placeholder="Ingrese una observación" id="comment" class="cmtArea"></textarea>' +
	       '<div class="row-fluid clearfix">' +
	       '<label class="labelcom clearfix"><strong>Acción:</strong></label><input type="radio" name="EditType" value="Add" class="radiogaga">Extensión de presencia</input></br>' +
 	       '<input type="radio" name="EditType" value="Cut" class="radiogaga">Sobrepredicción</input></br>' +
 	       '<input type="radio" name="EditType" value="Other" class="radiogaga" checked>Otro</input></br>'+
	       '<button class="btn2" id="saveBtn" type="button">guardar</button>' +
           '<button class="btn2" id="popUpCancelBtn" type="button">cancelar</button></div>';
        pointForm = '<div class="commentForm">' +
           '<input id="review_type" type="hidden">'+
           '<label class="tituloformas">Registro:</label><br />' +
	       '<label>Lat: </label><input type="text" name="latitude" id="lat" size="7" disabled class="inputforma wauto"><label> Lng: </label><input type="text" name="longitude" id="lng" size="7" class="inputforma wauto" disabled><br />' +
	       '<input type="date" id="fecha_registro" name="fecha_registro" placeholder="Fecha de registro (mm/dd/aa)" class="inputforma w227"><br />' +
	       '<input type="text" id="r_localidad" name="localidad" placeholder="Localidad" class="inputforma w227"><br />' +
	       '<input type="text" name="tipo" id="r_tipo" placeholder="Tipo de registro" class="inputforma w227"><br />' +
	       '<input type="text" name="colector" id="r_observador" placeholder="Observador" class="inputforma w227"><br />' +
	       '<input type="text" name="cita" id="r_cita" placeholder="Cita" class="inputforma w227"><br />' +
	       '<textarea rows="4" cols="30" placeholder="Ingrese una observación" id="comment" class="inputforma w227"></textarea>' +
	       '<div class="row-fluid clearfix">' +
	       '<button class="btn2" id="saveBtn" type="button">guardar</button>' +
           '<button class="btn2" id="popUpCancelBtn" type="button">cancelar</button></div>';

	var init = function() {

		var latlng = new L.LatLng(4, -72),
        	zoom = 6,
        	mZoom = 2,
        	mxZoom = 16;


        /*var cities = new L.LayerGroup();

            L.marker([4.60, -74.08]).bindPopup('Bogotá').addTo(cities),
            L.marker([3.43, -76.52]).bindPopup('Cali').addTo(cities),
            L.marker([6.25, -75.56]).bindPopup('Medellín').addTo(cities),
            L.marker([1.21, -77.28]).bindPopup('Pasto').addTo(cities);*/


        var bogota = L.marker([4.66, -74.10]).bindPopup('Bogotá');

        /* var precipitation = L.tileLayer.wms('http://nowcoast.noaa.gov/arcgis/services/nowcoast/analysis_meteohydro_sfc_qpe_time/MapServer/WmsServer', {
            format: 'image/png',
            transparent: true,
            layers: '5'
        }); */

        var cuerposdeagua1 = L.tileLayer.wms('http://geocarto.igac.gov.co/geoservicios/cien_mil/wms', {
            format: 'image/png',
            transparent: true,
            layers: 'Drenaje_Doble'
            /*transparent: true,*/
            /*attribution: "Weather data © 2012 IEM Nexrad"*/
        });


        var cuerposdeagua2 = L.tileLayer.wms('http://geocarto.igac.gov.co/geoservicios/cien_mil/wms', {
            format: 'image/png',
            transparent: true,
            layers: 'Drenaje_sencillo'
            /*attribution: "Weather data © 2012 IEM Nexrad"*/
        });

        var embalses = L.tileLayer.wms('http://geocarto.igac.gov.co/geoservicios/cien_mil/wms', {
            format: 'image/png',
            transparent: true,
            layers: 'Embalse'
            /*attribution: "Weather data © 2012 IEM Nexrad"*/
        });

        var humedales = L.tileLayer.wms('http://geocarto.igac.gov.co/geoservicios/cien_mil/wms', {
            format: 'image/png',
            transparent: true,
            layers: 'Humedal'
            /*attribution: "Weather data © 2012 IEM Nexrad"*/
        });


        var capitales = L.tileLayer.wms('http://geocarto.igac.gov.co/geoservicios/cien_mil/wms', {
            format: 'image/png',
            transparent: true,
            layers: 'Capitales'
        });

        var municipios = L.tileLayer.wms('http://geocarto.igac.gov.co/geoservicios/cien_mil/wms', {
            format: 'image/png',
            transparent: true,
            layers: 'Limite_Municipal_Linea'
        });


        var departamentos = L.tileLayer.wms('http://geocarto.igac.gov.co/geoservicios/cien_mil/wms', {
            format: 'image/png',
            transparent: true,
            layers: 'Limite_Departamental_Linea'
        });

        	/* Base Layers */
        	var googleTerrain = new L.Google('TERRAIN', {minZoom:mZoom, maxZoom: mxZoom}),
				googleSatellite = new L.Google('SATELLITE', {minZoom:mZoom, maxZoom: mxZoom}),
                googleRoad = new L.Google('ROADMAP', {minZoom:mZoom, maxZoom: mxZoom}),
                googleHybrid = new L.Google('HYBRID', {minZoom:mZoom, maxZoom: mxZoom}),
	    		osmBase = new L.TileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
	            {
	                minZoom: mZoom,
	                maxZoom: mxZoom,
	                attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> Contributors'
	            }),
	    		thunderForestLand= new L.TileLayer('http://{s}.tile.thunderforest.com/landscape/{z}/{x}/{y}.png',{
	    			minZoom: mZoom,
	                maxZoom: mxZoom,
					attribution: 'Map data ' + L.TileLayer.OSM_ATTR + ', Tiles &copy; <a href="http://www.mapquest.com/" target="_blank">MapQuest</a> <img src="http://developer.mapquest.com/content/osm/mq_logo.png" />'

	    		}),
                esri= new L.TileLayer('http://services.arcgisonline.com/ArcGIS/rest/services/World_Physical_Map/MapServer/tile/{z}/{y}/{x}.png',{
                    minZoom: mZoom,
                    maxZoom: mxZoom,
                    attribution: 'Map data ' + L.TileLayer.OSM_ATTR + ', Tiles &copy; <a href="http://www.arcgis.com/home/item.html?id=c4ec722a1cd34cf0a23904aadf8923a0" target="_blank">ArcGIS - World Physical Map</a>'
                     })
                /* prueba= new L.TileLayer('http://tiles.mapc.org/basemap/{z}/{x}/{y}.png',{
                    minZoom: mZoom,
                    maxZoom: mxZoom,
                })*/
                ;
                ;


        var baseLayers, overlays;
        baseLayers = {
            "Google Terrain": googleTerrain,
            "Google Satellite": googleSatellite,
            "Google Roads": googleRoad,
            "Google Hybrid": googleHybrid,
            "OpenStreetMap": osmBase,
            "Thunderforest Landscape": thunderForestLand,
            "ESRI": esri
            /*"Prueba": prueba*/
        };
        overlays = {
            "Bogotá": bogota,
            /*"Precipitación": precipitation,*/
            "Drenaje sencillo": cuerposdeagua1,
            "Drenaje doble": cuerposdeagua2,
            "Embalses": embalses,
            "Humedales": humedales,
            "Capitales": capitales,
            "Municipios": municipios,
            "Departamentos": departamentos
        };


        map = L.map('map', {crs: L.CRS.EPSG4326}).setView(latlng, zoom);
        //map = L.map('map', {crs: L.CRS.EPSG3857}).setView(latlng, zoom);
    	//map = L.map('map').setView(latlng, zoom);

	    map.addLayer(googleTerrain);


	    /* autoZIndex controls the layer order */
	    layerControl = L.control.layers(baseLayers, overlays, {autoZIndex: true});
	    layerControl.addTo(map);

	    L.control.coordinates({
    		position:"bottomright", //optional default "bootomright"
		    decimals:2, //optional default 4
		    decimalSeperator:".", //optional default "."
		    labelTemplateLat:"Latitud: {y}", //optional default "Lat: {y}"
		    labelTemplateLng:"Longitud: {x}", //optional default "Lng: {x}"
		    enableUserInput:false, //optional default true
		    useDMS:false, //optional default false
		    useLatLngOrder: true //ordering of labels, default false-> lng-lat
		}).addTo(map);
	};

	var unloadModel = function() {
		if(map.hasLayer(modelOverlay)) {
       		map.removeLayer(modelOverlay);
       		layerControl.removeLayer(modelOverlay);
       }
	}


	var loadModel = function (modelUrl, speciesID) {

		var imageUrl = modelUrl;

		if (speciesID == 5090)
			imageBounds = [[12.46667, -59.86666], [-13.84166, -84.86666]];
			//imageBounds = [[12.466957766, -59.864685059], [-13.841375567, -84.864685059]];
		else if (speciesID == 5091)
			//imageBounds = [[28.8, -83.14999],[9.34167, -102]];
			imageBounds = [[29.35000466,-83.149994949],[9.341670283, -101.999995932]];
			//imageBounds = [[29.352815756, -83.148901367], [9.344482423, -101.998901367]];
		else
			imageBounds = [[12.675, -60.48333], [-13.84166, -82.94999]];

       /* Dispose older model if it exists */
        unloadModel();

	    modelOverlay = new L.ImageOverlay(imageUrl, imageBounds, {opacity: 0.6});

	    map.addLayer(modelOverlay, true);
	    layerControl.addOverlay(modelOverlay, "Modelo");

	    map.on('overlayadd', function(e) {
	         if(e.layer === modelOverlay)
	             modelOverlay.bringToBack();
	    });
	};

	var unloadModel_n2 = function() {
		if(map.hasLayer(modelOverlay2)) {
       		map.removeLayer(modelOverlay2);
       		layerControl.removeLayer(modelOverlay2);
       }
	}


	var loadModel_n2 = function (modelUrl, speciesID) {

		var imageUrl = modelUrl;

		if (speciesID == 5090)
			imageBounds = [[12.46667, -59.86666], [-13.84166, -84.86666]];
			//imageBounds = [[12.466957766, -59.864685059], [-13.841375567, -84.864685059]];
		else if (speciesID == 5091)
			//imageBounds = [[28.8, -83.14999],[9.34167, -102]];
			imageBounds = [[29.35000466,-83.149994949],[9.341670283, -101.999995932]];
			//imageBounds = [[29.352815756, -83.148901367], [9.344482423, -101.998901367]];
		else
			imageBounds = [[12.675, -60.48333], [-13.84166, -82.94999]];

       /* Dispose older model if it exists */
        unloadModel_n2();

	    modelOverlay2 = new L.ImageOverlay(imageUrl, imageBounds, {opacity: 0.6});

	    map.addLayer(modelOverlay2, true);
	    layerControl.addOverlay(modelOverlay2, "Modelo Nivel 2");

	    map.on('overlayadd', function(e) {
	         if(e.layer === modelOverlay2)
	             modelOverlay2.bringToBack();
	    });
	};


	var unloadReview = function (){
		if(map.hasLayer(reviewLayer)) {
       		map.removeLayer(reviewLayer);
       		layerControl.removeLayer(reviewLayer);
       }
	};

	var loadReview = function (reviewGeoJSON) {

		/* Dispose older review if it exists */
       unloadReview();

       /* Deactivate edition if it is active */
       if (isEditOn)
       	deactivateEdition();

       var 	propTypes = ["Fecha de Registro", "Localidad", "Tipo", "Observador", "Cita"],
       		popupString = '';


		reviewLayer = new L.GeoJSON(JSON.parse(reviewGeoJSON), {
        	onEachFeature: function (feature, layer) {
            	if (feature.geometry.type === 'Point') {
            		for (var i=0; i < propTypes.length; i++) {
						popupString += '<b>'+propTypes[i]+'</b><br />'+ feature.properties[propTypes[i]]+'<br /><br />';
					}
				}
				popupString += '<b>Comentario </b><br />'+ feature.properties.Comentario+'<br /><br />';
                layer.bindPopup(popupString, { maxHeight: 200 });
    		}
    	});

    	map.addLayer(reviewLayer);
    	layerControl.addOverlay(reviewLayer,"Anotación");
    	reviewLayer.openPopup();

	};

	var loadPoints = function (csvUrl) {
		var csvTitles = ["ID","Nombre original","Localidad","Municipio","Departamento","Altitud","Fecha","Institución","Colector","Evidencia"];

		csvLayer = L.geoCsv(null, {
										onEachFeature: function (feature, layer) {
												var popup = '<div class="cajita">';
												popup += '<b><div id="point_lon">'+ feature.geometry.coordinates[0]+'</div>, <div id="point_lat"> '+ feature.geometry.coordinates[1] + '</div></b><br /><br />';
												for (var i=0; i < csvTitles.length; i++) {
													popup += '<b>'+csvTitles[i]+'</b><br />'+ feature.properties[csvLayer.getPropertyName(csvTitles[i])]+'<br /><br />';
												}
												popup += '<a href="/species/comment_point" data-method="post" data-remote="true" rel="nofollow" class="wrongbtn">Reportar Error</a></div>'
												//popup += '<a href="/species/workshop_test" data-method="post" data-remote="true" rel="nofollow" class="wrongbtn">Reportar Error</a></div>'
												layer.bindPopup(popup);
										},
										latitudeTitle: 'lat',
										longitudeTitle: 'lon',
										firstLineTitles: true,
										fieldSeparator: ','});


		$.ajax ({
			type:'GET',
			dataType:'text',
			url: csvUrl,
			async: false,
   			error: function() {
     			alert('No fue posible cargar los puntos de registro');
   			},
			success: function(data) {
     			cluster = new L.MarkerClusterGroup({});
				csvLayer.addData(data);
				cluster.addLayer(csvLayer);
				map.addLayer(cluster);
				layerControl.addOverlay(cluster,"Registros");
				//map.fitBounds(cluster.getBounds());

			},
   			complete: function() {
      			//$('#cargando').delay(500).fadeOut('slow');
   			}
		});
    };

    var loadTestPoints = function () {

    };

    var unloadPoints = function () {
		if(map.hasLayer(cluster)) {
       		map.removeLayer(cluster);
       		layerControl.removeLayer(cluster);
       }
	};

	var activateEdition = function () {

		unloadReview();

    	if(!isEditOn) {

    		isEditOn = true;

    		drawnItems = new L.FeatureGroup(); //Capa editable
		    /* Control */
		    drawControl = new L.Control.Draw({
		        draw: {
		            position: 'topright',
		            circle: false,
		            rectangle: false
		        },
		        edit: {
		            featureGroup: drawnItems
		        }
		    });

		    map.addControl(drawControl);
		    layerControl.addOverlay(drawnItems, "Edición");
		    map.addLayer(drawnItems);

		    /* Draw Created Event Listener */
		    map.on('draw:created', function(e) {

		    	var type = e.layerType,
		    		layer = e.layer,
		    		pLatLng,
		    		popup = new L.Popup({
		            	closeButton: false,
		            	closeOnClick: false
		       		});

    			if (type === 'marker') {
    				pLatLng = layer.getLatLng();
    				popup.setContent(pointForm);
    			}
    			else {
    				//popup.setContent($('.editControls').html());
    				popup.setContent(commentForm);
    			}

    			layer.bindPopup(popup);
		        drawnItems.addLayer(layer);
		        layer.openPopup();

		        if(type === 'marker'){
		        	$('#lat').val(L.NumberFormatter.round(pLatLng.lat, 2, "."));
		        	$('#lng').val(L.NumberFormatter.round(pLatLng.lng, 2, "."));
		        	$('#review_type').val('point');
		        }
		        else if(type === 'polygon')
		        	$('#review_type').val('polygon');
		    });

		    /* Updates lat lng points on popup when edited */
		    map.on('draw:edited', function (e) {
    			var layers = e.layers;
    			layers.eachLayer(function (layer) {
    				if(layer._latlng != undefined){
        		  		$('#lat').val(L.NumberFormatter.round(layer.getLatLng().lat, 2, "."));
		        		$('#lng').val(L.NumberFormatter.round(layer.getLatLng().lng, 2, "."));
		        	}
    			});
			});

		    /* Popup Open Event Listener*/
		    map.on('popupopen', function(e) {
		        currentPopupID = e.popup._leaflet_id;
		    });

		}
	};

	var deactivateEdition = function () {
		if(drawnItems != null && drawControl != null && layerControl != null){
			isEditOn = false;
			if(drawnItems._map != null)
				map.removeLayer(drawnItems);
		 	if(drawControl._map != null)
		 		map.removeControl(drawControl);
		 	if(layerControl._map != null)
		 		layerControl.removeLayer(drawnItems);
		}
	};

	var cancelLayer = function () {

		currentLayer = getCurrentLayer(currentPopupID);
		drawnItems.removeLayer(currentLayer);

	};

	var getCurrentLayer = function (popupID) {
	    var layerRet;
	    if (popupID !== undefined && popupID !== null) {
	        drawnItems.eachLayer(function(layer) {
	            if (layer._popup._leaflet_id === popupID) {
	                var count = 0;
	                //console.log(count++);
	                layerRet = layer;
	            }
	        });
	    }
	    return layerRet;
	};


	var saveEdition = function () {
		var popupHtml = '<div class="usuarioreg">';
		var comment = $("#comment").val();
	    if (comment.length === 0) {
	        alert("¡Ingrese una observación!");
	        return false;
	    }

	    currentLayer = getCurrentLayer(currentPopupID);

	    if (currentLayer !== undefined && currentLayer !== null) {
	    	var editType = $('input[name="EditType"]:checked').val();
	    	if($('#review_type').val() === 'point'){
	    		popupHtml +=	'<label>Fecha de Registro</label><p id="puFechaRegistro">'+ $('#fecha_registro').val() +'</p>' +
	    						'<label>Localidad</label><p id="puLocalidad">'+ $('#r_localidad').val() +'</p>' +
	    						'<label>Tipo</label><p id="puTipo">'+ $('#r_tipo').val() +'</p>' +
	    						'<label>Observador</label><p id="puObservador">'+ $('#r_observador').val() +'</p>' +
	    						'<label>Cita</label><p id="puCita">'+ $('#r_cita').val() +'</p>';
	    	}
	    	else if($('#review_type').val() === 'polygon')
	    		popupHtml += '<label>Acción</label><p id="puAction">'+ $('input[name="EditType"]:checked').val() +'</p>';
	    	popupHtml += '<label>Comentario: </label><p id="puComment">'+ $('#comment').val() +'</p></div>';


	        currentLayer.closePopup();
	        currentLayer.bindPopup(popupHtml);
	        currentLayer.openPopup();
	    }
	    else {
	        alert("No se ha podido enviar el comentario");
	        return false;
	    }
	    //console.log(toGeoJSON());
	    $('#review_geoJSON').val(toGeoJSON());
	    $('#new_review').submit();
	};

	var cancelEdition = function () {
		deactivateEdition();
	};


	var toGeoJSON = function () {

	    var geoJSONLayer = '{"type": "FeatureCollection", "features":[',
	        layNum = drawnItems.getLayers().length,
	        count = 0;

	    drawnItems.eachLayer(function(layer) {
	        ltG = layer.toGeoJSON();
	        geoJSONLayer += '{"type": "' + ltG.type + '", "geometry": {"type": "' + ltG.geometry.type + '", "coordinates": ';

	        var coords, isPoint = false, isPolygon = false;

	        /* Check if layer is Point, Polygon or LineString */
	        switch (ltG.geometry.coordinates.length)
	        {
	            case 1:
	                coords = ltG.geometry.coordinates[0];
	                isPolygon = true;
	                break;
	            case 2:
	                coords = ltG.geometry.coordinates;
	                isPoint = true;
	                break;
	            default:
	                coords = ltG.geometry.coordinates;
	                break;
	        }

	        var len = coords.length;
	        if (!isPoint) {
	            if (len > 1 && !isPolygon)
	                geoJSONLayer += '[';
	            else if (len > 1)
	                geoJSONLayer += '[[';
	            for (var i = 0; i < len; i++)
	            {
	                geoJSONLayer += '[' + coords[i] + ']';
	                if (i < len - 1)
	                    geoJSONLayer += ',';
	            }
	            if (len > 1 && !isPolygon)
	                geoJSONLayer += ']';
	            else if (len > 1)
	                geoJSONLayer += ']]';
	        }
	        else
	            geoJSONLayer += '[' + coords + ']';

	        geoJSONLayer += '}, "properties": {"Comentario": "' + $('#puComment').text().replace(/(?:\r\n|\r|\n)/g, ' ');
	        if (ltG.geometry.type === 'Point'){
	        	geoJSONLayer += '", "Fecha de Registro": "' + $('#puFechaRegistro').text() + '"' +
	        					', "Localidad": "' + $('#puLocalidad').text() + '"' +
	        					', "Tipo": "' + $('#puTipo').text() + '"' +
	        					', "Observador": "' + $('#puObservador').text() + '"' +
	        					', "Cita": "' + $('#puCita').text();
	        }
	        else
	        	geoJSONLayer += '", "Accion": "' + $('#puAction').text();

	        geoJSONLayer += '"}}';

	        if (layNum > 1 && count < layNum - 1)
	            geoJSONLayer += ',';
	        count += 1;
	    });
	    geoJSONLayer += ']}';

	    geoJSONLayer.replace();
	    return geoJSONLayer;
	};


	return {

		init: init,
		loadModel: loadModel,
		loadModel_n2 : loadModel_n2,
		unloadModel: unloadModel,
		unloadModel_n2: unloadModel_n2,
		activateEdition: activateEdition,
		deactivateEdition: deactivateEdition,
		cancelLayer: cancelLayer,
		saveEdition: saveEdition,
		loadReview: loadReview,
		unloadReview: unloadReview,
		loadPoints: loadPoints,
		unloadPoints: unloadPoints,
		cancelEdition: cancelEdition
	};
}();

$(document).ready(function() {

	/* Function Handlers */

	$("#editBtn").click(function() {
    	_mapVisorModule.activateEdition();
    });

	$("body").on("click", "#saveBtn", function(){
     	_mapVisorModule.saveEdition();
	});

	$("body").on("click", "#popUpCancelBtn", function(){
		_mapVisorModule.cancelLayer();
	});

	$("body").on("click", "#pointComment", function(){
		$.ajax({url: "species/comment_point", type: "POST"});
	});

	_mapVisorModule.init();

});