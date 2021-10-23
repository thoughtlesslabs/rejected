pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
-- rejected
-- a thoughtless labs experiment

function _init()
	comp={
	 {name="jimbo",x=80,y=100},
	 {name="tank",x=20,y=100}
	 }
	player={
		name="you",x=5,y=60,dx=0,dy=0}
	
	ball={
		x=50,y=10,dx=0,dy=0}
		
	gravity = 0.9
	friction = 0.6
	
	current = 1
end

function _update60()
	moveplayer()
	moveai(ball.x,ball.y)
	moveball()
end

function _draw()
	cls()
	print(player.dy)
	print(player.y)
	rectfill(player.x,player.y,player.x+5,player.y+5,10)
	rectfill(comp[current].x,comp[current].y,comp[current].x+5,comp[current].y+5,5)
	circfill(ball.x,ball.y,3,7)
end

function moveplayer()
	if btn(0) then player.dx-=1 end
	if btn(1) then player.dx+=1 end
	if btnp(2) then player.dy-=10 end
	if btn(3) then player.dy+=1 end

	player.dx *= friction
	player.dy += gravity
	
	player.x += player.dx
	player.y += player.dy
	
	player.x = mid(0,player.x,100)
	player.y = mid(0,player.y,100)
	
	if player.y >=100 then
		player.dy = 0
	end
end
-->8
-- computer

function moveai(cx,cy)
	local speed,angle,dx,dy
	
	speed = 0.5
	
	dx = cx - comp[current].x
	dy = cy - comp[current].y
	
	angle = atan2(dx,dy)
	
	comp[current].x += cos(angle)*speed
	comp[current].y += sin(angle)*speed
end

function moveball()
 ball.dy += gravity
	
	ball.x += ball.dx
	ball.y += ball.dy
	
	ball.x = mid(0,ball.x,100)
	ball.y = mid(0,ball.y,100)
	
	if ball.y >=100 then
		ball.dy = 0
	end
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
