extends Entity

const TEXTURES = {
    # "Archer-Green": preload("res://asset_packs/Puny-Characters/Archer-Green.png"),
    # "Archer-Purple": preload("res://asset_packs/Puny-Characters/Archer-Purple.png"),
    # "Character-Base": preload("res://asset_packs/Puny-Characters/Character-Base.png"),
    # "Human-Soldier-Cyan": preload("res://asset_packs/Puny-Characters/Human-Soldier-Cyan.png"),
    # "Human-Soldier-Red": preload("res://asset_packs/Puny-Characters/Human-Soldier-Red.png"),
    # "Human-Worker-Cyan": preload("res://asset_packs/Puny-Characters/Human-Worker-Cyan.png"),
    # "Human-Worker-Red": preload("res://asset_packs/Puny-Characters/Human-Worker-Red.png"),
    # "Mage-Cyan": preload("res://asset_packs/Puny-Characters/Mage-Cyan.png"),
    # "Mage-Red": preload("res://asset_packs/Puny-Characters/Mage-Red.png"),
    # "Orc-Grunt": preload("res://asset_packs/Puny-Characters/Orc-Grunt.png"),
    # "Orc-Peon-Cyan": preload("res://asset_packs/Puny-Characters/Orc-Peon-Cyan.png"),
    # "Orc-Peon-Red": preload("res://asset_packs/Puny-Characters/Orc-Peon-Red.png"),
    # "Orc-Soldier-Cyan": preload("res://asset_packs/Puny-Characters/Orc-Soldier-Cyan.png"),
    # "Orc-Soldier-Red": preload("res://asset_packs/Puny-Characters/Orc-Soldier-Red.png"),
    "Soldier-Blue": preload("res://asset_packs/Puny-Characters/Soldier-Blue.png"),
    "Soldier-Red": preload("res://asset_packs/Puny-Characters/Soldier-Red.png"),
    "Soldier-Yellow": preload("res://asset_packs/Puny-Characters/Soldier-Yellow.png"),
    "Warrior-Blue": preload("res://asset_packs/Puny-Characters/Warrior-Blue.png"),
    "Warrior-Red": preload("res://asset_packs/Puny-Characters/Warrior-Red.png"),
}

func _ready():
    super()
    var keys = TEXTURES.keys()
    var index = randi() % keys.size()
    %Sprite2D.texture = TEXTURES[keys[index]]
    %HealthBar.health_depleted.connect(self.destroy)
    %HurtBox.damaged.connect(%HealthBar.on_damaged)
    %HurtBox.damaged.connect(%Movement.on_damaged)

