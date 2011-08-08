$: << '.'

require 'mine_sweeper'
require 'windows'

window = Windows::find_window(nil, 'Minesweeper')
raise 'Could not find Minesweeper window' if window == 0

left, top, right, bottom = Windows::get_client_rect(window)

#loop do
  ms = MineSweeper.new(window, right - left, bottom - top)

  ms.restart

  begin
    x = rand(ms.dim_x)
    y = rand(ms.dim_y)
    ms.move_to(x, y)
    p = ms.click
    exit if p < 0
  end until p == 0
  
  loop do
    ms.mark_flags
    
    arr = ms.available
    exit if arr.size == 0
#  gets
    arr.each do |i|
#    puts i.to_s
      ms.move_to(i.first, i.last)
      p = ms.click
      exit if p < 0
    end
  end
  
#end

#3.times do
#  ms.restart
#  ms.move_to(3, 3)
#  puts ms.click
#  ms.move_to(22, 10)
#  puts ms.click
#  ms.move_to(14, 4)
#  puts ms.click
#end