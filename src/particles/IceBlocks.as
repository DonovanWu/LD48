package particles 
{
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	public class IceBlocks extends FlxSprite
	{
		public var _should_fall:Boolean = false;
		public var _vx:Number = 0;
		public var _vy:Number = 3;
		public var _theta:Number = 0;
		public var _friction:Number = 0.9;
		
		public const STATUS_ONE:String = "STATUS_ONE";
		public const STATUS_TWO:String = "STATUS_TWO";
		public const STATUS_THREE:String = "STATUS_THREE";
		public const STATUS_DRILLED:String = "STATUS_DRILLED";
		
		public function IceBlocks() 
		{
			var choice:int = Util.random_int(1, 3);
			this.loadGraphic(Resource.IMPORT_ICEBLOCK, true, false, 40, 30);
			this.addAnimation(STATUS_ONE, [0]);
			this.addAnimation(STATUS_TWO, [1]);
			this.addAnimation(STATUS_THREE, [2]);
			this.addAnimation(STATUS_DRILLED, [3]);
			
			switch(choice) {
				case 1:
					this.play(STATUS_ONE);
					break;
				case 2:
					this.play(STATUS_TWO);
					break;
				case 3:
					this.play(STATUS_THREE);
					break;
			}
			
			// this.play(STATUS_DRILLED);
			
			this.health = 100;
		}
		
		public override function kill():void {
			super.kill();
			exists = true;
			this.play(STATUS_DRILLED);
		}
		
		public function update_iceblock():void {
			if (_should_fall) {
				this.x += _vx;
				this.y += _vy;
				_vx *= _friction;
				_vy *= _friction;
				this.angle += _theta;
			}
		}
		
		public function fall(vx:Number):void {
			_should_fall = true;
			_vx = vx;
			_theta = vx;
		}
	}

}