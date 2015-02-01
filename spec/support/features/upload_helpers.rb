module Features
  module UploadHelpers

    def valid_csv_file
      csv_path('valid_file.csv')
    end

    def invalid_csv_file
      csv_path('invalid_file.csv')
    end

    private
      def csv_path(filename)
        Rails.root.join("spec/support/files/", filename)
      end

  end
end