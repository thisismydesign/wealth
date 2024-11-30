# frozen_string_literal: true

module Ibkr
  class CsvSectionParser < ApplicationService
    attr_accessor :csv_file, :section

    def call
      headers = find_section_headers
      collect_section_data(headers)
    end

    private

    def find_section_headers
      CSV.foreach(csv_file.path, headers: false, liberal_parsing: true) do |row|
        return row[2..] if section_header_row?(row)
      end
    end

    def collect_section_data(headers)
      section_data = []

      CSV.foreach(csv_file.path, headers: false, liberal_parsing: true) do |row|
        next unless section_data_row?(row)

        section_data << create_data_hash(headers, row[2..])
      end

      section_data
    end

    def section_header_row?(row)
      row[0] == section && row[1] == 'Header'
    end

    def section_data_row?(row)
      row[0] == section && row[1] == 'Data'
    end

    def create_data_hash(headers, data)
      headers.zip(data).to_h
    end
  end
end
