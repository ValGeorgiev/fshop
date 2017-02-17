function Main() {
	var options = {
		selectors: {
			loginClass: '.login',
			loginModal: '#login',
			signupClass: '.signup',
			signupModal: '#signup',
			magnifierClass: '.header .magnifier',
			searchFormClass: '.header form'
		},
		variables: {

		}
	},

	init = function() {
		magnifierEvent();
		openCart();
		hideErrorMsg();
		checkoutValidator();
	},

	openCart = function() {
		$('.bag-wrapper, .modal-message').on('click', function() {
			if (!$(this).hasClass('error')) {
				location.href = "/cart"
			}
		});
	},

	magnifierEvent = function() {
		$(options.selectors.magnifierClass).on('click', function(e) {
			$(options.selectors.searchFormClass).removeClass('hide');
			$(this).hide();
		});
	},

	checkoutValidator = function() {
		$('.buyBtn').on('click', function(e) {
			e.preventDefault();

			var $city = $('#inputCity'),
				$address = $('#inputAdress');

			if (!$city.val()) {
				$city.addClass('error');
			} else {
				$city.removeClass('error');
			} if (!$address.val()) {
				$address.addClass('error');
			} else {
				$address.removeClass('error');
			} 

			if (!$address.hasClass('error') && !$city.hasClass('error')) {
				$('.checkoutForm').submit();
			}
		});
	},

	hideErrorMsg = function() {
		setTimeout(function() {
			$('.error-msg').slideUp(500);
			window.history.pushState(null, null, window.location.pathname);
		}, 5000)
	};

	return {
		init: init
	};

}


$(document).ready(function() {
	var main = new Main(); 
	main.init();
});