$(document).ready(function(){
	
	//$('#statement-search').focus();
	
	$('.delete-report').click(function(){
		var deleteActionsContainer = $(this).parents('.delete-actions-container');
		deleteActionsContainer.find('.delete-intro-container').hide();
		deleteActionsContainer.find('.delete-confirmation-container').show();
	});

	$('.delete-report-confirmed').click(function(){
		var reportContainer = $(this).parents('.report-container');
		var reportId = reportContainer.data('id');
		reportContainer.hide();
		$.ajax({url: '/reports/' + reportId,
			method: 'delete'})
		.done(function(){
			display_message('Report deleted.','success', 3500);
			reportContainer.remove();
		})	
		.fail(function(){
			display_message('Report deletion failed.','danger', 3500);
			reportContainer.show();
		});
	});

	$('.cancel-report-deletion').click(function(){
		var deleteActionsContainer = $(this).parents('.delete-actions-container');
		deleteActionsContainer.find('.delete-confirmation-container').hide();
		deleteActionsContainer.find('.delete-intro-container').show();
	});

	$('.delete-template').click(function(){
		var deleteActionsContainer = $(this).parents('.delete-actions-container');
		deleteActionsContainer.find('.delete-intro-container').hide();
		deleteActionsContainer.find('.delete-confirmation-container').show();
	});

	$('.delete-template-confirmed').click(function(){
		var templateContainer = $(this).parents('.template-container');
		var templateId = templateContainer.data('id');
		templateContainer.hide();
		$.ajax({url: '/inspection_templates/' + templateId,
			method: 'delete'})
		.done(function(){
			display_message('Template deleted.','success', 3500);
			templateContainer.remove();
		})	
		.fail(function(){
			display_message('Template deletion failed.','danger', 3500);
			templateContainer.show();
		});
	});

	$('.cancel-template-deletion').click(function(){
		var deleteActionsContainer = $(this).parents('.delete-actions-container');
		deleteActionsContainer.find('.delete-confirmation-container').hide();
		deleteActionsContainer.find('.delete-intro-container').show();
	});
	function showStatementControls(){
		$(this).find('.statement-controls').show();
	};
	
	function hideStatementControls(){
		$(this).find('.statement-controls').hide();
	};
	// TODO: convert "inspector-statement-container" to "statement-container" and share styles w/ templates & reports
	$('.inspector-statement-container').on('mouseenter', showStatementControls);
	$('.inspector-statement-container').on('mouseleave', hideStatementControls);

	$('#statement-search').keyup(function(){
		var search_string = $(this).val();
		if (search_string.length > 2) {
			$.ajax({url: '/inspector_statements/',
					method: 'get',
					data: {search: search_string}})
			.done(function(response){
				var search_results_list = $('.search-results').html('');
				if (response.length > 0) {
					var answers;
					$.each(response, function(index, statement){
						/*if (statement.answer_values.length) {
							answers = '';
							$.each(statement.answer_values, function(index, answer){
								answers += '<li data-answer-value-id="' + answer.id + '">' + answer.value + '</li>';
							});
						} else {
							answers = 'N/A';
						}*/
						search_results_list.append('<div class="inspector-statement-container" data-statement-id="' + statement.id + '" data-statement-type-id="' + statement.statement_type_id + '" data-section-type-id="' + statement.section_type_id + '">'+
												      '<div class="row display-inspector-statement-container">'+
													  	 '<div class="section col-sm-3">'+
															'<span class="statement-controls"><a class="delete-inspector-statement"><span class="glyphicon glyphicon-trash"></span></a>&nbsp;<a class="edit-inspector-statement">Edit</a></span>'+
														    '<span class="section-type-name">' + statement.section_type.name + '</span>'+
															'<br>'+
															'<span class="statement-type-name">' + statement.statement_type.name + '</span>'+
														 '</div>'+
														 '<div class="keyword col-sm-2">' + statement.keyword + '</div>'+
														 '<div class="content col-sm-5">' + statement.content + '</div>'+
														 '<div class="answers col-sm-2"><!--<ul class="list-unstyled">' + answers + '</ul>--></div>'+
													  '</div>'+
												 	  '<div class="row edit-inspector-statement-container"></div>'+
													'</div>');
						answers = 'N/A';	
	
//	<span class="statement-text"><%= statement.content %></span>
//	<div class="edit-statement-form-container">
//		<textarea rows="4" cols="80" class="statement-text-editor"></textarea>
//		<div><button class="btn btn-sm btn-default save-statement">Save Changes</button> or <button class="btn btn-link btn-sm cancel-statement-update">Cancel</button></div>
//	</div>
					});
					$('.inspector-statement-container').on('mouseenter', showStatementControls);
					$('.inspector-statement-container').on('mouseleave', hideStatementControls);
					
					$('.delete-inspector-statement').click( function(){ 
						deleteInspectorStatementClickHandler(this)
					});
					
					$('.edit-inspector-statement').click(function(){
						editInspectorStatementClickHandler(this);
					});
					
				} else {
					search_results_list.html('<div class="no-results-found col-sm-12">Nothing found</div>');
				}
						
			})
			.fail(function(){
				display_message('Search failed','danger', 3500);
			});
		};
		
	});
	
	// TODO: dry this up
	// these commands are conflicting with similiar code in templates.js
	$('.delete-inspector-statement').click(function(){
//		deleteInspectorStatementClickHandler(this);
	});
	
	$('.edit-inspector-statement').click(function(){
		editInspectorStatementClickHandler(this);
	});
	
	$('.cancel-inspector-statement-update').click(function(){
		cancelInspectorStatementClickHandler(this);
	});
	
	$('.update-inspector-statement').click(function(){
		updateInspectorStatementClickHandler(this);
	});
	
	function deleteInspectorStatementClickHandler(that){
		
		var statement_container = get_statement_container($(that));
		$.ajax({url: '/inspector_statements/' + statement_container.attr('data-statement-id'),
				method: 'delete'})
		.done(function(){
			statement_container.remove();
			display_message('Statement removed from library.','success', 1500);
		})
		.fail(function(){
			display_message('Statement removal failed. Please try again.','danger', 3500);
		});		
	};
	
	function editInspectorStatementClickHandler(that){
		var statement_container = get_statement_container($(that));		
		var display_statement_container = statement_container.find('.display-inspector-statement-container');
		var edit_statement_form_container = statement_container.find('.edit-inspector-statement-container').show();
		var statement_type_id = statement_container.data('statement-type-id');
		var section_type_id = statement_container.data('section-type-id');
		
		statement_container.find('.statement-controls').hide();
		statement_container.off('mouseenter');
		
		// TODO: remove hardcoded statement type and section type pickers
		var statement_type_select = '<select id="statement-type" class="form-control"><option value="1">General Statement</option><option value="2">General Recommendation</option><option value="3">Common Issue</option><option value="4">Deficiency</option></select>';
		var section_type_select = '<select id="section-type" class="form-control"><option value="1">Structural Systems</option><option value="3" class="level-1" selected="selected">Foundations</option><option value="5" class="level-1">Grading and Drainage</option><option value="7" class="level-1"> Roof Covering Materials</option><option value="9" class="level-1"> Roof Structures and Attics</option><option value="11" class="level-1"> Walls (Interior and Exterior)</option><option value="13" class="level-2">Interior Walls</option><option value="15" class="level-2">Exterior Walls</option><option value="17"> Ceilings and Floors</option><option value="19">  Ceilings</option><option value="21">  Floors</option><option value="23"> Doors</option><option value="25"> Windows</option><option value="27"> Stairways</option><option value="29"> Fireplaces and Chimneys</option><option value="31"> Porches, Balconies, Decks, and Carports</option><option value="33"> Other</option><option value="35">Electrical Systems</option><option value="37"> Service Entrance and Panels</option><option value="39">  Main Disconnect Panel</option><option value="41">  Sub Panels</option><option value="43">  Distribution Wiring</option><option value="45"> Branch Circuits, Connected Devices, and Fixtures</option><option value="47">   Outlets and Switches</option><option value="49">   Fixtures</option><option value="51">  Smoke and Fire Alarms</option><option value="53">Heating, Ventilation and Air Conditioning Systems</option><option value="55"> Heating Equipment</option><option value="57"> Cooling Equipment</option><option value="59"> Duct Systems, Chases, and Vents</option><option value="61">Plumbing Systems</option><option value="63"> Plumbing Supply, Distribution Systems and Fixtures</option><option value="65"> Drains, Wastes, and Vents</option><option value="67"> Water Heating Equipment</option><option value="69"> Hydro-Massage Therapy Equipment</option><option value="71"> Other</option><option value="73">Appliances</option><option value="75"> Dishwashers</option><option value="77"> Food Waste Disposers</option><option value="79"> Range Hood and Exhaust Systems</option><option value="81"> Ranges, Cooktops, and Ovens</option><option value="83"> Microwave Ovens</option><option value="85"> Mechanical Exhaust Vents and Bathroom Heaters</option><option value="87"> Garage Door Operators</option><option value="89"> Dryer Exhaust Systems</option><option value="91"> Other</option><option value="93">Optional Systems</option><option value="95"> Landscape Irrigation (Sprinkler) Systems</option><option value="97"> Swimming Pools, Spas, Hot Tubes, and Equipment</option><option value="99"> Outbuildings</option><option value="101"> Private Water Wells</option><option value="103"> Private Sewage Disposal (Septic) Systems</option><option value="105"> Other</option></select>';
		var answer_list_type_select = '<select id="answer-list-type" class="form-control"><option>N/A</option><option>Yes / No</option><option selected="selected">Select one or more from a list</option><option>Select only one from a list</option></select>';
		
		/*edit_statement_form_container.append('<div class="col-sm-3">' + section_type_select + 
												'<br><br>' + statement_type_select + 
											 '</div>'+
											 '<div class="col-sm-2">'+
												'<textarea id="keyword"></textarea>'+
											 '</div>'+
											 '<div class="col-sm-7">'+
											 	'<textarea style="width:100%" rows="4" id="content"></textarea>'+
											 '</div>'+
											 '<div class="col-sm-12">'+
												'<button class="btn btn-primary update-statement">Save changes</button>&nbsp; or <a class="btn cancel-statement-update">Cancel</a>'+
											 '</div>');*/
		edit_statement_form_container.append('<div class="col-sm-12">'+
												'<div class="row">'+
													'<div class="col-sm-12">'+
														'<div class="form-group">'+
															'<label for="content">Statement</label>'+
															'<textarea rows="4" id="content" class="form-control"></textarea>'+
														'</div>'+
													'</div>'+
												'</div>'+
												'<div class="row">'+
													'<div class="col-sm-4">'+
														'<div class="form-group">'+
															'<label for="keyword">Keyword(s)</label>'+
															'<textarea id="keyword" class="form-control"></textarea>'+
														'</div>'+
													'</div>'+
													'<div class="col-sm-4">'+
														'<div class="form-group">'+
															'<label for="section-type">Section</label>' + section_type_select + 
														'</div>'+
													'</div>'+
													'<div class="col-sm-4">'+
														'<div class="form-group">'+
															'<label for="statement-type">Statement Type</label>'+ statement_type_select +
														'</div>'+
													'</div>'+
												'</div>'+
												'<!--<div class="row">'+
													'<div class="col-sm-4">'+ 
														'<div class="form-group">'+
															'<label for="answer-list-type">Answer List Type</label>'+
															answer_list_type_select +
														'</div>'+
													'</div>'+
													'<div class="col-sm-4">'+ 
														'<div class="form-group">'+
															'<label>Answers</label>'+
															'<ul id="answers" class="list-unstyled">'+
																'<li class="add-answer-container"><a class="btn add-answer">Add answer</a></li>'+
															'</ul>'+
														'</div>'+
													'</div>'+
												'</div>-->'+
												 '<div class="form-group">'+
													'<button class="btn btn-primary update-inspector-statement">Save changes</button><span class="between-button-text">or</span><button class="btn btn-link cancel-inspector-statement-update">Cancel</button>'+
												 '</div>'+
											 '</div>');
											 
		display_statement_container.find('.answers li').each( function( index ){
			edit_statement_form_container.find('#answers').children('.add-answer-container').before('<li data-answer-value-id="' + $(this).data('answer-value-id') + '"><div class="input-group"><input type="text" class="form-control" value="' + $(this).html() + '"><span class="input-group-btn"><button class="btn btn-default delete-answer" type="button"><span class="glyphicon glyphicon-trash"></span></button></span></div></li>');
		} );		
		
		//edit_statment_form_container.find
		
		edit_statement_form_container.find('#keyword').val(display_statement_container.find('.keyword').html());
		edit_statement_form_container.find('#content').val(display_statement_container.find('.content').html());		
		
		display_statement_container.hide();
		edit_statement_form_container.show();
		
		edit_statement_form_container.find('.cancel-inspector-statement-update').click(function(){
			cancelInspectorStatementClickHandler(this);
		});
		
		edit_statement_form_container.find('.update-inspector-statement').click(function(){
			updateInspectorStatementClickHandler(this);
		});		
		
		edit_statement_form_container.find('.add-answer').click(function(){
			addAnswerClickHandler(this);
		});
		
		edit_statement_form_container.find('.delete-answer').click(function(){
			deleteAnswerClickHandler(this);
		});
		
	};
	
	function cancelInspectorStatementClickHandler(that){
		var statement_container = get_statement_container($(that));
		statement_container.find('.edit-inspector-statement-container').html('').hide();
		statement_container.find('.display-inspector-statement-container').show();
		statement_container.on('mouseenter', showStatementControls);
	};
	
	function updateInspectorStatementClickHandler(that){
		var statement_container = get_statement_container($(that));
		var keywords = statement_container.find('#keyword').val();
		var updated_statement_content = statement_container.find('#content').val();
		var answer_list_type = statement_container.find('#answer-list-type').val();
		var answer_values = [];
		var answers = '';
		
		statement_container.find('#answers input').each( function(){
			answer_values.push({id: $(this).parents('li').data('answer-value-id'), value: $(this).val()}); 
		});
		
		$.ajax({url: '/inspector_statements/' + statement_container.attr('data-statement-id'),
				method: 'patch',
				data: {content: updated_statement_content,
					   keyword: keywords,
					   statement_type_id: statement_container.find('#statement-type').val(),
					   section_type_id: statement_container.find('#section-type').val(),
					   list_type: answer_list_type,
					   answer_values: answer_values}})
		.done(function(){
			
			statement_container.find('.statement-type-name').html(statement_container.find('#statement-type :selected').text());
			statement_container.find('.section-type-name').html(statement_container.find('#section-type :selected').text());
			statement_container.find('.keyword').html(keywords);
			statement_container.find('.content').html(updated_statement_content);
			statement_container.find('.edit-inspector-statement-container').html('').hide();
			statement_container.find('.display-inspector-statement-container').show();
			$.each(answer_values, function(index, answer){
				answers += '<li data-answer-value-id="' + answer.id + '">' + answer.value + '</li>';
			});
			statement_container.find('.answers ul').html(answers);
			statement_container.on('mouseenter', showStatementControls);
			display_message('Statement updated.','success', 1500);
		})
		.fail(function(){
			display_message('Statement update failed. Please try again.','danger', 3500);
		});
	};
	
	function addAnswerClickHandler(that){
		$(that).before('<li><input type="text" class="form-control"></li>').parent('li').find('input').last().focus();
		//$(that);
	};
	
	function deleteAnswerClickHandler(that){
		var answer_value_id = $(that).parents('li').data('answer-value-id');
		$.ajax({url: '/answer_values/' + answer_value_id,
				method: 'delete',
				})
		.done(function(){
			$(that).parents('li').remove();
			display_message('Answer removed.','success', 1500);
		})
		.fail(function(){
			display_message('Answer removal failed. Please try again.','danger', 3500);
		});
	}
	
	// TODO: dry this up
	function get_statement_container(element){
		return $(element).parents('.inspector-statement-container');
	}

	/*$('.delete-report').on('ajax:success',function(e, data, status, xhr){
		$(e.currentTarget).parents('tr').remove();
		display_message('Report deleted.','success', 1500);
	}).on('ajax:error',function(e, xhr, status, error){
		display_message('Report deletion failed.','danger', 3500);
	});	

	$('.delete-template').on('ajax:success',function(e, data, status, xhr){
		$(e.currentTarget).parents('tr').remove();
		display_message('Template deleted.','success', 1500);
	}).on('ajax:error',function(e, xhr, status, error){
		display_message('Template deletion failed.','danger', 3500);
	});	*/
});
