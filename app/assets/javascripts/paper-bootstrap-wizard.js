
// Paper Bootstrap Wizard Functions

searchVisible = 0;
transparent = true;

        $(document).ready(function(){

            /*  Activate the tooltips      */
            $('[rel="tooltip"]').tooltip();
            // Code for the Validator
            var $validator = $('.wizard-card form').validate({

        		  rules: {
        		    name: {
        		      required: true,
        		      minlength: 3
        		    },
                email: {
                  required: true,
                  minlength: 3,
                  email : true
                },
        		    subdomain: {
            		      required: true,
            		      minlength: 3,
                          remote: {
                            url: "/check_subdomain",
                            type: "GET",
                            data: {
                              subdomain: function() {
                                return $( "#company-subdomain").val().trim();
                              }
                            },
                            beforeSend: function(){
                                $('#symbol').addClass('fa fa-spinner fa-spin');
                            },
                            dataFilter: function(response) {
                              if (response == "no"){
                                $('#symbol').addClass('glyphicon-ok green');
                                $('#symbol').removeClass('glyphicon-remove red');
                                $('#symbol').removeClass('fa fa-spinner fa-spin');
                                return true;
                              } else {
                                $('#symbol').addClass('glyphicon-remove red');
                                $('#symbol').removeClass('glyphicon-ok green');
                                $('#symbol').removeClass('fa fa-spinner fa-spin');
                                return false;
                              }
                            }
                          }
                         
        		    }
                },
                messages: {
                    subdomain: {
                      remote: "Subdomain already exist, use another"
                    }
                  },


        highlight: function(element) {
            $(element).closest('.form-group').addClass('has-error');
        },
        unhighlight: function(element) {
            $(element).closest('.form-group').removeClass('has-error');
        },
        errorElement: 'span',
        errorClass: 'help-block',
        errorPlacement: function(error, element) {
            if(element.parent('.input-group').length) {
                error.insertAfter(element.parent());
            } else {
                error.insertAfter(element);
            }
        }





        	});

            $.validator.addMethod("cRequired", $.validator.methods.required,
            "This field is required, remove it if you are not adding collaborator");
            $.validator.addClassRules("collaborator", {
              cRequired: true,
              minlength: 2,
            });

            $.validator.addClassRules("interview-details", {
              required: true,
              minlength: 2,
            });

            // add custom validation to validate time
            $.validator.addMethod("timeValidation", function(value, element) {
              return this.optional(element) || /^[0-5]{1,2}:[0-9]{1,2}$/.test(value);
            }, "Please specify the correct time format, use mm:ss ");

            $.validator.addClassRules("interview-time", {
              required: true,
              minlength: 2,
              timeValidation: true
            });

            // add custom validation to validate time
            $.validator.addMethod("numberValidation", function(value, element) {
              return this.optional(element) || /^[0-9]+$/.test(value);
            }, "Value must be numeric "); 

            $.validator.addClassRules("interview-number-file", {
              required: true,
              max:5,
              numberValidation: true

            });

            $.validator.addClassRules("interview-number-word", {
              required: true,
              max:500,
              numberValidation: true
            });

      

            // Wizard Initialization
          	$('.wizard-card').bootstrapWizard({
                'tabClass': 'nav nav-pills',
                'nextSelector': '.btn-next',
                'previousSelector': '.btn-previous',

                onNext: function(tab, navigation, index) {
        
                	var $valid = $('.wizard-card form').valid();
                	if(!$valid) {
                		$validator.focusInvalid();
                		return false;
                	}
                },

                onInit : function(tab, navigation, index){

                  //check number of tabs and fill the entire row
                  var $total = navigation.find('li').length;
                  $width = 100/$total;

                  navigation.find('li').css('width',$width + '%');

                },

                onTabClick : function(tab, navigation, index){

                    var $valid = $('.wizard-card form').valid();

                    if(!$valid){
                        return false;
                    } else{
                        return true;
                    }

                },

                onTabShow: function(tab, navigation, index) {
                    var $total = navigation.find('li').length;
                    var $current = index+1;

                    var $wizard = navigation.closest('.wizard-card');

                    // If it's the last tab then hide the last button and show the finish instead
                    if($current >= $total) {
                        $($wizard).find('.btn-next').hide();
                        $($wizard).find('.btn-finish').show();
                    } else {
                        $($wizard).find('.btn-next').show();
                        $($wizard).find('.btn-finish').hide();
                    }

                    //update progress
                    var move_distance = 100 / $total;
                    move_distance = move_distance * (index) + move_distance / 2;

                    $wizard.find($('.progress-bar')).css({width: move_distance + '%'});
                    //e.relatedTarget // previous tab

                    $wizard.find($('.wizard-card .nav-pills li.active a .icon-circle')).addClass('checked');

                }
	        });


                // Prepare the preview for profile picture
                $("#wizard-picture").change(function(){
                    readURL(this);
                });

                $('[data-toggle="wizard-radio"]').click(function(){
                    wizard = $(this).closest('.wizard-card');
                    wizard.find('[data-toggle="wizard-radio"]').removeClass('active');
                    $(this).addClass('active');
                    $(wizard).find('[type="radio"]').removeAttr('checked');
                    $(this).find('[type="radio"]').attr('checked','true');
                });

                $('[data-toggle="wizard-checkbox"]').click(function(){
                    if( $(this).hasClass('active')){
                        $(this).removeClass('active');
                        $(this).find('[type="checkbox"]').removeAttr('checked');
                    } else {
                        $(this).addClass('active');
                        $(this).find('[type="checkbox"]').attr('checked','true');
                    }
                });

                $('.set-full-height').css('height', 'auto');

            });



         //Function to show image before upload

        function readURL(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();

                reader.onload = function (e) {
                    $('#wizardPicturePreview').attr('src', e.target.result).fadeIn('slow');
                }
                reader.readAsDataURL(input.files[0]);
            }
        }



        function validateSubdomain(word){
            $.ajax({
              url: '/check_subdomain', 
              type: 'GET',
              data: {subdomain: word },
              success: function(data){
                  if (data == "yes")
                    { return true; }  
                else 
                    {return false; }
              },
              error : function(jqXHR, textStatus, errorThrown) {
                   
               }
           });
        }
