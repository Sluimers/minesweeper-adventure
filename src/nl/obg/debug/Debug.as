package  nl.obg.debug {
	/**
	 * I'm sure there is a better way to do this
	 * @author Rogier Sluimers
	 */
	import flash.display.BitmapData;
	import nl.obg.engine.*;
	import nl.obg.standards.*;
	import nl.obg.locals.*;
	 
	public class Debug
	{
		public static var main:Main;
		
		// set False if you want to turn off the debugging.
		public static var showDebug:Boolean = true;
		
		// for debugging
		public static var debugString:String = "";
		
		public static function addDebugger(nwMain:Main):void {
			main = nwMain;
			DText.init(PObjectList.getBitmapData("fonts/proggyclean.png"));
		}
		
		public static function debug():void {
			const w:int = main.stage.stageWidth;
			const str:String = debugString, canvas:BitmapData = Engine.canvas;
			
			var i:uint = 100;
			
			DText.draw(canvas, str, 0, 0, DText.LEFT);
			DText.draw(canvas, FPSCounter.update(), w - 1, 0, DText.RIGHT);
		}
		
		public static  function addDebugLine(... s):void {
			debugString = debugString + s + "\n";
		}
		
		public static function mood(m:int):String {
			switch(m) {
				case Mood.IDLE: 	return "IDLE";
				case Mood.NORMAL: 	return "NORMAL";
				case Mood.ATTACK: 	return "ATTACK";
				case Mood.REGRESS: 	return "REGRESS";
				case Mood.YIELD: 	return "YIELD";
				case Mood.MAKEWAY: 	return "MAKEWAY";
				case Mood.ASLEEP: 	return "ASLEEP";
				case Mood.WAIT: 	return "WAIT";
				default: return "UNKNOWN";
			}
		}
		
		public static function moodArray(m:Array):String {
			var s:String = "[";
			for (var i:int = 0; i < m.length; i++) {
				s = s + mood(m[i]) + ",";
			}
			return s.split(0,-1) + "]";
		}
		
		public static function dir(d:int):String {
			switch(d) {
				case Dir.DOWN: 	return "DOWN";
				case Dir.UP: 	return "UP";
				case Dir.RIGHT: return "RIGHT";
				case Dir.LEFT: 	return "LEFT";
				default: return "UNKNOWN";
			}
		}
		
		public static function dirArray(d:Array):String {
			var s:String = "";
			for (var i:int = 0; i < d.length; i++) {
				s = s + dir(d[i]) + ",";
			}
			return "[" + s.slice(0,-1) + "]";
		}
	}
}