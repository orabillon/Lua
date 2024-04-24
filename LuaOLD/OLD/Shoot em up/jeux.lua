jeux = {}

function jeux.update(dt) 
  -- déplace la camera
    camera.y = camera.y + (camera.vitesse * dt)
    
    -- déplacement vaisseau
    if love.keyboard.isDown("right") and hero.x < largeur_ecran - hero.largeur / 2   then 
      hero.x = hero.x + hero.vitesseX * dt
    end
    if love.keyboard.isDown("left") and hero.x - hero.largeur / 2 > 0   then 
      hero.x = hero.x - hero.vitesseX * dt
    end
    if love.keyboard.isDown("up") and hero.y - hero.hauteur / 2 > 0 then 
      hero.y = hero.y - hero.vitesseY * dt
    end
    if love.keyboard.isDown("down") and hero.y < hauteur_ecran - hero.hauteur / 2 then 
      hero.y = hero.y + hero.vitesseY * dt
    end
    
    -- Mise a jour position tir
    -- a l'envers pour eviter decalage
    local l 
    for l=#tirs, 1 , -1 do
      local t = tirs[l]
      t.y = t.y + t.vitesseY * dt
      t.x = t.x + t.vitesseX * dt
      
      -- verification collision 
      if t.type == "alien" then
       if collision(hero,t) then
         hero.vie = hero.vie - 1
         t.isSupprime = true
         table.remove(tirs,l)
         if hero.vie <= 0 then
           ecran_courant = "perdu"
         end
       end
      end
      
      if t.type == "hero" then
        local n 
        for n=#aliens, 1 , -1 do
          local a = aliens[n]
          if a.isActif then
            if collision(t,a) then
              sonExplosion:play()
              CreerExplosion(t.x,t.y)
              a.vie = a.vie - 1
              t.isSupprime = true
              table.remove(tirs,l)
              if a.vie <= 0 then
                a.isSupprime = true
                for nExplosion = 1,6 do
                  CreerExplosion(a.x + love.math.random(-10,10), a.y + love.math.random(-10,10))
                end
                if a.type == 3 then
                  for nExplosion = 1,80 do
                  CreerExplosion(a.x + love.math.random(-100,100), a.y + love.math.random(-100,100))
                  end
                  victoire = true
                end
                table.remove(aliens,n)
                hero.score = hero.score + a.score
              end
            end
          end
        end
      end
      
      -- si tir sort ecran 
      if (t.y < 0 or t.y> hauteur_ecran) and t.isSupprime == false then
        table.remove(tirs,l)
        t.isSupprime = true
      end
    end
    
    -- traitement aliens
     local n 
    for n=#aliens, 1 , -1 do
      local a = aliens[n]
         
      if a.y > 0 then 
        a.isActif = true
      end
      
      if a.isActif then
        a.y = a.y + a.vy * dt
        a.x = a.x + a.vx * dt
        
        if a.type == 4 then -- tourelle
          a.chronoTir = a.chronoTir - 1 
          if a.chronoTir <= 0 then
            a.chronoTir = love.math.random(30,40)
            local angle, vx, vy
            angle = math.angle(a.x,a.y,hero.x,hero.y)
            vx = 300 * math.cos(angle)
            vy = 300 * math.sin(angle)
            CreerTir("alien","laser2",a.x, a.y, vx, vy)
          end
        elseif a.type == 1 or a.type == 2 then
          a.chronoTir = a.chronoTir - 1 
          if a.chronoTir <= 0 then
            a.chronoTir = love.math.random(50,60)
            CreerTir("alien","laser2",a.x, a.y, 0, 300)
          end
        elseif a.type == 3  then
          if a.y > hauteur_ecran / 3 then
            a.y = hauteur_ecran / 3
          end
          a.chronoTir = a.chronoTir - 1 
          if a.chronoTir <= 0 then
           a.chronoTir = 10
            local vx, vy
            a.angle = a.angle + 0.5
            vx = 300 * math.cos(a.angle)
            vy = 300 * math.sin(a.angle)
            CreerTir("alien","laser2",a.x, a.y, vx, vy)
          end
        end
      else 
        a.y = a.y + (camera.vitesse * dt)
      end
      
      -- si sort ecran 
      if a.y> hauteur_ecran then
        table.remove(aliens,n)
        a.isSupprime = true
      end
    end
    
    -- traitement et suppression des sprites
    for n=#sprites, 1 , -1 do
      local s = sprites[n]
      -- sprite anime
      if s.maxFrame > 1 then 
        s.frame = s.frame + 0.1
        if math.floor(s.frame) > s.maxFrame then
          s.isSupprime = true
        else 
          s.image = s.listeFrames[math.floor(s.frame)]
        end
      end
      if s.isSupprime then
        table.remove(sprites,n)
      end
    end
    
    if victoire == true  then
      if timerVictoire == 0 then
        ecran_courant = "victoire"
      else
        timerVictoire = timerVictoire - 1
      end
    end
end

function jeux.draw()
  -- dessin niveau
  local l,c 
  for l=1 , niveau.height do
    for c=1, niveau.width do
      local id = niveau.grid[l][c]
      local texture = tuiles[id]
      if texture ~= nil then
        love.graphics.draw(texture,(c-1)*niveau.tuileWidht,(((l-1)*niveau.tuileHeight)*-1)+camera.y,0)
      end
    end
  end
  
  for l=1, #sprites do
    local s = sprites[l]
    love.graphics.draw(s.image, s.x, s.y, 0, 1, 1, s.largeur / 2, s.hauteur / 2)
  end
    
    love.graphics.print(" VIE : "..hero.vie.. "     SCORE : "..hero.score , 0,0 )
end

return jeux