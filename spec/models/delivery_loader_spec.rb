require 'rails_helper'

describe DeliveryLoader do

  # before :each do

  # end

  # it "should not throw error on save to empty data directory" do
  #   expect {
  #     DeliveryLoader.save(File.new("#{Rails.root}/foo.txt"))
  #   }.to_not raise_error
  # end

  # it "should find tempfiles" do
  #   tf = Tempfile.new('foo')
  #   expect(tf.exists?).to be_truthy
  # end


  # xit "should save a csv file to data directory" do
  #   expected_filename = DateTime.now.strftime('%Y%m%d.csv')
  #   DeliveryLoader.save(Tempfile.new('foo'))
  #   file_exists = File.exists?(Rails.root.join("data", expected_filename))
  #   file_count = Dir[Rails.root.join("data/*.csv")].length
  #   expect(file_exists).to be_truthy
  #   expect(file_count).to be_equal(1)
  # end

  # xit "should load array if there is an existing valid file" do
  #   DeliveryLoader.save(StringIO.new("simple,file,test,simple,file,test,simple,file,test,simple"))
  #   records = DeliveryLoader.load
  #   expect(records.length).to be_equal(1)
  # end

  # xit "should load empty array if there are no files" do
  #   #File.delete(Dir[Rails.root.join("data/*.csv")].join(','))
  #   records = DeliveryLoader.load
  #   expect(records.length).to be_equal(1)
  # end

  # xit "should not throw an error on save if there are no files existing" do

  # end
end