local Element = {
  Fire = 1,
  Water = 2,
  Electricity = 3,
  Ground = 4,
  Plant = 5
}

return {
  GroundTop = 50,
  GroundHeight = 3,
  Character = {
    Life = 100,
    PositionX = 60,
    PositionY = 20,
    ToRightEdgeSpace = 4
  },
  LifeBar = {
    BorderSize = 1,
    PositionY = 18
  },
  Element = Element,
  Finger = {
    ButtonBottom = 20,
    ToCenterSpace = 5
  },
  Smartphone = {
    PatchHeight = 11,
    ToCardSpace = 14,
    ScreenBottom = 10,
    ToButtonSpace = 5,
    Direction = {
      Right = 1,
      Left = 2
    }
  },
  Card = {
    ScreenBottom = 20,
    ToLineSpace = 8,
    ToElementSpace = 6,
    ToCardSpace = 6,

    Bill = {
      Element = Element.Electricity,
      Name = "bill",
    },
    Croak = {
      Element = Element.Plant,
      Name = "croak",
    },
    Floof = {
      Element = Element.Fire,
      Name = "floof",
    },
    Gudboy = {
      Element = Element.Ground,
      Name = "gudboy",
    },
    Jlo = {
      Element = Element.Water,
      Name = "jlo",
    },
  },
  TinyCard = {
    Scale = 1 / 2,
    InvocationX = 88,
    InvocationY = 20
  },
  Monster = {
    Left = 100,

    Catato = {
      Name = "catato",
      Life = 100,
      ToLeftEdgeSpace = 5,
    },
    ZombieChicken = {
      Name = "zombieChicken",
      Life = 100,
      ToLeftEdgeSpace = 2
    }
  }
}