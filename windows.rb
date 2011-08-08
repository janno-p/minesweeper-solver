require 'win32/api'

module Windows
  FindWindow = Win32::API.new('FindWindowA', 'PP', 'L', 'user32')
  
  def self.find_window(class_name, window_name)
    FindWindow.call(class_name, window_name)
  end
  
  MOUSEEVENT_MOVE = 0x0001
  MOUSEEVENT_LEFTDOWN = 0x0002
  MOUSEEVENT_LEFTUP = 0x0004
  MOUSEEVENT_RIGHTDOWN = 0x0008
  MOUSEEVENT_RIGHTUP = 0x0010
  MOUSEEVENT_ABSOLUTE = 0x8000
  
  MouseEvent = Win32::API.new('mouse_event', 'LLLLP', 'V', 'user32')
  
  def self.mouse_event(flags, dx, dy, data, extra_info)
    MouseEvent.call(flags, dx, dy, data, extra_info)
  end
  
  GetClientRect = Win32::API.new('GetClientRect', 'PP', 'V', 'user32')
  
  def self.get_client_rect(window)
    rect = ' ' * 16
    GetClientRect.call(window, rect)
    rect.unpack('LLLL')
  end
  
  ClientToScreen = Win32::API.new('ClientToScreen', 'LP', 'I', 'user32')
  
  def self.client_to_screen(window, x, y)
    point = [x, y].pack('LL')
    ClientToScreen.call(window, point)
    point.unpack('LL')
  end
  
  SetCursorPos = Win32::API.new('SetCursorPos', 'II', 'I', 'user32')
  
  def self.set_cursor_pos(x, y)
    SetCursorPos.call(x, y)
  end
  
  GetCursorPos = Win32::API.new('GetCursorPos', 'P', 'I', 'user32')
  
  def self.get_cursor_pos
    point = ' ' * 8
    GetCursorPos.call(point)
    point.unpack('LL')
  end
  
  GetWindowDC = Win32::API.new('GetWindowDC', 'L', 'L', 'user32')
  
  def self.get_window_dc(window)
    GetWindowDC.call(window)
  end
  
  ReleaseDC = Win32::API.new('ReleaseDC', 'LL', 'I', 'user32')
  
  def self.release_dc(window, dc)
    ReleaseDC.call(window, dc)
  end
  
  GetPixel = Win32::API.new('GetPixel', 'LII', 'I', 'gdi32')
  
  def self.get_pixel(dc, x, y)
    GetPixel.call(dc, x, y)
  end
  
  GetWindowRect = Win32::API.new('GetWindowRect', 'LP', 'I', 'user32')
  
  def self.get_window_rect(window)
    rect = ' ' * 16
    GetWindowRect.call(window, rect)
    rect.unpack('LLLL')
  end
end