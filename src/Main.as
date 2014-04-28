package 
{
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	import flash.display.*;
	import flash.events.*;
	import org.flixel.FlxGame;
	import org.flixel.FlxG;
	
	[SWF(backgroundColor = "#000000", frameRate = "60", width = "640", height = "360")]
	[Frame(factoryClass="Preloader")]
	
	public class Main extends FlxGame {

		public function Main():void {
			// super(640, 360, FishingGame);
			super(640, 360, TitleScreen);
		}
	}
	
}