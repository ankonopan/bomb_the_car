require 'gosu'
require 'pry'
include Gosu

class GameWindow < Gosu::Window
  def initialize
    super(640, 480, false)
    self.caption = "Jump 'n Run"
    @bullet, @walk1, @walk2, @jump = Gosu::Image.load_tiles(self, "images/bullet.png", 20, 20, false)
    @standing, @walk1, @walk2, @jump = Gosu::Image.load_tiles(self, "images/car.png", 38, 15, false)
    @explosion, @walk1, @walk2, @jump = Gosu::Image.load_tiles(self, "images/explosion.png", 50, 50, false)
    @points_text = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @lives_text = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @game_over = Gosu::Font.new(self, Gosu::default_font_name, 40)
    @restart = Gosu::Font.new(self, Gosu::default_font_name, 11)
    @x, @y = 300, 400
    @bx, @by = rand(640), 400
    @points=0
    @lives=3
    @etime = 0
    @loose = false
  end

  def update
  end

  def draw
    case @pressed
      # now also runs on linux
      when 123, 105 then @x = @x-3
      when 124, 106 then @x = @x+3
      when 125, 108 then @y = @y+3
      when 126, 103 then @y = @y-3
      when 45, 49 then
        @x,@y=300,400
        @bx,@by= rand(640), 0
        @loose = false
        @lives = 3
    end
    unless @loose
      @by = @by+4
      if @by > 480
        @by=0
        @bx=rand(640)
        @points = @points +1
      end

      if (@by+20 > @y && @y+15 > @by) && (@bx+20 > @x && @bx < @x+38 )
        @ex,@ey=@x,@y-25
        @x,@y=300,400
        @bx,@by= rand(640), 0
        @etime = 20
        @lives= @lives-1
        if @lives < 1
          @loose = true
        end
      end

      if @etime > 0
        @explosion.draw(@ex,@ey,1)
        @etime =@etime -1
      else
        @bullet.draw(@bx, @by, 0.5)
        @standing.draw(@x, @y, 1)
      end
    else
      @game_over.draw("Game Over", 220, 220, 3.0, 1.0, 1.0, 0xffffffff)
      @game_over.draw("restart press 'n' ", 250, 250, 3.0, 1.0, 1.0, 0xffffffff)
    end

    @points_text.draw("Points: #{@points}", 10, 10, 3.0, 1.0, 1.0, 0xffffffff)
    @lives_text.draw("Lives: #{(1..@lives).map{|l| "X" }.join(" ")}", 450, 10, 3.0, 1.0, 1.0, 0xffffffff)
  end

  def button_down(id)
    @pressed = id
  end

  def button_up(id)
    @pressed = nil
  end


end

window = GameWindow.new
window.show
