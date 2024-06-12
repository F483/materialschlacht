extends Entity

const TEXTURE = preload("res://asset_packs/PUNY_MONSTERS_v1/Santelmo.png")

@export var vision_range: float = 64

func _ready():
    super()
    %Sprite2D.texture = TEXTURE
    %HealthBar.health_depleted.connect(self.destroy)
    %HurtBox.damaged.connect(%HealthBar.on_damaged)
    %HurtBox.damaged.connect(%Movement.on_damaged)
    %HitBox.damaged.connect(self._on_damaged)

func _on_damaged(_dest_hurtbox: HurtBox):
    # TODO set target unit on fire!
    self.destroy()
    
func _physics_process(_delta):
    # FIXME replace with state machine
    var children = Utils.get_2dchildren(player_units)
    if children.size() > 0:
        var closest = Utils.find_closest(self, children)
        var dist = self.global_position.distance_to(closest.global_position)
        if dist <= vision_range:
            %Movement.target =  closest.global_position
            return
    %Movement.stop()
