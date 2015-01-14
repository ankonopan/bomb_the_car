require 'gosu'
require 'pry'
include Gosu

GAME_PARAMS={
  window:{
    width: 640,
    height: 480
  },
  lives: 3,
  max_point_level: 200,
  x_init_place: lambda { rand(640) }
}

class GameWindow < Gosu::Window


  # initializing the Window
  def initialize
    super(GAME_PARAMS[:window][:width], GAME_PARAMS[:window][:height], false)
    self.caption = "Bomb the Car. Uhhhh"

    # initializing a bullet
    @bullet, @walk1, @walk2, @jump = Gosu::Image.load_tiles(self, "images/bullet.png", 20, 20, false)
    # initializing a second bullet
    @bullet2, @walk1, @walk2, @jump = Gosu::Image.load_tiles(self, "images/bullet.png", 20, 20, false)

    @standing, @walk1, @walk2, @jump = Gosu::Image.load_tiles(self, "images/car.png", 38, 15, false)
    @explosion, @walk1, @walk2, @jump = Gosu::Image.load_tiles(self, "images/explosion.png", 50, 50, false)

    # Initializing Texts
    @points_text = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @lives_text = Gosu::Font.new(self, Gosu::default_font_name, 20)
    @game_over = Gosu::Font.new(self, Gosu::default_font_name, 40)
    @restart = Gosu::Font.new(self, Gosu::default_font_name, 11)

    # INit Parameters
    @x, @y = 300, 400
    @bx, @by = GAME_PARAMS[:x_init_place].call, 400
    @points=0
    @lives=3
    @etime = 0
    @loose = false
  end

  def update
  end

  def draw

    case @pressed
      when 123 then @x = @x-3
      when 124 then @x = @x+3
      # when 125 then @y = @y+3
      # when 126 then @y = @y-3
      when 45 then
        @x,@y=300,400
        @bx,@by= GAME_PARAMS[:x_init_place].call, 0
        @loose = false
        @lives = 3
    end

    unless @loose
      @by = @by+4
      if @by > 480
        @by=0
        @bx=GAME_PARAMS[:x_init_place].call
        @points = @points +1
      end

      if (@by+20 > @y && @y+15 > @by) && (@bx+20 > @x && @bx < @x+38 )
        @ex,@ey=@x,@y-25
        @x,@y=300,400
        @bx,@by= GAME_PARAMS[:x_init_place].call, 0
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