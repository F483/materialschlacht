extends Entity

const TEXTURE = preload("res://asset_packs/PUNY_MONSTERS_v1/Aghoy.png")

func _ready():
    super()
    %Sprite2D.texture = TEXTURE
    %HealthBar.health_depleted.connect(self.destroy)
    %HurtBox.damaged.connect(%HealthBar.on_damaged)
    %HurtBox.damaged.connect(%Movement.on_damaged)

func _physics_process(_delta):
    # FIXME replace with state machine
    var children = Utils.get_2dchildren(player_units)
    if children.size() > 0:
        var closest = Utils.find_closest(self, children)
        %Movement.target =  closest.global_position
    else:
        %Movement.target = Vector2.ZERO
