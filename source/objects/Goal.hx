package objects;

import flixel.util.FlxTimer;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;
import states.MenuState;

class Goal extends FlxSprite {
	private var _calculateScore:Bool = false;

	public function new(x:Float, y:Float) {
		super(x, y);
		solid = true;
		immovable = true;
		makeGraphic(2, FlxG.height * 2, FlxColor.TRANSPARENT);
	}

	public function reach(player:Player) {
		solid = false;
		Reg.pause = true;

		player.velocity.y = Player.JUMP_FORCE / 2;
		player.velocity.x = Player.WALK_SPEED;
		player.acceleration.x = 0;
		player.drag.x = player.drag.x / 4;

		new FlxTimer().start(4.0, function(_) {
			_calculateScore = true;
			player.drag.x = player.drag.x * 4;
			player.acceleration.x = Player.WALK_SPEED;
		}, 1);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);

		if (!_calculateScore)
			return;

		if (Reg.time > 0) {
			FlxG.sound.play("time-convert", 0.75);
			Reg.time -= 5;
			Reg.score += 50;
		} else {
			Reg.time = 0;
			_calculateScore = false;
			new FlxTimer().start(2.0, function(_) {
				Reg.PS.nextLevel();
			}, 1);
		}
	}
}
