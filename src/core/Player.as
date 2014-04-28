package core 
{
	import org.flixel.FlxEmitter;
	import org.flixel.FlxGroup;
	import org.flixel.FlxG;
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	public class Player extends FlxGroup
	{
		public const ANIM_STAND:String = "ANIM_STAND";
		public const ANIM_WALK:String = "ANIM_WALK";
		public const ANIM_FISH:String = "ANIM_FISH";
		public const ANIM_DRILL:String = "ANIM_DRILL";
		public const ANIM_SCORCH:String = "ANIM_SCORCH";
		public const ANIM_LOOKUP:String = "ANIM_LOOKUP";
		public const ANIM_LOOKAWAY:String = "ANIM_LOOKAWAY";
		public const ANIM_WELLWELL:String = "ANIM_WELLWELL";
		
		public var _body:FlxSprite = new FlxSprite();
		public var _bait:FlxSprite = new FlxSprite();
		public var _thread:FlxSprite = new FlxSprite();
		public var _bait_home_y:Number = 340;
		public var _occupied:Boolean = false;
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _flipped:Boolean = false;
		
		public function Player(x:Number = 0, y:Number = 0) 
		{
			_body.loadGraphic(Resource.IMPORT_PLAYER, true, false, 45, 75);
			_body.addAnimation(ANIM_STAND, [0]);
			_body.addAnimation(ANIM_WALK, [1, 2, 3, 2], 6);
			_body.addAnimation(ANIM_FISH, [4]);
			_body.addAnimation(ANIM_LOOKUP, [5]);
			_body.addAnimation(ANIM_DRILL, [6, 7], 30);
			_body.addAnimation(ANIM_SCORCH, [8, 8, 8, 8, 8, 8, 9, 8, 9, 8, 9, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8], 6);
			_body.addAnimation(ANIM_LOOKAWAY, [10]);
			_body.addAnimation(ANIM_WELLWELL, [11]);
			this.add(_body);
			
			_bait.loadGraphic(Resource.IMPORT_BAIT);
			_bait.visible = false;
			_bait.y = _bait_home_y;
			this.add(_bait);
			
			_thread.makeGraphic(1, 10, 0xff999999);
			_thread.visible = false;
			_thread.y = _bait_home_y - 10;
			this.add(_thread);
			
			_x = x;
			_y = y;
			
			update_position();
		}
		
		public function update_player():void {
			update_position();
		}
		
		public function update_position():void {
			_body.set_position(_x, _y);
			_bait.x = _x + 16.5;
			_thread.x = _x +22.5;
		}
		
		public function set_pos(x:Number, y:Number):void {
			_x = x;
			_y = y;
			update_position();
		}
		
		public function x(dx:Number = 0):Number {
			if (dx != 0) {
				_x += dx;
				update_position();
			}
			return _x;
		}
		
		public function y(dy:Number = 0):Number {
			if (dy != 0) {
				_y += dy;
				update_position();
			}
			return _y;
		}
		
		public function stand():void {
			_body.play(ANIM_STAND);
		}
		
		public function walk(vx:Number = 0):void {
			if (vx < 0) {
				_body.scale.x = -1;
			} else {
				_body.scale.x = 1;
			}
			_body.play(ANIM_WALK);
			x(vx);
		}
		
		public function drill():void {
			_body.play(ANIM_DRILL);
			FlxG.play(Resource.IMPORT_SOUND_HIT, 0.3);
		}
		
		public function look_away(dir:Number = 1):void {
			if (dir < 0) {
				_body.scale.x = -1;
			} else {
				_body.scale.x = 1;
			}
			_body.play(ANIM_LOOKAWAY);
		}
		
		public function well_well():void {
			_body.play(ANIM_WELLWELL);
		}
		
		public function fish():void {
			_thread.visible = true;
			_bait.visible = true;
			_body.play(ANIM_FISH);
		}
		
		public function unfish():void {
			_thread.visible = false;
			_bait.visible = false;
		}
		
		public function scorch():void {
			_body.play(ANIM_SCORCH);
		}
	}

}