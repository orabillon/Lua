-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

local scaleZoom = 4
local sndTeleportation = love.audio.newSource("assets/sons/voyager_transporter.mp3","static")

kirk = {}
kirk.image = nil
kirk.x = 0
kirk.y = 0
kirk.isBeam = true
kirk.beamLevel = 1
kirk.maxPercent = 70


function love.load()

	screenWidth = love.graphics.getWidth() / scaleZoom
	screenHeight = love.graphics.getHeight() / scaleZoom
	love.graphics.setBackgroundColor(0.3,0.45,0.65)

	kirk.image = love.graphics.newImage("assets/images/kirk.png")
	kirk.x = math.floor(screenWidth / 2) - math.floor(kirk.image:getWidth() / 2) 
	kirk.y = math.floor(screenHeight / 2) - math.floor(kirk.image:getHeight() / 2) 

	sndTeleportation:play()

end

function love.update(dt)
	
	if kirk.isBeam then
		local coeff = 0.4 * 60 * dt 
		kirk.beamLevel = kirk.beamLevel + coeff

		if kirk.beamLevel >= kirk.maxPercent then 
			kirk.isBeam = false
			kirk.beamLevel = 1
		end
	end 
end

local mask_shader = love.graphics.newShader[[
   vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
      if (Texel(texture, texture_coords).rgba == vec4(0.0)) {
         discard;
      }
      return vec4(1.0);
   }
]]

local function myStencilFunction()
  love.graphics.setShader(mask_shader)
  love.graphics.draw(kirk.image, kirk.x, kirk.y)
  love.graphics.setShader()
end

function love.draw()
	love.graphics.scale(scaleZoom,scaleZoom)

	if kirk.isBeam == false then
		love.graphics.draw(kirk.image,kirk.x,kirk.y)
	else 
		-- kirk en filigramme 
		love.graphics.setColor(1,1,1,1*(kirk.beamLevel / kirk.maxPercent))
		love.graphics.draw(kirk.image,kirk.x,kirk.y)
		love.graphics.stencil(myStencilFunction, "replace", 1)
    	love.graphics.setStencilTest("greater", 0)

		local percent
		if kirk.beamLevel <= kirk.maxPercent / 2 then
			percent = (kirk.beamLevel *2) / 100
		else
			percent = ((kirk.maxPercent - kirk.beamLevel) *2) / 100
		end

		local l,h = kirk.image:getWidth(), kirk.image:getHeight()
		local nbPoints = (l*h) * percent

		love.graphics.setColor(0.99,0.98,0.83,1)
		local np 
		for np=1, nbPoints do 
			local rx, ry = math.random(0,l-1), math.random(0,h-1)
			love.graphics.rectangle("fill",kirk.x + rx, kirk.y + ry,1,1)
			
		end
		 -- Fin du masque
		 love.graphics.setStencilTest()
	end
end

function love.keypressed(key)
end
