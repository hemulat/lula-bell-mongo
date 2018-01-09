require 'csv'
# You can name the file dumps different things, but make sure they start with
# 'dump/' and have some form of extention(thus '.something').
#  Otherwise gitignore will not recognize the patter and the dumps will show up
# in your git repository.
def dumpItems(file_name = 'dump/items.csv')
    field_list = []
    Item.fields.keys.each do |field_name|
        if field_name[0]!='_' && !(field_name.include? "image")
            field_list.push(field_name)
        end
    end
    field_list.push("_SKU")
    all_items = Item.all
    CSV.open(file_name, "wb") do |csv|
        csv << field_list # CSV Header
        all_items.each do |item|
            csv_arr = []
            field_list.each do |f_name|
                csv_arr.push(item[f_name])
            end
            csv << csv_arr
        end
    end
end


def dumpReserves(file_name = 'dump/reserves.csv')
    header_names = ["Student ID","Email","Pick-up date", "Due date","Item name", "Item SKU"]
    field_list = ["student_id","email","start_date","end_date"]
    all_reserves = Reserve.all
    CSV.open(file_name, "wb") do |csv|
        csv << header_names # CSV Header
        all_reserves.each do |reserve|
            csv_arr = []
            field_list.each do |f_name|
                csv_arr.push(reserve[f_name])
            end
            item = reserve.item
            csv_arr.push(item.name)
            csv_arr.push(item._SKU)
            csv << csv_arr
        end
    end
end


def dumpTransactions(file_name = 'dump/transactions.csv')
    header_names = ["Student ID","Email","Pick-up date", "Due date","Returned on","Item name", "Item SKU"]
    field_list = ["student_id","email","start_date","end_date"]
    all_trasactions = Transaction.all
    CSV.open(file_name, "wb") do |csv|
        csv << header_names # CSV Header
        all_trasactions.each do |transaction|
            csv_arr = []
            field_list.each do |f_name|
                csv_arr.push(transaction[f_name])
            end
            rt_date = (transaction.status) ? transaction.return_date : "Not returned Yet!"
            csv_arr.push(rt_date)
            item = transaction.item
            csv_arr.push(item.name)
            csv_arr.push(item._SKU)
            csv << csv_arr
        end
    end
end

def dumpAugmented(file_name = 'dump/augmented.csv')
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
    CSV.open(file_name, "wb") do |csv|
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


def dumpAll
    dumpItems()
    dumpTransactions()
    dumpReserves()
    dumpAugmented()
end
