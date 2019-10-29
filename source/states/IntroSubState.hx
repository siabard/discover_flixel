package states;

import flixel.util.FlxTimer;
import flixel.FlxObject;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxSubState;

class IntroSubState extends FlxSubState {
	private var _text:FlxText;
	private var _iconLives:FlxSprite;
	private var _textLives:FlxText;

	private var _gameOver:Bool = false;
	private var _waitToDisappear:Float = 3.0;
	private var _gameFinished:Bool = false;

	override public function create():Void {
		super.create();

		if (Reg.currentLevel >= Reg.levels.length) {
			_gameFinished = true;
		}

		if (Reg.lives < 0)
			_gameOver = true;

		_text = new FlxText(0, FlxG.height / 2 + 8, FlxG.width, "Get Ready!");
		_textLives = new FlxText(FlxG.width * 0.5, FlxG.height / 2 - 8, FlxG.width, "x " + Reg.lives);
		_iconLives = new FlxSprite(FlxG.width * 0.5 - 20, FlxG.height / 2 - 4);
		_iconLives.loadGraphic(AssetPaths.hud__png, true, 8, 8);
		_iconLives.animation.add("life", [1], 0);
		_iconLives.animation.play("life");

		add(_text);
		if (_gameOver) {
			_text.text = "Game Over";
			_text.setPosition(0, FlxG.height / 2);
		} else {
			if (_gameFinished) {
				_text.text = "Thanks for Playing!";
				_text.setPosition(0, FlxG.height / 2);
				_waitToDisappear = 5.0;
			} else {
				add(_iconLives);
				add(_textLives);
			}
		}

		forEachOfType(FlxObject, function(member) {
			member.scrollFactor.set(0, 0);
		});

		forEachOfType(FlxText, function(member) {
			member.setFormat(AssetPaths.pixel_font__ttf, 8, FlxColor.WHITE, null, FlxTextBorderStyle.OUTLINE, 0xff005784);
		});

		_text.alignment = FlxTextAlign.CENTER;

		new FlxTimer().start(_waitToDisappear, function(_) {
			if (_gameOver || _gameFinished) {
				Reg.saveScore();
				Reg.lives = 2;
				Reg.score = 0;
				FlxG.switchState(new MenuState());
			} else {
				FlxG.sound.playMusic("pixelland");
				close();
			}
		}, 1);
	}
}
