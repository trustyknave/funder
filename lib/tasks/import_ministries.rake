namespace :ministries do
  desc "Create ministries from a given spreadsheet file"
    task :import => :environment do
      require 'roo'

      puts "Starting task runner..."
      file = "./ministries.xlsx"
      import(file)
      puts "Import complete."

      def import(file)
        puts "Starting import..."
        spreadsheet = open_spreadsheet(file)
        header = spreadsheet.row(1)
        (2..spreadsheet.last_row).each do |i|

          # transform the spreadsheet row into a Ruby hash
          row = Hash[[header, spreadsheet.row(i)].transpose]

          # create the Ministries and insert them into the DB
          ministry = Ministry.new(name: row["Ministry"])
          ministry.save!
        end
      end

      def open_spreadsheet(file)
        case File.extname(File.basename(file))
        when ".xlsx" then Roo::Excelx.new(file)
        else raise "Unknown file type"
        end
      end
    end
end