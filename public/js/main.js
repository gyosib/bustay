$(function() {
	$('.delete').off('click');
  $('.delete').on('click', function() {
		console.log("test");
    var span = $(this);
    if(!confirm('sure?')){
      return;
    }
    $.post('/destroy', {
      id: this.id,
			_csrf: $(this).data('token')
    },function() {
			window.location.href = "/"
    });
  });

	$('.logout').on('click', function() {
	$('.logout').off('click');
		console.log("logoutdayo");
		console.log($(this).data('token'));
		$.post('/logout', {
			_csrf: $(this).data('token')
		}, function() {
			window.location.href = "/"
		});
	});

	$('.favorite').off('click');
	$('.favorite').on('click', function() {
		console.log("favorite");
    if(!confirm('sure?')){
      return;
    }
		$.post('/favorite', {
			id: this.id,
			_csrf: $(this).data('token')
		}, function() {
			location.reload();
		});
	});

	$('.des_favorite').off('click');
	$('.des_favorite').on('click', function() {
		console.log("destroy favorite");
    if(!confirm('sure?')){
      return;
    }
		$.post('/des_favorite', {
			id: this.id,
			_csrf: $(this).data('token')
		}, function() {
			location.reload();
		});
	});
});
