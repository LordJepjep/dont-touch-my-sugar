extends TextureRect

var upgrade = null
var item_name = null

func _ready():
	if upgrade != null:
		$ItemTexture.texture = load(UpgradeDb.UPGRADES[upgrade]["icon"])
		item_name = UpgradeDb.UPGRADES[upgrade]["displayname"]
