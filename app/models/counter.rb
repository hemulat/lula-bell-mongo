class Counter
  include Mongoid::Document
  field :name, type: String
  field :seq, type: Integer


  def self.next(seq_name)
     next_seq = Counter.where(name: seq_name).find_one_and_update({"$inc" => {seq: 1}})
     return next_seq.seq
  end

end
