// this will send CSRF token in all ajax request
	$.ajaxSetup({
  		headers: {
   		 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
  		}
  	});


 function setProperites(companyCustomization, editable){

    var setPageCustomization = function() {
      $('.dq-company-logo').attr('alt', companyCustomization.name);
      $('.dq-hero-heading').html(companyCustomization.heroText);
      $('.dq-hero-subheading').html(companyCustomization.subHeroText);
      $('.dq-pre-cta').html(companyCustomization.preCtaText);
      $('.dq-btn-start-interview').html(companyCustomization.ctaButton);
      $('.dq-company-contact').html(companyCustomization.contactInfo);
      $('.dq-color-customized').css('background', companyCustomization.primaryColor);

      // $('.homepage-body').css('background', 'url('+companyCustomization.backgroundImageUrl+')');
    };

    // Toggle page customization
    var customizePage = function(toggle) {
      $('.editableContent').attr('contenteditable', toggle);
    };

    // Initialize page
    var init = function(){
      setPageCustomization();
      customizePage(editable);
    };

    init();
 }

 function setColor(colorValue){
    $('.dq-color-customized').css('background', colorValue);
 }





  