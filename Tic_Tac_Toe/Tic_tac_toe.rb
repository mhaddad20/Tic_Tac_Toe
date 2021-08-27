require 'ruby2d'

set background:'yellow'
LENGTH_SQUARE =Window.width/100*39-Window.width/100*20


class Grid
  attr_writer :finished
  attr_reader :player_number
  def initialize
    @player_number = 1
    @turn = 0
    @draw = false
    @finished = false
    $arr =[false,false,false,false,false,false,false,false,false]
    $letter_grid =[['','',''],['','',''],['','','']]
  end

  def arr_check?(x)
    $arr[x]==false
  end
  def arr_fill(x)
    $arr[x]=true
  end
  def draw
    9.times do
      Line.new(x1: Window.width/100*20,y1:Window.height/100*45,
               x2:Window.width/100*80,y2:Window.height/100*45,size:200,color:'red') #Line 1 horizontal
      Line.new(x1: Window.width/100*20,y1:Window.height/100*75,
               x2:Window.width/100*80,y2:Window.height/100*75,size:200,color:'red') # Line 2 horizontal
      Line.new(x1:(Window.width/100*37),y1:Window.height/100*15,
               x2:(Window.width/100*37),y2:Window.height/100*99,size:200,color:'red')# Line 1 vertical
      Line.new(x1:(Window.width/100*59),y1:Window.height/100*15,
               x2:(Window.width/100*59),y2:Window.height/100*99,size:200,color:'red')# Line 2 vertical
    end
  end


  def letter_input(num)
    num%2==0 ? 'O' : 'X'
  end

  def input_letter(x,y)
    index=0
    width=10
    for a in 0..2
      for b in 0..2
        if arr_check?(index)
          @shape=Square.new(x:LENGTH_SQUARE+(LENGTH_SQUARE*b),y:Window.width/100*width,size:LENGTH_SQUARE,color:'yellow')
          if @shape.contains?(x,y)
            Text.new("#{letter_input(@player_number)}",x:(LENGTH_SQUARE+(LENGTH_SQUARE*b))+(LENGTH_SQUARE/3.5),
                     y:(Window.width/100*width)+LENGTH_SQUARE/3.5,size:LENGTH_SQUARE/2)
            @turn%2==0 ? @player_number=2 : @player_number=1
            @turn+=1
            $letter_grid[a][b]=letter_input(@player_number)
            txt
            player_turn
            if count_letter?$letter_grid
              game_finish
            end
            arr_fill(index)
          end
        end
        index+=1
      end
      width+=20
    end
  end
  def txt
    @t.remove
  end
  def player_turn
    @t = Text.new("Player #{@player_number}'s Turn")
  end

  def count_letter?(x)
    for b in 0..2 #Vertical
      z=[]
      for a in 0..2
        z.push(x[a][b])
      end
      return true if z.count('O')==3||z.count('X')==3
    end

    for b in 0..2 # horizontal
      z=[]
      for a in 0..2
        z.push(x[b][a])
      end
      return true if z.count('O')==3||z.count('X')==3
    end


    z=[]
    for b in 0..2 #down from the left
      z.push(x[b][b])
    end
    return true if z.count('O')==3||z.count('X')==3

    z=[]
    col=2
    for b in 0..2 #down from the right
      z.push(x[b][col])
      col-=1
    end
    return true if z.count('O')==3||z.count('X')==3
    if @turn==9
      @draw=true
      return true
    end
    false
  end
  def game_finish
    @finished=true
  end
  def finished?
    @finished
  end
  def text_message
    player = @turn%2==1 ? 1:2
    if finished?
      if !@draw
        Text.new("Game over, Player #{player} wins! Press 'R' to restart. ",x:LENGTH_SQUARE,y:Window.height/100*10,color:'red')
      else
        Text.new("Game over, The result is a Draw! Press 'R' to restart. ",x:LENGTH_SQUARE,y:Window.height/100*10,color:'red')
      end
    end
  end
end

game=Grid.new
game.player_turn
update do
  game.draw
  if game.finished?
    game.text_message
  end
end

on :key_down do |event|
  if game.finished? && event.key=='r'
    clear
    game=Grid.new
    game.player_turn
    game.finished =false
  end
end

on :mouse_down do |event|
  unless game.finished?
    game.input_letter(event.x,event.y)
  end
  puts LENGTH_SQUARE
  puts event.x,event.y
end

show