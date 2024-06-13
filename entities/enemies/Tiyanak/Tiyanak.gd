extends Entity

@export var vision_range: float = 96

func _ready():
    super()
    %HealthBar.health_depleted.connect(self.destroy)
    %HurtBox.damaged.connect(%HealthBar.on_damaged)
    %HurtBox.damaged.connect(%Movement.on_damaged)

func _physics_process(_delta):
    # FIXME replace with state machine
    var children = Utils.get_2dchildren(player_units)
    if children.size() > 0:
        var closest = Utils.find_closest(self, children)
        var dist = self.global_position.distance_to(closest.global_position)
        if dist <= vision_range:
            %Movement.target =  closest.global_position
            %AnimationPlayer.play("Move")
            return
    %Movement.stop()
    %AnimationPlayer.play("Hold")
