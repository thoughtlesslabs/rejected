pico-8 cartridge // http://www.pico-8.com
version 33
__lua__
-- rejected
-- a thoughtless labs experiment

function _init()
	-- init ai players
	comp={
	 {name="jimbo",x=80,y=100,dx=0,dy=0,
	 	g=0.8,f=0.9,j=false},
	 {name="tank",x=20,y=100,dx=0,dy=0,
	 	g=0.8,j=false}}
	-- init player
	player={
		name="you",x=5,y=60,dx=0,dy=0,
		g=0.5,f=0.7,j=false}
	-- init ball
	ball={
		x=60,y=10,dx=0,dy=0,r=4,
		g=0.2,f=0.95,ang=1}
	
	-- defaults
	shake = 0 
	current = 1
	debug = ""
end

function _update60()
	screenshake()
	moveplayer()
	moveai(ball.x,ball.y)
	moveball(player.x,player.y)
end

function _draw()
	cls()
	drawbackground()
	print(debug)
	spr(1,player.x,player.y)
	rectfill(comp[current].x,comp[current].y,comp[current].x+5,comp[current].y+5,5)
	rect(hitboxx,hitboxy,hitboxx+7,hitboxy+10,phbcol)
	rect(aiboxx,aiboxy,aiboxx+7,aiboxy+10,aihbcol)
	circ(ballhbx,ballhby,ball.r,ballhbcol)
	spr(17,ball.x,ball.y)
end

function moveplayer()
	if btn(0) then player.dx-=1 end
	if btn(1) then player.dx+=1 end
	if btnp(2) and not player.j then player.j = true player.dy-=6 end
	if btn(3) then player.dy+=1 end
	
	hitboxy = player.y
	hitboxx = player.x
	
	player.dx *= player.f
	player.dy += player.g
	
	player.x += player.dx
	player.y += player.dy
	
	player.x = mid(0,player.x,100)
	player.y = mid(0,player.y,100)


	if player.y >=100 then
		player.dy = 0
		player.j = false
	end
end

function drawbackground()
	rectfill(0,0,128,100,12)
	rectfill(0,100,128,128,4)
	rectfill(1,75,3,90,5)
	line(3,85,10,85,5)
	rectfill(0,80,1,110,5)
	rectfill(126,80,127,110,5)
	rectfill(124,75,126,90,5)
	rectfill(124,75,126,90,5)
	line(117,85,124,85,5)
end
-->8
-- computer

function moveai(cx,cy)
	local speed,angle,ccx,ccy
	co = comp[current]
	speed = 1
	
	ccx = cx - co.x
	ccy = cy - co.y
	debug = ccy
	angle = atan2(ccx,ccy)
	
	co.x += cos(angle)*speed
	if abs(ccy) < 10 and abs(ccx) < 10 and not co.j then
		if ccy < 0 then
			co.dy -= 6
			co.y += sin(angle)*speed
			co.j = true
		end
	end

	co.dy += co.g
	co.dx *= co.f
	co.y += co.dy
	
	aiboxx = co.x
	aiboxy = co.y
	
	co.x = mid(0,co.x,100)
	co.y = mid(0,co.y,100)
	
	if co.y >=100 then
		co.dy = 0
		co.j = false
	end

end

function moveball()
 ball.dx *= ball.f
 ball.dy += ball.g

	-- hitbox visual for testing
	ballhbx = ball.x+ball.r
	ballhby = ball.y+ball.r
	
	nextx = ball.x+ball.dx
	nexty = ball.y+ball.dy
	
	if checkcollision(ball.x,ball.y) then
		if calcslope(ball.x,ball.y,ball.dx,ball.dy) then
			ball.dx = -ball.dx
			if ball.x < player.x+4 then
				nextx=player.x-ball.r
			else
				nextx=player.x+8+ball.r
			end
		else
			nexty=player.y-ball.r
			if abs(player.dx)>2 then
				if sign(player.x)==sign(ball.dx) then
					setang(ball,mid(0,ball.ang-1,2))
					else
						if ball.ang==2 then
							ball.dx=-ball.dx
						else
							setang(ball,mid(0,ball.ang+1,2))
						end
					end
				end
			end
		end
	-- change hitbox color
			phbcol = 8
			aihbcol = 8
			ballhbcol = 8
--			shake=0.1
--	else
--	-- hitbox default color
--		phbcol = 7
--		aihbcol = 7
--		ballhbcol = 7
--	end

	
	-- check if ball hit wall
	if nexty >=100 then
		ball.dy = -ball.dy*ball.f
--		shake=0.1
	end
	if nextx <=0 or nextx >=100 then
		ball.dx =  -ball.dx
--		shake=0.1
	end
	
	

	-- move ball within frame
	ball.x = mid(0,nextx,100)
	ball.y = mid(0,nexty,100)
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
	return not (bx-ball.r>colcheckx+8
										or bx+ball.r<colcheckx
										or by-ball.r > colchecky+8
										or by+ball.r < colchecky)
end

function calcslope(bx,by,bdx,bdy)
	--calculate slope
	local slp = bdy / bdx
	local cx, cy
	if bdx == 0 then
		return false
	elseif bdy == 0 then
		return true
	elseif slp > 0 and bdx > 0 then
			cx = player.x-bx
			cy = player.y-by
			return cx > 0 and cy/cx < slp
	elseif slp < 0 and bdx > 0 then
			cx = player.x - bx
			cy = player.y + 8 - by
			return cx > 0 and cy/cx >= slp
	elseif slp > 0 and bdx < 0 then
			cx = player.x + 8 - bx
			cy = player.y + 8 - by
			return cx < 0 and cy/cx <= slp
	else
			cx = player.x + 8 - bx
			cy = player.y -by
			return cx < 0 and cy/cx >= slp
	end
end

function setang(bl,ang)
 bl.ang=ang
	if ang==2 then
		bl.dx=0.50*sign(bl.dx)
		bl.dy=1.30*sign(bl.dx)
	elseif ang==0 then
		bl.dx=1.30*sign(bl.dx)
		bl.dy=0.50*sign(bl.dx)
	else
		bl.dx=1*sign(bl.dx)
		bl.dy=1*sign(bl.dx)
	end
end

function sign(n)
 if n<0 then
 	return -1
 elseif n>0 then
 	return 1
 else
 	return 0
	end
end
-->8
-- juice

function screenshake()
	local shakex = 16-rnd(32)
	local shakey = 16-rnd(32)

	camx = shakex*shake
	camy = shakey*shake
	camera(camx,camy)
	
	shake=shake*0.95
	if shake<0.05 then
		shake=0
	end
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
