class HomepageController < ApplicationController 
    layout 'application'
  # GET /
  def index
    
  end

  def import_excel
    begin
      excel_importer = ExcelImporter.new
      excel_options = { file: params[:file] }
      @main_json = excel_importer.import(excel_options)
      @report = compare_json(@main_json)
    rescue Exception => exception
      @error = { msg: "Please contact admin " + exception}
    end
  end

  def compare_json(combine_summary_json)
    begin
      main_json = combine_summary_json[:main_json]
      gsp_json = combine_summary_json[:gsp_json]
      gsp_json.each_with_index do |obj, index|
        # compare entry
        main_entries = main_json[obj[0]]
        gsp_entries = obj[1]
        gsp_entries.each_with_index do |entry, i|
          if !main_entries.nil? && entry == main_entries[i]
            entry[:matched] = true
          end
        end
      end
      gsp_json
    rescue Exception => e
      @error = { msg: "Please contact admin " + exception.to_s}
    end
  end

  def compare
  end

end
