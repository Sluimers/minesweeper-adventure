package nl.obg.gtk {
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author Rogier Sluimers
	 */
	public class GtkWidget extends MovieClip {
		
		private var children:Array = [];
		
		public function GtkWidget() { }
		
		public function init():void {}
		
		protected function loadXML(xml:XML):void {
			const objects:XMLList = xml.object;
			const attributes:XMLList = objects.attribute("class");
			var idName:String = "";
			var currentObject:XMLList;
			
			for (var i:int = attributes.length(); i--; ) {
				
				trace("test 1:"+attributes[i]);
				
				if (attributes[i] == "GtkWindow") {
					currentObject = objects.children()[i].children();
					
					if (currentObject.attribute("class") == "GtkVBox") {
						idName = currentObject.attribute("id");
						
						addChild(new GtkVBox(currentObject));
						//addChild( { id:isName, className:new GtkVBox(currentObject) } );
					}
				}
			}
			
			
			width = stage.stageWidth;
			height = stage.stageHeight;
			
		}
		
		/*
		public function addChild(child:*):void {
			children.add(child);
		}
		*/
	}
}