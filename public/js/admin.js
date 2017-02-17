function Admin() {
	var options = {
		selectors: {
			adminCheckbox: '.admin-checkbox',
			completeCheckbox: '.complete-checkbox'
		
		},
		variables: {
			
		}
	},

	init = function() {
		detectAdminCheckbox();
		detectCompleteCheckbox();
		deleteProduct();
		openModаls();
		sizeRadioButtons();
	},

	sizeRadioButtons = function() {
		$('.size').on('click', function() {
			if ($(this).hasClass('checked')) {
				$(this).removeClass('checked');
				$(this).prop('checked', false);
			} else {
				$(this).addClass('checked');
			}
			var size = '';
			$('.size').each(function(index) {
				if ($(this).is(":checked")) {
					size += $(this).val() + ',';
				}
			});
			$('#hidden-size').val(size);

		})
	},
 
	openModаls = function() {
		$('.edit-modal').on('click', function(event) {
			event.preventDefault();
			
			var id = $(this).data('id');

			$.ajax({
				type: "POST",
				url: 'get/product',
				data: {
					id: id
				}
			}).always(function(product) {

				$('#product-name').val(product.name);
				$('#product-description').val(product.description);
				$('#hidden-size').val(product.size);
				$('#product-price').val(product.price);
				$('#product-id').val(product.id);

				if ( product.size ){
					$('.size-group').removeClass('hide');
					$('input[type="radio"').attr('checked', false);

					if (product.size.indexOf('XS') > -1) {
						$('#xs-size').attr('checked', true);
					}
					if (product.size.indexOf('S') > -1) {
						$('#s-size').attr('checked', true);
					}
					if (product.size.indexOf('M') > -1) {
						$('#m-size').attr('checked', true);
					}
					if (product.size.indexOf('L') > -1) {
						$('#l-size').attr('checked', true);
					}
					if (product.size.indexOf('XL') > -1) {
						$('#xl-size').attr('checked', true);
					}
					if (product.size.indexOf('XXL') > -1) {
						$('#xxl-size').attr('checked', true);
					}
				} else {
					$('.size-group').addClass('hide');
				}
				$('#edit-product').modal('toggle');

			});
		});

		$('.comments-modal').on('click', function(event) {
			event.preventDefault();
			
			var id = $(this).data('id');

			$.ajax({
				type: "POST",
				url: '/get/comments',
				data: {
					pid: id
				}
			}).always(function(comments) {

				var $commentsSection = $('.admin-comments');

				$commentsSection.empty();

				if (comments.length > 0) {
					comments.map(function(comment) {
						$commentsSection.append("<div class='comment'><span>" + comment.uname + ":   </span>" + comment.comment + "<button class='btn btn-primary delete-id' data-id='" + comment.id + "'>X</button></div>");
					});
				} else {
					$commentsSection.append("<div> No comments for this product </div>");
				}
				
				
				deleteComment();
					
				$('#comment-product').modal('toggle');
			});



		});
	},

	deleteProduct = function() {

		$('.deleteProduct').on('click', function() {
			var product = this;
			$.ajax({
				type: "DELETE",
				url: "delete/product",
				data: {
					id: $(product).data('id')
				}
			}).always(function(data) {

				$(product).closest('.col-xs-12').remove();
				deleteProduct();
			});
		}) 
	},

	deleteComment = function() {

		$('.comment .delete-id').on('click', function() {
			
			var comment = this;
			$.ajax({
				type: "DELETE",
				url: "delete/comment",
				data: {
					id: $(comment).data('id')
				}
			}).always(function(data) {
				$(comment).closest('.comment').remove();
			});
		}) 
	},

	detectAdminCheckbox = function() {
		var id;
		$(options.selectors.adminCheckbox).on('change', function() {
			id = $(this).data('id');
			if (!id) {
				console.log('wrong id');
			} else {


				if (this.checked) {
					makeUserAdmin(id);
				} else {
					makeAdminUser(id);
				}

			}
		});
	},

	detectCompleteCheckbox = function() {
		var id;
		$(options.selectors.completeCheckbox).on('change', function() {
			id = $(this).data('id');
			if (!id) {
				console.log('wrong id');
			} else {
				if (this.checked) {
					makeOrderComplete(id);
				} else {
					makeOrderNotcomplete(id);
				}
			}
		});
	},

	makeOrderNotcomplete = function(id) {
		$.ajax({
			type: 'POST',
			url: 'order/notcomplete',
			data: {
				id: id
			}
		}).always(function(data) {
			$('.order-grid').html(data);
			detectCompleteCheckbox();
		});
	},

	makeOrderComplete = function(id) {
		$.ajax({
			type: 'POST',
			url: 'order/complete',
			data: {
				id: id
			}
		}).always(function(data) {
			console.log(data);
			$('.order-grid').html(data);
			detectCompleteCheckbox();
		});
	},

	makeUserAdmin = function(id) {
		$.ajax({
			type: 'POST',
			url: 'new',
			data: {
				id: id
			}
		}).always(function(data) {
			$('.user-grid').html(data.responseText);
			detectAdminCheckbox();	
		});
	},

	makeAdminUser = function(id) {
		$.ajax({
			type: 'POST',
			url: 'delete',
			data: {
				id: id
			}
		}).always(function(data) {
			$('.user-grid').html(data.responseText);
			detectAdminCheckbox();	
		});
	};

	return {
		init: init
	};

}


$(document).ready(function() {
	var admin = new Admin(); 
	admin.init();
});