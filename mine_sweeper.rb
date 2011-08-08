class MineSweeper
  ORIGIN_X = 12
  ORIGIN_Y = 55
  
  attr_reader :dim_x, :dim_y
  
  def initialize(window, width, height)
    @window = window
    @restart_x = width / 2
    @dim_x = (width - ORIGIN_X - 8) / 16
    @dim_y = (height - ORIGIN_Y - 8) / 16
    @x = -1
    @y = -1
    t1, t2, t3, t4 = Windows::get_window_rect(@window)
    t3, t4 = Windows::client_to_screen(window, 0, 0)
    @win_offset_x = t3 - t1
    @win_offset_y = t4 - t2
    @table = Array.new(self.dim_x * self.dim_y) { -1 }
  end
  
  def move_to(x, y)
    return if x > self.dim_x or y > self.dim_y or x < 0 or y < 0
    @x = x
    @y = y
    animate_move_to(pos_x, pos_y)
  end
  
  def click
    Windows::mouse_event(Windows::MOUSEEVENT_LEFTDOWN, 0, 0, 0, 0)
    Windows::mouse_event(Windows::MOUSEEVENT_LEFTUP, 0, 0, 0, 0)
    return if @x < 0 or @y < 0
    n = get_number
    @table[@x + @y * self.dim_x] = n
    update_table(@x + self.dim_x * @y) if n == 0
    n
  end
  
  def right_click
    Windows::mouse_event(Windows::MOUSEEVENT_RIGHTDOWN, 0, 0, 0, 0)
    Windows::mouse_event(Windows::MOUSEEVENT_RIGHTUP, 0, 0, 0, 0)
  end
  
  def restart
    @x = -1
    @y = -1
    animate_move_to(@restart_x, 28)
    click
    click
  end
  
  def mark_flags
    for i in 0...(self.dim_x * self.dim_y) do
      next if @table[i] < 0 or @table[i] == 10
      if count_unknown(i) == @table[i]
        cells(i) do |ix|
          next unless @table[ix] < 0
          move_to(ix % self.dim_x, ix / self.dim_x)
          right_click
          @table[ix] = 10
        end
      end
    end
  end
  
  def available
    arr = []
    for i in 0...(self.dim_x * self.dim_y) do
      next if @table[i] < 1 or @table == 10
      if count_flagged(i) == @table[i]
        print "#{i} #{@table[i]}: "
        cells(i) do |ix|
          if @table[ix] < 0
            arr << [ix % self.dim_x, ix / self.dim_x]
            print "#{arr.last.to_s} #{@table[ix]}"
          end
        end
        puts
      end
    end
    arr
  end
  
private
  def count_unknown(index)
    count = 0
    cells(index) do |i|
      count += 1 if @table[i] == -1 or @table[i] == 10
    end
    count
  end
  
  def count_flagged(index)
    count = 0
    cells(index) do |i|
      count += 1 if @table[i] == 10
    end
    count
  end
  
  def cells(index)
    max = self.dim_x * self.dim_y
    
    yield index - self.dim_x unless index - self.dim_x < 0
    yield index + self.dim_x if index + self.dim_x < max
    
    unless (index % self.dim_x) == 0
      yield index - 1 unless index - 1 < 0
      yield index - self.dim_x - 1 unless index - self.dim_x - 1 < 0
      yield index + self.dim_x - 1 if index + self.dim_x - 1 < max
    end
    
    unless ((index + 1) % self.dim_x) == 0
      yield index + 1 if index + 1 < max
      yield index + self.dim_x + 1 if index + self.dim_x + 1 < max
      yield index - self.dim_x + 1 unless index - self.dim_x + 1 < 0
    end
  end

  def update_table(index)
    cells(index) do |cell_index|
      next unless @table[cell_index] < 0
      n = get_number(cell_index % self.dim_x, cell_index / self.dim_x)
      @table[cell_index] = n
      update_table(cell_index) if n == 0
    end
  end

  def get_number(x = nil, y = nil)
    my_x = pos_x(x)
    my_y = pos_y(y)
    
    dc = Windows::get_window_dc(@window)    
    c = Windows::get_pixel(dc, @win_offset_x + my_x + 1, @win_offset_y + my_y)
    c2 = Windows::get_pixel(dc, @win_offset_x + my_x - 5, @win_offset_y + my_y - 5)
    Windows::release_dc(@window, dc)
    
    case c
    when 16711680 then 1      
    when 32768 then 2
    when 255 then 3
    when 8388608 then 4
    when 128 then 5
    when 8421376 then 6
    when 0 then c2 == 255 ? -1 : 7
    when 8421504 then 8
    else 0
    end
  end
  
  def animate_move_to(x, y)
    cur_x, cur_y = Windows::get_cursor_pos
    pos_x, pos_y = Windows::client_to_screen(@window, x, y)
    
    distance = Math.sqrt((pos_x - cur_x) ** 2 + (pos_y - cur_y) ** 2)
    num_steps = (distance / 5)
    
    step_x = (pos_x - cur_x) / num_steps
    step_y = (pos_y - cur_y) / num_steps
    
    num_steps.to_i.times do
      cur_x += step_x
      cur_y += step_y
      Windows::set_cursor_pos(cur_x, cur_y)
      sleep 0.01
    end

    Windows::set_cursor_pos(pos_x, pos_y)
  end
  
  def pos_x(x = nil)
    ORIGIN_X + 16 * (x || @x) + 8
  end
  
  def pos_y(y = nil)
    ORIGIN_Y + 16 * (y || @y) + 8
  end
end