package states;

import flixel.ui.FlxButton;
import openfl.system.System;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxState;

class MenuState extends FlxState {
	static inline var OFFSET:Int = 4;

	private var _textScore:FlxText;
	private var _bg:FlxSprite;
	private var _cursor:FlxSprite;
	private var _selected:Int = 0;
	private var _buttonStart:FlxButton;
	private var _buttonExit:FlxButton;

	private static var _menuEntries:Array<String> = ["NEW GAME", "EXIT"];
	private static var _menuPos:FlxPoint = new FlxPoint(132, 132);
	private static var _menuSpacing:Int = 16;

	override public function create():Void {
		_bg = new FlxSprite(0, 0);
		_bg.loadGraphic(AssetPaths.title__png, false, 320, 180);

		_textScore = new FlxText(OFFSET, OFFSET, 0);
		_textScore.text = "HIGH\n" + StringTools.lpad(Std.string(Reg.loadScore()), "0", 5);

		add(_bg);
		add(_textScore);

		#if mobile
		_buttonStart = new FlxButton(_menuPos.x - 12, _menuPos.y, _menuEntries[0], resolveChoice.bind(0));
		_buttonExit = new FlxButton(_menuPos.x - 12, _menuPos.y + _menuSpacing, _menuEntries[1], resolveChoice.bind(1));

		add(_buttonStart);
		add(_buttonExit);
		#else
		_cursor = new FlxSprite(_menuPos.x - _menuSpacing, _menuPos.y);
		_cursor.loadGraphic(AssetPaths.hud__png, true, 8, 8);
		_cursor.animation.add("cursor", [1]);
		_cursor.animation.play("cursor");
		_cursor.offset.set(0, -4);

		add(_cursor);
		for (i in 0..._menuEntries.length) {
			var entry:FlxText = new FlxText(_menuPos.x, _menuPos.y + _menuSpacing * i);
			entry.text = _menuEntries[i];
			add(entry);
		}
		#end

		forEachOfType(FlxText, function(member) {
			member.setFormat(AssetPaths.pixel_font__ttf, 8, FlxColor.WHITE, null, FlxTextBorderStyle.OUTLINE, 0xff005784);
		});

		forEachOfType(FlxButton, function(btn) {
			btn.label.setFormat(AssetPaths.pixel_font__ttf, 8, FlxColor.WHITE, FlxTextBorderStyle.OUTLINE, 0xff005784);
		});
		super.create();
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);

		#if !mobile
		if (FlxG.keys.justPressed.UP)
			_selected -= 1;
		if (FlxG.keys.justPressed.DOWN)
			_selected += 1;

		_selected = FlxMath.wrap(_selected, 0, _menuEntries.length - 1);
		_cursor.y = _menuPos.y + _menuSpacing * _selected;

		if (FlxG.keys.justPressed.ENTER) {
			resolveChoice(_selected);
		}
		#end
	}

	private function resolveChoice(choice:Int):Void {
		FlxG.cameras.fade(FlxColor.BLACK, .2, false, function() {
			switch (choice) {
				case 0:
					FlxG.switchState(new PlayState());
				case 1:
					System.exit(0);
			}
		});
	}
}
