package  nl.obg.widgets {
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	
	import nl.obg.standards.*;
	/**
	 * ...
	 * @author Rogier Sluimers
	 */
	public class Widget extends EMovieClip {
		protected var align:String = "topLeft";
		
		protected var centerX:uint;
		protected var centerY:uint;
		
		protected var items:Array;
		protected var topLeftItems:Array;
		protected var topItems:Array;
		protected var topRightItems:Array;
		protected var leftItems:Array;
		protected var centerItems:Array;
		protected var rightItems:Array;
		protected var bottomLeftItems:Array;
		protected var bottomItems:Array;
		protected var bottomRightItems:Array;
		protected var eventListeners:Array;
		protected var itemEventListeners:Array;
		
		protected var rows:uint;
		protected var columns:uint;
		
		public function Widget() 
		{
			items = [];
			topLeftItems = [];
			topItems = [];
			topRightItems = [];
			leftItems = [];
			centerItems = [];
			rightItems = [];
			bottomLeftItems = [];
			bottomItems = [];
			bottomRightItems = [];
			eventListeners = [];
			itemEventListeners = [];
		}
		
		public function init():void {}
		
		public function setSize(width:int, height:int):void {
			var g:Graphics = graphics;
			g.clear();
			g.beginFill( 0x000000 , 0 );
			g.drawRect(0, 0, width, height);
			g.endFill();
		}
		
		public function move(nwX:int, nwY:int):void {
			x = nwX;
			y = nwY;
			align = "topLeft";
		}
		
		public function top(nwX:int, nwY:int):void {
			centerX = nwX - width / 2;
			x = centerX;
			y = nwY;
			align = "top";
		}
		
		public function left(nwX:int, nwY:int):void {
			centerY = nwY - width / 2;
			x = nwX;
			y = centerY;
			align = "left";
		}
		
		public function center(nwX:int, nwY:int):void {
			centerX = nwX;
			centerY = nwY;
			x = centerX - width / 2;
			y = centerY - height / 2;
			align = "center";
		}
		
		public function right(nwX:int, nwY:int):void {
			x = nwX - width;
			y = nwY;
			align = "right";
		}
		
		public function addBackground(color:int):void {
			var g:Graphics = graphics;
			
			g.beginFill(color);
			g.drawRect(0, 0, width, height);
			g.endFill();
		}
		
		public function addWidget(name:String, alignInWidget:String, alignOfWidget:String):Widget {
			var w:Widget = new Widget();
			w.align = alignOfWidget;
			switch(alignInWidget) {
				case "center": 	addCenterItem(name, w); break;
				default:		addItem(name, w); break;
			}
			switch (alignOfWidget) {
				case "center":	w.centerY = w.y; 
				case "top":		w.centerX = w.x; break;
			}
			return w;
		}
		
		public function addCenterItem(name:String, item:DisplayObject):void {
			var t:DisplayObject, i:uint = 0, th:uint = 0, h:uint = 0;
			
			addItem(name, item);
			
			// * aligning and array collecting * //
			centerItems.push(item);
			
			for (i = centerItems.length; i--; ) th = th + centerItems[i].height;
			for (i = centerItems.length; i--; ) {
				t = centerItems[i];
				h = h + t.height;
				t.x = width / 2 - t.width / 2;
				t.y = height / 2 + th / 2 - h;
			}
			
		}
		
		public function addCenterRightItem(name:String, item:DisplayObject):void {
			var t:DisplayObject, i:uint = 0, th:uint = 0, h:uint = 0;
			addItem(name, item);
			
			// * aligning and array collecting * //
			t = items[items.length - 1]; 
			rightItems.push(t);
			
			for (i = rightItems.length; i--; ) th = th + rightItems[i].height;
			for (i = rightItems.length; i--; ) {
				t = rightItems[i];
				h = h + t.height;
				t.x = width - t.width;
				t.y = height / 2 + th / 2 - h;
			}
		}
		
		public function addCenterLeftItem(name:String, item:DisplayObject):void {
			var t:DisplayObject, i:uint = 0, th:uint = 0, h:uint = 0;
			addItem(name, item);
			
			// * aligning and array collecting * //
			leftItems.push(item);
			
			for (i = leftItems.length; i--; ) th = th + leftItems[i].height;
			for (i = leftItems.length; i--; ) {
				t = leftItems[i];
				h = h + t.height;
				t.y = height / 2 + th / 2 - h;
			}
		}
		
		public function addTopLeftItem(name:String, item:DisplayObject):void {
			var h:uint = 0;
			addItem(name, item);
			
			// * aligning and array collecting * //
			topLeftItems.push(item);
			
			for (var i:uint = items.length; i--; ) {
				h = h + topLeftItems[i].height;
			}
			item.y = h;
		}
		
		public function addTopItem(name:String, item:DisplayObject):void {
			var t:DisplayObject, u:DisplayObject;
			addItem(name, item);
			
			// * aligning and array collecting * //
			t = items[items.length-1]; 
			topItems.push(t);
			
			for (var i:uint = topItems.length; i--; ) {
				t = topItems[i];
				t.x = width / 2 - t.width / 2;
			}
			t = items[items.length - 1]; 
			t.x = width / 2 - t.width / 2;
		}
		
		private function addTopRightItem(name:String, item:DisplayObject):void {
			var t:DisplayObject, u:DisplayObject;
			addItem(name, item);
			
			// * aligning and array collecting * //
			t = items[items.length-1]; 
			topItems.push(t);
			
			t.x = width - t.width;
			
			/*
			for (var i:uint = items.length; i--; ) {
				t = topRightItems[i];
				u = topRightItems[i - 1];
				t.y = u.y + u.height;
				t.x = width - t.width;
			}*/
		}
		
		private function addItem(name:String, item:DisplayObject):void {
			item.name = name;
			addChild(item);
			items.push(item);
			reAlign();
		}
		
		private function newTextField(text:String, size:int, color:int, align:String = "left"):WTextField {
			var t:WTextField = new WTextField();
			var tf:TextFormat = new TextFormat();
			tf.font = "Verdana";
			tf.size = size;
			tf.color = color;
			
			if (align == "center") {
				tf.align = align;
				t.autoSize = TextFieldAutoSize.CENTER;
			}
			
			t.selectable = false;
			t.autoSize = TextFieldAutoSize.LEFT;
			t.align = align;
			t.text = text;
			
			// TODO: fix alignments
			// t.border = true;
			
			t.setTextFormat(tf);
			t.defaultTextFormat = tf;
			
			return t;
		}
		
		public function addText(name:String, text:String, size:int = 16, color:int = Color.DARKGRAY0):void {
			var t:WTextField, u:WTextField, i:uint;
			
			t = newTextField(text, size, color);
			addTopLeftItem(name, t);
		}
		
		public function addTopText(name:String, text:String, size:int = 16, color:int = Color.DARKGRAY0):void {
			var t:WTextField, i:uint;
			
			t = newTextField(text, size, color);
			addTopItem(name, t);
			
			topItems.push(t);
		}
		
		public function addRightText(name:String, text:String, size:int = 16, color:int = Color.DARKGRAY0):void {
			var t:WTextField;
			
			t = newTextField(text, size, color);
			addTopRightItem(name, t);
		}
		
		public function addCenterRightText(name:String, text:String, size:int = 16, color:int = Color.DARKGRAY0):void {
			var t:WTextField = newTextField(text, size, color);
			addCenterRightItem(name, t);
		}
		
		public function addCenterLeftText(name:String, text:String, size:int = 16, color:int = Color.DARKGRAY0):void {
			var t:WTextField = newTextField(text, size, color);
			addCenterLeftItem(name, t);
		}
		
		public function addCenterText(name:String, text:String, size:int = 16, color:int = Color.DARKGRAY0):void {
			var t:WTextField = newTextField(text, size, color, "center");
			addCenterItem(name, t);
		}
		
		public function addBottomText(name:String, text:String, size:int = 16, color:int = Color.DARKGRAY0):void {
			var t:WTextField;
			addText(name, text, size, color);
			t = items[items.length - 1]; 
			t.y = height - t.height;
		}
		
		public function addBottomCenterText(name:String, text:String, size:int = 16, color:int = Color.DARKGRAY0):void {
			var t:WTextField = newTextField(text, size, color, "bottomcenter");
			addCenterItem(name, t);
			t = items[items.length - 1]; 
			t.y = height - t.height;
		}
		
		public function addBottomRightText(name:String, text:String, size:int = 16, color:int = Color.DARKGRAY0):void {
			var t:WTextField;
			addRightText(name, text, size, color);
			t = items[items.length - 1]; 
			t.y = height - t.height;
		}
		
		public function editText(name:String, text:String):void {
			var i:uint = items.length;
			var t:WTextField;
			
			for (i = items.length; i--; ) {
				t = items[i]; 
				if (t.name == name) {
					t.text = text;
					reAlignText(t);
					reAlign();
					return;
				}
			}
			
			trace("error: menu object " + name +" not found!");
		}
		
		private function reAlignText(t:WTextField):void {
			switch (t.align) {
				case "center":
				t.y = centerY - (t.height >> 1);
				case "bottomcenter": 
				case "topcenter":
				t.x = centerX - (t.width >> 1); break;
				case "left":
				case "right":
				//t.y = centerY - (t.height >> 1); break;
				break;
			}
		}
		
		private function reAlign():void {
			switch (align) {
				case "center":
				y = centerY - (height >> 1);
				case "bottomcenter": 
				case "topcenter":
				x = centerX - (width >> 1); break;
				case "left":
				case "right":
				y = centerY - (height >> 1); break;
				break;
			}
		}
		
		public function getItemIndex(name:String):int {
			var i:uint = items.length;
			var t:DisplayObject;
			
			for (i = items.length; i--; ) {
				t = items[i]; 
				if (t.name == name) {
					return i;
				}
			}
			return -1;
		}
		
		public function getItem(name:String):DisplayObject {
			var i:uint = items.length;
			var t:DisplayObject;
			
			for (i = items.length; i--; ) {
				t = items[i]; 
				if (t is Widget) {
					t = (t as Widget).getItem(name);
					if (t != null) return t;
				}
				else if (t.name == name) {
					return t;
				}
			}
			return null;
		}
		
		public function getLastItem():WTextField {
			return items[items.length-1];
		}
		
		public function removeItems():void {
			for (var i:uint = items.length; i--; ) removeItem(items[i]);
			
			items = null;
			
			topLeftItems = null;
			topItems = null;
			topRightItems = null;
			leftItems = null;
			centerItems = null;
			rightItems = null;
			bottomLeftItems = null;
			bottomItems = null;
			bottomRightItems = null;
		}
		
		public override function addEventListener (type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void { 
			items[items.length - 1].addEventListener (type, listener, useCapture, priority, useWeakReference);
			if (eventListeners == null) eventListeners = [];
			eventListeners.push({ type:type, listener:listener});
		}
		
		public function addItemEventListener (name:String, type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void { 
			var i:int = getItemIndex(name);  
			if (i != -1) {
				items[i].addEventListener (type, listener, useCapture, priority, useWeakReference);
				if (itemEventListeners == null) itemEventListeners = [];
				itemEventListeners.push( { id:i, type:type, listener:listener } );
			}
		}
		
		public function getItems():Array {
			return items;
		}
		
		public function removeEvents():void {
			var i:uint, o:Object, s:String;
			
			if(eventListeners != null) {
				for (i = eventListeners.length; i--; ) {
					o = eventListeners[i];
					s = o.type;
					if (hasEventListener(s)) {
						removeEventListener(s, o.listener);
					}
				}
				eventListeners = null;
			}
			
			if(itemEventListeners != null) {
				for (i = itemEventListeners.length; i--; ) {
					o = itemEventListeners[i];
					s = o.type;
					if (hasEventListener(s)) {
						items[o.id].removeEventListener(s, o.listener);
					}
				}
				itemEventListeners = null;
			}
		}
	}
}