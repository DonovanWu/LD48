package  
{
	import core.Player;
	import org.flixel.*;
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	public class TitleScreen extends FlxState
	{
		public var _titlescreen:FlxSprite = new FlxSprite();
		public var _player:Player = new Player();
		public var _msg:FlxText;
		public var _init:Boolean = false;
		
		public var _ct:Number = 0;
		
		public override function create():void {
			super.create();
			
			// title screen
			_titlescreen.loadGraphic(Resource.IMPORT_TITLESCREEN);
			_titlescreen.set_position(0, 0);
			this.add(_titlescreen);
			
			// player
			_player.set_pos(-50, 255);
			this.add(_player);
			
			// flashing text
			_msg = new FlxText(75, 200, 160, "Press Enter To Start.\nArrow Keys to Control.");
			_msg.color = 0x990000;
			this.add(_msg);
		}
		
		public override function update():void {
			super.update();
			
			if (_player.x() <= 350) {
				_player.walk(1);
			} else {
				_player.stand();
			}
			
			_ct++;
			if (_ct % 60 == 0) {
				_msg.visible = !(_msg.visible);
			}
			
			if (FlxG.keys.justPressed("ENTER")) {
				FlxG.switchState(new FishingGame());
			}
		}
	}

}