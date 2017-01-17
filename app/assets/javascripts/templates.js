$(document).ready(function(){

	$('.create-rei').click(function(){
		var sections = $('.section-container.level-1');
		var valid = true;
		var message = 'One or more sections were incomplete: \n\n'
		$(sections).each(function(){
			if (!$(this).find('.inspected').is(':checked')) {
				if (!$(this).find('.not-inspected').is(':checked')) {
					message = message + $(this).find('.section-name > a').html() + '\n';
					valid = false;
				}
			}
		});
		if (!valid) {
			alert(message);
		}
		return valid;
	});
	
	$('.delete-statement').click(function(){
		deleteStatementClickHandler(this);
	});

	$('.edit-statement').click(function(){
		editStatementClickHandler(this);
	});

	$('.cancel-statement-update').click(function(){
		cancelStatementClickHandler(this);
	});

	$('.save-statement').click(function(){
		saveStatementClickHandler(this);
	});

	function deleteStatementClickHandler(that){
		var statement_container = get_statement_container($(that));
		$.ajax({url: '/statements/' + statement_container.attr('data-statement-id'),
				method: 'delete'})
		.done(function(){
			// TODO: make this logic to uncheck "D" a bit more elegant.  As it stands it's pretty brittle and has a hardcoded value for the deficiency statement type ID
			if ( statement_container.data('statement-type-id') === 4 ) {
				if (statement_container.siblings('.statement-container').length === 0) {
					var section_container = get_section_container(that);
					section_container.find('.deficient').prop('checked', false).trigger('change');
				};
			};
			statement_container.remove();
			display_message('Statement removed.','success', 1500);
		})
		.fail(function(){
			display_message('Statement removal failed. Please reload the template and try again.','danger', 3500);
		});		
	};

	function editStatementClickHandler(that){
		var statement_container = get_statement_container($(that));		
		statement_container
			.find('.statement-text-editor')
				.val(statement_container
						.find('.statement-text')
							.html().replace(/<br\s*[\/]?>/gi, "\n"));
		statement_container.find('.edit-statement-type-selector').val(statement_container.data('statement-type-id'));
		statement_container.find('.statement-display').hide();
		statement_container.find('.edit-statement-form-container').show();
		statement_container.find('.statement-text-editor').focus();
	};

	function cancelStatementClickHandler(that){
		var statement_container = get_statement_container($(that));
		statement_container.find('.edit-statement-form-container').hide();
		statement_container.find('.statement-display').show();
	};

	function saveStatementClickHandler(that){
		var statement_container = get_statement_container($(that));
		var updated_statement_content = statement_container.find('.statement-text-editor').val();
		var updated_statement_type_id = statement_container.find('.edit-statement-type-selector').val();
		$.ajax({url: '/statements/' + statement_container.attr('data-statement-id'),
				method: 'patch',
				data: {content: updated_statement_content,
				       statement_type_id: updated_statement_type_id}})
		.done(function(){
			if (statement_container.data('statement-type-id') != updated_statement_type_id) {
				var section_container = get_section_container(statement_container);
				var new_statement_type_container = section_container.find('.statement-type-container[data-statement-type-id='+updated_statement_type_id+']');
				statement_container.find('.edit-statement-type-selector').val(updated_statement_type_id);
				statement_container.attr('data-statement-type-id', updated_statement_type_id);
				statement_container.data('statement-type-id', updated_statement_type_id);
				//new_statement_type_container.append(statement_container);
				new_statement_type_container.find('.sortable').append(statement_container).sortable('refresh');
				statement_container.parent('.sortable').sortable('refresh');
			}
			statement_container.find('.statement-text').html(updated_statement_content.replace(/\n/g,"<br>"));
			statement_container.find('.statement-display').show();
			statement_container.find('.edit-statement-form-container').hide();
			statement_container.find('.statement-text-editor').html();
			display_message('Statement updated.','success', 1500);
		})
		.fail(function(){
			display_message('Statement update failed. Please try again.','danger', 3500);
		});
	};

	$('.add-statement').click(function(){
		var section_container = get_section_container($(this));
		section_container.find('.add-statement').hide();
		section_container
			.find('.add-statement-form-container')
				.show()
				.find('.library-filter')
					.focus().select();
	});

	$('.library-filter').keyup(function(){
		var section_container = get_section_container($(this));
		$.ajax({url: '/inspector_statements/',
				method: 'get',
				data:  {section_type_id: section_container.attr('data-section-type-id'),
					search: $(this).val()}})
		.done(function(response){
			statement_library_container = section_container.find('.statement-library-container').html('').show();
			if (response.length > 0) {
				$.each(response,function(index, statement){
					statement_library_container.append('<hr><div class="row library-statement-selection-container" data-statement-type-id="' + statement.statement_type_id + '"><div class="col-sm-12"><div class="keyword-display"><span class="prompt">Keyword(s): </span>'+ statement.keyword +'<button class="btn btn-sm btn-primary pull-right">Select statement</button></div><span class="statement-content">'+ statement.content.replace(/\n/g,"<br>") +'</span></div></div>');
				});
				statement_library_container.children('.row').click(function(){
					var statement_content = $(this).find('.statement-content').html().replace(/<br\s*[\/]?>/gi, "\n");
					var statementTypeId = $(this).data('statement-type-id');
					section_container.find('.new-statement-text-editor').val(statement_content);
					section_container.find('.statement-type-selector').val(statementTypeId);
					section_container.find('.create-statement').focus();
				});
			} else {
				statement_library_container.append('<div>No matching statements found</div>');
			}
		})
		.fail(function(){
			display_message('Failed to load statement library','danger', 3500);
		});
	});

	$('.cancel-statement-creation').click(function(){
		var section_container = get_section_container($(this));		
		section_container.find('.add-statement-form-container').hide().find('.new-statement-text-editor').val('');
		section_container.find('.statement-type-selector').val('1');
		section_container.find('.library-filter').val('');
		section_container.find('.statement-library-container').html('').show();
		section_container.find('.add-statement').show();
		$('html, body').animate({scrollTop: section_container.offset().top},0);
	});

	$('.create-statement').click(function(){
		var section_container = get_section_container($(this));
		var new_statement_content = section_container.find('.new-statement-text-editor').val();
		var statement_type_id = section_container.find('.statement-type-selector').val();
		var statement_ids = [];
		$(section_container).find('.statement-container').each(function(){
			statement_ids.push($(this).attr('id'));
		});
		$.ajax({url: '/statements',
				method: 'post',
				data: {content: new_statement_content,
				       section_id: section_container.attr('data-section-id'),
				       statement_ids: statement_ids,
				       statement_type_id: statement_type_id}})
		.done(function(response){
			section_container.find('.add-statement-form-container').hide();
			section_container.find('.new-statement-text-editor').val('');
			new_statement_content = new_statement_content.replace(/\n/g,"<br>")
			section_container.find('[data-statement-type-id=' + statement_type_id +']').siblings('.sortable').append('<div class="statement-container" id="' + response.id + '" data-statement-id="' + response.id + '" data-statement-type-id="' + statement_type_id + '"><div class="row statement-display"><div class="col-sm-10 statement-text">' + new_statement_content + '</div><div class="col-sm-2 text-right"><a class="edit-statement" role="button" title="Edit statement">Edit</a><a class="delete-statement" role="button" title="Remove statement"><span class="glyphicon glyphicon-trash"></span></a></div></div><div class="edit-statement-form-container row"><div class="col-sm-12"><div class="form-group"><label for="statement-text-editor">Statment content</label><textarea rows="10" cols="80" class="form-control statement-text-editor"></textarea></div><div class="form-group"><label for="statement-type">Statement type</label><select name="statement-type" class="edit-statement-type-selector form-control"><option value="1">General Statement</option><option value="2">General Recommendation</option><option value="3">Common Issue</option><option value="4">Deficiency</option></select></div><div class="form-group"><button class="btn btn-sm btn-primary save-statement">Save</button><span class="between-button-text">or</span><button class="btn btn-link btn-sm cancel-statement-update">Cancel</button></div></div></div></div>');
			section_container.find('.add-statement').show();
			var statement_container = section_container.find('#' + response.id);
			statement_container.find('.edit-statement').click(function(){
				editStatementClickHandler(this);
			});
			statement_container.find('.cancel-statement-update').click(function(){
				cancelStatementClickHandler(this);
			});
			statement_container.find('.delete-statement').click(function(){
				deleteStatementClickHandler(this);
			});
			statement_container.find('.save-statement').click(function(){
				saveStatementClickHandler(this);
			});
			section_container.find('[data-statement-type-id=' + statement_type_id +']').siblings('.sortable').sortable( 'refresh' );
			// TODO: fix this hardcoded statement_type_id = deficiency bit
			if (statement_type_id == 4) {
				section_container.find('.deficient').prop('checked', true).trigger('change');
			}
			section_container.find('.statement-type-selector').val('1');
			section_container.find('.library-filter').val('');
			section_container.find('.statement-library-container').html('').show();
			$('html, body').animate({scrollTop: section_container.offset().top},0);
			display_message('Statement added.','success', 1500);
		})
		.fail(function(){
			display_message('Statement addition failed. Please try again.','danger', 3500);
		});
	});

	$('.add-photo').click(function(){
		var section_container = get_section_container($(this));
		var section_id = section_container.attr('data-section-id');
		section_container.find('.add-photo').hide();
		section_container.find('.save-photo').prop('disabled', false);
		section_container.find('#photo-picker-'+section_id).val('');
		section_container.find('#caption-'+section_id).val('');
		section_container
			.find('.add-photo-form-container')
				.show()
				.find('.photo-picker')
					.focus();
	});

	// Variable to store your files
	var files;

	// Add events
	$('input[type=file]').on('change', prepareUpload);

	// Grab the files and set them to our variable
	function prepareUpload(event) {
		files = event.target.files;
	};	

	$('.save-photo').click(function(){
		if ( files !== undefined ) {
			if ( files.length === 1 ) {
				$(this).prop('disabled', true);
				var section_container = get_section_container($(this));
				var section_id = section_container.attr('data-section-id');
				var caption = section_container.find('#caption-' + section_id).val();
				var photo = section_container.find('#photo-picker-' + section_id).val();
				var data = new FormData();
				$.each(files, function(key, value){
					data.append('image', value);
				});		
				var image_ids = [];
				$(section_container).find('.image-container').each(function(){
					image_ids.push($(this).data('image-id'));
				});
				data.append("section_id", section_id);
				data.append('caption', caption);
				for (i = 0; i < image_ids.length; i++) {
					data.append('image_ids[]', image_ids[i]);
				}
				section_container.find('.add-photo-form-container').hide();
				section_container.find('.add-photo').show();
				section_container.find('.image-thumbnails-container').append('<div class="temp-image">temp</div>');
				$.ajax({url: '/images',
						type: 'POST',
						data: data,
						cache: false,
						dataType: 'json',
						processData: false, // Don't process the files
						contentType: false})
				.done(function(response){
					section_container.find('.temp-image').remove();
					section_container.find('.image-thumbnails-container').append('<div id="image-' + response.id + '" class="image-container" data-url="' + response.image_url + '" data-image-id="' + response.id + '"><img src="' + response.image_thumbnail_url + '" alt=""><br><span class="image-caption small">' + response.caption + '</span></div>');
					$('#image-' + response.id).click(function(){
						imageContainerClickHandler(this);
					});
					section_container.find('.image-sortable').sortable( 'refresh' );
					display_message('Photo uploaded.','success', 1500);
				})
				.fail(function(){
					display_message('Photo upload failed. Please try again.','danger', 3500);
				})
				.always(function(){
					section_container.find('#photo-picker-'+section_id).val('');
					section_container.find('#caption-'+section_id).val('');
					section_container.find('.save-photo').prop('disabled', false);
				});
			} else {
				alert('Please select an image to upload');
			}
		} else {
			alert('Please select an image to upload');
		}
	});
	
	$('.save-cover-photo').click(function(){
		var report_container = get_report_container($(this));
		var add_cover_photo_container = $('.add-cover-photo-form-container');
		var photo = add_cover_photo_container.find('#cover-photo-picker').val();
		var data = new FormData();
		$.each(files, function(key, value){
			data.append('cover_image', value);
		});		
		$(this).prop('disabled', true);
		$.ajax({url: '/reports/' + report_container.data('id'),
				type: 'PATCH',
				data: data,
				cache: false,
				dataType: 'json',
				processData: false, // Don't process the files
				contentType: false})
		.done(function(response){
			add_cover_photo_container.hide();
			$('.edit-cover-photo').hide();
			report_container.find('.cover-photo-display').append('<div id="cover-photo-image" class="image-container" data-cover-photo="true" data-url="' + response.cover_image_url + '" data-image-id=""><img src="' + response.cover_image_thumbnail_url + '" alt=""></div>');
			$('#cover-photo-image').click(function(){
				imageContainerClickHandler(this);
			});
			display_message('Cover photo uploaded.','success', 1500);
		})
		.fail(function(){
			display_message('Cover photo upload failed. Please try again.','danger', 3500);
		})
		.always(function(){
			add_cover_photo_container.find('.save-cover-photo').prop('disabled', false);
		});
	});

	$('.cancel-cover-photo-upload').click(function(){
		$('.add-cover-photo-form-container').hide();
	});

	$('.save-photo-edits').click(function(){
		//todo: grab edited image file
		var caption = $('#edit-image-caption').val();
		var image_id = $('#image-id').val();
		$.ajax({url: '/images/' + image_id,
				method: 'PATCH',
				data: {caption: caption}})
		.done(function(response){
			$('#image-editor-modal').modal('hide');
			$('#image-' + image_id).find('.image-caption').html(caption);
			display_message('Photo edits saved.','success', 1500);
		})
		.fail(function(){
			display_message('Photo edits failed. Please try again.','danger', 3500);
		});
	});
	
	$('.cancel-photo-save').click(function(){
		var section_container = get_section_container($(this));
		section_container.find('.add-photo-form-container').hide();
		section_container.find('.add-photo').show();		
	});

	function getImageEditorContainer(){
		return $('#image-editor-modal');
	};
	
	$('.delete-photo').click(function(){
		var imageEditorContainer = getImageEditorContainer();
		if ( imageEditorContainer.data('cover-photo') ) {
			var reportContainer = get_report_container(this);
			$.ajax({url: '/reports/' + reportContainer.data('id') + '/cover_photo',
				method: 'DELETE'})
			.done(function(response){
				$('#image-editor-modal').modal('hide');
				$('#cover-photo-image').remove();
				$('.edit-cover-photo').show();
				display_message('Cover photo deleted.','success', 1500);
			})
			.fail(function(){
				display_message('Cover photo deletion failed. Please try again.','danger', 3500);
			});

		} else {
			var image_id = $('#image-id').val();
			$.ajax({url: '/images/' + image_id,
					method: 'DELETE'})
			.done(function(response){
				$('#image-editor-modal').modal('hide');
				$('#image-' + image_id).remove();
				display_message('Photo deleted.','success', 1500);
			})
			.fail(function(){
				display_message('Photo deletion failed. Please try again.','danger', 3500);
			});
		}
	});
	
	$('.image-container').click(function(){
		imageContainerClickHandler(this);
	});
	
	function imageContainerClickHandler(that){
		if ( ! $(that).hasClass('sorting') ) {
			var imageEditorContainer = getImageEditorContainer();
			// hide caption stuff for cover photos
			if ( $(that).data('cover-photo') ) {
				imageEditorContainer.find('.caption-container').hide();
				imageEditorContainer.find('.save-photo-edits').hide();
				imageEditorContainer.find('.between-button-text').hide();
				imageEditorContainer.data('cover-photo', true);
			} else {
				imageEditorContainer.find('.caption-container').show();
				imageEditorContainer.find('.save-photo-edits').show();
				imageEditorContainer.find('.between-button-text').show();
				imageEditorContainer.data('cover-photo', false);
			}
			imageEditorContainer.modal('show');
			$('#image-id').val($(that).data('image-id'));
			$('#edit-image-caption').val($(that).find('.image-caption').html());
			$('#edit-image-container').append('<img src="' + $(that).data('url') + '" class="img-responsive" />');
		}
	};
	
	
	$('#image-editor-modal').on('hidden.bs.modal', function(e){
		$(this).find('#edit-image-caption').val();
		$(this).find('#edit-image-container img').remove();
		$(this).find('#image-id').val();
	});

	$('.edit-cover-photo').click(function(){
		$('.add-cover-photo-form-container').find('.photo-picker').val('');
		$('.add-cover-photo-form-container').show();
	});
	
	function get_section_container(element){
		return $(element).parents('.section-container');		
	}

	function get_todo_container(element){
		return $(element).parents('.todo-container');
	}

	function get_answer_container(element){
		return $(element).parents('.answer-container');
	}

	function get_cya_container(element){
		return $(element).parents('.cya-container');
	}

	function get_statement_container(element){
		return $(element).parents('.statement-container');
	}

	function get_inspector_statement_container(element){
		return $(element).parents('.inspector-statement-container');
	}

	$( '.sortable' ).sortable({
		placeholder: 'statement-sortable-target',
		axis: 'y',
		revert: 100,
		tolerance: 'intersect',
		distance: 5,
		stop: handle_statement_display_order_adjustment
	});
	//$( '.sortable' ).disableSelection();
	function handle_statement_display_order_adjustment() {
		var statement_ids = [];
		$(this).children('.statement-container').each(function(){
			statement_ids.push($(this).attr('id'));
		});
		$.ajax({url: '/sections/update_all/' + get_section_container($(this)).data('section-id'),
				method: 'PATCH',
				data: {statement_ids: statement_ids}})
		.done(function(response){
			display_message('Statement display order updated.','success', 1500);
		})
		.fail(function(){
			display_message('Statement display order failed. Please try again.','danger', 3500);
		});
	};

	$( '.inspector-statement-sortable' ).sortable({
		placeholder: 'statement-sortable-target',
		axis: 'y',
		revert: 100,
		tolerance: 'intersect',
		distance: 5,
		stop: handle_inspector_statement_display_order_adjustment
	});

	function handle_inspector_statement_display_order_adjustment() {
		var inspector_statement_ids = [];
		$(this).children('.inspector-statement-container').each(function(){
			inspector_statement_ids.push($(this).data('id'));
		});
		$.ajax({url: '/section_types/' + get_section_container($(this)).data('section-type-id') + '/update_inspector_statement_order/' ,
				method: 'PATCH',
				data: {inspector_statement_ids: inspector_statement_ids}})
		.done(function(response){
			display_message('Statement library display order updated.','success', 1500);
		})
		.fail(function(){
			display_message('Statement library display order failed. Please try again.','danger', 3500);
		});
	};

	$( '.cya-sortable-container' ).sortable({
		placeholder: 'statement-sortable-target',
		axis: 'y',
		revert: 100,
		tolerance: 'intersect',
		distance: 5,
		stop: handle_cya_display_order_adjustment
	});
	//$( '.cya-sortable-container' ).disableSelection();
	function handle_cya_display_order_adjustment() {
		var cya_ids = [];
		$(this).children('.cya-container').each(function(){
			cya_ids.push($(this).data('id'));
		});
		$.ajax({url: '/sections/update_cya_order/' + get_section_container($(this)).data('section-id'),
				method: 'PATCH',
				data: {cya_ids: cya_ids}})
		.done(function(response){
			display_message('CYA display order updated.','success', 1500);
		})
		.fail(function(){
			display_message('CYA display order failed. Please try again.','danger', 3500);
		});
	};
	$( '.todo-sortable-container' ).sortable({
		placeholder: 'statement-sortable-target',
		axis: 'y',
		revert: 100,
		tolerance: 'intersect',
		stop: handle_todo_display_order_adjustment
	});
	//$( '.todo-sortable-container' ).disableSelection();
	function handle_todo_display_order_adjustment() {
		var todo_ids = [];
		$(this).children('.todo-container').each(function(){
			todo_ids.push($(this).data('id'));
		});
		$.ajax({url: '/sections/update_todo_order/' + get_section_container($(this)).data('section-id'),
				method: 'PATCH',
				data: {todo_ids: todo_ids}})
		.done(function(response){
			display_message('To-do display order updated.','success', 1500);
		})
		.fail(function(){
			display_message('To-do display order failed. Please try again.','danger', 3500);
		});
	};
	$( '.answer-sortable-container' ).sortable({
		placeholder: 'statement-sortable-target',
		axis: 'y',
		revert: 100,
		tolerance: 'intersect',
		stop: handle_answer_display_order_adjustment
	});
	//$( '.answer-sortable-container' ).disableSelection();
	function handle_answer_display_order_adjustment() {
		var answer_ids = [];
		$(this).children('.answer-container').each(function(){
			answer_ids.push($(this).data('id'));
		});
		$.ajax({url: '/to_dos/update_answer_order/' + get_todo_container($(this)).data('id'),
				method: 'PATCH',
				data: {answer_ids: answer_ids}})
		.done(function(response){
			display_message('Answer display order updated.','success', 1500);
		})
		.fail(function(){
			display_message('Answer display order failed. Please try again.','danger', 3500);
		});
	};
	
	$(function(){
		$( '.image-sortable' ).sortable({
	    	placeholder: 'image-sortable-target',
			forcePlaceholderSize: true,
			//axis: 'y',
			revert: 50,
			tolerance: 'intersect',
			stop: handle_image_display_order_adjustment,
			start: disable_modal
	    });
	    //$( '.image-sortable' ).disableSelection();
		function disable_modal(event, ui){
			$(ui.item).addClass('sorting');
		};
		function handle_image_display_order_adjustment(event, ui) {
			var image_ids = [];
			$(this).children('.image-container').each(function(){
				image_ids.push($(this).data('image-id'));
			});
			$.ajax({url: '/sections/update_all_images/' + get_section_container($(this)).data('section-id'),
					method: 'PATCH',
					data: {image_ids: image_ids}})
			.done(function(response){
				display_message('Image display order updated.','success', 1500);
			})
			.fail(function(){
				display_message('Image display order failed. Please try again.','danger', 3500);
			});
			$(ui.item).removeClass('sorting');
		}
	});


	$('.delete-cya').click(function(){
		deleteCyaClickHandler(this);
	});

	function deleteCyaClickHandler(that) {
		var cyaContainer = $(that).parents('.cya-container');
		var cya_id = cyaContainer.data('id');
		$.ajax({url: '/cyas/' + cya_id,
				method: 'DELETE'})
		.done(function(response){
			cyaContainer.remove();
			display_message('CYA deleted.','success', 1500);
		})
		.fail(function(){
			display_message('CYA deletion failed. Please try again.','danger', 3500);
		});
		
	};

	$('.add-cya').click(function(){
		var section_container = get_section_container($(this));
		section_container.find('.add-cya').hide();
		section_container
			.find('.add-cya-form-container')
				.show()
				.find('.new-cya-text-editor')
					.focus().select();
	});

	$('.cancel-cya-creation').click(function(){
		var section_container = get_section_container($(this));		
		section_container.find('.add-cya-form-container').hide().find('.new-cya-text-editor').val('');
		section_container.find('.add-cya').show();
	});

	$('.create-cya').click(function(){
		var section_container = get_section_container($(this));
		var new_cya_content = section_container.find('.new-cya-text-editor').val();
		$.ajax({url: '/cyas',
				method: 'post',
				data: {content: new_cya_content,
					   section_id: section_container.attr('data-section-id')}})
		.done(function(response){
			section_container.find('.add-cya-form-container').hide().find('.new-cya-text-editor').val('');
			section_container.find('.add-cya-container').before('<div id="cya' + response.id + '" class="cya-container" data-id="' + response.id + '"><div class="row cya-display"><div class="col-sm-10 cya-content">' + response.content + '</div><div class="col-sm-2 text-right"><a class="edit-cya" title="Edit CYA">Edit</a><a class="delete-cya" title="Delete CYA"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></a></div></div><div class="edit-cya-form-container row"><div class="col-sm-12"><div class="row"><div class="col-sm-12"><div class="form-group"><input type="text" class="cya-text-editor form-control"></div></div></div><div class="row"><div class="col-sm-12"><div class="form-group"><button class="btn btn-sm btn-primary save-cya">Save</button><span class="between-button-text">or</span><button class="btn btn-link btn-sm cancel-cya-update">Cancel</button></div></div></div></div></div></div>');
			section_container.find('.add-cya').show();
			var cya_container = section_container.find('#cya' + response.id);
			cya_container.find('.edit-cya').click(function(){
				editCyaClickHandler(this);
			});
			cya_container.find('.cancel-cya-update').click(function(){
				cancelCyaUpdateClickHandler(this);
			});
			cya_container.find('.delete-cya').click(function(){
				deleteCyaClickHandler(this);
			});
			cya_container.find('.save-cya').click(function(){
				saveCyaClickHandler(this);
			});
			//section_container.find('[data-statement-type-id=' + statement_type_id +']').siblings('.sortable').sortable( 'refresh' );
			display_message('CYA added.','success', 1500);
		})
		.fail(function(){
			display_message('CYA addition failed. Please try again.','danger', 3500);
		});
	});

	$('.edit-cya').click(function(){
		editCyaClickHandler(this);
	});

	function editCyaClickHandler(that){
		var cya_container = get_cya_container($(that));		
		cya_container.find('.cya-text-editor').val(cya_container.find('.cya-content').html().replace(/<br\s*[\/]?>/gi, "\n"));
		cya_container.find('.cya-display').hide();
		cya_container.find('.edit-cya-form-container').show();
		cya_container.find('.cya-text-editor').focus();
	};

	$('.cancel-cya-update').click(function(){
		cancelCyaUpdateClickHandler(this);
	});

	function cancelCyaUpdateClickHandler(that){
		var cya_container = get_cya_container($(that));
		cya_container.find('.edit-cya-form-container').hide();
		cya_container.find('.cya-display').show();
	};

	$('.save-cya').click(function(){
		saveCyaClickHandler(this);
	});

	function saveCyaClickHandler(that){
		var cya_container = get_cya_container($(that));
		var cya_content = cya_container.find('.cya-text-editor').val();
		var cya_id = cya_container.data('id');
		$.ajax({url: '/cyas/' + cya_id,
			method: 'patch',
			data: {
				content: cya_content}})
		.done(function(response){
			cya_container.find('.cya-content').html(cya_content);
			cya_container.find('.edit-cya-form-container').hide();
			cya_container.find('.cya-display').show();
			display_message('CYA updated.','success', 1500);
		})
		.fail(function(){
			display_message('CYA update failed.', 'danger', 3500);
		});
	};

	$('.add-todo').click(function(){
		var section_container = get_section_container($(this));
		section_container.find('.add-todo').hide();
		section_container
			.find('.add-todo-form-container')
				.show()
				.find('.new-todo-content-text-editor')
					.focus().select();
	});

	$('.cancel-todo-creation').click(function(){
		var section_container = get_section_container($(this));		
		section_container.find('.add-todo-form-container').hide().find('.new-todo-text-editor').val('');
		section_container.find('.add-todo').show();
	});

	$('.create-todo').click(function(){
		var section_container = get_section_container($(this));
		var new_todo_content = section_container.find('.new-todo-content-text-editor').val();
		var new_todo_type_id = section_container.find('.todo-type').val();
		var todo_ids = [];
		$(section_container).find('.todo-container').each(function(){
			todo_ids.push($(this).data('id'));
		});
		console.log(todo_ids);
		$.ajax({url: '/to_dos',
				method: 'post',
				data: {content: new_todo_content,
					to_do_type_id: new_todo_type_id,
					completed: false,
					todo_ids: todo_ids,
					section_id: section_container.attr('data-section-id')}})
		.done(function(response){
			section_container.find('.add-todo-form-container').hide();
			section_container.find('.todo-sortable-container').append('<div id="todo' + response.id + '" class="todo-container" data-id="' + response.id + '"><div class="panel panel-default"><div class="panel-heading"><div class="row"><div class="col-sm-5">' + response.content + '</div><div class="col-sm-5 text-muted">' + response.to_do_type.name + '</div><div class="col-sm-2 text-right"><a class="delete-todo" title="Delete To do"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></a></div></div></div><div class="panel-body"><div class="row"><div class="col-sm-1"><strong>Default</strong></div><div class="col-sm-4"><strong>Answer</strong></div><div class="col-sm-5"><strong>If selected, this statement will be added</strong></div></div><div class="answer-sortable-container"></div><div class="row add-answer-link-container"> <div class="col-sm-12"> <a class="add-answer">Add answer</a></div></div><div class="row"><div class="add-answer-form-container col-sm-12"> <div class="row"> <div class="col-sm-1"> <div class="checkbox"> <label> <input type="checkbox" class="new-answer-selected"> </label> </div> </div> <div class="col-sm-4"> <div class="form-group"> <input type="text" class="form-control new-answer-text-editor" placeholder="Answer..."> </div> </div> <div class="col-sm-5"> <div class="form-group"> <select class="form-control new-answer-inspector-statement"> <option disabled="disabled">Statement to add to report</option> </select></div></div></div><div class="row"><div class="col-sm-12"><div class="form-group"><button class="btn btn-sm btn-primary create-answer">Add this answer</button><span class="between-button-text">or</span><button class="btn btn-link btn-sm cancel-answer-creation">Cancel</button></div></div></div></div></div></div></div></div>');
			section_container.find('.add-todo').show();
			var todo_container = section_container.find('#todo' + response.id);
			todo_container.find('.edit-todo').click(function(){
				editTodoClickHandler(this);
			});
			todo_container.find('.cancel-todo-update').click(function(){
				cancelEditTodoClickHandler(this);
			});
			todo_container.find('.delete-todo').click(function(){
				deleteTodoClickHandler(this);
			});
			todo_container.find('.save-todo').click(function(){
				saveTodoClickHandler(this);
			});
			todo_container.find('.add-answer').click(function(){
				addAnswerClickHandler(this);
			});
			todo_container.find('.cancel-answer-creation').click(function(){
				cancelAnswerCreationClickHandler(this);
			});
			todo_container.find('.create-answer').click(function(){
				createAnswerClickHandler(this);
			});
			todo_container.find('.answer-sortable-container').sortable({
				placeholder: 'statement-sortable-target',
				axis: 'y',
				revert: 100,
				tolerance: 'intersect',
				stop: handle_answer_display_order_adjustment
			});
			//todo_container.find('.answer-sortable-container').disableSelection();
			display_message('To do added.','success', 1500);
		})
		.fail(function(){
			display_message('To do addition failed. Please try again.','danger', 3500);
		});
	});

	$('.delete-todo').click(function(){
		deleteTodoClickHandler(this);
	});

	function deleteTodoClickHandler(that) {
		var todoContainer = $(that).parents('.todo-container');
		var todo_id = todoContainer.data('id');
		$.ajax({url: '/to_dos/' + todo_id,
				method: 'DELETE'})
		.done(function(response){
			todoContainer.remove();
			display_message('To do deleted.','success', 1500);
		})
		.fail(function(){
			display_message('To do deletion failed. Please try again.','danger', 3500);
		});
		
	};

	$('.add-answer').click(function(){
		addAnswerClickHandler(this);
	});

	function addAnswerClickHandler(that) {
		var todo_container = get_todo_container($(that));		
		var section_container = get_section_container($(that));
		var add_answer_form_container = todo_container.find('.add-answer-form-container');
		var is_select_list = add_answer_form_container.find('.new-answer-inspector-statement');
		refreshStatementList(is_select_list, section_container);
		todo_container.find('.add-answer').hide();
		add_answer_form_container.show()
				.find('.new-answer-text-editor').focus().select();
	};

	function refreshStatementList(is_select_list, section_container) {
		$(is_select_list).find('option').remove().end().append($('<option></option>').attr('value', '-').text('Do nothing when this answer is selected'));
		$.each(section_container.find('.inspector-statement-container'), function(index, statementContainer){
			is_select_list.append($('<option></option>').attr('value', $(statementContainer).data('id')).text($(statementContainer).find('.inspector-statement-content').html()));
	       	});
       	};

	$('.cancel-answer-creation').click(function(){
	       	cancelAnswerCreationClickHandler(this); 
	});

	function cancelAnswerCreationClickHandler(that){ 
		var todo_container = get_todo_container($(that));		
		todo_container.find('.add-answer-form-container').hide().find('.new-answer-text-editor').val('');
	       	todo_container.find('.add-answer').show();
       	};

	$('.create-answer').click(function(){ 
		createAnswerClickHandler(this); 
	}); 

	function createAnswerClickHandler(that){ 
		var todo_container = get_todo_container($(that));
	       	var new_answer_content = todo_container.find('.new-answer-text-editor').val();
	       	var selected = "false";
	       	if (todo_container.find('.new-answer-selected').is(":checked")) { 
			selected = "true"; 
		};
	       	var inspector_statement_id = todo_container.find('.new-answer-inspector-statement').val(); 
		var inspector_statement_text = todo_container.find('.new-answer-inspector-statement option:selected').text();
		var answer_ids = [];
		$(todo_container).find('.answer-container').each(function(){
			answer_ids.push($(this).data('id'));
		});
	       	$.ajax({url: '/answers',
		       	method: 'post',
		       	data: {content: new_answer_content, 
			       to_do_id: todo_container.attr('data-id'),
			       answer_ids: answer_ids,
			       selected: selected}})
		.done(function(response){
		       todo_container.find('.add-answer-form-container').hide();
		       todo_container.find('.answer-sortable-container').append('<div id="answer' + response.id + '" class="answer-container" data-id="' + response.id + '"><div class="row answer-display"><div class="col-sm-1"><input type="checkbox"' + (response.selected ? ' checked="checked" ' : '' ) + '></div><div class="col-sm-4 answer-content">' + response.content + '</div><div class="col-sm-5 answer-statement">' + inspector_statement_text + '</div><div class="col-sm-2 text-right"><a class="edit-answer" role="button" title="Edit answer">Edit</a><a class="delete-answer" role="button" title="Delete answer"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></a></div></div><div class="row edit-answer-form-container"><div class="col-sm-12"><div class="row"><div class="col-sm-1"><div class="checkbox"><label><input type="checkbox" class="new-answer-selected"></label></div></div><div class="col-sm-4"><div class="form-group"><input type="text" class="form-control answer-text-editor"></div></div><div class="col-sm-5"><div class="form-group"><select class="form-control edit-answer-inspector-statement"><option disabled="disabled">Statement to add to report</option></select></div></div></div><div class="row"><div class="col-sm-12"><div class="form-group"><button class="btn btn-sm btn-primary save-answer">Save</button><span class="between-button-text">or</span><button class="btn btn-link btn-sm cancel-answer-update">Cancel</button></div></div></div></div></div</div>'); 
		       // todo: fix this logic where the statment text appears before the rule for it is actually created.  If the rule creation fails, the UI will not reflect reality.
		       todo_container.find('.add-answer').show(); 
		       todo_container.find('.new-answer-text-editor').val(''); 
		       var answer_container = todo_container.find('#answer' + response.id);
		       answer_container.find('.edit-answer').click(function(){ 
			       editAnswerClickHandler(this); 
		       }); 
		       answer_container.find('.cancel-answer-update').click(function(){ 
			       cancelAnswerUpdateClickHandler(this); 
		       }); 
		       answer_container.find('.delete-answer').click(function(){ 
			       deleteAnswerClickHandler(this); 
		       }); 
		       answer_container.find('.save-answer').click(function(){ 
			       saveAnswerClickHandler(this); 
		       }); 
		       answer_container.find('.selected').click(function(){ 
			       updateDefaultAnswerClickHandler(this); 
		       }); 
		       display_message('Answer added.','success', 1500); //TODO: really think about this approach.  Wouldn't it be cleaner to create the rule when the answer is created?  I think so, but don't know enough rails to implement that approach quickly.
		       $.ajax({url: '/rules',
			       method: 'post',
			       data: {answer_id: response.id,
				      inspector_statement_id: inspector_statement_id }})
		       .done(function(response){ 
				display_message('Answer with rule added succesfully.','success', 1500); 
		       })
		       .fail(function(){
			     display_message('Rule addition failed. Please try again.','danger', 3500); 
		       }); 
		})
	       	.fail(function(){ 
			display_message('Answer addition failed. Please try again.','danger', 3500);
	       	}); 
	}; 

	$('.delete-answer').click(function(){ 
		deleteAnswerClickHandler(this); 
	}); 

	function deleteAnswerClickHandler(that) {
	       	var answerContainer = $(that).parents('.answer-container'); 
		var answer_id = answerContainer.data('id'); 
		$.ajax({url: '/answers/' + answer_id,
				method: 'DELETE'})
		.done(function(response){
			answerContainer.remove();
			display_message('Answer deleted.','success', 1500);
		})
		.fail(function(){
			display_message('Answer deletion failed. Please try again.','danger', 3500);
		});
		
	};

	$('.edit-answer').click(function(){
		editAnswerClickHandler(this);
	});

	function editAnswerClickHandler(that){
		var answer_container = get_answer_container($(that));
		var section_container = get_section_container(answer_container);
		var edit_answer_form_container = answer_container.find('.edit-answer-form-container');
		var is_select_list = edit_answer_form_container.find('.edit-answer-inspector-statement');
		refreshStatementList(is_select_list, section_container);
		answer_container.find('.answer-text-editor').val(answer_container.find('.answer-content').html().replace(/<br\s*[\/]?>/gi, "\n"));
		answer_container.find('.answer-display').hide();
		answer_container.find('.edit-answer-form-container').show();
		answer_container.find('.answer-text-editor').focus();
	};

	$('.cancel-answer-update').click(function(){
		cancelAnswerUpdateClickHandler(this);
	});

	function cancelAnswerUpdateClickHandler(that){
		var answer_container = get_answer_container($(that));		
		answer_container.find('.answer-display').show();
		answer_container.find('.edit-answer-form-container').hide();
	};

	$('.save-answer').click(function(){
		saveAnswerClickHandler(this);
	});

	function saveAnswerClickHandler(that){
		var answer_container = $(that).parents('.answer-container');
		var answer_content = answer_container.find('.answer-text-editor').val();
		var answer_id = answer_container.data('id');
	       	var inspector_statement_id = answer_container.find('.edit-answer-inspector-statement').val(); 
		var selected = "false";
		if (answer_container.find('.selected').is(":checked")) {
			selected = "true";
		}
		$.ajax({url: '/answers/' + answer_id,
				method: 'PATCH',
				data: {
					selected: selected,
					content: answer_content}})
		.done(function(response){
		        $.ajax({url: '/rules/' + response.rules[0].id, //TODO: modify for cases where there is no rule stored for an answer or if there are multiple rules for a single answer
				method: 'patch',
				data: {answer_id: response.id,
				       inspector_statement_id: inspector_statement_id
			}})
			.done(function(response){ 
				display_message('Rule updated.','success', 1500); 
			})
			.fail(function(){
				display_message('Rule update failed. Please try again.','danger', 3500); 
			}); 
			answer_container.find('.answer-content').html(answer_content);
			answer_container.find('.answer-statement').html(answer_container.find('.edit-answer-inspector-statement option:selected').text());
			answer_container.find('.edit-answer-form-container').hide();
			answer_container.find('.answer-display').show();
			display_message('Answer updated.','success', 1500);
		})
		.fail(function(){
			display_message('Answer update failed. Please try again.','danger', 3500);
		});
	};

	$('.selected').click(function(){
		updateDefaultAnswerClickHandler(this);
	});

	function updateDefaultAnswerClickHandler(that) {
		var answerContainer = $(that).parents('.answer-container');
		var answer_id = answerContainer.data('id');
		var selected = "false";
		if (answerContainer.find('.selected').is(":checked")) {
			selected = "true";
		}
		$.ajax({url: '/answers/' + answer_id,
				method: 'PATCH',
				data: {
					selected: selected}})
		.done(function(response){
			display_message('Default answer updated.','success', 1500);
		})
		.fail(function(){
			display_message('Default answer update failed. Please try again.','danger', 3500);
		});
	};

	$('.add-inspector-statement').click(function(){
		var section_container = get_section_container($(this));
		section_container.find('.add-inspector-statement').hide();
		section_container
			.find('.add-inspector-statement-form-container')
				.show()
				.find('.new-inspector-statement-text-editor')
					.focus().select();
	});

	$('.create-inspector-statement').click(function(){
		var section_container = get_section_container($(this));
		var new_statement_content = section_container.find('.new-inspector-statement-text-editor').val();
		var statement_type_id = section_container.find('.inspector-statement-type-selector').val();
		var keywords = section_container.find('.new-inspector-statement-keywords').val();
		var inspector_statement_ids = [];
		$(section_container).find('.inspector-statement-container').each(function(){
			inspector_statement_ids.push($(this).data('id'));
		});
		$.ajax({url: '/inspector_statements',
				method: 'post',
				data: {content: new_statement_content,
				       section_type_id: section_container.attr('data-section-type-id'),
				       keyword: keywords,
				       inspector_statement_ids: inspector_statement_ids,
				       statement_type_id: statement_type_id}})
		.done(function(response){
			section_container.find('.add-inspector-statement-form-container').hide();
			response.content = response.content.replace(/\n/g,"<br>")
			section_container.find('.add-inspector-statement-container').siblings('.inspector-statement-sortable').append('<div id="inspectorStatement' + response.id + '" class="inspector-statement-container" data-id="' + response.id +'" data-statement-type-id="' + response.statement_type_id + '"><div class="row inspector-statement-display"><div class="col-sm-8 inspector-statement-content">' + response.content + '</div><div class="col-sm-2 keyword-content">' + response.keyword + '</div><div class="col-sm-2 text-right"><a class="edit-inspector-statement" role="button" title="Edit statement">Edit</a><a class="delete-inspector-statement" role="button" title="Delete statement"><span class="glyphicon glyphicon-trash" aria-hidden="true"></span></a></div></div><div class="edit-inspector-statement-form-container row"><div class="col-sm-12"><div class="form-group"><label for="inspector-statement-text-editor">Statement content</label><textarea rows="10" cols="80" class="inspector-statement-text-editor form-control"></textarea></div><div class="form-group"><label for="keyword-text-editor">Keyword(s)</label><input class="keyword-text-editor form-control" type="text"></div><div class="form-group"><label for="statement-type">Statement type</label><select name="statement-type" class="edit-inspector-statement-type-selector form-control"><option value="1">General Statement</option><option value="2">General Recommendation</option><option value="3">Common Issue</option><option value="4">Deficiency</option></select></div><div class="form-group"><button class="btn btn-sm btn-primary save-inspector-statement">Save</button><span class="between-button-text">or</span><button class="btn btn-link btn-sm cancel-inspector-statement-update">Cancel</button></div></div></div></div>');
			section_container.find('.add-inspector-statement').show();
			section_container.find('.no-statements-message-container').hide();
			var inspector_statement_container = section_container.find('#inspectorStatement' + response.id);
			inspector_statement_container.find('.edit-inspector-statement').click(function(){
				editInspectorStatementClickHandler(this);
			});
			inspector_statement_container.find('.cancel-inspector-statement-update').click(function(){
				cancelInspectorStatementUpdateClickHandler(this);
			});
			inspector_statement_container.find('.delete-inspector-statement').click(function(){
				deleteInspectorStatementClickHandler(this);
			});
			inspector_statement_container.find('.save-inspector-statement').click(function(){
				saveInspectorStatementClickHandler(this);
			});
			section_container.find('[data-statement-type-id=' + statement_type_id +']').siblings('.sortable').sortable( 'refresh' );
			display_message('Statement added to library.','success', 1500);
		})
		.fail(function(){
			display_message('Statement addition failed. Please try again.','danger', 3500);
		});
	});

	$('.delete-inspector-statement').click(function(){
		deleteInspectorStatementClickHandler(this);
	});

	function deleteInspectorStatementClickHandler(that){
		var inspector_statement_container = get_inspector_statement_container($(that));
		var inspector_statement_id = inspector_statement_container.data('id')
		$.ajax({url: '/inspector_statements/' + inspector_statement_id,
				method: 'delete'})
		.done(function(){
			inspector_statement_container.remove();
			display_message('Statement removed from library.','success', 1500);
		})
		.fail(function(){
			display_message('Statement removal failed. Please reload the template and try again.','danger', 3500);
		});
	};

	$('.cancel-inspector-statement-creation').click(function(){
		var section_container = get_section_container($(this));		
		section_container.find('.add-inspector-statement-form-container').hide().find('.new-inspector-statement-text-editor').val('');
		section_container.find('.add-inspector-statement').show();
	});

	$('.edit-inspector-statement').click(function(){
		editInspectorStatementClickHandler(this);
	});

	function editInspectorStatementClickHandler(that){
		var inspector_statement_container = get_inspector_statement_container($(that));		
		inspector_statement_container.find('.inspector-statement-text-editor').val(inspector_statement_container.find('.inspector-statement-content').html().replace(/<br\s*[\/]?>/gi, "\n"));
		inspector_statement_container.find('.keyword-text-editor').val(inspector_statement_container.find('.keyword-content').html().replace(/<br\s*[\/]?>/gi, "\n"));
		inspector_statement_container.find('.edit-inspector-statement-type-selector').val(inspector_statement_container.data('statement-type-id'));
		inspector_statement_container.find('.inspector-statement-display').hide();
		inspector_statement_container.find('.edit-inspector-statement-form-container').show();
		inspector_statement_container.find('.inspector-statement-text-editor').focus();
	};

	$('.cancel-inspector-statement-update').click(function(){
		cancelInspectorStatementUpdateClickHandler(this);
	});

	function cancelInspectorStatementUpdateClickHandler(that){
		var inspector_statement_container = get_inspector_statement_container($(that));
		inspector_statement_container.find('.edit-inspector-statement-form-container').hide();
		inspector_statement_container.find('.inspector-statement-display').show();
	};

	$('.save-inspector-statement').click(function(){
		saveInspectorStatementClickHandler(this);
	});

	function saveInspectorStatementClickHandler(that){
		var inspector_statement_container = get_inspector_statement_container($(that));
		var inspector_statement_content = inspector_statement_container.find('.inspector-statement-text-editor').val();
		var inspector_statement_keyword = inspector_statement_container.find('.keyword-text-editor').val();
		var inspector_statement_id = inspector_statement_container.data('id');
		var inspector_statement_type_id = inspector_statement_container.find('.edit-inspector-statement-type-selector').val();
		$.ajax({url: '/inspector_statements/' + inspector_statement_id,
			method: 'patch',
			data: {
				content: inspector_statement_content,
				keyword: inspector_statement_keyword,
				statement_type_id: inspector_statement_type_id}})
		.done(function(response){
			inspector_statement_content = inspector_statement_content.replace(/\n/g,"<br>")
			inspector_statement_container.find('.inspector-statement-content').html(inspector_statement_content);
			inspector_statement_container.find('.keyword-content').html(inspector_statement_keyword);
			inspector_statement_container.find('.edit-inspector-statement-form-container').hide();
			inspector_statement_container.find('.inspector-statement-display').show();
			display_message('Statement updated.','success', 1500);
		})
		.fail(function(){
			display_message('Statement update failed.', 'danger', 3500);
		});
	};

	$('.inspected').change(function(){
		toggleInspected(this);
	});

	function toggleInspected(that){
		var inspected = $(that).is(':checked');
		var notInspected = !inspected;
		var section_container = get_section_container($(that));
		$.ajax({url: '/sections/' + section_container.data('section-id'),
			method: 'patch',
			data: {inspected: inspected,
			       not_inspected: notInspected}})
		.done(function(){
			if (inspected) {
				section_container.find('.not-inspected').prop('checked', false);
			} else {
				section_container.find('.not-inspected').prop('checked', true);
			}
			display_message('Section updated', 'success', 1500);
		})
		.fail(function(){
			display_message('Section update failed', 'danger', 3500);
		});
	};

	$('.not-inspected').change(function(){
		toggleNotInspected(this);
	});

	function toggleNotInspected(that){
		var notInspected = $(that).is(':checked');
		var inspected = !notInspected;
		var section_container = get_section_container($(that));
		$.ajax({url: '/sections/' + section_container.data('section-id'),
			method: 'patch',
			data: {not_inspected: notInspected,
			       inspected: inspected}})
		.done(function(){
			if (notInspected) {
				section_container.find('.inspected').prop('checked', false);
			} else {
				section_container.find('.inspected').prop('checked', true);
			}
			display_message('Section updated', 'success', 1500);
		})
		.fail(function(){
			display_message('Section update failed', 'danger', 3500);
		});
	};

	$('.not-present').change(function(){
		toggleNotPresent(this);
	});

	function toggleNotPresent(that){
		var selected = $(that).is(':checked');
		var section_container = get_section_container($(that));
		$.ajax({url: '/sections/' + section_container.data('section-id'),
			method: 'patch',
			data: {not_present: selected}})
		.done(function(){
			display_message('Section updated', 'success', 1500);
		})
		.fail(function(){
			display_message('Section update failed', 'danger', 3500);
		});
	};

	$('.deficient').change(function(){
		toggleDeficient(this);
	});

	function toggleDeficient(that){
		var selected = $(that).is(':checked');
		var section_container = get_section_container($(that));
		var inspected = section_container.find('.inspected');
		var inspected_selected = $(inspected).is(':checked');
		var not_inspected = section_container.find('.not-inspected');
		// if Deficient is checked, then force Inspected to be checked, too, and force Not Inspected to be unchecked
		if (selected) {
			if (!inspected_selected) {
				inspected.prop('checked',true);
				inspected_selected = true;
				not_inspected.prop('checked',false);
			} 
		}
		$.ajax({url: '/sections/' + section_container.data('section-id'),
			method: 'patch',
			data: {deficient: selected,
			       inspected: inspected_selected,
			       not_inspected: !inspected_selected}})
		.done(function(){
			display_message('Section updated', 'success', 1500);
		})
		.fail(function(){
			display_message('Section update failed', 'danger', 3500);
		});
	};

	function get_report_container(element){
		return $(element).parents('.report-container');
	};

	function get_client_name_container(element){
		return $(element).parents('.client-name-container');
	};

	$('.edit-client-name').click(function(){
		var clientNameContainer = get_client_name_container(this);
		clientNameContainer.find('.display-client-name-container').hide();
		clientNameContainer.find('.client-name-update-form').show().find('.client-name').focus();
	});

	$('.cancel-client-name-update').click(function(){
		var clientNameContainer = get_client_name_container(this);
		clientNameContainer.find('.client-name-update-form').hide();
		clientNameContainer.find('.display-client-name-container').show();
	});

	$('.save-client-name-update').click(function(){
		var clientNameContainer = get_client_name_container(this);
		var reportContainer = get_report_container(this);
		var clientName = clientNameContainer.find('.client-name').val();
		$.ajax({url: '/reports/' + reportContainer.data('id'),
			method: 'patch',
			data: {client_name: clientName}})
		.done(function(response){
			clientNameContainer.find('.client-name-display').html(response.client_name);
			clientNameContainer.find('.client-name-update-form').hide();
			clientNameContainer.find('.display-client-name-container').show();
			display_message('Client name updated', 'success', 1500);
		})
		.fail(function(){
			display_message('Client name update failed', 'danger', 3500);
		});
	});

	function get_inspection_scope_container(element) {
		return $(element).parents('.scope-container');
	};

	$('.edit-inspection-scope').click(function(){
		var scopeContainer = get_inspection_scope_container(this);
		scopeContainer.find('.display-scope-container').hide();
		scopeContainer.find('.inspection-scope-update-form').show().find('#inspection-scope').focus();
	});

	$('.cancel-inspection-scope-update').click(function(){
		var scopeContainer = get_inspection_scope_container(this);
		scopeContainer.find('.inspection-scope-update-form').hide();
		scopeContainer.find('.display-scope-container').show();
	});

	$('.save-inspection-scope').click(function(){
		var scopeContainer = get_inspection_scope_container(this);
		var reportContainer = get_report_container(this);
		var scope = scopeContainer.find('#inspection-scope').val();
		$.ajax({url: '/reports/' + reportContainer.data('id'),
			method: 'patch',
			data: {scope: scope}})
		.done(function(response){
			scopeContainer.find('.inspection-scope-display').html(response.scope);
			scopeContainer.find('.inspection-scope-update-form').hide();
			scopeContainer.find('.display-scope-container').show();
			display_message('Scope updated', 'success', 1500);
		})
		.fail(function(){
			display_message('Scope update failed', 'danger', 3500);
		});
	});

	function get_inspection_overview_container(element) {
		return $(element).parents('.overview-container');
	};

	$('.edit-inspection-overview').click(function(){
		var overviewContainer = get_inspection_overview_container(this);
		overviewContainer.find('.display-overview-container').hide();
		overviewContainer.find('.inspection-overview-update-form').show().find('#overview').focus();
	});

	$('.cancel-inspection-overview-update').click(function(){
		var overviewContainer = get_inspection_overview_container(this);
		overviewContainer.find('.inspection-overview-update-form').hide();
		overviewContainer.find('.display-overview-container').show();
	});

	$('.save-inspection-overview-update').click(function(){
		var overviewContainer = get_inspection_overview_container(this);
		var reportContainer = get_report_container(this);
		var overview = overviewContainer.find('#overview').val();
		$.ajax({url: '/reports/' + reportContainer.data('id'),
			method: 'patch',
			data: {overview: overview}})
		.done(function(response){
			overviewContainer.find('.inspection-overview-display').html(response.overview);
			overviewContainer.find('.inspection-overview-update-form').hide();
			overviewContainer.find('.display-overview-container').show();
			display_message('Overview updated', 'success', 1500);
		})
		.fail(function(){
			display_message('Overview update failed', 'danger', 3500);
		});
	});

	function get_inspection_overview_summary_container(element) {
		return $(element).parents('.overview-summary-container');
	};

	$('.edit-inspection-overview-summary').click(function(){
		var overviewSummaryContainer = get_inspection_overview_summary_container(this);
		overviewSummaryContainer.find('.display-overview-summary-container').hide();
		overviewSummaryContainer.find('.inspection-overview-summary-update-form').show().find('#overview-summary').focus();
	});

	$('.cancel-inspection-overview-summary-update').click(function(){
		var overviewSummaryContainer = get_inspection_overview_summary_container(this);
		overviewSummaryContainer.find('.inspection-overview-summary-update-form').hide();
		overviewSummaryContainer.find('.display-overview-summary-container').show();
	});

	$('.save-inspection-overview-summary-update').click(function(){
		var overviewSummaryContainer = get_inspection_overview_summary_container(this);
		var reportContainer = get_report_container(this);
		var overviewSummary = overviewSummaryContainer.find('#overview-summary').val();
		$.ajax({url: '/reports/' + reportContainer.data('id'),
			method: 'patch',
			data: {overview_summary: overviewSummary}})
		.done(function(response){
			overviewSummaryContainer.find('.inspection-overview-summary-display').html(response.overview_summary);
			overviewSummaryContainer.find('.inspection-overview-summary-update-form').hide();
			overviewSummaryContainer.find('.display-overview-summary-container').show();
			display_message('Overview summary updated', 'success', 1500);
		})
		.fail(function(){
			display_message('Overview summary update failed', 'danger', 3500);
		});
	});



	function get_inspection_date_container(element){
		return $(element).parents('.inspection-date-container');
	};

	$('.edit-inspection-date').click(function(){
		var inspectionDateContainer = get_inspection_date_container(this);
		inspectionDateContainer.find('.display-inspection-date-container').hide();
		inspectionDateContainer.find('.inspection-date-update-form').show().find('.inspection-date').focus();
	});

	$('.cancel-inspection-date-update').click(function(){
		var inspectionDateContainer = get_inspection_date_container(this);
		inspectionDateContainer.find('.inspection-date-update-form').hide();
		inspectionDateContainer.find('.display-inspection-date-container').show();
	});

	$('.save-inspection-date-update').click(function(){
		var inspectionDateContainer = get_inspection_date_container(this);
		var reportContainer = get_report_container(this);
		var inspectionDate= inspectionDateContainer.find('.inspection-date').val();
		$.ajax({url: '/reports/' + reportContainer.data('id'),
			method: 'patch',
			data: {inspection_datetime: inspectionDate}})
		.done(function(response){
			inspectionDateContainer.find('.inspection-date-display').html(response.inspection_datetime);
			inspectionDateContainer.find('.inspection-date-update-form').hide();
			inspectionDateContainer.find('.display-inspection-date-container').show();
			display_message('Inspection date updated', 'success', 1500);
		})
		.fail(function(){
			display_message('Inspection date update failed', 'danger', 3500);
		});
	});

	function get_address_container(element){
		return $(element).parents('.address-container');
	};

	$('.edit-address').click(function(){
		var clientNameContainer = get_address_container(this);
		clientNameContainer.find('.display-address-container').hide();
		clientNameContainer.find('.address-update-form').show().find('.address').focus();
	});

	$('.cancel-address-update').click(function(){
		var clientNameContainer = get_address_container(this);
		clientNameContainer.find('.address-update-form').hide();
		clientNameContainer.find('.display-address-container').show();
	});

	$('.save-address-update').click(function(){
		var clientNameContainer = get_address_container(this);
		var reportContainer = get_report_container(this);
		var address1 = clientNameContainer.find('.address-line-1').val();
		var address2 = clientNameContainer.find('.address-line-2').val();
		var address3 = clientNameContainer.find('.address-line-3').val();
		var address4 = clientNameContainer.find('.address-line-4').val();
		var city = clientNameContainer.find('.city').val();
		var state = clientNameContainer.find('.state').val();
		var zip = clientNameContainer.find('.zip').val();
		$.ajax({url: '/reports/' + reportContainer.data('id'),
			method: 'patch',
			data: {address_line_1: address1,
			       address_line_2: address2,
			       address_line_3: address3,
			       address_line_4: address4,
			       city: city,
			       state: state,
			       zip: zip }})
		.done(function(response){
			clientNameContainer.find('.address-display').html(response.address_line_1 + ' ' + response.address_line_2 + ' ' + response.address_line_3 + ' ' + response.address_line_4 + ' ' + response.city + ' ' + response.state + ', ' + response.zip);
			clientNameContainer.find('.address-update-form').hide();
			clientNameContainer.find('.display-address-container').show();
			display_message('Address updated', 'success', 1500);
		})
		.fail(function(){
			display_message('Address update failed', 'danger', 3500);
		});
	});

	$('#copy-template').click(function(){
		alert('ht');
	});

	$('.edit-template-name').click(function(){
		$('.template-name-display').hide();	
		$('.edit-template-name-container').show().find('#template-name-text-editor').focus();
	});

	$('.cancel-template-name-update').click(function(){
		$('.template-name-display').show();	
		$('.edit-template-name-container').hide();
	});

	$('.save-template-name-update').click(function(){
		var newTemplateName = $('#template-name-text-editor').val();
		console.log(newTemplateName);
		var templateID = $('#template-container').data('id');
		$.ajax({url: '/inspection_templates/' + templateID,
			method: 'patch',
			data: {name: newTemplateName }})
		.done(function(response){
			$('.template-name').html(newTemplateName);
			$('.template-name-display').show();	
			$('.edit-template-name-container').hide();
			display_message('Template name updated', 'success', 1500);
		})
		.fail(function(){
			display_message('Template name update failed', 'danger', 3500);
		});

	});

});
