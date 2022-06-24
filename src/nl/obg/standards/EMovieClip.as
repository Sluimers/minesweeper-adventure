package nl.obg.standards {
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	
	/**
	 * A few extra functions movieclip or Sprite should have.
	 * @author Rogier Sluimers
	 */
	public class EMovieClip extends MovieClip {
		// stick at one menu
		// protected var menu:Widget;
		
		public function EMovieClip() {
			
		}
		
		public function removeItem(i:DisplayObject):void {	
			var item:DisplayObject = i as DisplayObject;
			if(item != null) {					
				if(item.parent != null){
					removeChild(item);
				}
			}
		}
		
		public function getChildren():String {
			var ch:String;
			
			if (!i) return null;
			ch = ""+getChildAt(0);
			for (var i:int = 0; i < numChildren; i++) {
				ch = ch + "," + getChildAt(i);
			}
			
			return ch;
		}
	}

}