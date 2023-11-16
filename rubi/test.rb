require "google_drive"

class T  

  attr_accessor :tabela
  def initialize key
    session = GoogleDrive::Session.from_config("config.json")
    @tabela = session.spreadsheet_by_key(key).worksheets[0]
  end


  def row broj_reda
  @tabela.rows[broj_reda]
  end

  def col broj_kolone
    @tabela.rows.transpose[broj_kolone]
  end

  def each
    (1..@tabela.num_rows).each do |row|
      (1..@tabela.num_cols).each do |column|
        celija = @tabela[row,column] 
        yield celija unless celija.to_s.empty?
      end
    end
  end

  def each_with_index
    (1..@tabela.num_rows).each do |row|
      (1..@tabela.num_cols).each do |column|
        cell = @tabela[row,column] 
        yield cell,row,column unless cell.to_s.empty?
      end
    end
  end

  def method_missing text,*args
    name = text.to_s
    return self[name]
  end


  def [] nesto
    name = nesto.to_s
    (1..@tabela.num_cols).each do |col|
      array = @tabela.rows.transpose[col-1]
      cell = @tabela[1,col].to_s
      return array.drop 1 if cell.gsub(" ","") == name.gsub(" ","")
    end
  end

  def + tabela2
    return nil if self.row(0) != tabela2.row(0)
    novatabela = @tabela
      (1..tabela2.tabela.num_rows-1).each do |element|
           novi_red = tabela2.row(element)
           p novi_red.class
           novatabela.insert_rows(novatabela.num_rows+1,[novi_red])
      end
novatabela
  end

end


class Array

  def sum
    suma = 0
    self.drop(1).each do |element|
      suma+=element.to_i unless element.to_s.empty?
    end
    suma
  end

  def avg
    total = 0
    count = 0
    self.drop(1).each do |element|
         if !element.empty?
          total+=element.to_i
          count+=1
         end
   end
  total.to_f/count unless count == 0
  end
  
  def method_missing text,*args
     name = text.to_s
     self.each_with_index do |element,index|
      return index+1 if name == element
     end
  end

end
key1 = "16_HG-7YUTSq7igeSiWoIfG-5PirgyUR4yy2IxYOAJ94"
key2 = "1MStdg4YskIANYpCweAOIBnutCxfpPs2x_Au2OazZvpc"
t = T.new key1
t2 = T.new key2
