pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
-- rejected
-- a thoughtless labs experiment

function _init()
	comp={
	 {name="jimbo",x=80,y=100,dx=0,dy=0},
	 {name="tank",x=20,y=100,dx=0,dy=0}
	 }
	player={
		name="you",x=5,y=60,dx=0,dy=0,jump=false}
	
	ball={
		x=60,y=10,dx=0,dy=0}
		
	gravity = 0.9
	friction = 0.6
	jumping = false
	current = 1
end

function _update60()
	moveplayer()
	moveai(ball.x,ball.y)
	moveball()
end

function _draw()
	cls()
	print(player.jump)
	print(hitboxx)
	spr(1,player.x,player.y)
	rectfill(comp[current].x,comp[current].y,comp[current].x+5,comp[current].y+5,5)
	rect(hitboxx,hitboxy,hitboxx+7,hitboxy+10,5)
	rect(ballhbx,ballhby,ballhbx+8,ballhby+8,5)
	spr(17,ball.x,ball.y)
end

function moveplayer()
	if btn(0) then player.dx-=1 end
	if btn(1) then player.dx+=1 end
	if btnp(2) and not player.jump then player.dy-=10 player.jump = true end
	if btn(3) then player.dy+=1 end
	
	hitboxy = player.y+1
	hitboxx = player.x-1
	
	player.dx *= friction
	player.dy += gravity
	
	player.x += player.dx
	player.y += player.dy
	
	player.x = mid(0,player.x,120)
	player.y = mid(0,player.y,100)

	if player.y >=100 then
		player.dy = 0
		player.jump = false
	end
end
-->8
-- computer

function moveai(cx,cy)
	local speed,angle,ccx,ccy
	co = comp[current]
	speed = 1
	
	ccx = cx - co.x
	ccy = cy - co.y
	
	angle = atan2(ccx,ccy)
	
	co.x += cos(angle)*speed
	if abs(ccy) < 10 and abs(ccx) < 10 and not jumping then
		co.dy -= 5
		co.y += sin(angle)*speed
		jumping = true
	end

	co.dy += gravity
	co.y += co.dy
	co.x = mid(0,co.x,100)
	co.y = mid(0,co.y,100)
	
	if co.y >=100 then
		co.dy = 0
		jumping = false
	end

end

function moveball()
 ball.dx *= 0.8
 ball.dy += 0.8
	
	-- hitbox visual for testing
	ballhbx = ball.x-1
	ballhby = ball.y+1
	

	
-- if hitboxcheck(nextx,nexty,player.x,player.y) then
-- if ball_deflection(nextx,nexty,ball.dx,ball.dy,player.x,player.y) then
--		ball.dx = -ball.dx
--	else
--
--	end
--	end
	ball.x += ball.dx
	ball.y += ball.dy
	
		nextx = ball.x
	nexty = ball.y
	
	if nexty >=100 then
		ball.dy = -ball.dy*0.95
	end
	if nextx <=0 or nextx >=120 then
		ball.dx =  -ball.dx
	end

	ball.x = mid(0,ball.x,120)
	ball.y = mid(0,ball.y,100)
end

--deflect ball using slope
function ball_deflection(bx,by,bdx,bdy,tx,ty,tw,th)
	--calculate slope
	local slp = bdy / bdx
	local cx, cy
	tx = player.x+8
	ty = player.y+8
	if bdx == 0 then
		return false
	elseif bdy == 0 then
		return true
	elseif slp > 0 and bdx > 0 then
			cx = tx-bx
			cy = ty-by
			return cx > 0 and cy/cx < slp
	elseif slp < 0 and bdx > 0 then
			cx = tx - bx
			cy = ty + th - by
			return cx > 0 and cy/cx >= slp
	elseif slp > 0 and bdx < 0 then
			cx = tx + tw - bx
			cy = ty + th - by
			return cx < 0 and cy/cx <= slp
	else
			cx = tx + tw - bx
			cy = ty -by
			return cx < 0 and cy/cx >= slp
	end
end

function hitboxcheck(bx,by,px,py)
	if by+8 > py+8 then	return false end
	if by+8 < py then return false end
	if bx-8 > px+8 then	return false end
	if bx+8 < px then return false end
	return true
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000ccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000ccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770000ccccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000ccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000ccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000c0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000c0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000090990900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999099090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000099099000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000900000090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000999099090000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000090990900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
