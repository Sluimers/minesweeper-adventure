package nl.obg.mapsprites {
	import flash.filters.DisplacementMapFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	import nl.obg.engine.*;
	import nl.obg.mine.*;
	import nl.obg.locals.*;
	
	public class NumberLight extends MapSprite {
		
		public var number:int;
		
		public function NumberLight(x:int, y:int, z:int, n:int) {
			const mw:uint = Map.mapWidth, ms:uint = Map.mapSize;
			
			name = 		"NumberLight";
			number = 	n;
			
			setHotXY(n);
			
			// now it loads the sprite twice, which is one too many times
			super(x, y, z, n + ".png");
			
			if (Map.isCovered[xyz]) visible = false;
			MineMap.numberLights[xyz] = this;
		}
		
		public function setNumber(n:int):void {
			if(number != n) {
				number = n;
				setHotXY(n);
				loadSprite(PObjectList.getBitmapData(spriteName));
			}
		}
		
		private function setHotXY(n:int):void {
			switch(n) {
				case 1: hotx = 0; hoty = 0; break;
				case 2: hotx = 0; hoty = 6; break;
				case 3: hotx = 0; hoty = 10; break;
			}
		}
	}
}