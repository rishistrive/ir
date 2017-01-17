function display_message(content, type, duration){
	$('.container').append('<div class="row"><div class="center-block server-message-container"><div class="server-message alert alert-'+type+'">'+content+'</div></div></div>');
	setTimeout(
		function(){
			$('.server-message-container').fadeOut(500, function(){
				$(this).remove()
			});
		}, 
		duration);
};
