local baton = require("baton")

return baton.new {
  controls = {
    action = {'key:return', "key:kpenter", 'button:a'},
    left = {'key:left'},
    right = {'key:right'},
  },
  joystick = love.joystick.getJoysticks()[1],
}
