function Home() {
	var options = {
		selectors: {
			owlCarouselClass : '.owl-carousel',
			emailRegEx : /^([0-9a-zA-Z]([-_\\.]*[0-9a-zA-Z]+)*)@([0-9a-zA-Z]([-_\\.]*[0-9a-zA-Z]+)*)[\\.]([a-zA-Z]{2,9})$/,
			error : '.error',
			login : {
				emailID : '#inputEmail',
				password : '#inputPassword',
				form : '.login-form'
			},
			register : {
				emailID : '#emailRegister',
				password : '#passwordRegister',
				name : '#nameRegister',
				form : '.register-form'
			}
		},
		variables: {
			owlCarouselOptions: {
				loop: false,
				margin: 20,
				items: 5,
				mouseDrag: false,
				nav: true,
				navText: ['', ''],
				responsive: {
					640: {

					},
					768: {

					},
					1024: {

					}
				}
			}
		}
	},

	init = function() {
		owlCarouselInit(options.variables.owlCarouselOptions);
		login();
		register();
		openModal();
		openSignUpModal();
		search();
	},

	search = function() {
		$('.search-btn').on('click', function(e) {
			e.preventDefault();
			var searchValue = $('.search-input').val();
			if ( !!searchValue ) {
				window.location.href = '/products/' + searchValue;
			}
		});
	},

	loadComments = function(pid) {
		$.ajax({
			type: "POST",
			url: "/get/comments",
			data: {
				pid: pid
			}
		}).always(function(comments) {
			var $commentsSection = $('.comments');
			$commentsSection.empty();
			comments.map(function(comment) {
				$commentsSection.append("<div class='comment'><span>" + comment.uname + ":   </span>" + comment.comment + "</div>");
			});
		})
	},

	openModal = function() {

		$('.open-modal').on('click', function(event) {
			event.preventDefault();
			var pid = $(this).find('.id').val();
			$('.modal-title').html($(this).find('.name').html());
			$('.modal-price').html($(this).find('.price').html());
			$('.modal-description').html($(this).find('.description').html());
			$('.modal-img').attr('src', $(this).find('img').attr('src'));
			$('.modal-id').val(pid);
			$('.modal-quantity').val(1);

			//parse the size and create select options
			var sizeStr = $(this).find('.size').val();

			if ( sizeStr[sizeStr.length - 1] === ',') {
				sizeStr = sizeStr.slice(0, -1);
			}
 			var size = sizeStr.split(',');

			if (sizeStr === '') {
				$('.modal-size-wrapper').addClass('hide');
			} else {
				$('.modal-size-wrapper').removeClass('hide');
				$('.modal-size').empty();
			}

			size.map(function(s) {
				$('.modal-size').append('<option value="' + s + '">' + s + '</option>')
			});

			loadComments(pid);



			$('#product').modal('toggle');
		});
		
	},

	owlCarouselInit = function(carouselOptions) {
		$(options.selectors.owlCarouselClass).owlCarousel(carouselOptions);
	},

	login = function() {
		$(options.selectors.login.emailID).focusout(function(){
			validateEmail(this);
		});
		$(options.selectors.login.password).focusout(function(){
			validatePassword(this);
		});

		$('.loginBtn').on('click', function(e) {
			e.preventDefault();
			validateEmail(options.selectors.login.emailID);
			validatePassword(options.selectors.login.password);


			var data = { 
				email: $(options.selectors.login.emailID).val(),
				password: $(options.selectors.login.password).val()
			};

			if ( $(options.selectors.login.form + ' ' + options.selectors.error).length === 0) {
				$(options.selectors.login.form).submit();
			}
		});
	},

	register = function() {
		$(options.selectors.register.emailID).focusout(function(){
			validateEmail(this);
		});
		$(options.selectors.register.password).focusout(function(){
			validatePassword(this);
		});

		$('.registerBtn').on('click', function(e) {
			e.preventDefault();
			validateEmail(options.selectors.register.emailID);
			validatePassword(options.selectors.register.password);


			var data = { 
				email: $(options.selectors.register.emailID).val(),
				password: $(options.selectors.register.password).val(),
				name: $(options.selectors.register.name).val()
			};

			if ( $(options.selectors.register.form + ' ' + options.selectors.error).length === 0) {
				$(options.selectors.register.form).submit();
			}
		});

	},

	validateEmail = function(that) {
		var value = $(that).val();

		if (!options.selectors.emailRegEx.test(value)) {
			$(that).addClass('error');
		
		} else {
			$(that).removeClass('error');
		}
	},	
	validatePassword = function(that) {
		var value = $(that).val();

		if (value === '' || value.length < 6) {
			$(that).addClass('error');
		} else {
			$(that).removeClass('error');
		}
	},

	openSignUpModal = function() {
		$('.modalSignup').on('click', function() {
			$('#login').modal('toggle');
			$('#signup').modal('toggle');
		});
	};

	return {
		init: init
	};

}


$(document).ready(function() {
	var home = new Home(); 
	home.init();
});