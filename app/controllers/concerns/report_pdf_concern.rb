require "prawn"

module ReportPDFConcern
  extend ActiveSupport::Concern

  EMPTY_CHECKBOX   = "\u2610" # "☐"
  CHECKED_CHECKBOX = "\u2611" # "☑" 
  EXED_CHECKBOX    = "\u2612" # "☒"
  CHECKBOX_FONT    = Rails.root.join('app','assets','fonts','DejaVuSans.ttf')

  included do
    def create_rei_75(filename)
      # PDF constants
      statement_hyphen_spacing = 10
      statement_list_character = "–"
      space_between_paragraphs = 5
      image_width = 220
      image_height = 220
      space_after_top_level_section = 10
      space_after_subsection = 20
      no_new_section_beneath_this_cursor_location = 140

      # TODO: more elegant and flexible storage of roman numerals and alpha
      roman_numerals = ['I','II','III','IV','V','VI','VII','VIII','IX','X','XI','XII','XIII','XIV','XV','XVI','XVII','XVIII','XIX','XX']
      alpha = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','AA']

      @statementTypes = StatementType.all
      @rsStatementTypes = StatementType.where(name: ['Common Issue', 'Deficiency'])
      level_indents = [0, 70, 70]
      # Prawn default page size is LETTER (612, 792), default margin is .5 inch
      pdf = Prawn::Document.new
      pdf.font_families.update("Times-Roman" => {
        :normal => Rails.root.join('app','assets','fonts','Times New Roman.ttf'), #"/app/assets/fonts/Times New Roman.ttf",
        :italic => Rails.root.join('app','assets','fonts','Times New Roman Italic.ttf'), #"/app/assets/fonts/Times New Roman Italic.ttf",
        :bold => Rails.root.join('app','assets','fonts','Times New Roman Bold.ttf'), #"/app/assets/fonts/Times New Roman Bold.ttf",
        :bold_italic => Rails.root.join('app','assets','fonts','Times New Roman Bold Italic.ttf') #"/app/assets/fonts/Times New Roman Bold Italic.ttf"
      })
      pdf.font "Times-Roman"
      pdf.create_stamp("draw_report_identification_bit") do
        pdf.draw_text "Report Identification: #{@report.address_single_line}", :inline_format => true, :at => [0,711], :size => 10
      end
      pdf.create_stamp("new_section_page") do
        #pdf.stroke_axis
        pdf.stamp "draw_report_identification_bit"
        pdf.horizontal_line 89, 540, :at => 706
        pdf.draw_text "I=Inspected              NI=Not Inspected              NP=Not Present              D=Deficient",
                      :indent_paragraphs => 5,
                      :at => [0, 687],
                      :style => :bold,
                      :size => 10
        pdf.bounding_box([-6, 682], :width => 546) do
          pdf.move_down 4
          pdf.text "I    NI   NP   D", :inline_format => true, :indent_paragraphs => 6, :style => :bold, :size => 10
          pdf.stroke_bounds
        end
      end

      #pdf.stroke_axis
      #filename = Time.now.strftime('%m-%d-%y_%H%M%S')  + ".pdf"
      # TODO: move to a database lookup
      pdf.image "public/assets/tahi-logo.jpg", :at => [-3, 690], :width => 186, :height => 44
      pdf.move_down 96

      if @report.cover_image.exists?
        pdf.image @report.cover_image.path(:small), :at => [390, 618], :width => 150, :height => 150
      end

      pdf.draw_text "Property:", :at => [0, pdf.y]
      pdf.draw_text @report.address_first_line, :at => [110, pdf.y]
      pdf.move_down 14
      pdf.draw_text @report.address_second_line, :at => [110, pdf.y]
      pdf.move_down 14
      pdf.draw_text "Client:", :at => [0, pdf.y]
      pdf.draw_text @report.client_name, :at => [110, pdf.y]
      pdf.move_down 14
      #pdf.draw_text "Inspection Type:", :at => [0, pdf.y]
      #pdf.draw_text "", :at => [110, pdf.y]
      #pdf.move_down 14
      pdf.draw_text "Inspector:", :at => [0, pdf.y]
      pdf.draw_text @inspector.first_name + " " + @inspector.last_name + "  #" + @inspector.license_number, :at => [110, pdf.y]
      pdf.move_down 14
      pdf.draw_text "Date:", :at => [0, pdf.y]
      pdf.draw_text @report.inspection_datetime.strftime('%B %-d, %Y'), :at => [110, pdf.y]

      pdf.move_down 80

      pdf.text "To Whom It May Concern:"

      pdf.move_down 20

      pdf.text "On #{@report.inspection_datetime.strftime("%B %-d, %Y")}, a site visit to the above mentioned address was made in order to perform a property inspection. Information discovered during the inspection process has been provided in this report."  
      pdf.move_down space_between_paragraphs
      pdf.move_down space_between_paragraphs
      pdf.text "Multiple limitations were present and additional issues, minor and/or significant, may not be documented in this report or discovered during the property assessment. The inspection process is not designed to be intrusive, destructive, or all encompassing. Rather, the inspection and report represent this inspector’s professional opinion of the overall condition of the structure and associated systems. Concerns, recommendations, and opinions may vary from one professional to another. This 3rd party inspection and report has been provided to the client for the purposes of due diligence, research, and filing of available information. The inspection process and report do not, in any manner, represent a guarantee or warranty that all issues, minor and/or significant, will be discovered during the inspection process. Further information and helpful links in regards to inspection limitations and licensing standards can be found in the addendum section of this report."
      pdf.start_new_page

      #######################################
      # Property Inspection Report - Page 1 #
      #######################################
      #pdf.stroke_axis
      pdf.text_box "PROPERTY INSPECTION REPORT", :align => :center, :style => :bold, :at => [0, 720], :size => 18
      pdf.stroke_horizontal_line 0, 502, :at => 690
      pdf.draw_text "Prepared For:", :at => [10, 670], :style => :bold, :size => 12
      pdf.draw_text @report.client_name, :at => [115, 670], :size =>10
      pdf.stroke_horizontal_line 105, 445, :at => 665
      pdf.text_box "(Name of Client)", :at => [10, 663], :align => :center, :size => 8

      pdf.draw_text "Concerning:", :at => [10, 640], :style => :bold, :size => 12
      pdf.draw_text @report.address_single_line, :at => [115, 640], :size =>10
      pdf.stroke_horizontal_line 105, 445, :at => 635
      pdf.text_box "(Address or Other Identification of Inspected Property)", :at => [10, 633], :align => :center, :size => 8

      pdf.draw_text "By:", :at => [10, 610], :style => :bold, :size => 12
      pdf.draw_text @report.inspector.first_name.to_s + ' ' + @report.inspector.last_name.to_s + ',  Lic #' + @report.inspector.license_number.to_s, :at => [115, 610], :size => 10
      pdf.draw_text @report.inspection_datetime.strftime("%B %-d, %Y"), :at => [375, 610], :size => 10
      pdf.stroke_horizontal_line 105, 445, :at => 605
      pdf.text_box "(Name and License Number of Inspector)", :at => [140, 603], :align => :left, :size => 8
      pdf.text_box "(Date)", :at => [400, 603], :align => :left, :size => 8
      pdf.stroke_horizontal_line 105, 445, :at => 575

      if !@report.inspector.sponsor_name.blank?
        pdf.draw_text @report.inspector.sponsor_name + ',  Lic #' + @report.inspector.sponsor_license_number, :at => [115, 580], :size => 10
      end
      pdf.text_box "(Name, License Number of Sponsoring Inspector)", :at => [140, 573], :align => :left, :size => 8
      pdf.stroke_horizontal_line 0, 502, :at => 550

      pdf.text_box "PURPOSE, LIMITATIONS AND INSPECTOR / CLIENT RESPONSIBILITIES", :align => :center, :at => [0, 540], :style => :bold
      pdf.move_cursor_to 525
      pdf.font_size 10
      pdf.text "This property inspection report may include an inspection agreement (contract), addenda, and other information related to
      property conditions. If any item or comment is unclear, you should ask the inspector to clarify the findings. It is important that
      you carefully read ALL of this information", :align => :justify
      pdf.move_down space_between_paragraphs
      pdf.text "This inspection is subject to the rules (“Rules”) of the Texas Real Estate Commission (“TREC”), which can be found at
      www.trec.texas.gov."
      pdf.move_down space_between_paragraphs
      pdf.text "The TREC Standards of Practice (Sections 535.227-535.233 of the Rules) are the minimum standards for inspections by TREC-licensed inspectors. An inspection addresses only those components and conditions that are present, visible, and accessible at
      the time of the inspection. While there may be other parts, components or systems present, only those items specifically noted
      as being inspected were inspected. The inspector is NOT required to turn on decommissioned equipment, systems, utility
      services or apply an open flame or light a pilot to operate any appliance. The inspector is NOT required to climb over obstacles,
      move furnishings or stored items. The inspection report may address issues that are code-based or may refer to a particular
      code; however, this is NOT a code compliance inspection and does NOT verify compliance with manufacturer’s installation
      instructions. The inspection does NOT imply insurability or warrantability of the structure or its components. Although some
      safety issues may be addressed in this report, this inspection is NOT a safety/code inspection, and the inspector is NOT required
      to identify all potential hazards.", :align => :justify
      pdf.move_down space_between_paragraphs
      pdf.text "In this report, the inspector shall indicate, by checking the appropriate boxes on the form, whether each item was inspected, not
      inspected, not present or deficient and explain the findings in the corresponding section in the body of the report form. The
      inspector must check the Deficient (D) box if a condition exists that adversely and materially affects the performance of a
      system or component or constitutes a hazard to life, limb or property as specified by the TREC Standards of Practice. General
      deficiencies include inoperability, material distress, water penetration, damage, deterioration, missing components, and
      unsuitable installation. Comments may be provided by the inspector whether or not an item is deemed deficient. The inspector
      is not required to prioritize or emphasize the importance of one deficiency over another."
      pdf.move_down space_between_paragraphs
      pdf.text "Some items reported may be considered life-safety upgrades to the property. For more information, refer to Texas Real Estate
      Consumer Notice Concerning Recognized Hazards or Deficiencies below."
      pdf.move_down space_between_paragraphs
      pdf.text "THIS PROPERTY INSPECTION IS NOT A TECHNICALLY EXHAUSTIVE INSPECTION OF THE STRUCTURE,
      SYSTEMS OR COMPONENTS. The inspection may not reveal all deficiencies. A real estate inspection helps to reduce some
      of the risk involved in purchasing a home, but it cannot eliminate these risks, nor can the inspection anticipate future events or
      changes in performance due to changes in use or occupancy. It is recommended that you obtain as much information as is
      available about this property, including any seller’s disclosures, previous inspection reports, engineering reports,
      building/remodeling permits, and reports performed for or by relocation companies, municipal inspection departments, lenders,
      insurers, and appraisers. You should also attempt to determine whether repairs, renovation, remodeling, additions, or other
      such activities have taken place at this property. It is not the inspector’s responsibility to confirm that information obtained
      from these sources is complete or accurate or that this inspection is consistent with the opinions expressed in previous or future
      reports."
      pdf.move_down space_between_paragraphs
      pdf.text "ITEMS IDENTIFIED IN THE REPORT DO NOT OBLIGATE ANY PARTY TO MAKE REPAIRS OR TAKE OTHER
      ACTIONS, NOR IS THE PURCHASER REQUIRED TO REQUEST THAT THE SELLER TAKE ANY ACTION. When a
      deficiency is reported, it is the client’s responsibility to obtain further evaluations and/or cost estimates from qualified service
      professionals. Any such follow-up should take place prior to the expiration of any time limitations such as option periods."
      pdf.move_down space_between_paragraphs
      pdf.stroke_horizontal_line -3, 540, :at => 70
      pdf.stroke_horizontal_line -3, 540, :at => 67
      pdf.move_down space_between_paragraphs
      pdf.text "Promulgated by the Texas Real Estate Commission (TREC) P.O. Box 12188, Austin, TX 78711-2188 (512) 936-3000
      (http://www.trec.texas.gov)."
      pdf.start_new_page
      pdf.stamp "draw_report_identification_bit"
      pdf.horizontal_line 89, 540, :at => 706
      pdf.move_down space_between_paragraphs * 4
      pdf.text "Evaluations by qualified tradesmen may lead to the discovery of additional deficiencies which may involve additional repair costs. Failure to address deficiencies or comments noted in this report may lead to further damage of the structure or systems and add to the original repair costs. The inspector is not required to provide follow-up services to verify that proper repairs have been made."
      pdf.move_down space_between_paragraphs
      pdf.text "Property conditions change with time and use. For example, mechanical devices can fail at any time, plumbing gaskets and seals may crack if the appliance or plumbing fixture is not used often, roof leaks can occur at any time regardless of the apparent condition of the roof, and the performance of the structure and the systems may change due to changes in use or occupancy, effects of weather, etc. These changes or repairs made to the structure after the inspection may render information contained herein obsolete or invalid. This report is provided for the specific benefit of the client named above and is based on observations at the time of the inspection. If you did not hire the inspector yourself, reliance on this report may provide incomplete or outdated information. Repairs, professional opinions or additional inspection reports may affect the meaning of the information in this report. It is recommended that you hire a licensed inspector to perform an inspection to meet your specific needs and to provide you with current information concerning this property."
      pdf.move_down space_between_paragraphs
      pdf.text_box "TEXAS REAL ESTATE CONSUMER NOTICE CONCERNING HAZARDS OR DEFICIENCIES", :align => :center, :style => :bold, :at => [0, 555]
      pdf.move_down space_between_paragraphs * 4
      pdf.text "Each year, Texans sustain property damage and are injured by accidents in the home. While some accidents may not be avoidable, many other accidents, injuries, and deaths may be avoided through the identification and repair of certain hazardous conditions. Examples of such hazards include:"
      pdf.text "•       malfunctioning, improperly installed, or missing ground fault circuit protection (GFCI) devices for electrical receptacles", :indent_paragraphs => 28
      pdf.text "in garages, bathrooms, kitchens, and exterior areas;", :indent_paragraphs => 49
      pdf.text "•       malfunctioning arc fault protection (AFCI) devices;", :indent_paragraphs => 28
      pdf.text "•       ordinary glass in locations where modern construction techniques call for safety glass;", :indent_paragraphs => 28
      pdf.text "•       malfunctioning or lack of fire safety features such as smoke alarms, fire-rated doors in certain locations, and functional", :indent_paragraphs => 28
      pdf.text "emergency escape and rescue openings in bedrooms;", :indent_paragraphs => 49
      pdf.text "•       malfunctioning carbon monoxide alarms;", :indent_paragraphs => 28
      pdf.text "•       excessive spacing between balusters on stairways and porches;", :indent_paragraphs => 28
      pdf.text "•       improperly installed appliances;", :indent_paragraphs => 28
      pdf.text "•       improperly installed or defective safety devices;", :indent_paragraphs => 28
      pdf.text "•       lack of electrical bonding and grounding; and ADDITIONAL INFORMATION PROVIDED BY INSPECTOR", :indent_paragraphs => 28
      pdf.text "•       lack of bonding on gas piping, including corrugated stainless steel tubing (CSST)", :indent_paragraphs => 28
      pdf.move_down space_between_paragraphs
      pdf.text "To ensure that consumers are informed of hazards such as these, the Texas Real Estate Commission (TREC) has adopted Standards of Practice requiring licensed inspectors to report these conditions as “Deficient” when performing an inspection for a buyer or seller, if they can be reasonably determined."
      pdf.move_down space_between_paragraphs
      pdf.text "These conditions may not have violated building codes or common practices at the time of the construction of the home, or they may have been “grandfathered” because they were present prior to the adoption of codes prohibiting such conditions. While the TREC Standards of Practice do not require inspectors to perform a code compliance inspection, TREC considers the potential for injury or property loss from the hazards addressed in the Standards of Practice to be significant enough to warrant this notice."
      pdf.move_down space_between_paragraphs
      pdf.text "Contract forms developed by TREC for use by its real estate licensees also inform the buyer of the right to have the home inspected and can provide an option clause permitting the buyer to terminate the contract within a specified time. Neither the Standards of Practice nor the TREC contract forms require a seller to remedy conditions revealed by an inspection. The decision to correct a hazard or any deficiency identified in an inspection report is left to the parties to the contract for the sale or purchase of the home."
      pdf.move_down space_between_paragraphs
      pdf.text "INFORMATION INCLUDED UNDER \"ADDITIONAL INFORMATION PROVIDED BY INSPECTOR\", OR PROVIDED AS AN ATTACHMENT WITH THE STANDARD FORM, IS NOT REQUIRED BY THE COMMISSION AND MAY CONTAIN CONTRACTUAL TERMS BETWEEN THE INSPECTOR AND YOU, AS THE CLIENT. THE COMMISSION DOES NOT REGULATE CONTRACTUAL TERMS BETWEEN PARTIES. IF YOU DO NOT UNDERSTAND THE EFFECT OF ANY CONTRACTUAL TERM CONTAINED IN THIS SECTION OR ANY ATTACHMENTS, CONSULT AN ATTORNEY."

      pdf.start_new_page
      pdf.stamp "new_section_page"
      pdf.move_down 65

      top_level_section_counter = 0
      second_level_section_counter = 0
      third_level_section_counter = 0

      @report.sections.sorted.each do |section|
        # first, see if we're too close to the bottom of the page to start a new section.  If so, start a new page.
        if pdf.cursor < no_new_section_beneath_this_cursor_location
          pdf.start_new_page
          pdf.stamp "new_section_page"
          pdf.move_down 65
        end

        if section.level == 0
          top_level_section_counter += 1
          second_level_section_counter = 0
          pdf.text roman_numerals[top_level_section_counter - 1] + '. ' + section.section_type.name.upcase,
                   :align => :center,
                   :style => :bold,
                   :size => 12
          pdf.move_down 10
        elsif section.level == 1
          second_level_section_counter += 1
          third_level_section_counter = 0
          pdf.formatted_text [
            {text: section.inspected ? EXED_CHECKBOX : EMPTY_CHECKBOX, font: CHECKBOX_FONT},
            {text: "   "},
            {text: section.not_inspected ? EXED_CHECKBOX : EMPTY_CHECKBOX, font: CHECKBOX_FONT},
            {text: "   "},
            {text: section.not_present ? EXED_CHECKBOX : EMPTY_CHECKBOX, font: CHECKBOX_FONT},
            {text: "   "},
            {text: section.deficient ? EXED_CHECKBOX : EMPTY_CHECKBOX, font: CHECKBOX_FONT}
          ]
          pdf.text_box alpha[second_level_section_counter - 1] + '.  ' + section.section_type.name,
                       :at => [level_indents[section.level], pdf.cursor + 11],
                       :height => 10,
                       :style => :bold
          pdf.move_down 5
        elsif section.level > 1
          third_level_section_counter += 1
          pdf.text_box roman_numerals[third_level_section_counter - 1 ].downcase + '.  ' + section.section_type.name,
                       :align => :left,
                       :at => [level_indents[section.level], pdf.cursor],
                       :height => 10,
                       :style => :bold
          pdf.move_down 15
        end

        if section.level > 0 and section.subsections.count == 0
          @statementTypes.each do |statementType|
            display_statement_type_label = false
            section.statements.each do |statement|
              if statementType.id == statement.statement_type_id
                display_statement_type_label = true
                break
              end
            end
            if display_statement_type_label 
              text_will_not_fit_on_page = false
              pdf.bounding_box [level_indents[section.level], pdf.cursor], :width => 400 do
                pdf.move_down 4
                test_statement_type_label = Prawn::Text::Box.new(statementType.name, :document => pdf, :overflow => :expand)
                test_statement_type_label.render :dry_run => true
                if test_statement_type_label.height < (pdf.y - 100)
                  pdf.text statementType.name == 'Deficiency' ? 'IMMEDIATE ACTION REQUIRED' : statementType.name.pluralize.upcase,
                           :style => :bold,
                           :align => :left,
                           :leading => 2
                  pdf.move_down 2
                else
                  text_will_not_fit_on_page = true
                end
              end

              if text_will_not_fit_on_page
                pdf.start_new_page
                pdf.stamp "new_section_page"
                pdf.move_down 70
                pdf.bounding_box [level_indents[section.level], pdf.cursor], :width => 400 do
                  pdf.text statementType.name == 'Deficiency' ? 'IMMEDIATE ACTION REQUIRED' : statementType.name.pluralize.upcase,
                           :style => :bold,
                           :align => :left,
                           :leading => 2
                  pdf.move_down 2
                end
              end
            end

            statements_in_statement_type_counter = 0
            section.statements.each do |statement|
              if statementType.id == statement.statement_type_id
                statements_in_statement_type_counter += 1
                text_will_not_fit_on_page = false
                lineCounter = 0
                overflowText = ""
                # TODO: set the width to use a dynamically calculated variable here and elsewhere
                pdf.bounding_box [level_indents[section.level] + statement_hyphen_spacing, pdf.cursor], :width => 460 do
                  pdf.move_down 2
                  steve_tb = Prawn::Text::Box.new(statement.content, :document => pdf, :overflow => :expand)
                  steve_tb.render :dry_run => true
                  if steve_tb.height < (pdf.y - 100)
                    pdf.text_box statement_list_character, at: [-statement_hyphen_spacing, pdf.cursor]
                    pdf.text statement.content,
                             :align => :left,
                             :leading => 2
                    pdf.move_down 2
                  else
                    text_will_not_fit_on_page = true
                    pdf.text_box statement_list_character, at: [-statement_hyphen_spacing, pdf.cursor]
                    overflowText = pdf.text_box statement.content, :align => :left, :leading => 2, :overflow => :truncate
                  end
                end
                if text_will_not_fit_on_page then
                  pdf.start_new_page
                  pdf.stamp "new_section_page"
                  pdf.move_down 80
                  statementChunk = ""
                  for i in lineCounter..statement.content.lines.count - 1 do
                    statementChunk += statement.content.lines[i]
                  end
                  pdf.bounding_box [level_indents[section.level] + statement_hyphen_spacing, pdf.cursor], :width => 460 do
                    #pdf.text_box statement_list_character, at: [-statement_hyphen_spacing, pdf.cursor]
                    #pdf.text statementChunk,
                    pdf.text overflowText,
                             :align => :left,
                             :leading => 2
                    pdf.move_down 2
                  end
                end
              end
            end
          end
        end

        image_counter = 0
        image_row_y_position = 0
        image_x_position = 0
        space_between_image_rows = 30
        row_has_caption_flag = false
        
        section.images.each do |image|
          # todo: may need some kind of try / catch here for funky images
          image_counter += 1
          image_x_position = level_indents[section.level]
          if image_counter.odd?
            # only check to see if we need to start a new page on a new image row
            if pdf.cursor < image_height + 60
              pdf.start_new_page
              pdf.stamp "new_section_page"
              pdf.move_down 80
              new_page_flag = true
            else
              new_page_flag = false
            end
            image_row_y_position = pdf.cursor
            if image_counter > 1 and !new_page_flag
              image_row_y_position = image_row_y_position - space_between_image_rows # create a little space between the image rows
            end
            row_has_caption_flag = false #reset this flag on each odd image b/c each odd image is gonna be a new row
          else
            image_x_position = level_indents[section.level] + image_width + 10
          end
          pdf.bounding_box([image_x_position, image_row_y_position], :width => image_width, :height => image_height) do
            pdf.image  image.image.path(:small), :at => [0, image_height], :fit => [image_width, image_height]
            #pdf.move_down 5
            #pdf.text image.caption
            if image.caption? 
              pdf.draw_text image.caption, :at =>[0, -15]
              row_has_caption_flag = true
            end
          end
        end
        # end of image loop

        # logic to properly pad the last row of images
        if row_has_caption_flag 
          pdf.move_down 20
        end
        
        # logic to provide spacing at the end of a section
        if section.level > 0 and section.subsections.count == 0
          pdf.move_down space_after_subsection  # this gives a little cushion at the end of each section
        end
      end

      pdf.start_new_page
      pdf.text "ADDENDUM: REPORT OVERVIEW", :align => :center, :style => :bold, :size => 16
      pdf.move_down 20
      pdf.text "THE SCOPE OF THE ASSESSMENT", :style => :bold, :size => 12
      pdf.move_down 10
      pdf.text @report.scope
      pdf.move_down 30
      pdf.text "THE STRUCTURE IN PERSPECTIVE", :style => :bold, :size => 12
      pdf.move_down 10
      pdf.text @report.overview_summary
      pdf.move_down 10
      pdf.text @report.overview
      pdf.move_down 30

      pdf.start_new_page
      pdf.text "ADDENDUM: REPORT SYNOPSIS", :align => :center, :style => :bold, :size => 16
      pdf.move_down space_between_paragraphs * 2
      pdf.font_size 12
      pdf.text "The following is a synopsis of the recommended repairs noted in this report. Most of the recommended repairs are considered to be minor. However, there may be some potentially significant improvements that should be budgeted for over the short term. Other significant improvements, outside the scope of this inspection, may also be necessary. Please refer to the body of this report for further details on these and other recommendations:", :style => :italic   
      pdf.move_down space_between_paragraphs * 3

      @report.sections.sorted.each do |section|
        # first, see if we're too close to the bottom of the page to start a new section.  If so, start a new page.
        if pdf.cursor < 100
          pdf.start_new_page
          #pdf.move_down 80
        end

        if section.level == 0
          section_name_should_be_displayed = false
          section.subsections.each do |section|
            if section.statements.where(statement_type_id: [3,4]).count > 0
              section_name_should_be_displayed = true
              break
            end
          end
          if section_name_should_be_displayed 
            pdf.text section.section_type.name.upcase,
                     :style => :bold,
                     :size => 14
            pdf.move_down space_between_paragraphs
          end
        elsif section.level == 1
          if section.statements.where(statement_type_id: [3,4]).count > 0
            pdf.text section.section_type.name,
                         :height => 10,
                         :style => :bold
            pdf.move_down space_between_paragraphs
          end
        elsif section.level > 1
          if section.statements.where(statement_type_id: [3,4]).count > 0
            pdf.text section.section_type.name,
                         :height => 10,
                         :style => :bold
            pdf.move_down space_between_paragraphs
          end
        end

        if section.level > 0 and section.subsections.count == 0
          displayed_section_flag = false
          @rsStatementTypes.each do |statementType|
            section.statements.each do |statement|
              if statementType.id == statement.statement_type_id
                displayed_section_flag = true
                text_will_not_fit_on_page = false
                # TODO: set the width to use a dynamically calculated variable here and elsewhere
                pdf.bounding_box [0, pdf.cursor], :width => 550 do
                  pdf.move_down 2
                  steve_tb = Prawn::Text::Box.new(statement.content, :document => pdf, :overflow => :expand)
                  steve_tb.render :dry_run => true
                  if steve_tb.height < (pdf.y - 100)
                    #pdf.text steve_tb.to_s + ' ' + pdf.y.to_s + ' ' + statement.content,
                    pdf.text statement.content,
                             :align => :left
                    pdf.move_down 2
                  else
                    text_will_not_fit_on_page = true
                  end
                end
                if text_will_not_fit_on_page then
                  pdf.start_new_page
                  pdf.text section.section_type.name + " (continued)",
                         :height => 10,
                         :style => :bold
                  pdf.move_down space_between_paragraphs
                  pdf.bounding_box [0, pdf.cursor], :width => 550 do
                    pdf.text statement.content,
                             :align => :left
                    pdf.move_down 2
                  end
                end
              end
            end
          end
          if displayed_section_flag
            pdf.move_down 20 # this gives a little bit of cushion after each displayed section
          end
        end
      end

      pdf.number_pages "Page <page> of <total>", {:at => [230, -10], :page_filter => lambda{ |pg| pg != 1}, :start_count_at => 2, :size => 12}
      pdf.number_pages "REI 7-5 (5/4/2015)", {:at => [0, -20], :page_filter => lambda{ |pg| pg != 1}, :size => 9}
      pdf.render_file "#{Rails.root}/public/" + filename

    end

    def create_preliminary_assessment

    end
  end
end
