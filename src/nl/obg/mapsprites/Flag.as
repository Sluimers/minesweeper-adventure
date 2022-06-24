package nl.obg.mapsprites {
	import flash.filters.DisplacementMapFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	
	import nl.obg.engine.*;
	import nl.obg.mine.*;
	import nl.obg.debug.*;
	
	public class Flag extends MapSprite {
		private var numberField:TextField;
		
		public function Flag(x:int, y:int, z:int) {
			name = "Flag";
			
			hotx = 5;
			hoty = 25; 
			
			super(x, y, z, name + ".png");
			
			const xyz:int = tx + ty * mapWidth + z * mapSize;
			var number:uint = 0;
			var mx:int, my:int, mi:uint = 3, mj:uint, mk:int, ml:int;
			var hasMine:Array = MineMap.hasMine, hasObs:Array = Map.hasObs;
			var color:uint = 0;
			var showNumber:Boolean = false;
			
			numberField = new TextField();
			
			MineMap.hasFlag[xyz] 	= true;
			
			while (--mi -( -1)) {
				mj = 3;
				while (--mj -( -1)) {
					if (mi == 1) if (mj == 1) mj--;
					mx = tx + mi - 1;
					my = ty + mj - 1;
					if (hasMine[mx]) {
						if (!showNumber) {
							if (mi == 1 || mj == 1) {
								
								mk = mi - 1;
								ml = mj - 1;
								if (mk < 0) mk = 2; 
								if (ml < 0) ml = 2;
								if (hasMine[mk] || hasObs[mk]) showNumber = true;
								
								mk = mi + 1;
								ml = mj - 1;
								if (mk > 2) mk = 0; 
								if (ml < 0) ml = 2;
								if (hasMine[mk] || hasObs[mk]) showNumber = true;
								
								mk = mi - 1;
								ml = mj + 1;
								if (mk < 0) mk = 2; 
								if (ml > 2) ml = 0;
								if (hasMine[mk] || hasObs[mk]) showNumber = true;
								
								mk = mi + 1;
								ml = mj + 1;
								if (mk > 2) mk = 0; 
								if (ml > 2) ml = 0;
								if (hasMine[mk] || hasObs[mk]) showNumber = true;
							}
						}
						number++;
					}
				}
			}
			
			numberField.autoSize = TextFieldAutoSize.LEFT;
			if(showNumber) numberField.text = ""+number;
			numberField.mouseEnabled = false;
			numberField.selectable = false;
			
			if(number == 8)		color = 0x000000;
			else if(number == 7)color = 0xaaaaaa; 
			else if(number == 6)color = 0xcc00cc;
			else if(number == 5)color = 0x00bbbb;
			else if(number == 4)color = 0xbbbb00;
			else if(number == 3)color = 0xbb0000;
			else if(number == 2)color = 0x00bb00;
			else if(number == 1)color = 0x0000ff;
			
			numberField.x = 19;
			numberField.y = 9;
			
			numberField.setTextFormat(new TextFormat("Verdana", 8, color, true));
			
		}
		
		public override function updateAnimation():void {
			Debug.addDebugLine(Engine.getXYZ(this));
			super.updateAnimation();
		}
		
		
	}
}