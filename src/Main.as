package {
	import nl.obg.widgets.Preloader;
	import nl.obg.standards.EMovieClip;
	import nl.obg.engine.*;
	import nl.obg.www.*;
	import nl.obg.controllers.*;
	
	import flash.display.Graphics;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	// needs an instance, without it, it has no stage.
 	public class Main extends EMovieClip {
		private static const preloader:Preloader = new Preloader();
		
		public function Main() {
			Engine.addMain(this);
			stage.align = "left";
			
			Settings.checkForFullScreen(stage);
			
			stage.addChild(preloader);
			preloader.init();
			
		}
		
		public function init():void {
			addCanvas();
			
			stage.addEventListener(Event.ENTER_FRAME, Engine.run);
			stage.addEventListener(KeyboardEvent.KEY_UP, KeyControl.onKeyUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyControl.onKeyDown);
			stage.addEventListener(MouseEvent.CLICK, MouseControl.onMouseClick);
			stage.addEventListener(Event.DEACTIVATE, Engine.windowNotActive);
			stage.addEventListener(Event.ACTIVATE, Engine.windowActive);
		}
		
		private function addCanvas():void {
			const g:Graphics = graphics, w:int = stage.stageWidth, h:int = stage.stageHeight;
			
			Engine.canvas = new BitmapData(w, h, true, 0x000000);
			
			g.clear();
			g.beginBitmapFill(Engine.canvas);
			g.drawRect(0, 0, w, h);
			g.endFill();
		}
	}
}