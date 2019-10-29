package objects;

import flixel.FlxG;

class WalkEnemy extends Enemy {
	private static inline var WALK_SPEED:Int = 40;
	private static inline var SCORE_AMOUNT:Int = 100;

	public function new(x:Float, y:Float) {
		super(x, y);

		loadGraphic(AssetPaths.enemyA__png, true, 16, 16);
		animation.add("walk", [0, 1, 2, 1], 12);
		animation.add("dead", [3], 12);
		animation.play("walk");

		setSize(12, 12);
		offset.set(2, 4);
	}

	override private function move() {
		velocity.x = _direction * WALK_SPEED;
	}

	override public function kill() {
		Reg.score += SCORE_AMOUNT;
		FlxG.sound.play("defeat");
		super.kill();
	}
}
