extends Entity

const TEXTURES = {
	"Boar": preload("res://asset_packs/PUNY_MONSTERS_v1/Boar.png"),
	"Boar2": preload("res://asset_packs/PUNY_MONSTERS_v1/Boar2.png"),
}

func _ready():
	super()
	var keys = TEXTURES.keys()
	var index = randi() % keys.size()
	%Sprite2D.texture = TEXTURES[keys[index]]
	%HealthBar.health_depleted.connect(self.destroy)
	%HurtBox.damaged.connect(%HealthBar.on_damaged)
	%HurtBox.damaged.connect(%Movement.on_damaged)

func _physics_process(_delta):
	# TODO replace with state machine
	var children = Utils.get_2dchildren(player_units)
	if children.size() > 0:
		var closest = Utils.find_closest(self, children)
		%Movement.target =  closest.global_position
	else:
		%Movement.target = Vector2.ZERO
