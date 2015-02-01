require 'csv'
require 'post_code_finder'

class DeliveryLoader

  CSV_COLUMNS = 11
  HEADER_START = 'code'

  # "loads" uploaded file and saves to disk
  def self.load(iofile)
    # delete all existing first
    empty_data_directory
    # save new file
    filename = DateTime.now.strftime('%Y%m%d_%H%M%S.csv')
    # need to use tmp directory for Heroku
    filepath = Rails.root.join("tmp", filename)
    save_to_file(iofile, filepath)
  end

  # saves csv contents to DB
  def self.save
    # get csv file contents
    drecords = load_csv_file
    # keep track of any problems (1 = ok, 0 = file problem, -1 = db problem)
    status = 1
    # if there are no records, quit
    return 0 if drecords.empty?

    # tidy up database
    Location.remove_old
    Delivery.remove_old
    # remove todays deliveries as well, if any - to avoid duplication
    Delivery.destroy_all(date: Date.today)

    # add each new delivery
    drecords.each do |record|
      # try to create customer first
      # NOTE: compares by customer code, may lead to duplicate if multiple
      #   codes exist for a single customer.
      customer = Customer.find_or_create_by(code: record.customer_code) do |c|
        c.name = record.customer
        c.address = record.address
        c.postcode = record.postcode
        # try to find geo coordinates by postcode
        coords = PostCodeFinder.get(record.postcode)
        # if no coords found, set to 0,0 - it will be flagged later
        if coords.nil?
          c.latitude = 0
          c.longitude = 0
          status = -1
        else
          c.latitude = coords[:lat]
          c.longitude = coords[:lon]
        end
      end
      # assign to user based on van id
      user = User.where(van: record.van).first
      if user.nil?
        # assign to first non admin, if van not found
        user = User.where(admin: false).first
      end
      # create new delivery, this should eliminate multiple deliveries to
      # the same customer too
      Delivery.find_or_create_by(user: user, customer: customer, date: Date.today)
    end
    # remove file, only used on non Heroku filesystems
    #empty_data_directory
    # return status
    status
  end

  private


    # save the uploaded file to disk
    def self.save_to_file(infile, outfile)
      begin
        f = File.open(outfile, 'w')
        f.write(infile.read)
        f.close
        infile.close
      rescue SystemCallError => e
        Rails.logger.error "Failed to save uploaded file."
        Rails.logger.error  e
        f.close
        infile.close
        return false
      end
      true
    end

    # read a delivery csv file
    def self.read_csv(csv_file)
      records = []
      begin
        # read a csv line by line
        CSV.foreach(csv_file,
            headers: true,
            header_converters: :symbol,
            converters: :all,
            field_size_limit: nil) do |row|
          # make address string, squeeze out consecutive ',' or ' '
          address = [ row[:line1], row[:line2], row[:line3], row[:town],
            row[:county] ].join(',').squeeze(', ')
          # add new object to output array
          records << DeliveryRecord.new(row[:name], row[:code], address,
            row[:postcode], row[:our_reference], row[:van_id])
        end
      rescue MalformedCSVError
        Rails.logger.error "A malformed CSV was encountered"
      end
      records
    end

    # load file from disk - a litle fragile if more than one csv exists
    def self.load_csv_file
      csv_files = Dir[Rails.root.join("tmp/*.csv")]
      if !csv_files.empty?
        # shouldn't be more than one, but just in case
        return read_csv(csv_files.sort.last)
      end
      return []
    end

    # empty the data directory of csv files
    # NOTE: not using this anymore, as Heroku only allows tmp directory
    def self.empty_data_directory
      csv_files = Dir[Rails.root.join("data/*.csv")]
      csv_files.each do |f|
        begin
          # try and delete file
          File.delete(f)
        rescue SystemCallError
          # on system error, log & move on to next file
          Rails.logger.error "Failed to delete data directory file (#{f})."
          next
        end
      end
    end

end

# object to hold delivery information
class DeliveryRecord
  attr_reader :customer, :customer_code, :address, :postcode, :references, :van

  def initialize(customer, code, address, postcode, references, van)
    @customer = customer
    @customer_code = code
    @address = address
    @postcode = postcode
    @references = references
    @van = van
  end

  def to_s
    "#{@customer}, #{@customer_code}, #{@references}, #{@van}"
  end

end
