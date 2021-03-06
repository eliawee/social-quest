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
  lifebar = Bank.Asset.Image("assets/images/life_bar.png"),
  smartphone = {
    background = Bank.Asset.Image("assets/images/smartphone_bg.png"),
    image = Bank.Asset.Image("assets/images/smartphone.png"),
  },
  card = {
    bill = Bank.Asset.Image("assets/images/card_bill.png"),
    croak = Bank.Asset.Image("assets/images/card_croak.png"),
    floof = Bank.Asset.Image("assets/images/card_floof.png"),
    gudboy = Bank.Asset.Image("assets/images/kiki_card.png"),
    jlo = Bank.Asset.Image("assets/images/card_jlo.png"),
  },
  element = {
    image = Bank.Asset.Image("assets/sprites/elements/elements.png"),
    spec = Bank.Asset.JSON("assets/sprites/elements/elements.json"),
  },
  monster = {
    zombieChicken = {
      image = Bank.Asset.Image("assets/sprites/zombie-chicken/zombie-chicken.png"),
      spec = Bank.Asset.JSON("assets/sprites/zombie-chicken/zombie-chicken.json"),
    },
    catato = {
      image = Bank.Asset.Image("assets/sprites/catato/catato.png"),
      spec = Bank.Asset.JSON("assets/sprites/catato/catato.json"),
    }
  },
  shield = Bank.Asset.Image("assets/images/shield.png"),
  shieldElement = {
    image = Bank.Asset.Image("assets/sprites/shield_element/shield_element.png"),
    spec = Bank.Asset.JSON("assets/sprites/shield_element/shield_element.json"),
  }
})
