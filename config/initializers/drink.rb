# encoding: utf-8

class Drink
  @@all = {
    1 => "Не пьет",
    2 => "Пьет немного",
    3 => "Пьет"
  }
  def self.collection
    @@all.map {|id, name| [name, id]}
  end

  def self.get (id)
    @@all[id]
  end

end

class Fixnum
  def to_drink
    Drink.get(self)
  end
end
