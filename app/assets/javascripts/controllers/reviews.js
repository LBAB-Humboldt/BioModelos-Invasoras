$( document ).ready(function() {
	$("body").on("click", "#load-link-review", function(e){
		e.preventDefault();
		$('img', this).attr('src', function(i, oldSrc) {
		    return oldSrc == '/assets/ver.png' ? '/assets/ver2.png' : '/assets/ver.png';
		});	
		$('#saveBtn').hide();
        $('#editBtn').show();
        _mapVisorModule.loadReview($(this).find('input').attr('value'));
	});

	$("body").on("click", "#like", function(e){
		e.preventDefault(); 
		$('img', this).attr('src', function(i, oldSrc) {
		    return oldSrc == '/assets/like.png' ? '/assets/like2.png' : '/assets/like.png';
		});
	});
});