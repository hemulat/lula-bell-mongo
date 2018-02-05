class AdminsController < ApplicationController

  before_action :authorize_admin

  def index
    @admins = Admin.all
  end

  def destroy
    @admin = Admin.find(params[:id])
    if @admin.destroy
      redirect_to admins_path, notice: 'Account successfully deleted!'
    else
      redirect_to admins_path, alert: 'The account could not be deleted.'
    end
  end

  def download
      send_data dumpAugmented, filename: 'augmented.csv'
  end
  private
  # don't really have another good place to put it at
  def dumpAugmented
      item_fields = []
      Item.fields.keys.each do |field_name|
          if field_name[0]!='_' && !(field_name.include? "image")
              item_fields.push(field_name)
          end
      end
      item_fields.push("_SKU")
      field_list = ["student_id","email","start_date","end_date"]
      header = ["Student ID","Email","Pick-up date", "Due date","Returned on"]
      all_items = Item.all
      CSV.generate(headers: true) do |csv|
          all_items.each do |item|
              # First Item detail
              csv << ["Item Details"]
              csv << item_fields
              csv_arr = []
              item_fields.each do |f_name|
                  csv_arr.push(item[f_name])
              end
              csv << csv_arr
              # Now add transactions
              item_transactions = item.transactions
              if (item_transactions.count > 0)
                  csv << ["Item transactions"]
                  csv << header
                  item_transactions.each do |transaction|
                      csv_arr = []
                      field_list.each do |f_name|
                          csv_arr.push(transaction[f_name])
                      end
                      rt_date = (transaction.status) ? transaction.return_date : "Not returned Yet!"
                      csv_arr.push(rt_date)
                      csv << csv_arr
                  end
              end

              # Now add reservations
              item_reservations = item.reservations
              if (item_reservations.count > 0 )
                  csv << ["Item reservations"]
                  csv << header[0,header.size-1]
                  item_reservations.each do |reserve|
                      csv_arr = []
                      field_list.each do |f_name|
                          csv_arr.push(reserve[f_name])
                      end
                      csv << csv_arr
                  end
              end
              csv << []
          end
      end
  end
end
