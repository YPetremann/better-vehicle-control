require "defines"

function Set(l)
  local s={}
  for i,k in ipairs(l) do
    s[k]=i
  end
  return s
end

angle_delta   = 0.030
angle_step    = 0.001
linear_delta  = 0.666
linear_step   = 0.005
linear_offset = 1.000
angles = {
  [0.000]={x=2,y=0}, 
  [0.125]={x=0,y=0}, 
  [0.250]={x=0,y=2}, 
  [0.375]={x=0,y=0}, 
  [0.500]={x=2,y=0}, 
  [0.625]={x=0,y=0}, 
  [0.750]={x=0,y=2}, 
  [0.875]={x=0,y=0}, 
  [1.000]={x=2,y=0}
}

vehicle_blacklist = Set{
  "locomotive",
  "cargo-wagon"
}

function on_tick(event)
  for k,v in pairs(game.players) do
    local vehicle = v.vehicle
    if vehicle ~= nil and vehicle.valid and not vehicle_blacklist[vehicle.type] then
      local orientation = vehicle.orientation
      for angle,linear in pairs(angles) do
        if orientation > angle - angle_delta and orientation < angle then
          v.vehicle.orientation = math.min(angle, orientation + angle_step)
        elseif orientation > angle and orientation < angle + angle_delta then
          v.vehicle.orientation = math.max(angle, orientation - angle_step)
        end
      end
    end
  end
end

script.on_init(on_init)
script.on_load(on_load)
script.on_event(defines.events,on_event)
for k,v in pairs(defines.events) do 
  if type(_G[k]) == "function" then
    script.on_event(v,_G[k])
  end
end
