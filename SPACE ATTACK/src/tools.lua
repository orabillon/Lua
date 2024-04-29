-- Test de collision
function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
	return x1 < x2+w2 and
		   x2 < x1+w1 and
		   y1 < y2+h2 and
		   y2 < y1+h1
end

-- Distance entre 2 point 
function Distance(x1, y1, x2, y2)
    return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5
end