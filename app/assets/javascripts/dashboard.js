//= require_tree ./dashboard

$(document).ready(function(){

	// this will send CSRF token in all ajax request
	$.ajaxSetup({
  		headers: {
   		 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
  		}
  	});

    // Instance the tour
		var tour = new Tour({
		  steps: [
		  {
		    element: "#step1",
		    title: "Create An Interview",
		    content: "Create a video interview with just a click"
		  },
		  {
		    element: "#step2",
		    title: "QueBox",
		    content: "Click here to Display all videos newly submitted"
		  },
		  {
		    element: "#step3",
		    title: "Interview",
		    content: "Click here to display and edit all the interviews you have created"
		  },
		  {
		    element: "#step4",
		    title: "shortlisted",
		    content: "Click here to display all video applications that you have shortlisted"
		  },
		  {
		    element: "#step5",
		    title: "Pending",
		    content: "Click here to display all video applications that you have pended"
		  },
		  {
		    element: "#step6",
		    title: "Declined",
		    content: "Click here to display all video applications that you have Declined"
		  },
		  {
		    element: "#selectThis",
		    title: "Filter",
		    content: "Click here to filter video submissions by interviews"
		  }
		  
		],

		storage: true
	 });

	// this will get the number of signin to know when to show tour
	var signInCount = $("#number_of_signin").val();
	if ( signInCount == "1"){
		// Initialize the tour and start tour
		tour.init();
		tour.start();
	} 



	

	$('.filterismo').on("click", "a.ajax-btn", function(){
		var thisObject = $(this);
		var patchLink = thisObject.attr('href');
		$.ajax({
		      url: patchLink,
		      type: 'PATCH',
		      success: function(data){
		      	if (data == "success"){
		      		var current_status_parent = $('#current_status_stored').val();
		      		var current_status = thisObject.attr('current_status');
		      		if (current_status == current_status_parent){
		      			if (current_status == "reject"){
    							showMessage('top','right', "Candidate already declined", 4);
    						} else if (current_status == "pend"){
    							showMessage('top','right', "Candidate already pended", 1);
    						} else {
    							showMessage('top','right', "Candidate already shortlisted", 2);
    						}
		      		} else{
				      	var  parentCard = thisObject.parents('div.card-start');
				      	parentCard.hide("slide", { direction: "left"}, 300, function() {
    						thisObject.parents('div.card-start')[0].remove();
    						if (current_status == "reject"){
    							showMessage('top','right', "you have Declined this candidate", 4);
    						} else if (current_status == "pend"){
    							showMessage('top','right', "you have pended this candidate", 1);
    						} else {
    							showMessage('top','right', "you have shortlisted this candidate", 2);
    						}
						});
		      		}
		      		
		      	} else {
		      		showMessage('top','right', "An error occurred, please try again", 4);
		      	}
		      },
		      error : function(jqXHR, textStatus, errorThrown) {
		      	   showMessage('top','right', "An error occurred, please try again", 4);
		       }
		   });
		return false;
	});


	$('.filterismo').on("click", "button.comment_button", function(){
		var id = $(this).attr('id-modal');

		var isAttached = $(this).attr('attached');
		if (isAttached == "false"){
		   var modalView = $(this).parent().find('div.myModal');
           $('#modal-list').append(modalView.html());
           modalView.html("");
           $(this).attr("attached", "true");
		} 
           $(id).modal();
	});


	$('.myModal').on('shown.bs.modal', function () {

	});


	$('#selectThis').change(function(){
		var option = $('#selectThis option:selected');
		var link = option.attr('link');
		var status = option.attr('status');
		filterAjaxRequest(link+"&status="+status);
	});

	$(".filterismo").on("click", ".upvoted", function(){
		var hrefValue = $(this).attr('href');
     	var thisObject = $(this).find('.upvote_count');
     	var sibling = $(this).parent().find('.downvote_count');
     	var val = thisObject.html();
     	var siblingVal = sibling.html();
     		thisObject.html(1 + parseInt(val));
     		if (parseInt(siblingVal) >= 1){
		   		sibling.html(parseInt(siblingVal) - 1);
		   	}
     	$.ajax({
		      url: hrefValue,
		      type: 'GET',
		      success: function(data){
		          if (data == "false"){
		          	thisObject.html(val);
		          	sibling.html(siblingVal);
		          }
		      },
		      error : function(jqXHR, textStatus, errorThrown) {
		      	    thisObject.html(val);
		          	sibling.html(siblingVal);
		       }
		   });
     	return false; 
    });


    $(".filterismo").on("click", ".downvoted", function(){
     	var hrefValue = $(this).attr('href');
     	var thisObject = $(this).find('.downvote_count');
     	var sibling = $(this).parent().find('.upvote_count');
     	var val = thisObject.html();
     	var siblingVal = sibling.html();
     		thisObject.html(parseInt(val) + 1);
     		if (parseInt(siblingVal) >= 1){
		      	sibling.html(parseInt(siblingVal) - 1);
		     }
     	$.ajax({
		      url: hrefValue,
		      type: 'GET',
		      success: function(data){
		      	if (data == "false"){
		          	thisObject.html(val);
		          	sibling.html(siblingVal);
		          }
		      },
		      error : function(jqXHR, textStatus, errorThrown) {
		      	  thisObject.html(val);
		          sibling.html(siblingVal);
		       }
		   });
     	return false;
    });


	
	// this is the script responsible for tags
	var emailTag = $('#emails');
	emailTag.tagit({
		placeholderText: "mail@example.com",
		beforeTagAdded: function(event, ui) {
        // do something special
	        var email = emailTag.tagit('tagLabel', ui.tag);
	        if (!validateEmail(email)){
	        	$("#indicator").html("Invalid Email");
	        	return false;
	        }
	        $("#indicator").html("");
    	}
	});


	

	var emailTagList = $('#email-list');
	emailTagList.tagit({
		placeholderText: "mail@example.com",
		beforeTagAdded: function(event, ui) {
        // do something special
	        var email = emailTagList.tagit('tagLabel', ui.tag);
	        if (!validateEmail(email)){
	        	$("#indicator-mail").html("Invalid Email");
	        	return false;
	        }
	        $("#indicator-mail").html("");
    	}
	});


    formatQuestion();

	// check if the there is questions and parse the json 
	var questionString = $("#questions-json").val() ;
	if (questionString && questionString != null ) {
		var resultArray = JSON.parse(questionString);

		if (resultArray != null) {
			for (var i = 0; i < resultArray.length; i++) {
				if (resultArray[i]["question_type"] == 1){
		    		 var q = resultArray[i]["question_video"];
		    		 var t = resultArray[i]["time_allowed"] ;
		    		$("#question-tag").append(addNewQuestionWithDetails(q,t, 1));   
	    		} else if (resultArray[i]["question_type"] == 2){
	    			 var q = resultArray[i]["question_text"];
		    		 var t = resultArray[i]["max_char"] ;
		    		$("#question-tag").append(addNewTextQuestionWithDetails(q,t, 2));   

	    		} else if (resultArray[i]["question_type"] == 3){
	    			 var q = resultArray[i]["file_text"];
		    		 var t = resultArray[i]["file_size"] ;
		    		$("#question-tag").append(addNewFileUpload(q,t, 3));   

	    		}
			}
		}

	}





    $("#add-new").click(function(){
    	  var checkType = $("#question-type").val(); 
 
    	if(checkType == 1){
    	  var newQuestion = addNewQuestionWithDetails("",null, checkType);
        } else if(checkType == 2){
          var newQuestion = addNewTextQuestionWithDetails("","", checkType);
        } else if(checkType == 3){
          var newQuestion = addNewFileUpload("","", checkType);
        }

        $("#question-tag").append(newQuestion);

       
    });


     $("#question-tag").on("click", ".remove", function(){
     	$(this).parents('div.row')[0].remove(); 
    
        // var question = $(this).attr("cartprice");
        // var index = $(this).closest('div.cart-item').index();
        // var productList = (Cookies.getJSON('cart'));
        // productList.splice(productList.length - 1 - index,1);
        // Cookies.set('cart', productList, { expires: 7 });
        
        // $('#cartsum').text(parseInt($('#cartsum').text()) - parseInt(price));
        // $('.sum').text($('#cartsum').text());
        // $('#cartcount').text(parseInt($('#cartcount').text()) - 1);
          // alert("clidk me");
        return false;
    });

 function validateTime(email) {
     var re = /^[0-9]{1,2}:[0-9]{1,2}$/;
    return re.test(email);
}


     $("#interview-submit").click(function(event){
    	// this part will add the questions to the question field before submission
    	// check if title is empty
    	var titleInterview = $("#title-interview").val()
    	if (!titleInterview) {
    		showMessage('top','right', "Interview title cannot be empty", 4);
    		event.preventDefault();
    	}
    	var descriptionInterview = $("#title-description").val()
    	if(!descriptionInterview) {
    		showMessage('top','right', "Interview description cannot be empty", 4);
    		event.preventDefault();
    	} 
    	var instructionInterview = $("#title-instruction").val()
    	if(!instructionInterview) {
    		showMessage('top','right', "Interview instruction cannot be empty", 4);
    		event.preventDefault();
    	} 
    	
       jsonObj = [];

     	 $("#question-tag").find(".row").each(function(index) {
     	 	 var type = $(this).attr("type");
     	 	 var questionObject = $(this).find("input");
		     var firstField = questionObject.get(0).value ;
		     var secondField = questionObject.get(1).value
		     
		     if (!firstField || !secondField){
		     	// check if question or timeAllowed is empty
		     	showMessage('top','right', "question field cannot be empty", 4);
		     	event.preventDefault();

		     } else{

		     	if (type == 1){
		     		// check time format
			     	if (!validateTime(secondField)){
				        showMessage('top','right', "Time format not correct, use mm:ss ", 4);
				        event.preventDefault();
		       		 } else {
		       		 	questionItem = {}
		       		 	questionItem["question_type"] = type ;
			         	questionItem["question_video"] = firstField;
			         	questionItem["time_allowed"] = convertTimeToMillisecond(secondField);
			         	jsonObj.push(questionItem);

		       		 }
	       		} else if (type == 2){
	       				questionItem = {}
		       		 	questionItem["question_type"] = type ;
			         	questionItem["question_text"] = firstField;
			         	questionItem["max_char"] = secondField;
			         	jsonObj.push(questionItem);

	       		} else if (type == 3 ){
	       				questionItem = {}
		       		 	questionItem["question_type"] = type ;
			         	questionItem["file_text"] = firstField;
			         	questionItem["file_size"] = secondField;
			         	jsonObj.push(questionItem);

	       		}
		     }
		     
		});

     	 	$("#questions-json").val(JSON.stringify(jsonObj));

        });


		// this is the close notification button for notification
		$(".close-notification").click(function(event){
			var notification_id = $(this).attr('notification-id');
			$(this).parents('li')[0].remove();

			$.ajax({
		      url: '/update_notification',
		      type: 'PUT',
		      data :{ read: 1, notification_id: notification_id},
		      success: function(data){
		      	console.log(data);
		          if (data == "success"){
		          	$('#notification-number').text(parseInt($('#notification-number').text()) - 1 );	
		          }
		      },
		      error : function(jqXHR, textStatus, errorThrown) {
		      	  showMessage('top','right', "An error occur, please try again", 4);
		       }
		   });
			
			event.preventDefault();
			return false;


		});

    

 
});

// end of document ready function


function addNewQuestionWithDetails(q,t, type){
	var fomattedTime = "";
	if (t != null){
		fomattedTime = milisecondsToMinsFormat2(t);
	}
	
	var result = 
			"<div class='row' type ='"+type+"'>" +
		      "<div class='col-md-8'>"+
		         "<div class='form-group'>"+
		              "<input type='text' class='form-control border-input' placeholder='Video Question' value='"+q+"' >"+
		          "</div>"+
		      "</div>"+
		      "<div class='col-md-3'>"+
		          "<div class='form-group'>"+
		              "<input type='text' class='form-control border-input' placeholder='Time allowed' value='"+fomattedTime+"'>"+
		          "</div>"+
		      "</div>"+
		      "<div class='col-md-1 close'>"+
		        "<btn class='btn remove'><i class='ti-close'></i></btn>"+
		      "</div>"+ 
		  "</div>";
	return result;
}

function addNewTextQuestionWithDetails(q, c, type){
	var result = 
		"<div class='row'  type ='"+type+"'>" +
	          "<div class='col-md-8'>" +
	             "<div class='form-group'>" +
	                  "<input type='text' class='form-control border-input' placeholder='Text Question' value='"+q+"' >" +
	              "</div>" +
	          "</div>" +
	          "<div class='col-md-3'>" +
	              "<div class='form-group'>" +
	                  "<input type='text' class='form-control border-input' placeholder='Max words allowed' value='"+c+"'>" +
	              "</div>"+
	          "</div>"+
	          "<div class='col-md-1 close'>"+
	            "<btn class='btn remove'><i class='ti-close'></i></btn>"+
	          "</div>"+
	  	"</div>";
	  return result;
}

function addNewFileUpload(q, s, type){
	var result = 
	"<div class='row' type ='"+type+"'>" +
          "<div class='col-md-8'>" +
             "<div class='form-group'>"+
                  "<input type='text' class='form-control border-input' placeholder='File Description' value='"+q+"'>"+ 
              "</div>" +
          "</div>" +
          "<div class='col-md-3'>"+
              "<div class='form-group'>"+
                  "<input type='text' class='form-control border-input' placeholder='Max File Size' value='"+s+"'>"+
              "</div>"+
          "</div>"+
          "<div class='col-md-1 close'>"+
            "<btn class='btn remove'><i class='ti-close'></i></btn>"+
          "</div>"+
      "</div>";
      return result;
}




function formatQuestion(){
	var resultQuestion = $('#question-returned').val();
	
	 if (resultQuestion) {
		var resultArrayQuestion = JSON.parse(resultQuestion);

		for (var i = 0; i < resultArrayQuestion.length; i++) {
			 var type = resultArrayQuestion[i]["question_type"];

			 if (type == 1){

			 	 var f = resultArrayQuestion[i]["question_video"];
    		 	 var s = milisecondsToMins(resultArrayQuestion[i]["time_allowed"]) ;
    		 	 var typeShow = "Video Question"

			 } else if (type == 2){
			 	 var f = resultArrayQuestion[i]["question_text"];
    		 	 var s = resultArrayQuestion[i]["max_char"] +' words';
    		 	 var typeShow = "Text Question"


			 } else if (type == 3){
			 	var f = resultArrayQuestion[i]["file_text"];
    		 	var s = resultArrayQuestion[i]["file_size"] +'Mb';
    		 	var typeShow = "File Upload"
			 }

    		
    	    $("#question-holder").append(
    	    	'<tr>'+
    	    		'<td>'+typeShow+'</td>'+
                    '<td>'+f+'</td>'+
                    '<td>'+s+'</td>'+
                '</tr>');
		}

	}		
}



function milisecondsToMins(milliseconds){
  //Get hours from milliseconds
  
  var minutes = milliseconds / (1000 * 60)
  var absoluteMinutes = Math.floor(minutes);
  var m = absoluteMinutes > 9 ? absoluteMinutes : '0' +  absoluteMinutes;

  //Get remainder from minutes and convert to seconds
  var seconds = (minutes - absoluteMinutes) * 60;
  var absoluteSeconds = Math.floor(seconds);
  var s = absoluteSeconds > 9 ? absoluteSeconds : '0' + absoluteSeconds;

  return + m + ' min : ' + s+' sec';
}

function milisecondsToMinsFormat2(milliseconds){
  var minutes = milliseconds / (1000 * 60)
  var absoluteMinutes = Math.floor(minutes);
  var m = absoluteMinutes > 9 ? absoluteMinutes : '0' +  absoluteMinutes;

  //Get remainder from minutes and convert to seconds
  var seconds = (minutes - absoluteMinutes) * 60;
  var absoluteSeconds = Math.floor(seconds);
  var s = absoluteSeconds > 9 ? absoluteSeconds : '0' + absoluteSeconds;

  return  m+':'+ s;
}

function convertTimeToMillisecond(time){
	var splitedTime = time.split(":");
	var mins = splitedTime[0];
	var sec = splitedTime[1];
	return (parseInt(sec) * 1000) + (parseInt(mins) * 60 * 1000);
}


function validateEmail(email) {
    var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(email);
}

function filterAjaxRequest(urlIn){
	$.ajax({
		      url: urlIn,
		      type: 'GET',
		      success: function(data){
		      	$(".filterismo").closest("div").html(data);
		      },
		      error : function(jqXHR, textStatus, errorThrown) {
		      	 console.log(textStatus);
		       }
		   });
}


function showMessage(from, align, message, color){

	$.notify({
    	message: message
    },{
        type: type[color],
        timer: 2500,
        placement: {
            from: from,
            align: align
        }
    });
}




