package utils;

import flixel.FlxG;
import flixel.ui.FlxButton;

class ControlsHandler {
	static public function keyPressedLeft():Bool {
		if (#if mobile Reg.PS.virtualPad.buttonLeft.pressed #else (FlxG.keys.pressed.LEFT) #end) {
			return true;
		} else {
			return false;
		}
	}

	static public function keyPressedRight():Bool {
		if (#if mobile Reg.PS.virtualPad.buttonRight.pressed #else (FlxG.keys.pressed.RIGHT) #end) {
			return true;
		} else {
			return false;
		}
	}

	static public function keyPressedJump():Bool {
		if (#if mobile Reg.PS.virtualPad.buttonA.pressed #else (FlxG.keys.pressed.C) #end) {
			return true;
		} else {
			return false;
		}
	}

	static public function keyReleasedJump():Bool {
		if (#if mobile Reg.PS.virtualPad.buttonA.justReleased #else (FlxG.keys.justReleased.C) #end) {
			return true;
		} else {
			return false;
		}
	}

	static public function keyPressedRun():Bool {
		if (#if mobile Reg.PS.virtualPad.buttonB.pressed #else (FlxG.keys.pressed.X) #end) {
			return true;
		} else {
			return false;
		}
	}
}
