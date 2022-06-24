package nl.obg.widgets {
	/**
	 * ...
	 * @author Rogier Sluimers
	 */
	import flash.display.Graphics;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.ProgressEvent;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.display.Loader;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import nl.obg.standards.Color;
	import nl.obg.locals.*;
	 
	public class Preloader extends ScreenWidget
	{
		public static const DEFAULT_COLOR:uint = Color.WHITESMOKE;
		public static const DEFAULT_DARK_COLOR:uint = Color.DARKGRAY1;
		public static const TEXTSIZE:uint = 20;
		
		private static var introFilm:IntroFilm;
		private static var objectPaths:Array = [];
		private static var loader:Loader;
		private static var urlLoader:URLLoader;
		private static var loaderType:String;
		private static var objectsLoaded:int = 0;
		private static var objectContent:Array = [];
		
		public function Preloader() {
			
		}
		
		public override function init():void {
			super.init();
			
			setSize(stageWidth, stageHeight);
			center(stageWidth >> 1, stageHeight >> 1);
			
			addPreloadBar();
			
			objectPaths = PathName.files;
			loadObject();
		}
		
		private function addPreloadBar():void {
			addBottomCenterText("progress", " ", TEXTSIZE, DEFAULT_DARK_COLOR);
		}
		
		private function onProgress(event:ProgressEvent):void {
			
			if(loaderType == "loader") {
				var loaded:Number = loader.contentLoaderInfo.bytesLoaded;
				var total:Number = loader.contentLoaderInfo.bytesTotal;
				var percLoaded:Number = loaded / total * 100;
			}
			
		}
		
		private function loadObject(i:int = 0):void {
			
			if (objectPaths[i].slice( -4, objectPaths[i].length) == ".xml" || objectPaths[i].slice( -6, objectPaths[i].length) == ".glade") {
				urlLoader = new URLLoader();
				urlLoader.addEventListener (Event.COMPLETE, onComplete);
				urlLoader.addEventListener (ProgressEvent.PROGRESS, onProgress);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				urlLoader.load (new URLRequest (objectPaths[i]));
				loaderType = "urlLoader";
			}
			else {
				loader = new Loader ();
				loader.contentLoaderInfo.addEventListener (Event.COMPLETE, onComplete);
				loader.contentLoaderInfo.addEventListener (ProgressEvent.PROGRESS, onProgress);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				loader.load (new URLRequest (objectPaths[i]));
				loaderType = "loader";
			}
		}
		
		private function onCompleteOBG(event:Event):void {
			
			loadObject(objectsLoaded);
		}
		
		private function drawBackgroundImage(imageData:BitmapData):void {
			var imgX:Number = 0, imgY:Number = 0, imgHeight:Number, imgWidth:Number;
			
			// This changes the width of the, thus 
			//graphics.clear();
			
			imgHeight = imageData.height;
			imgWidth = imageData.width;
			if (imgWidth < stageWidth) imgX = (stageWidth - imgWidth) >> 1;
			if (imgHeight < stageHeight) imgY = (stageHeight - imgHeight) >> 1;
			
			graphics.beginBitmapFill(imageData, new Matrix(1, 0, 0, 1, imgX, imgY), false, true);
			graphics.drawRect(imgX, imgY, imgWidth, imgHeight);
			
			graphics.endFill();
		}
		
		private function onComplete(event:Event):void {
			if (loaderType == "loader") {
				if (objectPaths[objectsLoaded] == PathName.introDir + PathName.introBackground) {
					drawBackgroundImage(event.currentTarget.content.bitmapData);
				}
				else objectContent[objectsLoaded] = event.currentTarget.content;
				loader.contentLoaderInfo.removeEventListener (Event.COMPLETE, onComplete);
				loader.contentLoaderInfo.removeEventListener (ProgressEvent.PROGRESS, onProgress);
				loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			}
			else {
				objectContent[objectsLoaded] = event.target.data;
				urlLoader.removeEventListener (Event.COMPLETE, onComplete);
				urlLoader.removeEventListener (ProgressEvent.PROGRESS, onProgress);
				urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			}
			
			objectsLoaded++;
			var percLoaded:int = objectsLoaded / objectPaths.length * 100;
			
			editText("progress", " " + percLoaded + "% loaded");
			
			if (objectsLoaded != objectPaths.length) loadObject(objectsLoaded);
			else {
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			}
		}
		
		private function onIOError(evt:IOErrorEvent):void {
			trace("IOError: " + evt.text);
		}
		
		public  function onKeyDown(event:KeyboardEvent = null):void {
			if (event.keyCode == Keyboard.ENTER) {
				stage.removeEventListener (KeyboardEvent.KEY_DOWN, onKeyDown);
				PObjectList.setPreloadObjects(objectContent, objectPaths);
				introFilm = new IntroFilm();
				stage.addChild(introFilm);
				stage.removeChild(this);
				introFilm.init();
			}
		}
	}

}