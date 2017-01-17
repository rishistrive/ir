# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
=begin
andy = Inspector.where(first_name: :Andy, last_name: :Jordan).first
if !andy.blank?
  andyLibrary = InspectorStatement.where(inspector_id: andy.id)
  puts andyLibrary.count.to_s + " statements in Andy's library"
end

steve = Inspector.where(first_name: :Steve, last_name: :Lohmeyer).first

if !steve.blank?
  steveLibrary = InspectorStatement.where(inspector_id: steve.id)
  puts steveLibrary.count.to_s + " statements in Steve's library"
end
=end
client_list = [
  ["Fritz Fitzpatrick", "fritz@fritzy.com", "512-555-5555", "512-888-8888"]
]

inspector_list = [
  ["andy@tahi.com", "Andy", "Jordan", "Test1234", "The Austin Home Inspector", nil, "It was like that before I got here.", "9458", nil, nil],
  ["lohmeyer@gmail.com", "Steve", "Lohmeyer", "Test1234", "The Austin Home Inspector", nil, "It was like that before I got here.", "0000", "Andy Jordan", "9458"],
  ["chad@tahi.com", "Chad", "Higley", "Test1234", "The Austin Home Inspector", nil, "It was like that before I got here.", "21706", "Andy Jordan", "9458"],
  ["chessie@tahi.com", "Chessie", "Collins", "Test1234", "The Austin Home Inspector", nil, "It was like that before I got here.", "", "", ""]
]

report_type_list = [
   "REI 7-5"
   #"WDI"
]

section_types_list = [
  ["Structural Systems", nil, 0, nil],
  ["Foundations", "Structural Systems", 1, 2],
  ["Grading and Drainage", "Structural Systems", 1, 1],
  ["Roof Covering Materials", "Structural Systems", 1, 3],
  ["Roof Structures and Attics", "Structural Systems", 1, nil],
  ["Walls (Interior and Exterior)", "Structural Systems", 1, nil],
  ["Interior Walls", "Walls (Interior and Exterior)", 2, nil],
  ["Exterior Walls", "Walls (Interior and Exterior)", 2, nil],
  ["Ceilings and Floors", "Structural Systems", 1, nil],
  ["Ceilings", "Ceilings and Floors", 2, nil],
  ["Floors", "Ceilings and Floors", 2, nil],
  ["Doors", "Structural Systems", 1, nil],
  ["Windows", "Structural Systems", 1, nil],
  ["Stairways", "Structural Systems", 1, nil],
  ["Fireplaces and Chimneys", "Structural Systems", 1, 4],
  ["Porches, Balconies, Decks, and Carports", "Structural Systems", 1, nil],
  ["Other-ss", "Structural Systems", 1, nil],
  ["Electrical Systems", nil, 0, nil],
  ["Service Entrance and Panels", "Electrical Systems", 1, nil],
  ["Main Disconnect Panel", "Service Entrance and Panels", 2, nil],
  ["Sub Panels", "Service Entrance and Panels", 2, nil],
  ["Distribution Wiring", "Service Entrance and Panels", 2, nil],
  ["Branch Circuits, Connected Devices, and Fixtures", "Electrical Systems", 1, nil],
  ["Outlets and Switches", "Branch Circuits, Connected Devices, and Fixtures", 2, nil],
  ["Fixtures", "Branch Circuits, Connected Devices, and Fixtures", 2, nil],
  ["Smoke and Fire Alarms", "Branch Circuits, Connected Devices, and Fixtures", 2, nil],
  ["Heating, Ventilation and Air Conditioning Systems", nil, 0, nil],
  ["Heating Equipment", "Heating, Ventilation and Air Conditioning Systems", 1, nil],
  ["Cooling Equipment", "Heating, Ventilation and Air Conditioning Systems", 1, nil],
  ["Duct Systems, Chases, and Vents", "Heating, Ventilation and Air Conditioning Systems", 1, nil],
  ["Plumbing Systems", nil, 0, nil],
  ["Plumbing Supply, Distribution Systems and Fixtures", "Plumbing Systems", 1, nil],
  ["Drains, Wastes, and Vents", "Plumbing Systems", 1, nil],
  ["Water Heating Equipment", "Plumbing Systems", 1, nil],
  ["Hydro-Massage Therapy Equipment", "Plumbing Systems", 1, nil],
  ["Other-ps", "Plumbing Systems", 1, nil],
  ["Appliances", nil, 0, nil],
  ["Dishwashers", "Appliances", 1, nil],
  ["Food Waste Disposers", "Appliances", 1, nil],
  ["Range Hood and Exhaust Systems", "Appliances", 1, nil],
  ["Ranges, Cooktops, and Ovens", "Appliances", 1, nil],
  ["Microwave Ovens", "Appliances", 1, nil],
  ["Mechanical Exhaust Vents and Bathroom Heaters", "Appliances", 1, nil],
  ["Garage Door Operators", "Appliances", 1, nil],
  ["Dryer Exhaust Systems", "Appliances", 1, nil],
  ["Other-a", "Appliances", 1, nil],
  ["Optional Systems", nil, 0, nil],
  ["Landscape Irrigation (Sprinkler) Systems", "Optional Systems", 1, nil],
  ["Swimming Pools, Spas, Hot Tubs, and Equipment", "Optional Systems", 1, nil],
  ["Outbuildings", "Optional Systems", 1, nil],
  ["Private Water Wells", "Optional Systems", 1, nil],
  ["Private Sewage Disposal (Septic) Systems", "Optional Systems", 1, nil],
  ["Other-os", "Optional Systems", 1, nil]
]

statement_type_list = [
  "General Statement",
  "General Recommendation",
  "Common Issue",
  "Deficiency"
]

=begin
roof_covering_inspector_statement_list = [
  ["The shingle roof coverings are considered to be in generally fair condition for the material age and type.", "Shingle fair condition"],
  ["The roof coverings are considered to be in generally good condition.", "Coverings good"],
  ["The installation of the roofing materials has been performed in a professional manner and good quality materials have been used.","Roof installation professional"],
]
foundation_inspector_statement_list = [
  ["Slab foundations are foundational, fool!", "Slab foundation"],
  ["Pier and beam foundations are foundational, fool!", "Pier beam foundation"]
]
roof_covering_recommendations_list = [
  ["Caulking all exposed nail heads at flashings, shingles, and vent exits is recommended to prevent further rusting and possible moisture entry at these areas.", "Caulk roof nail heads"],
  ["Re-securing loose vent boot is recommended to prevent moisture entry.","Secure loose vent boot"]
]
=end

template_list = [
  "Single Family Home",
  "Empty Template"  
]

rhythm_list = [
  "Andy's A.D.D."
]
=begin
report_list = [
  ["1609 Springer Lane","Austin","TX","78758",Time.now],
  ["482 Shoal Creek Drive","Austin","TX","78701",Time.now],  
  ["731 Chukar Road","Round Rock","TX","78764",Time.now]  
]
=end
todo_type_list = [
	"One from a list",
	"One or more from a list",
	"Number"
]

#customer_list.each do |name, logo, tagline|
#  Customer.create(name: name, logo: nil, tagline: tagline)
#end

#tahi = Customer.where(name: 'The Austin Home Inspector').first

todo_type_list.each do |name|
  if ToDoType.where(name: name).first.blank? 
    ToDoType.create(name: name)
  end
end

inspector_list.each do |email, first_name, last_name, password, name, logo, tagline, license_number, sponsor_name, sponsor_license_number|
  if Inspector.where(first_name: first_name, last_name: last_name).blank?
    Inspector.create(email: email, first_name: first_name, last_name: last_name, password: password, company_name: name, logo: logo, tagline: tagline, license_number: license_number, sponsor_name: sponsor_name, sponsor_license_number: sponsor_license_number)
  end
end

#steve = Inspector.where(last_name: 'Lohmeyer').first
#andy = Inspector.where(last_name: 'Jordan').first
=begin
client_list.each do |name, email, primary_phone, secondary_phone|
  Client.create(inspector_id: andy.id, name: name, email: email, primary_phone: primary_phone, secondary_phone: secondary_phone)
end
=end
inspectors = Inspector.all

report_type_list.each do |name|
  if ReportType.where(name: name).blank?
    ReportType.create(name: name)
  end
end

reportTypes = ReportType.all

section_types_list.each do |name, parent, level|
  inspectors.each do |inspector|
    if SectionType.where(name: name, inspector_id: inspector.id).blank?
      SectionType.create(name: name, title: name, inspector_id: inspector.id, level: level)
    end
  end
end

statement_type_list.each do |name|
  if StatementType.where(name: name).blank?
    StatementType.create(name: name)
  end
end

=begin
generalStatementType = StatementType.where(name: 'General Statement').first 
recommendationStatementType = StatementType.where(name: 'General Recommendation').first 
roofCoveringsSection = SectionType.where(name: 'Roof Covering Materials').where(inspector_id: andy.id).first
foundationSection = SectionType.where(name: 'Foundations').where(inspector_id: andy.id).first
foundation_inspector_statement_list.each do |content, keyword|
  InspectorStatement.create(statement_type_id: generalStatementType.id, 
                            content: content,
                            keyword: keyword, 
                            inspector_id: andy.id,
                            section_type_id: foundationSection.id)
end
roof_covering_inspector_statement_list.each do |content, keyword|
  InspectorStatement.create(statement_type_id: generalStatementType.id, 
                            content: content,
                            keyword: keyword, 
                            inspector_id: andy.id,
                            section_type_id: roofCoveringsSection.id)
end
roof_covering_recommendations_list.each do |content, keyword|
  InspectorStatement.create(statement_type_id: recommendationStatementType.id, 
                            content: content,
                            keyword: keyword, 
                            inspector_id: andy.id,
                            section_type_id: roofCoveringsSection.id)
end
=end
template_list.each do |name|
  reportTypes.each do |reportType|
    inspectors.each do |inspector|
      if InspectionTemplate.where(inspector_id: inspector.id, report_type_id: reportType.id, name: name).blank?
        InspectionTemplate.create(inspector_id: inspector.id, report_type_id: reportType.id, name: name)
      end
    end
  end
end

templates = InspectionTemplate.all

rhythm_list.each do |name|
  templates.each do |template|
    if Rhythm.where(inspection_template_id: template.id, name: name).blank?
        Rhythm.create(inspection_template_id: template.id, name: name)
    end
  end
end

rhythms = Rhythm.all
sectionTypes = SectionType.all
incrementor = 0

rhythms.each do |rhythm|
  #inspectors.each do |inspector|
    sectionTypes.where(["inspector_id = ? and level > ?", rhythm.inspection_template.inspector.id, 0]).each do |sectionType|
      if RhythmSection.where(rhythm_id: rhythm.id, section_type_id: sectionType.id, completion_order: sectionType.id).blank?
        RhythmSection.create(rhythm_id: rhythm.id, section_type_id: sectionType.id, completion_order: sectionType.id)
      end
    end
	#end
end
=begin
report_list.each do |address_line_1, city, state, zip, date|
  Report.create(address_line_1: address_line_1, 
                city: city, 
                state: state, 
                zip: zip, 
                inspection_datetime: date, 
                inspector_id: andy.id, 
		rhythm_id: rhythms.first.id,
                report_type_id: reportTypes.where(name: "REI 7-5").first.id)
end
=end
#########################
# Populate answers      #
#########################

yes_no_answer_values_list = [
  "Yes",
  "No"
]

foundation_type_answer_list = [
  "Slab",
  "Pier and Beam"
]

generic_todo_answer_list = [
  "Generic answer 1",
  "Generic answer 2"
]

##############################
# Populate template sections #
##############################

rei7 = ReportType.where(name: 'REI 7-5').first
rei7InspectionTemplate = InspectionTemplate.where(name: 'Single Family Home').where(report_type_id: rei7.id).first

inspectors.each do |inspector|
  sectionsNamedOtherCounter = 0
  section_types_list.each_with_index do |section_type, index|
    puts "about to attempt to create: " + section_type[0] + " for inspector: " + inspector.email
    if section_type[0] == "Other" then
      case sectionsNamedOtherCounter
        when 0
          sectionType = SectionType.where(inspector_id: inspector.id).where(name: section_type[0]).first
          parentSectionType = SectionType.where(inspector_id: inspector.id).where(name: section_type[1]).first
          inspector.inspection_templates.each do |template|
            if !parentSectionType.nil?
              parentSection = Section.where(inspection_template_id: template.id).where(section_type_id: parentSectionType.id).first
              parentSectionId = parentSection.id
            else
              parentSectionId = nil
            end
            Section.create(inspection_template_id: template.id, section_type_id: sectionType.id, parent_section_id: parentSectionId, display_order: index, level: section_type[2])
          end
        when 1
          sectionType = SectionType.where(inspector_id: inspector.id).where(name: section_type[0]).second
          puts section_type[0]
          puts sectionType.name
          parentSectionType = SectionType.where(inspector_id: inspector.id).where(name: section_type[1]).second
          inspector.inspection_templates.each do |template|
            if !parentSectionType.nil?
              puts parentSectionType.name
              parentSection = Section.where(inspection_template_id: template.id).where(section_type_id: parentSectionType.id).first
              parentSectionId = parentSection.id
            else
              parentSectionId = nil
            end
            Section.create(inspection_template_id: template.id, section_type_id: sectionType.id, parent_section_id: parentSectionId, display_order: index, level: section_type[2])
          end
        when 2
          sectionType = SectionType.where(inspector_id: inspector.id).where(name: section_type[0]).third
          parentSectionType = SectionType.where(inspector_id: inspector.id).where(name: section_type[1]).third
          inspector.inspection_templates.each do |template|
            if !parentSectionType.nil?
              parentSection = Section.where(inspection_template_id: template.id).where(section_type_id: parentSectionType.id).first
              parentSectionId = parentSection.id
            else
              parentSectionId = nil
            end
            Section.create(inspection_template_id: template.id, section_type_id: sectionType.id, parent_section_id: parentSectionId, display_order: index, level: section_type[2])
          end
        when 3
          sectionType = SectionType.where(inspector_id: inspector.id).where(name: section_type[0]).fourth
          parentSectionType = SectionType.where(inspector_id: inspector.id).where(name: section_type[1]).fourth
          inspector.inspection_templates.each do |template|
            if !parentSectionType.nil?
              parentSection = Section.where(inspection_template_id: template.id).where(section_type_id: parentSectionType.id).first
              parentSectionId = parentSection.id
            else
              parentSectionId = nil
            end
            Section.create(inspection_template_id: template.id, section_type_id: sectionType.id, parent_section_id: parentSectionId, display_order: index, level: section_type[2])
          end
        else
          print "too many others error"
      end
      sectionsNamedOtherCounter = sectionsNamedOtherCounter + 1
    else
      sectionType = SectionType.where(inspector_id: inspector.id).where(name: section_type[0]).first
      parentSectionType = SectionType.where(inspector_id: inspector.id).where(name: section_type[1]).first
      inspector.inspection_templates.each do |template|
        if !parentSectionType.nil? 
          #puts parentSectionType.id
          parentSection = Section.where(inspection_template_id: template.id).where(section_type_id: parentSectionType.id).first
          parentSectionId = parentSection.id
        else
          parentSectionId = nil
        end
        Section.create(inspection_template_id: template.id, section_type_id: sectionType.id, parent_section_id: parentSectionId, display_order: index, level: section_type[2])
      end
    end
  end
end

@misnamedOtherSectionTypes = SectionType.where("name like ?", "Other%").find_each do |sectionType|
#puts @misnamedOtherSectionTypes.count.to_s + " is the number of misnamed other section types"
#puts @misnamedOtherSectionTypes
#@misnamedOtherSectionTypes.each do |sectionType| 
  sectionType.name = "Other"
  sectionType.title = "Other"
  sectionType.save
end


#################################
# Populate inspector statements #
#################################
=begin
if !andyLibrary.blank?
  andyLibrary.find_each do |statement|
    InspectorStatement.create(inspector_id: andy.id, keyword: statement.keyword, section_type_id: statement.section_type_id, content: statement.content, statement_type_id: statement.statement_type_id)
  end
end
if !steveLibrary.blank?
  steveLibrary.find_each do |statement|
    InspectorStatement.create(inspector_id: steve.id, keyword: statement.keyword, section_type_id: statement.section_type_id, content: statement.content, statement_type_id: statement.statement_type_id)
  end
end
=end
#################################
# Populate inspector statements #
#################################
=begin
SectionType.all.each do |sectionType|
  generic_todo_answer_list.each do |answer|
    InspectorStatement.create(inspector_id: sectionType.inspector.id, keyword: sectionType.name, section_type_id: sectionType.id, content: sectionType.name + ' - ' + answer, statement_type_id: 1)
    if sectionType.name == 'Foundations'
      foundationIStatement = InspectorStatement.create(inspector_id: sectionType.inspector.id, keyword: 'foundation', section_type_id: sectionType.id, content: 'Foundation Type:', statement_type_id: 1)
    end
  end
end
=end

########################################
# Populate template section statements #
########################################
=begin
InspectionTemplate.where.not(name: 'Empty Template').each do |template|
  template.sections.each do |section|
    if section.section_type.name == 'Roof Covering Materials'
      cya = Cya.create(content: "Is ladder put away?", section_id: section.id, completed: false, display_order: 1)
      cya = Cya.create(content: "And you made sure not to leave your tools on the roof?", section_id: section.id, completed: false, display_order: 1)
    end
    if section.section_type.name == 'Foundations'
      # create a one or more to-do
      foundationToDo = ToDo.create(content: "Foundation Type", section_id: section.id, to_do_type_id: ToDoType.find(2).id, completed: false, display_order: 1)
      # create a one from a list to-do
      yetAnotherFoundationToDo = ToDo.create(content: "Year foundation built:", section_id: section.id, to_do_type_id: ToDoType.find(3).id, completed: false, display_order: 2)
      foundation_type_answer_list.each_with_index do |value, index|
        #AnswerValue.create(inspector_statement_id: foundationIStatement.id, display_order: index, value: value)
        #AnswerValue.create(statement_id: foundationStatement.id, display_order: index, value: value)
        answer = Answer.create(to_do_id: foundationToDo.id, content: value, display_order: index, selected: false)
        if answer.content == "Slab"
          slabRule = InspectorStatement.where(content: 'Slab foundations are foundational, fool!').take
          Rule.create(answer_id: answer.id, inspector_statement_id: slabRule.id)
        else
          pierAndBeamRule = InspectorStatement.where(content: 'Pier and beam foundations are foundational, fool!').take
          Rule.create(answer_id: answer.id, inspector_statement_id: pierAndBeamRule.id)
        end
      end
      cya = Cya.create(content: "All gates closed?", section_id: section.id, completed: false, display_order: 1)
    end 
    if section.level > 0
      Statement.create(section_id: section.id, content: section.section_type.name + ' - general statement', display_order: 2, statement_type_id: 1)
      Statement.create(section_id: section.id, content: section.section_type.name + ' - general recommendation', display_order: 3, statement_type_id: 2)
      Statement.create(section_id: section.id, content: section.section_type.name + ' - common issue', display_order: 4, statement_type_id: 3)
      Statement.create(section_id: section.id, content: section.section_type.name + ' - deficiency', display_order: 4, statement_type_id: 4)
      cya = Cya.create(content: section.section_type.name + ' - reminder', section_id: section.id, completed: false, display_order: 1)
      cya = Cya.create(content: section.section_type.name + ' - completed reminder', section_id: section.id, completed: true, display_order: 1)
      genericSectionToDo = ToDo.create(content: section.section_type.name + ' - generic to do (pick one)', section_id: section.id, to_do_type_id: ToDoType.find(1).id, completed: false, display_order: 1)
      generic_todo_answer_list.each_with_index do |value, index|
        answer = Answer.create(to_do_id: genericSectionToDo.id, content: section.section_type.name + ' - ' + value, display_order: index, selected: false)
        #genericIS = InspectorStatement.create(inspector_id: andy.id, keyword: section.section_type.name, section_type_id: section.section_type_id, content: section.section_type.name + ' - ' + value, statement_type_id: 1)
        genericIS = InspectorStatement.where(content: section.section_type.name + ' - ' + value).take
        Rule.create(answer_id: answer.id, inspector_statement_id: genericIS.id)
      end
    end
  end
end
=end
