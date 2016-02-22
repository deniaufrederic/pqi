// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery.turbolinks
//= require jquery-ui
//= require jquery_ujs
//= require bootstrap-sprockets
//= require_tree .
//= require moment
//= require bootstrap-datetimepicker
//= require pickers
//= require cocoon
//= require turbolinks

function printpage()
{
	window.print();
}

$(function() {
	$( ".check" ).click(function() {
		if($(this).is(":checked")) {
			$(this).parent().children("input:not(:checked)").addClass("no-disp");
			$(this).parent().children("input:not(:checked) + span").addClass("no-disp");
       		$(this).parent().next().addClass("disp");
     	} else {
     		$(this).parent().children("input:not(:checked)").removeClass("no-disp");
     		$(this).parent().children("input:not(:checked) + span").removeClass("no-disp");
       		$(this).parent().next().removeClass("disp");
     	}
	});
});

$(function() {
	$( ".check" ).each(function() {
		if($(this).is(":checked")) {
			$(this).parent().children("input:not(:checked)").addClass("no-disp");
			$(this).parent().children("input:not(:checked) + span").addClass("no-disp");
	   		$(this).parent().next().addClass("disp");
     	}
	});
});

$(function() {
	$("input").focus(function() {
		$(this).parent().parent().parent(".part").addClass("focused");
	});
	$("input").blur(function() {
		$(this).parent().parent().parent(".part").removeClass("focused");
	});
	$("textarea").focus(function() {
		$(this).parent().parent().parent(".part").addClass("focused");
	});
	$("textarea").blur(function() {
		$(this).parent().parent().parent(".part").removeClass("focused");
	});
	$("select").focus(function() {
		$(this).parent().parent().parent(".part").addClass("focused");
	});
	$("select").blur(function() {
		$(this).parent().parent().parent(".part").removeClass("focused");
	});
});

$(document).ready(function() {
  $('form')
    .on('cocoon:after-insert', function() {
        $("input").focus(function() {
			$(this).parent().parent().parent(".part").addClass("focused");
		});
		$("input").blur(function() {
			$(this).parent().parent().parent(".part").removeClass("focused");
		});
	});
});

$(function() {
    $( "#navtop-icon" ).click(function() {
      	$( ".navtop" ).toggleClass( "responsive" );
    });
});

$(function() {
    $( "#navbot-icon" ).click(function() {
      	$( ".navbot" ).toggleClass( "responsive" );
    });
});

$(function() {
	$('[data-toggle="tooltip"]').tooltip();
});

$(function() {
    $( ".input-group.date" ).datetimepicker();
});

$(document).ready(function() {
  $('form')
    .on('cocoon:after-insert', function() {
        $( ".input-group.date" ).datetimepicker();
    })
});

$(function() {
    $( "#tabs" ).tabs({
    	collapsible: true,
    	heightStyle: "content"
    });
  });

$(function() {
	$('#accordion').accordion({
	    collapsible: true,
	    active: false,
	    heightStyle: "content",

	    beforeActivate: function(event, ui) {
	         // The accordion believes a panel is being opened
	        if (ui.newHeader[0]) {
	            var currHeader  = ui.newHeader;
	            var currContent = currHeader.next('.ui-accordion-content');
	         // The accordion believes a panel is being closed
	        } else {
	            var currHeader  = ui.oldHeader;
	            var currContent = currHeader.next('.ui-accordion-content');
	        }
	         // Since we've changed the default behavior, this detects the actual status
	        var isPanelSelected = currHeader.attr('aria-selected') == 'true';

	         // Toggle the panel's header
	        currHeader.toggleClass('ui-corner-all',isPanelSelected).toggleClass('accordion-header-active ui-state-active ui-corner-top',!isPanelSelected).attr('aria-selected',((!isPanelSelected).toString()));

	        // Toggle the panel's icon
	        currHeader.children('.ui-icon').toggleClass('ui-icon-triangle-1-e',isPanelSelected).toggleClass('ui-icon-triangle-1-s',!isPanelSelected);

	         // Toggle the panel's content
	        currContent.toggleClass('accordion-content-active',!isPanelSelected)    
	        if (isPanelSelected) { currContent.slideUp(); }  else { currContent.slideDown(); }

	        return false; // Cancel the default action
	    }
	});
});