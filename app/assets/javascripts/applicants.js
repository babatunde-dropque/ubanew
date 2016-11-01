// this will send CSRF token in all ajax request
	$.ajaxSetup({
  		headers: {
   		 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
  		}
  	});


  (function() {
  'use strict';

  // Default page values
  var companyCustomization = {
    name: 'Dropque',
    primaryColor: '#5e337b',
    // logoUrl: "images/dropque_logo.png",
    // backgroundImageUrl: '../images/interviewers.jpg',
    heroText: "At Dropifi, we create a world that inspires human connection.",
    // subHeroText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum non metus molestie, varius diam nec, gravida nisi. Proin luctus, libero id placerat dignissim.",
    subHeroText: "",
    // preCtaText: "Here to take an interview?",
    preCtaText: "",
    ctaButton: "Start your interview",
    contactInfo: "Have questions? Contact us on +234 (0) 90 777 2318 or <a href='mailto:info@dropque.com'>info@dropque.com</a>"
  };

  ///// DUMMY USE ///// Set initial values for customized page
  var setPageCustomization = function() {
    // $('.dq-company-logo').attr('src', companyCustomization.logoUrl);
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
    $('#editableContent').attr('contenteditable', toggle);
  };

  // Initialize page
  var init = function(){
    setPageCustomization();
    customizePage(false);
  };

  init();

}).call(this);


  