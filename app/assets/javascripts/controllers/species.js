$( document ).ready(function() {

  /* ***************** FRANK CODE ********************/
  /* ESTE SE ACTIVA CUANDO SE PRESIONA UNA ESPECIE RADIO BUTTON  */
  var ajaxGetSpecies = function(class_id){
    var category_id = "";
    $(":checkbox").each(function () {
        var ischecked = $(this).is(":checked");
        if (ischecked) {
            category_id += $(this).val() + ",";
        }
    });
    category_id = category_id.substring(0,category_id.length - 1);
    $.ajax({
        type: "POST",
        url: "/species/species_by_class",
        data: { class_id: class_id, category_id: category_id}
    });
  }
  /* ***************** END FRANK CODE ********************/

  /* Model animation */
  $("body").on("mouseenter",".cajadatosm",function(e){
        $(this).animate({scrollTop:$(".cajadatosm").scrollTop() + $(this).find(".modeldata").position().top},600);
  });
  $("body").on("mouseleave",".cajadatosm",function(e){
        $(this).animate({scrollTop:$(".cajadatosm").position().top - '20'},600).finish();
  });

  //Set species class
  $('#class_checker input:radio').change(function(){
      $("#class_id").val($("#class_checker input[type='radio']:checked").val());
        $('#search_field').val('');
        $('#search_field').typeahead('setQuery', '');
        ajaxGetSpecies($("#class_id").val());
  });

  /* Autocomplete */
	$("#search_field").typeahead({
       	name: 'Search',
    	//remote: '/species/autocomplete?query=%QUERY&class_id=%SPCLASS',
    	remote: {
            /* ***************** FRANK CODE ********************/
    				url: '/species/autocomplete?query=%QUERY&classId=%SPCLASS&category=%CATEGORY',
            /* ***************** END FRANK CODE ********************/
    				replace:
    					function(url, query) {
                  /* ***************** FRANK CODE ********************/
      						return buildUrl(url, query);
                  /* ***************** END FRANK CODE ********************/
    					}
  				},
    	minLength: 2
  });

/* ***************** FRANK CODE ********************/
  function buildUrl(url, query) {
      var sp_classId = encodeURIComponent($('#class_id').val());
      var sp_clategoryId = "";
      $(":checkbox").each(function () {
          var ischecked = $(this).is(":checked");
          if (ischecked) {
              sp_clategoryId += $(this).val() + ",";
          }
      });
      return url.replace('%QUERY', query).replace('%SPCLASS', sp_classId).replace('%CATEGORY', sp_clategoryId.substring(0,sp_clategoryId.length - 1));
  }

  /* Autocomplete */
  $("#specie_category1").change(function(){
    $.ajax({
        type: "GET",
        url: buildUrl('/species/autocomplete?query=%QUERY&classId=%SPCLASS&category=%CATEGORY',$("#search_field").val())
    });
    ajaxGetSpecies($("#class_id").val());
  });

  $("#specie_category2").change(function(){
    $.ajax({
        type: "GET",
        url: buildUrl('/species/autocomplete?query=%QUERY&classId=%SPCLASS&category=%CATEGORY',$("#search_field").val())
    });
    ajaxGetSpecies($("#class_id").val());
  });

  $("#specie_category3").change(function(){
    $.ajax({
        type: "GET",
        url: buildUrl('/species/autocomplete?query=%QUERY&classId=%SPCLASS&category=%CATEGORY',$("#search_field").val())
    });
    ajaxGetSpecies($("#class_id").val());
  });
/* ***************** END FRANK CODE ********************/
 
  $("#search_field").on("typeahead:selected typeahead:autocompleted", function(e,datum) { 
		$("#species_id").val(datum.id);
	});

  /* Model selection */
  $("body").on("click",".model_link",function (event) {
                _mapVisorModule.loadModel("/modelos/"+$(this).find('#imgsrc').val(), $('#species_id').val());
                if($("#imgsrc2").length) {
                  _mapVisorModule.loadModel_n2("/modelos/"+$(this).find('#imgsrc2').val(), $('#species_id').val());
                }
                $("#review_model_id").val($(this).find('img').attr('id'));
                $('.editControls').show('slow');
                $('.showmodels, .cajabusqueda, .selectores').hide ('slow');
                $(".botonmodelos").removeClass("w55");
                event.preventDefault(); // Prevent link from following its href
  });

  $("body").on("click", ".xcierre2", function (e) {
        $(".showmodels").hide();
        $(".botonmodelos").removeClass("w55");
        e.preventDefault();
  });
  
});

/* ***************** FRANK CODE ********************/

prepareFilter=function(obj){
  $("#species_date_from").val()="";
  $("#species_date_to").val()="";
  $("#region").val()="";
  $("#error").val()="";
  $("#altitud").val()="";
  $("#fuente").val()="";
  $("#evidencia").val()="";
  $("#search_field").val()="";
}
/* ***************** END FRANK CODE ********************/

