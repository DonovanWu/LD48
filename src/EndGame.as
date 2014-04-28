package  
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxG;
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	public class EndGame extends FlxState
	{
		private var _bg:FlxSprite = new FlxSprite();
		private var _init:Boolean = false;
		
		public function EndGame(win:Boolean) 
		{
			if (win) {
				_bg.loadGraphic(Resource.IMPORT_ENDSCREEN2);
			} else {
				_bg.loadGraphic(Resource.IMPORT_ENDSCREEN1);
			}
			this.add(_bg);
		}
		
		public override function update():void {
			super.update();
			
			if (!_init) {
				FlxG.flash(0xffffffff, 5);
				_init = true;
			}
			
			if (FlxG.keys.justPressed("R")) {
				FlxG.fade(0xff000000, 5, function () {
					FlxG.switchState(new TitleScreen());
				});
			}
		}
	}

}