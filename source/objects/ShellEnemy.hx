package objects;

import flixel.FlxObject;

class ShellEnemy extends Enemy {
	private static var WALK_SPEED:Int = 40;
	private static var SCORE_AMOUNT:Int = 100;

	private var _isShell:Bool = false;
	private var _isMovingShell:Bool = false;
	private var _waitToCollide:Float = 0;

	public function new(x:Float, y:Float) {
		super(x, y);

		loadGraphic(AssetPaths.enemyC__png, true, 16, 16);
		animation.add("walk", [0, 1, 2, 1], 12);
		animation.add("shell", [3], 12);
		animation.play("walk");

		setSize(12, 12);
		offset.set(2, 4);
	}

	override private function move() {
		if (_isMovingShell)
			velocity.x = _direction * WALK_SPEED * 4;
		else if (!_isShell)
			velocity.x = _direction * WALK_SPEED;
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		if (_waitToCollide > 0)
			_waitToCollide -= elapsed;
	}

	override public function interact(player:Player) {
		if (!alive || _waitToCollide > 0)
			return;

		checkIfInvincible(player);

		FlxObject.separateY(this, player);

		if (_isMovingShell) {
			if (player.velocity.y > 0 && isTouching(FlxObject.UP)) {
				Reg.score += SCORE_AMOUNT;
				_isMovingShell = false;
				damageOthers = false;
				velocity.x = 0;
				_waitToCollide = 0.25;
				player.jump();
			} else {
				player.damage();
			}
		} else if (_isShell) {
			if (player.velocity.y > 0 && isTouching(FlxObject.UP))
				player.jump();
			_direction = player.direction;

			_waitToCollide = 0.25;
			_isMovingShell = true;
			damageOthers = true;
		} else {
			if (player.velocity.y > 0 && isTouching(FlxObject.UP)) {
				Reg.score += SCORE_AMOUNT;
				animation.play("shell");
				_isShell = true;
				velocity.x = 0;
				_waitToCollide = 0.25;
				player.jump();
			} else {
				player.damage();
			}
		}
	}
}
