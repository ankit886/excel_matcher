require 'roo'


class ExcelImporter
  @header = [] # header of an excel sheet

  # parse the excel sheet into the JSON
  #
  # @param file excel sheet file
  # @params Hash of {file: excel__sheet.xlxs }
  # @return array of hash of SAVE_GSTR3B data
  def import(options)
    spreadsheet = Roo::Spreadsheet.open(options[:file], extension: :xlsx)
    @main_json = create_json_summary(spreadsheet.sheet(1))
    @gsp_json = create_json_summary(spreadsheet.sheet(0))
    return {"main_json": @main_json, "gsp_json": @gsp_json}
  end

  def create_json_summary(sheet)
    main_json = []
    (5..sheet.last_row).each do |row|
      gstin = cell_value(row, 'A', sheet)
      if sheet.row(row).any? && gstin != 0 
        temp = {
          "gstin": gstin,
          "invoice_number": cell_value(row, 'B', sheet),
          "invoice_date": cell_value(row, 'C', sheet),
          "invoice_amount": cell_value(row, 'D', sheet), 
          "place_of_supply": cell_value(row, 'E', sheet),
          "taxable_value": cell_value(row, 'I', sheet).to_i,
          "integrated_tax": cell_value(row, 'J', sheet).to_i,
          "central_tax_paid": cell_value(row, 'K', sheet).to_i,
          "state_tax_paid": cell_value(row, 'L', sheet).to_i,
          "matched": false
        }
        main_json.push(temp)
      end
    end
    main_json.group_by { |i| i[:gstin] }.map { |k, values| [k, values.sort_by { |i| i['invoice_number'] } ] }.to_h
  end



  def cell_value(row, column, sheet)
    sheet.cell(row, column).nil? ? 0 : sheet.cell(row, column)
  end

end
