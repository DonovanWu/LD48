package  
{
	import org.flixel.FlxState;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	public class EndGame extends FlxState
	{
		private var _win:Boolean;
		
		public function EndGame(win:Boolean) 
		{
			this._win = win;
			FlxG.flash(0xff000000, 5);
		}
		
		public override function update():void {
			super.update();
			
			if (FlxG.keys.justPressed("R")) {
				FlxG.switchState(new TitleScreen());
			}
		}
	}

}