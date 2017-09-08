require 'csv'
def read_csv(filename = 'books.csv')
    keys = ['title','author', 'ISBN', 'description', 'quantity','type']
    data = CSV.read(filename)
    string_data = data.map {|row| row.map {|cell| cell.to_s } }
    books = string_data.map {|row| Hash[*keys.zip(row).flatten] }
    books[1..-1].each do |b|
      b['rentable'] = true
      b['reservable'] = false
      b['_SKU'] = Book.next_sku
      book = Book.new(b)
      book.save
    end
end
