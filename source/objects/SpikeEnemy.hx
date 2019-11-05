package objects;

class SpikeEnemy extends Enemy {
	private static inline var WALK_SPEED:Int = 40;
	private static inline var SCORE_AMOUNT:Int = 100;

	public function new(x:Float, y:Float) {
		super(x, y);

		loadGraphic(AssetPaths.enemyB__png, true, 16, 16);
		animation.add("walk", [0, 1], 12);
		animation.play("walk");

		setSize(12, 12);
		offset.set(2, 4);
	}

	override private function move() {
		velocity.x = _direction * WALK_SPEED;
	}

	override public function interact(player:Player) {
		checkIfInvincible(player);

		if (alive)
			player.damage();
	}
}
