namespace :ir do
  desc "TODO"
  task savelib: :environment do
    @stdout = $stdout
    $stdout = File.new('console.out', 'w')
    $stdout.sync = true
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

    andyLibrary.each do |statement|
      puts "InspectorStatement.create(:inspector_id => '#{statement.inspector_id}', :section_type_id => '#{statement.section_type_id}', :content => '#{statement.content}', :keyword => '#{statement.keyword}', :statement_type_id => '#{statement.statement_type_id}')"
    end
    steveLibrary.each do |statement|
      puts "InspectorStatement.create(:inspector_id => '#{statement.inspector_id}', :section_type_id => '#{statement.section_type_id}', :content => '#{statement.content}', :keyword => '#{statement.keyword}', :statement_type_id => '#{statement.statement_type_id}')"
    end
    $stdout = @stdout
    $stdout.sync = true
  end

end
