package nl.obg.debug {
	
    import flash.display.*;
    import flash.geom.*;
    public class DText {
        public static const LEFT:int = 0;
        public static const RIGHT:int = 1;
        public static const CENTER:int = 2;
        
        public static var chars:BitmapData;
        
        private static const DEFAULT_CHAR:Number = '?'.charCodeAt(0);
        private static const NEW_LINE:Number = '\n'.charCodeAt(0);

        private static const CHAR_RECTS:Object = new Object();
        //static
        {
            (function():void {
                var i:int;
				
				for (i = 32; i < 161; i++){
                    CHAR_RECTS[i] = new Rectangle(((i - 32) % 16) * 16, (int)((i - 32) / 16) * 16, 9, 16);
                }
            }());
        }
		
		public static function init(bd:BitmapData):void {
			if (bd == null) trace("error: no bitmapdata for Debugger");
			chars = bd;
		}
        
        public static function draw(buffer:BitmapData, text:String, x:int = 0, y:int = 0, align:int = DText.LEFT):void {
            var lines:Array = text.split('\n');
			var len:uint = lines.length;
            var line:String;
			var linelen:uint;
			var n:int;
			
			for (n = 0; n < len; n++) {
				line = lines[n];
				linelen = line.length;
                if (align == LEFT)
                    drawLine(buffer, line, x, y);
                else if (align == RIGHT)
                    drawLine(buffer, line, x - line.length * 8, y);
                else // CENTER
                    drawLine(buffer, line, x - line.length * 8 / 2, y);
                y += 13;
            }
        }
        
        private static function drawLine(buffer:BitmapData, text:String, x:int, y:int):void {
            var p:Point = new Point(x, y);
            var len:int = text.length;
            for (var n:int = 0; n < len; n++) {
                var c:Number = text.charCodeAt(n);
                if (c > 160 || c < 32)
                    c = DEFAULT_CHAR;
                buffer.copyPixels(chars, CHAR_RECTS[c], p, null, null , true);
                p.x += 8;
            }
        }
    }
}