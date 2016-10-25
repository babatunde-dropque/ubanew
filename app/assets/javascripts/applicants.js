// this will send CSRF token in all ajax request
	$.ajaxSetup({
  		headers: {
   		 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
  		}
  	});

  