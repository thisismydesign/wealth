# frozen_string_literal: true

ActiveAdmin.register_page 'Import' do
  menu priority: 13

  content do
    panel 'Import activity from Kraken' do
      render 'admin/shared/csv_import_form', path: imports_activity_from_kraken_path
    end

    # panel 'Import activity from IBKR' do
    #   render 'admin/shared/csv_import_form', path: imports_activity_from_ibkr_path
    # end

    # panel 'Import activity from Wise' do
    #   render 'admin/shared/csv_import_form', path: imports_activity_from_wise_path
    # end
  end
end
