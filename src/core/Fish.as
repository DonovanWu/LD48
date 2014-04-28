package core 
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import particles.Bubble;
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	public class Fish extends FlxSprite
	{
		private var _ct:Number = 0;
		private var _left:Boolean = true;
		private var _right:Boolean = true;
		private var _old_swim:Number = 1;
		public var _weight:Number = 1;
		private var _caught:Boolean = false;
		public var _shouldrm:Boolean = false;
		
		public function Fish() 
		{
			var choice:int = Util.random_int(1, 5);
			switch(choice) {
				case 1:
					this.loadGraphic(Resource.IMPORT_FISH1);
					this._weight = 1;
					this.y = Util.random_float(400, 500);
					break;
				case 2:
					this.loadGraphic(Resource.IMPORT_FISH2);
					this._weight = 1;
					this.y = Util.random_float(400, 500);
					break;
				case 3:
					this.loadGraphic(Resource.IMPORT_FISH3);
					this._weight = 2;
					this.y = Util.random_float(400, 500);
					break;
				case 4:
					this.loadGraphic(Resource.IMPORT_SHARK1);
					this._weight = 5;
					this.y = Util.random_float(475, 575);
					break;
				default:
					this.loadGraphic(Resource.IMPORT_SHARK2);
					this._weight = 5;
					this.y = Util.random_float(475, 575);
					break;
			}
			
			// generate random swim pattern
			var left:Number = Util.random_float(1, 5);
			var right:Number = Util.random_float(1, 5);
			if (left <= 3) {
				_left = false;
				this.x = 768;
			} else if (right <= 3) {
				_right = false;
				this.x = -128;
			} else {
				this.x = -128;
			}
		}
		
		public function update_fish(g:FishingGame):void {
			if (!_caught) {
				_ct++;
				var swimmed:Boolean = false;
				
				// bubbles
				if (_ct % 10 == 0) {
					var dx:Number = 0;
					var ang:Number = Util.random_float(-75, -45);
					if (this.scale.x < 0) {
						dx = this.width;
						ang = 180 - ang;
					}
					g._bubbles.add(new Bubble(this.x + dx, this.y, ang));
				}
				
				// swim AI
				if (_ct >= 1800) {
					swim(1);
					swimmed = true;
				} else {
					if (is_out_of_bound() < 0) {
						swim(1);
						swimmed = true;
					} else if (is_out_of_bound() > 0) {
						swim( -1);
						swimmed = true;
					} else if (!_left && this.x < 320) {
						swim(1);
						swimmed = true;
					} else if (!_right && this.x > 320) {
						swim( -1);
						swimmed = true;
					}
				}
				
				if (!swimmed) {
					swim(_old_swim);
				}
				
				// float effect
				this.y += 0.2 * Math.sin(_ct * Util.RADIAN);
				
				// custom overlap test
				var bx:Number = g._player._bait.x + 6;
				var by:Number = g._player._bait.y + 6;
				var x0:Number = this.x;
				if (this.scale.x < 0) {
					x0 = this.x + this.width;
				}
				if (Math.abs(x0 - bx) <= 10 && Math.abs(this.y + this.height / 2 - by) <= 10 && !g._player._occupied) {
					trace("caught");
					g._player._occupied = true;
					caught();
				}
			} else {
				// caught
				this.set_position(g._player._bait.x - this.width / 2, g._player._bait.y - this.height / 2);
				this.angle = -80;
				if (this.y <= 360) {
					_shouldrm = true;
					g._player._occupied = false;
					g._score += _weight;
					FlxG.play(Resource.IMPORT_SOUND_SCORE, 2);
				}
			}
		}
		
		public function swim(vx:Number = 0):void {
			if (vx < 0) {
				this.scale.x = 1;
			} else {
				this.scale.x = -1;
			}
			this.x += vx;
			_old_swim = vx;
		}
		
		public function is_out_of_bound():int {
			if (this.x <= 0 - this.width) {
				return -1;
			} else if (this.x >= Util.WID + this.width) {
				return 1;
			} else {
				// not out of bound
				return 0;
			}
		}
		
		public function caught():void {
			_caught = true;
		}
		
		public function should_remove():Boolean {
			return (_ct >= 1800 && is_out_of_bound() != 0) || (_shouldrm);
		}
	}

}