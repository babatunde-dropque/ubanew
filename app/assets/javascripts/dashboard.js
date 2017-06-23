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
		    title: "Welcome to Dropque",
		    content: "Start by creating an Organisation"
		  }
		  // ,
		  // {
		  //   element: "#step2",
		  //   title: "QueBox",
		  //   content: "Click here to Display all videos newly submitted",
		  //   path: "/companies/new"
		  // }
		  // ,
		  // {
		  //   element: "#step3",
		  //   title: "Interview",
		  //   content: "Click here to display and edit all the interviews you have created"
		  // },
		  // {
		  //   element: "#step4",
		  //   title: "shortlisted",
		  //   content: "Click here to display all video applications that you have shortlisted"
		  // },
		  // {
		  //   element: "#step5",
		  //   title: "Pending",
		  //   content: "Click here to display all video applications that you have pended"
		  // },
		  // {
		  //   element: "#step6",
		  //   title: "Declined",
		  //   content: "Click here to display all video applications that you have Declined"
		  // },
		  // {
		  //   element: "#selectThis",
		  //   title: "Filter",
		  //   content: "Click here to filter video submissions by interviews"
		  // }
		  
		],

		storage: false	
	 });

	// this will get the number of signin to know when to show tour
	//var signInCount = $("#number_of_signin").val();
	//if ( signInCount == "1"){
		// Initialize the tour and start tour
		// tour.init();
		// tour.start();
	//} 

	// initiate popover
   $('[data-toggle="popover"]').popover();

	$('#selectThis').change(function(){
		var option = $('#selectThis option:selected');
		var link = option.attr('link');
		var status = option.attr('status');
		filterAjaxRequest(link+"&status="+status);
	});


		
	// this is the script responsible for tags
	var emailTag = $('#emails');
	emailTag.tagit({
		placeholderText: "mail@example.com",
		beforeTagAdded: function(event, ui){
	        var email = emailTag.tagit('tagLabel', ui.tag);
	        if (!validateEmail(email)){
	        	$("#indicator").html("Invalid Email");
	        	return false;
	        }
	        $("#indicator").html("");
    	}
	});



    formatQuestion();

    var counter = 0;
	// check if the there is questions and parse the json 
	var questionString = $("#questions-json").val() ;
	if (questionString && questionString != null ) {
		var resultArray = JSON.parse(questionString);

		if (resultArray != null) {
			for (var i = 0; i < resultArray.length; i++) {
				if (resultArray[i]["question_type"] == 1){
		    		 var q = resultArray[i]["question_video"];
		    		 var t = resultArray[i]["time_allowed"] ;
		    		$("#question-tag").append(addNewQuestionWithDetails(q,t, 1, 'name'+counter++, 'name'+counter++));   
	    		} else if (resultArray[i]["question_type"] == 2){
	    			 var q = resultArray[i]["question_text"];
		    		 var t = resultArray[i]["max_char"] ;
		    		$("#question-tag").append(addNewTextQuestionWithDetails(q,t, 2, 'name'+counter++, 'name'+counter++));   

	    		} else if (resultArray[i]["question_type"] == 3){
	    			 var q = resultArray[i]["file_text"];
		    		 var t = resultArray[i]["file_size"] ;
		    		$("#question-tag").append(addNewFileUpload(q,t, 3,'name'+counter++, 'name'+counter++));   

	    		}
			}
		}
	}



    $("#add-new").click(function(){
    	  var checkType = $("#question-type").val(); 
    	if(checkType == 1){
    	  var newQuestion = addNewQuestionWithDetails("",null, checkType, 'name'+counter++, 'name'+counter++);
        } else if(checkType == 2){
          var newQuestion = addNewTextQuestionWithDetails("","", checkType, 'name'+counter++, 'name'+counter++);
        } else if(checkType == 3){
          var newQuestion = addNewFileUpload("","", checkType, 'name'+counter++, 'name'+counter++);
        }
        $("#question-tag").append(newQuestion);
    });


     $("#question-tag").on("click", ".remove", function(){
     	$(this).parents('div.row')[0].remove();
        return false;
    });


 


     $("#interview-submit").click(function(event){
    	    	
       jsonObj = [];

     	 $("#question-tag").find(".row").each(function(index) {
     	 	 var type = $(this).attr("type");
     	 	 var questionObject = $(this).find("input");
		     var firstField = questionObject.get(0).value ;
		     var secondField = questionObject.get(1).value
		     	if (type == 1){
		       		 	questionItem = {}
		       		 	questionItem["question_type"] = type ;
			         	questionItem["question_video"] = firstField;
			         	questionItem["time_allowed"] = convertTimeToMillisecond(secondField);
			         	jsonObj.push(questionItem);

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
		     
		     
		});
			if (jsonObj.length == 0){
				showMessage('top','center', "You cannot create interview without any question ", 4);
				event.preventDefault();
			}
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




function addNewQuestionWithDetails(q,t, type, name1, name2){
	var fomattedTime = "";
	if (t != null){
		fomattedTime = milisecondsToMinsFormat2(t);
	}
	
	var result = 
			"<div class='row' type ='"+type+"'>" +
		      "<div class='col-md-8'>"+
		         "<div class='form-group'>"+
	         	  	"<div class='input-group'>"+
	                	"<span class='input-group-addon' title='Video question' data-toggle='popover' data-placement='top' data-trigger='hover' data-content='Enter question and time allowed (Maximum time: 5 minutes)' style='color: #66615B;'><i class='glyphicon glyphicon-play' ></i></span>"+
	                  	"<input type='text' class='form-control border-input interview-details'  name='"+name1+"' placeholder='Video Question' value='"+q+"' >"+
	                "</div>"+
		          "</div>"+
		      "</div>"+
		      "<div class='col-md-3'>"+
		          "<div class='form-group'>"+
		              "<input type='text' class='form-control border-input interview-time'  name='"+name2+"' placeholder='mm:ss Time allow' value='"+fomattedTime+"'>"+
		          "</div>"+
		      "</div>"+
		      "<div class='col-md-1 close'>"+
		        "<btn class='btn remove'><i class='ti-close'></i></btn>"+
		      "</div>"+ 
		  "</div>";
	return result;
}

function addNewTextQuestionWithDetails(q, c, type, name1, name2){
	var result = 
		"<div class='row'  type ='"+type+"'>" +
	          "<div class='col-md-8'>" +
	             "<div class='form-group'>" +
	             	"<div class='input-group'>"+
	                	"<span class='input-group-addon' title='Text question' data-toggle='popover' data-placement='top' data-trigger='hover' data-content='Enter question and number of words allowed (Maximum words: 500)' style='color: #66615B;'><i class='glyphicon glyphicon-text-width' ></i></span>"+
	                  	 "<input type='text' class='form-control border-input interview-details'  name='"+name1+"' placeholder='Text Question' value='"+q+"' >" +
	                "</div>"+
	              "</div>" +
	          "</div>" +
	          "<div class='col-md-3'>" +
	              "<div class='form-group'>" +
	                  "<input type='text' class='form-control border-input interview-number-word' placeholder='Max words allowed'  name='"+name2+"' value='"+c+"'>" +
	              "</div>"+
	          "</div>"+
	          "<div class='col-md-1 close'>"+
	            "<btn class='btn remove'><i class='ti-close'></i></btn>"+
	          "</div>"+
	  	"</div>";
	  return result;
}




function addNewFileUpload(q, s, type, name1, name2){
	var result = 
	"<div class='row' type ='"+type+"'>" +
          "<div class='col-md-8'>" +
         	"<div class='form-group'>"+
	             "<div class='input-group'>"+
                	"<span class='input-group-addon' title='Text question' data-toggle='popover' data-placement='top' data-trigger='hover' data-content='Enter question and max file size allowed (Maximum size: 5MB)' style='color: #66615B;'><i class='glyphicon glyphicon-cloud-upload' ></i></span>"+
                  	"<input type='text' class='form-control border-input interview-details' name='"+name1+"' placeholder='File Description' value='"+q+"'>"+ 
                  "</div>"+  
              "</div>" +
          "</div>" +
          "<div class='col-md-3'>"+
          "<div class='form-group'>"+
	           "<div class='input-group'>" +  
	                "<input type='text' class='form-control border-input interview-number-file'  name='"+name2+"' placeholder='Max File Size' value='"+s+"'>"+
	                "<span class='input-group-addon'>MB</span>"+
	            "</div>"+
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
                    '<td class="edit">'+f+'</td>'+
                    '<td class="edit">'+s+'</td>'+
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
        timer: 3500,
        placement: {
            from: from,
            align: align
        }
    });
}




