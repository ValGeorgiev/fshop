function Product() {
	var options = {
		selectors: {
			
		},
		variables: {
			
		}
	},

	init = function() {
		showCommentsInput();
		addComment();
		addToCart();
		updateBag();
		deleteProduct();
	},

	addComment = function() {
		$('.add-comment-btn').on('click', function() {
			var comment_text = $('.add-input').val();

			if ( !!comment_text ) {
				$.ajax({
					type: "POST",
					url: "/add/comment",
					data: {
						pid : $('.modal-id').val(),
						uid : $(this).data('user-id'),
						comment : comment_text 					
					}
				}).always(function(comment) {

					var $commentsSection = $('.comments');
					$commentsSection.prepend("<div class='comment'><span>" + comment.uname + ":   </span>" + comment.comment + "</div>");
					
					$('.comment-add').slideUp();
					$('.show-input').show();
				});
			} else {
				$('.comment-add').slideUp();
				$('.show-input').show();
			}
		});
	},

	showCommentsInput = function() {
		$('.show-input').on('click', function() {
			$('.add-input').val('');
			$(this).hide();
			$('.comment-add').slideDown();
			$('.add-input').focus();
		});
	},

	updateBag = function() {

		$.ajax({
			type: "GET",
			url: "/get/basket/size"
		}).always(function(data) {
			$('.bag-counter').html('(' + data + ')')
		});
	},

	deleteProduct = function() {

		$('.product-cart-remove').on('click', function() {
			var _btn = this; 
			$.ajax({
				type: "DELETE",
				url: "delete/cart",
				data: {
					pid: $(this).data('id')
				}
			}).always(function(data) {
				$(_btn).closest('.product-cart-wrapper').remove();
				updateBag();
				$('.price-tag').html('$' + data);

				if (data == 0) {
					$('.pay-cart-wrapper').remove();
					$('.car-wrapper').html('<h3>Ohh, you have no products in your basket <a href="products">Keep Looking</a></h3>')
				}

			});
		});
	},

	addToCart = function() {
		$('.modal-add').on('click', function() {
			var pid = $('.modal-id').val();
			var quantity = $('.modal-quantity').val();
			var size = $('.modal-size').val();

			if ( !isNaN(parseInt(quantity)) && quantity !== '0' ) {
				$.ajax({
					type: "POST",
					url: '/product/add',
					data: {
						pid: pid,
						quantity: quantity,
						size: size
					}
				}).always(function(data) {
					$('.modal-message .msg').html(data.message);

					if ( data.error ) {
						$('.modal-message').addClass('error').slideDown();
						setTimeout(function() {
							$('.modal-message').slideUp().removeClass('error');
						}, 4000);
					} else {
						updateBag();
						$('.modal-message').slideDown();
						setTimeout(function() {
							$('.modal-message').slideUp();
						}, 4000);
					}

				});
			} else {
				$('.modal-message .msg').html("Please, enter a correct quantity");
				$('.modal-message').addClass('error').slideDown();
				setTimeout(function() {
					$('.modal-message').slideUp().removeClass('error');
				}, 4000);
			}
		});
	};

	return {
		init: init
	};
}


$(document).ready(function() {
	var product = new Product(); 
	product.init();
});