local Bank = require("bank")

return Bank({
  background = Bank.Asset.Image("assets/images/game_bg.png"),
  finger = Bank.Asset.Image("assets/images/finger.png"),
  button = {
    follow = {
      image = Bank.Asset.Image("assets/sprites/follow_btn/follow_btn.png"),
      spec = Bank.Asset.JSON("assets/sprites/follow_btn/follow_btn.json"),  
    },
    invoke = {
      image = Bank.Asset.Image("assets/sprites/invoke_btn/invoke_btn.png"),
      spec = Bank.Asset.JSON("assets/sprites/invoke_btn/invoke_btn.json"),  
    }
  },
  character = {
    image = Bank.Asset.Image("assets/sprites/character/character.png"),
    spec = Bank.Asset.JSON("assets/sprites/character/character.json"),
  },
  smartphone = {
    background = Bank.Asset.Image("assets/images/smartphone_bg.png"),
    image = Bank.Asset.Image("assets/images/smartphone.png"),
  },
  card = {
    kiki = Bank.Asset.Image("assets/images/kiki_card.png"),
  },
  element = {
    image = Bank.Asset.Image("assets/sprites/elements/elements.png"),
    spec = Bank.Asset.JSON("assets/sprites/elements/elements.json"),
  },
  monster = {
    zombieChicken = {
      image = Bank.Asset.Image("assets/sprites/zombie-chicken/zombie-chicken.png"),
      spec = Bank.Asset.JSON("assets/sprites/zombie-chicken/zombie-chicken.json"),
    }
  }
})
