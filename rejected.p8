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
		name="you",x=5,y=60,dx=0,dy=0}
	
	ball={
		x=60,y=10,dx=0,dy=0}
		
	gravity = 0.9
	friction = 0.6
	jumping = false
	current = 1
	debug = ""
end

function _update60()
	moveplayer()
	moveai(ball.x,ball.y)
	moveball(player.x,player.y)
end

function _draw()
	cls()
	print(debug)
	spr(1,player.x,player.y)
	rectfill(comp[current].x,comp[current].y,comp[current].x+5,comp[current].y+5,5)
	rect(hitboxx,hitboxy,hitboxx+7,hitboxy+10,phbcol)
	rect(aiboxx,aiboxy,aiboxx+7,aiboxy+10,aihbcol)
	rect(ballhbx,ballhby,ballhbx+8,ballhby+8,ballhbcol)
	spr(17,ball.x,ball.y)
end

function moveplayer()
	if btn(0) then player.dx-=1 end
	if btn(1) then player.dx+=1 end
	if btnp(2) then player.dy-=10 end
	if btn(3) then player.dy+=1 end
	
	hitboxy = player.y+1
	hitboxx = player.x-1
	
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
	
	aiboxx = co.x
	aiboxy = co.y
	
	co.x = mid(0,co.x,100)
	co.y = mid(0,co.y,100)
	
	if co.y >=100 then
		co.dy = 0
		jumping = false
	end

end

function moveball()
 ball.dx *= 0.9
 ball.dy += gravity

	ball.x += ball.dx
	ball.y += ball.dy
	
	-- hitbox visual for testing
	ballhbx = ball.x
	ballhby = ball.y
	
	nextx = ball.x
	nexty = ball.y
	
	if checkcollision(ball.x,ball.y) then
		ball.dx += 10
		phbcol = 8
		aihbcol = 8
		ballhbcol = 8
	else
		phbcol = 7
		aihbcol = 7
		ballhbcol = 7
	end
	
	if nexty >=100 then
		ball.dy = -ball.dy*0.95
	end
	if nextx <=0 or nextx >=100 then
		ball.dx =  -ball.dx
	end

	ball.x = mid(0,ball.x,100)
	ball.y = mid(0,ball.y,100)
end

function checkcollision(bx,by)
	-- check player closeness
	cmxc = bx-comp[current].x
	cmyc = by-comp[current].y
	plxc = bx-player.x
	plyc = by-player.y
	
	if abs(cmxc) < abs(plxc) or abs(cmyc) < abs(plyc) then
		colcheckx = comp[current].x
		colchecky = comp[current].y
	elseif abs(cmxc)>abs(plxc) or abs(cmyc)>abs(plyc) then
		colcheckx = player.x
		colchecky = player.y
	end
	return not (bx>colcheckx+8
										or bx+8<colcheckx
										or by > colchecky+8
										or by+8 < colchecky)

end

function calcslope()

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
