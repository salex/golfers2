module PlayersHelper
  def get_trend(totals)
    trend = 0.0
    return trend if totals.blank?
    cnt =  totals.size
    if cnt > 2
      half = cnt / 2
      first_half = totals[0..half]
      last_half = totals[(half+1)..(cnt-1)]
      trend = (first_half.sum / first_half.size.to_f) - (last_half.sum / last_half.size.to_f)
    end
    trend.round(2)
  end

  def get_col_mapping(cnt,columns)
    return [] if columns.zero?
    return Array.new(columns) if cnt.zero?
    col_size = cnt/columns # mod size
    col_size += 1 if (cnt % columns) > 0
    # will inc size of all columns if mod > 0 
    all_cnts = (0..(cnt-1)).to_a 
    mapping = []
    columns.times do |c|
      mapping << all_cnts.shift(col_size)
      # shift will shift what left in last column
    end
    mapping
  end

  def number_to_col_array(numb,cols)
    numb_array = (1..numb).to_a
    arr = []
    1.upto((numb / cols) + 1){ arr << numb_array.shift(cols) unless numb_array.blank? } 
    arr
  end
  
  def col_map_array(ary,columns)
    col_size,mod_size = ary.size.divmod(columns)
    map = []
    columns.times do |c|
      rem = mod_size.zero? ? 0 : 1
      map << ary.shift(col_size + rem)
      mod_size -= 1 if !mod_size.zero?
    end
    map
  end

  def col_map_index(cnt,columns)
    ary = (0..(cnt-1)).to_a
    col_map_array(ary,columns)
  end

  def array_to_cols(arr,cols)
    map = []
    col_size,mod_size = (arr.size).divmod(cols)
    rem = mod_size.zero? ? 0 : 1
    cols.times do |c|
      map << arr.shift(col_size + rem)
    end
    map
  end

end
