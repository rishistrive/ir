require "prawn"

class ReportsController < ApplicationController
  include ReportPDFConcern
  protect_from_forgery :except => [:create, :destroy, :update]
  before_action :find_inspector
  before_action :set_report, only: [:show_sections, :update, :show, :create_rei, :destroy, :create_preliminary_assessment, :delete_cover_photo]

  def index
    @reports = @inspector.reports.sorted
    respond_to do |format|
      format.json {
        render json: @reports.to_json()
=begin
        render json: @reports.to_json(:include => {
						:rhythm => {
							:include => {
								:rhythm_sections => { :only => :section_type_id }
							}
						}
					})
=end
      }
      format.html {
        render :show
      }
    end
  end

  def show_sections
		@sections = @report.sections.includes(:section_type).sorted
		render :json => @sections.to_json(:include => :section_type)
  end

  def destroy
    # TODO: make sure it's not possible to destroy another inspector's report
    @report.destroy
    head :ok
  end

  def delete_cover_photo
    @report.cover_image.destroy
    head :ok
  end

  def update
    if @report.update_attributes(report_params)
      #render json: @report.as_json(only: [:client_name, :formatted_inspection_date])
      render json: @report.to_json(:methods => [:cover_image_url, :cover_image_thumbnail_url])
    else
      render json: @report.errors
    end
  end

  def show
    #@report = @inspector.reports.includes(sections: [{statements: :statement_type, statements: :answer_values}, :section_type, :images]).find(params[:id])
    @report = @inspector.reports.includes(sections: [{statements: :statement_type}, :section_type, :images]).find(params[:id])
    @statement_types = StatementType.all
    @todo_types = ToDoType.all #TODO: probably won't need this if report and template don't share view code
    respond_to do |format|
      format.json {
        render json: @report
      }
      format.html {
      }
    end
  end

  def new
    @report = Report.new(inspector_id: @inspector.id)
  end

  def create
    @report = Report.new(report_params)
    @report.inspector_id = @inspector.id
    @report.inspection_datetime = Time.now
    @report.report_type_id = 1 #TODO
    #@report.report_type_id = InspectionTemplate.find(params[:report][:id]).report_type_id #TODO: this seems sloppy.  Maybe I need to rethink my models.  I mean, why do I need a report type model that is entirely separate from a inspection template model?
    #@report.rhythm_id = @report.inspection_template_id # TODO: hardcoding, this assumes there is only one rhythm per template, soln is to add a rhythm picker to the new report form
    if @report.save
      # TODO: find a better place to store this logic...model probs?
      # TODO: fix bug where parent section id's are set to template's sections, not new report's sections
      level_0_section_id = nil
      level_1_section_id = nil
      @report.inspection_template.sections.sorted.each do |section|
        if section.level == 0
          parent_section_id = nil
        end
        if section.level == 1
          parent_section_id = level_0_section_id
        end
        if section.level == 2
          parent_section_id = level_1_section_id
        end
        new_section = Section.new(report_id: @report.id, display_order: section.display_order, level: section.level, section_type_id: section.section_type_id, parent_section_id: parent_section_id, inspected: section.inspected, not_inspected: section.not_inspected, not_present: section.not_present, deficient: section.deficient)
        if new_section.save
          if section.level == 0
            level_0_section_id = new_section.id
          end
          if section.level == 1
            level_1_section_id = new_section.id
          end
          # create to-dos, answers and rules
          section.to_dos.each do |to_do|
            new_to_do = ToDo.new(content: to_do.content, display_order: to_do.display_order, section_id: new_section.id, to_do_type_id: to_do.to_do_type_id, completed: to_do.completed)
            if new_to_do.save
              # create answers
              to_do.answers.each do |answer|
                new_answer = Answer.new(to_do_id: new_to_do.id, content: answer.content, display_order: answer.display_order, selected: answer.selected)
                if new_answer.save
                  # create rules
                  answer.rules.each do |rule|
                    new_rule = Rule.new(answer_id: new_answer.id, inspector_statement_id: rule.inspector_statement_id)
                    new_rule.save
                  end
                end
              end
            end
          end
          # create cyas
          section.cyas.each do |cya|
            new_cya = Cya.new(content: cya.content, display_order: cya.display_order, section_id: new_section.id, completed: cya.completed)
            new_cya.save
          end
          # create statements
          section.statements.each do |statement|
            new_statement = Statement.new(content: statement.content, display_order: statement.display_order, section_id: new_section.id, statement_type_id: statement.statement_type_id)
            if new_statement.save
              # Iono...seems like something would go here
            end
          end
        end
      end
      @statement_types = StatementType.all
      @todo_types = ToDoType.all #TODO: remove this after the views/layouts/_display_section logic is straightened out for reports
      #render :show
      respond_to do |format|
        format.json {
          render json: @report.to_json
=begin
          render json: @report.to_json(:include => {
						:rhythm => {
							:include => {
								:rhythm_sections => { :only => :section_type_id }
							}
						}
					})
=end
        }
        format.html {
          redirect_to action: :show, id: @report.id
          #render :show
        }
      end
    else
      render :new
    end
  end

  def create_rei
    # PDF constants
    filename = Time.now.strftime('%m-%d-%y_%H%M%S')  + ".pdf"
    create_rei_75(filename)
    send_file "#{Rails.root}/public/" + filename, :type=>"application/pdf", :disposition => "inline" #this line loads the file in the browser(filename)

    # send_file filename, :type=>"application/pdf" #this line downloads the file
    # redirect_to "/" + filename # serves the file up in the browser
  end

  EMPTY_CHECKBOX   = "\u2610" # "☐"
  CHECKED_CHECKBOX = "\u2611" # "☑" 
  EXED_CHECKBOX    = "\u2612" # "☒"
  #CHECKBOX_FONT    = "#{Prawn::BASEDIR}/data/fonts/DejaVuSans.ttf"
  #CHECKBOX_FONT    = "#{Rails.root}/fonts/DejaVuSans.ttf"
  CHECKBOX_FONT    = Rails.root.join('app','assets','fonts','DejaVuSans.ttf')

  def create_preliminary_assessment
    # PDF constants
    statement_hyphen_spacing = 10
    statement_list_character = "–"
    space_between_paragraphs = 5
    space_between_statements = 10
    image_width = 260
    image_height = 260
    # TODO: more elegant and flexible storage of roman numerals and alpha
    roman_numerals = ['I','II','III','IV','V','VI','VII','VIII','IX','X','XI','XII','XIII','XIV','XV','XVI','XVII','XVIII','XIX','XX']
    alpha = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','AA']

    @statementTypes = StatementType.where(name: ['Common Issue', 'Deficiency'])
    level_indents = [0, 70, 70]
    # Prawn default page size is LETTER (612, 792), default margin is .5 inch
    pdf = Prawn::Document.new
    pdf.font_families.update("Times-Roman" => {
      :normal => Rails.root.join('app','assets','fonts','Times New Roman.ttf'),
      :italic => Rails.root.join('app','assets','fonts','Times New Roman Italic.ttf'),
      :bold => Rails.root.join('app','assets','fonts','Times New Roman Bold.ttf'),
      :bold_italic => Rails.root.join('app','assets','fonts','Times New Roman Bold Italic.ttf')
    })
    pdf.font "Times-Roman"
    pdf.create_stamp("draw_report_identification_bit") do
      pdf.draw_text "Report Identification: #{@report.address_single_line}", :inline_format => true, :at => [0,711], :size => 10
    end

    #pdf.stroke_axis
    filename = Time.now.strftime('%m-%d-%y_%H%M%S')  + ".pdf"
    # TODO: move image retrieval to a database lookup
    pdf.image "public/assets/tahi-logo.jpg", :at => [-3, 690], :width => 186, :height => 44
    pdf.move_down 150

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
    pdf.draw_text "Inspection Type:", :at => [0, pdf.y]
    pdf.draw_text "Property Assessment Report", :at => [110, pdf.y]
    pdf.move_down 14
    pdf.draw_text "Lead Inspector:", :at => [0, pdf.y]
    pdf.draw_text @inspector.first_name + " " + @inspector.last_name + "  #" + @inspector.license_number, :at => [110, pdf.y]
    pdf.move_down 14
    pdf.draw_text "Date:", :at => [0, pdf.y]
    pdf.draw_text @report.inspection_datetime.strftime('%B %-d, %Y'), :at => [110, pdf.y]
    
    pdf.move_down 80

    pdf.text "To Whom It May Concern:"

    pdf.move_down 20

    pdf.text "On #{@report.inspection_datetime.strftime("%B %-d, %Y")}, a site visit to the above-referenced property was made in order to assess and investigate the property and/or associated systems. A list of noted concerns, recommendations, and/or issues has been provided in the report below. This report is not a TREC associated document and should not be used or perceived as such. Based on the scope of work, a full TREC report and/or additional information may be delivered in addition to this document."
    pdf.move_down space_between_paragraphs
    pdf.move_down space_between_paragraphs
    pdf.text "Multiple limitations were present and additional issues, both minor and significant, may not be documented in delivered reports or discovered during the assessment of the property. The assessment process is not designed to be intrusive, destructive, or all encompassing. Rather, the assessment and report represent this inspector’s professional opinion of the overall condition of the structure and/or associated systems. This third party assessment and report has been provided to the client for the purposes of due diligence, filing of available information, and additional client protection. The assessment process and report do not, in any manner, represent a guarantee or warranty of the above-referenced property."
    pdf.move_down space_between_paragraphs
    pdf.move_down space_between_paragraphs
    pdf.text "Below is a limited list of information gathered at the time of assessment."
    pdf.move_down space_between_paragraphs
    pdf.move_down space_between_paragraphs
    pdf.text "This is not an official TREC report document and should not be used as such."
    pdf.start_new_page
    #######################################
    # Preliminary Assessment - Page 2 #
    #######################################
    pdf.text "ADDENDUM: REPORT SYNOPSIS", :align => :center, :style => :bold, :size => 16
    pdf.move_down space_between_paragraphs * 2
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
          else
            section.subsections.each do |subsection| #here we're grabbing the subsections of the subsection
              if subsection.statements.where(statement_type_id: [3,4]).count > 0
                section_name_should_be_displayed = true
                break
              end
            end
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
        @statementTypes.each do |statementType|
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
                  pdf.move_down space_between_statements
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
                  pdf.move_down space_between_statements
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

    image_counter = 0
    image_row_y_position = 0
    image_x_position = 0
    space_between_image_rows = 30
    row_has_caption_flag = false

    @report.sections.sorted.each do |section|

      images_in_section_counter = 0
      
      section.images.each do |image|
        # todo: may need some kind of try / catch here for funky images
        image_counter += 1
        images_in_section_counter += 1
        # start a new page for the very 1st image in the entire report
        if image_counter == 1 
          pdf.start_new_page
          pdf.text "Inspection Photos", :height => 10, :style => :bold
          pdf.move_down 10
        end

        if images_in_section_counter == 1
          # start a new page if the cursor is getting close to the bottom of the page
          if pdf.cursor < 200
            pdf.start_new_page
            pdf.move_down 20
          end
          pdf.text section.section_type.name, :style => :bold
          pdf.move_down space_between_paragraphs
        end

        image_x_position = 0
        if images_in_section_counter.odd?
          # only check to see if we need to start a new page on a new image row
          if pdf.cursor < image_height + 60
            pdf.start_new_page
            pdf.move_down 80
            new_page_flag = true
          else
            new_page_flag = false
          end
          image_row_y_position = pdf.cursor
          if images_in_section_counter > 1 and !new_page_flag
            image_row_y_position = image_row_y_position - space_between_image_rows # create a little space between the image rows
          end
          row_has_caption_flag = false #reset this flag on each odd image b/c each odd image is gonna be a new row
        else
          image_x_position = image_width + 10
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

      if images_in_section_counter > 0
        pdf.move_down 30
      end

      # after we've completed the loop through the images, check if the final row contains an image with a caption and move down slightly
      if row_has_caption_flag
        pdf.move_down 15
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
    pdf.text "NOTE: This is not a full TREC report and should not be used as such. A full TREC report will be delivered at a later date/time. Please use this report as a partial and cursory document."

    pdf.number_pages "Page <page> of <total>", {:at => [230, -10], :size => 12}
    pdf.render_file "#{Rails.root}/public/" + filename
    send_file "#{Rails.root}/public/" + filename, :type=>"application/pdf", :disposition => "inline"
  end
  
private

    def report_params
      params.permit(:id, :address_line_1, :address_line_2, :address_line_3, :address_line_4, :city, :state, :zip, :report_type_id, :client_name, :inspection_datetime, :cover_image, :inspection_template_id, :scope, :overview, :overview_summary)
    end
end
