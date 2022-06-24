package nl.obg.menus {
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import nl.obg.gtk.GtkWidget;
	
	public class StartMenu2 extends GtkWidget {
		
		public function StartMenu2():void {
			super();
		}
		
		public override function init():void {
			try {
				const xmlWidget:XML = PObjectList.getXMLData(LocalPathName.menus + "MainMenu.glade");
			}
			catch(error:Error) {
				trace("Error catch: " + error);
			}
			loadXML(xmlWidget);
			Engine.addHookTimer(keyControl);
		}
		
		public function keyControl():void {
			const kpq:Array = Engine.keyPressedQueue, kpql:uint = kpq.length;
			const key:int = Engine.keyPressed;
			
			if (key == -1) return;
			
			switch(key) {
				case Key.ENTER: 
					 startMineSweeper(); 
				break;
			}
		}
		
		public function start(event:MouseEvent):void {
			startMineSweeper();
		}
		
		public function startMineSweeper():void {
			Engine.removeHooks();
			Engine.startGame();
		}
	}
}