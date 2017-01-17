select * from sections where id = 3396;
select * from section_types where id = 13;
select * from inspection_templates where id = 15;

select sections.id, parent.id, parent_type.name
  from sections,
       sections parent,
       section_types parent_type
 where parent.inspection_template_id = 15
   and sections.parent_section_id = parent.id
   and parent.section_type_id = parent_type.id
   and sections.inspection_template_id <> 15;
   
select sections.id
  from sections,
       sections parent
 where parent.inspection_template_id = 15
   and sections.parent_section_id = parent.id
   and sections.inspection_template_id <> 15;

select *
  from sections,
       section_types
 where sections.parent_section_id = 3396
   and sections.section_type_id = section_types.id;
   
update sections
   set parent_section_id = null
 where id in ( select sections.id
		            			from sections,
								     sections parent
							   where parent.inspection_template_id = 15
								 and sections.parent_section_id = parent.id
								 and sections.inspection_template_id <> 15 );
								 
								 
select * from inspectors where id = 2;

update inspectors
   set first_name = 'Steve'
  where id = 2;			
  
  
