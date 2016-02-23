$( document ).ready(function() {

  var clearShowBox = function() {
    $('#search_field').val('');
    $('#search_field').typeahead('setQuery', '');
    $('.cajabusqueda').show('slow');
  }

  var editButtonsOff = function(){
    $("#editBtn").show();
    $("#cancBtn").hide();
  }

//************  FRANK CODE ******************
  var ajaxGetSpecies = function(class_id){
    category_id = "";
    $.ajax({
        type: "POST",
        url: "/species/species_by_class",
        data: { class_id: class_id, category_id: category_id}
    });
  }
//************  END FRANK CODE ******************

//************  FRANK CODE ******************
    var ajaxGetRegion = function(class_id){
    $.ajax({
        type: "POST",
        url: "/species/regions_by_species",
        data: { class_id: class_id}
    });
  }
//************  END FRANK CODE ******************


  var resetEcoVariables = function(){
    // $("div.slider").each(function(e) {
    //         $(this).slider("values", 0, 0);
    //         $(this).slider("values", 1, 0.5);
    //         $(this).slider("values", 2, 1);
    //  });
    $("#accordion .slider").each(function(e) {
            $(this).hide();
    });
    $("#accordion h6").each(function(e) {
            $(this).hide();
    });
    $("#accordion").accordion( "option", "active", false );
    $("#accordion input[type=checkbox]").each(function(e) {
            $(this).prop( "checked", false);
    });
  }

  $('.searchcateg,.showmodels,.editControls,#cancBtn,.cajabusqueda,.showmodels,.cajaediciones,.edicionbar,.botonmodelos,.cajaecolog,.ecologicas').hide();
  $('.cajabusqueda').show('slow');
  ajaxGetSpecies($("#class_checker input[type='radio']:checked").val());
  $(".findbar").addClass("w55");
  $(".findbar").click(function(e){
          e.preventDefault();
          if($(".cajabusqueda").is(':visible')){
            $(".cajabusqueda").hide('slow');
            $(".findbar").removeClass("w55");
          }
          else{
            $('.cajabusqueda').show('slow');
            $('.showmodels, .editControls, .edicionbar, .botonmodelos, .cajaediciones, .cajaecolog, .ecologicas, .areaespecie').hide('slow');
            ajaxGetSpecies($("#class_checker input[type='radio']:checked").val());
            editButtonsOff();
            _mapVisorModule.deactivateEdition();
            _mapVisorModule.unloadModel();
            _mapVisorModule.unloadModel_n2();
            _mapVisorModule.unloadReview();
            _mapVisorModule.unloadPoints();
            $('#species_id').val('');
            $(".botonmodelos").removeClass("w55");
            $(".ecologicas").removeClass("w55");
            $(".edicionbar").removeClass("w55");
            $(".findbar").addClass("w55");
            resetEcoVariables();
          }
  });
  $(".edicionbar").click(function(e){
      if($(".cajaediciones").is(":visible")){
        $(".cajaediciones").hide();
        $(".edicionbar").removeClass("w55");
      }
      else{
        $('.cajaecolog, .cajabusqueda, .showmodels').hide('slow');
        $(".cajaediciones").show();
        $(".botonmodelos").removeClass("w55");
        $(".ecologicas").removeClass("w55");
        $(".edicionbar").addClass("w55");
      }     
      e.preventDefault();
  });
  $("#editBtn").click(function(e){
          $("#editBtn").hide();
          $("#cancBtn").show();
          e.preventDefault();
  });
  $("#cancBtn").click(function(e){
    e.preventDefault();
    _mapVisorModule.cancelEdition();
    editButtonsOff();
  });

  $(".botonmodelos").click(function(e){
      if($(".showmodels").is(":visible")){
        $(".showmodels").hide();
        $(".botonmodelos").removeClass("w55");
      }
      else{
        $('.cajaecolog, .cajabusqueda, .cajaediciones').hide('slow');
        $(".ecologicas").removeClass("w55");
        $(".edicionbar").removeClass("w55");
        $(".showmodels").show();
        $(".botonmodelos").addClass("w55");
      }
      
      e.preventDefault();
  });

  $(".ecologicas").click(function(e){
        if($(".cajaecolog").is(":visible")){
          $(".cajaecolog").hide();
          $(".ecologicas").removeClass("w55");
        }
        else{
          $('.showmodels, .cajabusqueda, .cajaediciones').hide('slow');
          $(".cajaecolog").show();
          $(".botonmodelos").removeClass("w55");
          $(".edicionbar").removeClass("w55");
          $(".ecologicas").addClass("w55");
      }
      e.preventDefault();
  });

  $(".xcierre").click(function(e){
     $(".cajaecolog").hide();
     $(".ecologicas").removeClass("w55");
     e.preventDefault();
  });
  
  $('.searchcateg').click(function(e){
    $('.cajabusqueda').show('slow');
    $('.resultados').html("");
    e.preventDefault();
  });


});




