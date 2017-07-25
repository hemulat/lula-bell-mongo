class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def authorize_admin
    redirect_to root_path, alert: 'Admins only!' unless admin_signed_in?
  end

  def is_available?(item, qty_id, start_date, end_date)
    '''
    Given an item, qty_id, start date, and end date, this function returns
    whether the item is available on those days.
    '''
    buffer = (item.buffer_period.to_i)
    date_range = start_date..(add_buffer(end_date, buffer))
    transactions = item.transactions.where(qty_id: qty_id)
    reservations = item.reservations.where(qty_id: qty_id)

    transactions.each do |transaction|
      if (transaction.return_date == nil)
        start_d = transaction.start_date
        end_d = add_buffer(next_business(transaction.end_date), buffer)
        if (start_d..end_d).overlaps?(date_range)
          return false
        end
      end
    end

    reservations.each do |reservation|
      start_d = reservation.start_date
      end_d = add_buffer(next_business(reservation.end_date), buffer)
      if (start_d..end_d).overlaps?(date_range)
        return false
      end
    end
    return true

  end

  def pick_available(item,start_date,end_date)
    available_qty = item.qty_ids()
    available_qty.each do |q|
      if is_available?(item,q,start_date,end_date)
        return q
      end
    end
    return nil
  end

  def pick_available_checkout(item,start_date,end_date)
    available_qty = item._quantity.clone
    available_qty.each do |q|
      if is_available?(item,q,start_date,end_date)
        return q
      end
    end
    return nil
  end

  def pick_different_from(item,start_date,end_date,unwanted_id)
    available_qty = item.qty_ids()
    available_qty.each do |q|
      if is_available?(item,q.to_i,start_date,end_date) && q.to_i !=unwanted_id
        return q.to_i
      end
    end
    return nil
  end

  def next_business(date)
    while (date.wday==6 || date.wday % 7 == 0)
      date = date + 1.day
    end
    return date
  end

  def add_buffer(date,buffer)
    while buffer > 0
      date = date + 1.day
      if (date.wday==6 || date.wday % 7 == 0)
        buffer -=1
      end
    end
    return date
  end

end
