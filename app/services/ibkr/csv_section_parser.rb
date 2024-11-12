# frozen_string_literal: true

module Ibkr
  class CsvSectionParser < ApplicationService
    attr_accessor :csv_file, :section

    def call
      headers = nil
      section_data = []

      CSV.foreach(csv_file.path, headers: false, liberal_parsing: true) do |row|
        headers = row[2..] if row[0] == section && row[1] == 'Header'
      end

      CSV.foreach(csv_file.path, headers: false, liberal_parsing: true) do |row|
        if row[0] == section && row[1] == 'Data'
          data = row[2..]
          section_data << headers.zip(data).to_h
        end
      end

      section_data
    end
  end
end
