local baton = require("baton")

return baton.new {
  controls = {
    action = {'key:return', "key:kpenter", 'button:a'},
  },
  joystick = love.joystick.getJoysticks()[1],
}
