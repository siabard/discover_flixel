import flixel.math.FlxPoint;
import flixel.util.FlxSave;
import states.PlayState;

class Reg {
	public static var level:Int = 0;
	public static var score:Int = 0;
	public static var coins:Int = 0;
	public static var lives:Int = 3;
	public static var time:Float = 300;
	public static var pause:Bool = false;
	public static var PS:PlayState;
	public static var checkpointReached:Bool = false;
	public static var levels:Array<String> = ["level1", "level2", "level3"];
	inline static private var SAVE_DATA:String = "HAXEFLIXELGAME";
	public static var currentLevel:Int = 0;

	static public var save:FlxSave;

	static public function saveScore():Void {
		save = new FlxSave();

		if (save.bind(SAVE_DATA)) {
			if ((save.data.score == null) || (save.data.score < Reg.score))
				save.data.score = Reg.score;
		}

		save.flush();
	}

	static public function loadScore():Int {
		save = new FlxSave();

		if (save.bind(SAVE_DATA)) {
			if ((save.data != null && save.data.score != null))
				return save.data.score;
		}
		return 0;
	}
}
