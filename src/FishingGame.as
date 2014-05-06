package  
{
	import core.Fish;
	import core.Player;
	import core.Submarine;
	import org.flixel.*;
	import flash.display.*;
	import particles.Bubble;
	import particles.Explosion;
	import particles.IceBlocks;
	import particles.Torpedo;
	import particles.WaterWeed;
	/**
	 * ...
	 * @author Wenrui Wu
	 */
	public class FishingGame extends FlxState
	{
		public const BAIT_SPD:Number = 2;
		public const POS_TOL:Number = 15;
		
		public var _camera_icon:FlxSprite = new FlxSprite();
		
		public var _bg:FlxSprite = new FlxSprite();
		public var _iceblocks:FlxGroup = new FlxGroup();
		public var _dialogs:FlxGroup = new FlxGroup();
		public var _autobaits:FlxGroup = new FlxGroup();
		public var _explosions:FlxGroup = new FlxGroup();
		public var _submarines:FlxGroup = new FlxGroup();
		public var _torpedos:FlxGroup = new FlxGroup();
		// public var _waterweeds:FlxGroup = new FlxGroup();
		
		public var _player:Player = new Player();
		public var _fishing:Boolean = false, _moving:Boolean = false, _drilling:Boolean = false;
		public var _threadlen:Number = 10;
		public var _booty:Number = 0;
		
		public var _intro:Boolean = true, _in_game:Boolean = false, _end_game:Boolean = false, _win:Boolean = false;
		public var _init:Boolean = false, _shaked:Boolean = false;
		public var _ct:Number = 0;
		public var _scorch_ct:int = 0;
		
		public var _bubbles:FlxGroup = new FlxGroup();
		public var _fishes:FlxGroup = new FlxGroup();
		
		public var _score:uint = 0;
		public var _score_board:FlxText;
		public var _instruction:FlxText;
		public var _skip_text:FlxText;
		
		public override function create():void {
			super.create();
			
			// background
			_bg.loadGraphic(Resource.IMPORT_BG);
			_bg.set_position(0, 0);
			this.add(_bg);
			
			/* waterweeds
			var waterweed1:WaterWeed = new WaterWeed(320, 640, -5).green_version();
			var waterweed2:WaterWeed = new WaterWeed(325, 640, 0);
			_waterweeds.add(waterweed1);
			_waterweeds.add(waterweed2);
			this.add(_waterweeds);
			*/
			
			// sets
			this.add(_submarines);
			this.add(_fishes);
			this.add(_torpedos);
			this.add(_bubbles);
			
			// ice blocks
			create_iceblocks();
			this.add(_iceblocks);
			
			// player
			_player.set_pos(350, 255);
			this.add(_player);
			this.add(_dialogs);
			this.add(_autobaits);
			
			this.add(_explosions);
			
			// camera
			_camera_icon.width = 1;
			_camera_icon.height = 1;
			_camera_icon.set_position(Util.WID / 2, Util.HEI / 2);
			_camera_icon.fill(0xFF66CCFF);
			_camera_icon.visible = false;	// turn on for debug
			this.add(_camera_icon);
			FlxG.camera.follow(_camera_icon);
			
			// score board
			_score_board = new FlxText(20, 20, 160, "", false);
			_score_board.text = "Weight: " + _score + " lb";
			_score_board.setFormat("sans-serif", 12, 0x000000);
			this.add(_score_board);
			
			// instruction
			_instruction = new FlxText(80, 100, 320, "", false);
			_instruction.text = "Instruction:\n" + 
							   "Press Down Arrow Key to fish, Up to pull the thread back.\n" +
							   "When not fishing, you may drill holes on ice by pressing Down,\n" + 
							   "but it won't be effective. Try to find a more effective way!\n" +
							   "But be sure not to make too many holes, or the icecap may break\n" +
							   "And you'll fall into river!";
			_instruction.setFormat("sans-serif", 12, 0xFF0000);
			_instruction.visible = false;
			this.add(_instruction);
			
			// skip text
			_skip_text = new FlxText(480, 80, 100, "", false);
			_skip_text.setFormat("sans-serif", 12, 0xFF0000);
			_skip_text.text = "Press ENTER to skip intro";
			_skip_text.visible = false;
			this.add(_skip_text);
		}
		
		public override function update():void {
			super.update();
			_ct++;
			update_explosion();
			update_skip_text();
			// update_waterweeds();
			if (_intro) {
				// introduction
				if (!_init) {
					FlxG.flash(0x00000000);
					_init = true;
					return;
				} else {
					var timer:Array = [120, 640, 660, 900, 1320, 1440, 1560, 1800, 2100, 2160];
					for (var k:int = 0; k < timer.length; k++ ) {
						timer[k] /= 1;	// test change point
					}
					for (var j:int = 0; j < timer.length - 1; j++ ) {
						if (_ct >= timer[j] && _ct < timer[j + 1]) {
							intro_event(j+1);
						}
					}
					if (_ct >= timer[timer.length - 1] || FlxG.keys.justPressed("ENTER")) {
						// going into game
						_intro = false;
						_in_game = true;
						_dialogs.clear();
						_player.stand();
						_ct = 0;
						_init = false;
						_player.set_pos(118, _player.y());
						_instruction.visible = true;
						if (_iceblocks.members[3].alive) {
							_iceblocks.members[3].kill();
							FlxG.flash(0xff000000);
						}
					}
				}
			} else if (_in_game) {
				// game part
				if (!_init) {
					_fishes.add(new Fish());
					_fishes.add(new Fish());
					_init = true;
				}
				
				// update score
				_score_board.text = "Weight: " + _score + " lb";
				
				update_control();
				update_fishes();
				update_bubbles();
				update_torpedos();
				
				// instruction fading
				if (_ct >= 600 && _instruction.alpha >= 0) {
					_instruction.alpha -= 0.02;
				}
				
				// submarine events
				if (_ct == 900) {	// test change point
					var start1:FlxPoint = new FlxPoint( -400, 400);
					var start2:FlxPoint = new FlxPoint(1080, 400);
					var end1:FlxPoint = new FlxPoint( -240, 400);
					var end2:FlxPoint = new FlxPoint(480, 400);
					_submarines.add(new Submarine(start1, end1, false));
					_submarines.add(new Submarine(start2, end2, true));
				} else if (_ct > 900) {
					for (var n:int = 0; n < _submarines.members.length; n++ ) {
						_submarines.members[n].update_submarine(this);
					}
				}
				
				// judge end game
				if (_iceblocks.countDead() >= 10) {
					// ice cap breaks
					_end_game = true;
					_win = false;
					_in_game = false;
				} else if (_score >= 100) {	// test change point
					_end_game = true;
					_win = true;
					_in_game = false;
				}
			} else if (_end_game) {
				// end game
				FlxG.switchState(new EndGame(_win));
			}
			
			for (var i:int = 0; i < _iceblocks.members.length; i++ ) {
				_iceblocks.members[i].update_iceblock();
			}
		}
		
		/*
		private function update_waterweeds():void {
			if (_waterweeds.members.length > 0) {
				for (var i:int = 0; i < _waterweeds.members.length; i++ ) {
					// _waterweeds.members[i].update_waterweed(this);
					_waterweeds.members[i].rotate(1);
				}
			}
		}
		*/
		
		private function update_bubbles():void {
			for (var i:int = _bubbles.members.length - 1; i >= 0; i--) {
				var itr_bubble:Bubble = _bubbles.members[i];
				if (itr_bubble != null) {
					itr_bubble.update_bubble(this);
				
					if (itr_bubble.should_remove()) {
						_bubbles.remove(itr_bubble, true);
					}
				}
			}
		}
		
		private function update_torpedos():void {
			for (var i:int = _torpedos.members.length - 1; i >= 0; i--) {
				var itr_bubble:Torpedo = _torpedos.members[i];
				if (itr_bubble != null) {
					itr_bubble.update_torpedo(this);
				
					if (itr_bubble.should_remove()) {
						var explosion:Explosion = new Explosion(itr_bubble.x, itr_bubble.y, 0)
						_explosions.add(explosion);
						explosion.explode();
						if (_player._occupied) {
							_player._occupied = false;
							trace("rod freed");
						}
						_torpedos.remove(itr_bubble, true);
					}
				}
			}
		}
		
		private function update_skip_text():void {
			if (_intro) {
				if (_ct % 60 == 1) _skip_text.visible = !(_skip_text.visible);
			} else {
				_skip_text.visible = false;
			}
		}
		
		private function update_explosion():void {
			for (var i:int = _explosions.members.length - 1; i >= 0; i--) {
				var itr_exp:Explosion = _explosions.members[i];
				if (itr_exp != null) {
					itr_exp.update_explosion(this);
				
					if (itr_exp.should_remove()) {
						_explosions.remove(itr_exp, true);
					}
				}
			}
		}
		
		private function update_fishes():void {
			if (_ct % 900 == 600) {
				_fishes.add(new Fish());
			}
			
			if (_fishes.length > 0) {
				for (var i:int = _fishes.members.length - 1; i >= 0; i--) {
					var itr_fish:Fish = _fishes.members[i];
					if (itr_fish != null) {
						itr_fish.update_fish(this);
					
						if (itr_fish.should_remove()) {
							_fishes.remove(itr_fish, true);
						}
					}
				}
				
				/*
				FlxG.overlap(_fishes, _player._bait, function(itr_fish:Fish, bait:FlxSprite):void {
					trace("overlapped");
					if (_booty == 0) {
						itr_fish.caught();
						_booty = 1;
					}
				});
				*/
			}
		}
		
		private function update_control():void {
			_moving = false;
			_drilling = false;
			
			if (_scorch_ct > 0) {
				_scorch_ct--;
				return;
			}
			
			if (FlxG.keys.pressed("LEFT")) {
				_moving = true;
				if (!_fishing && _player.x() >= 0) {
					_player.walk( -2.5);
				}
			} else if (FlxG.keys.pressed("RIGHT")) {
				_moving = true;
				if (!_fishing && _player.x() <= 595) {
					_player.walk(2.5);
				}
			} else if (FlxG.keys.pressed("UP")) {
				if (_fishing) {
					_player._bait.y -= BAIT_SPD;
					if (_player._bait.y <= _player._bait_home_y) {
						_player._bait.y = _player._bait_home_y;
						_fishing = false;
					}
					_threadlen = _player._bait.y - _player._bait_home_y + 8;
				}
			} else if (FlxG.keys.pressed("DOWN")) {
				if (on_hole()) {
					_fishing = true;
					_player._bait.y += BAIT_SPD;
					if (_player._bait.y >= 620) {
						_player._bait.y = 620;
					}
					_threadlen = _player._bait.y - _player._bait_home_y + 8;
				} else {
					_fishing = false;
					_drilling = true;
					_player.drill();
				}
			}
			
			_player._thread.makeGraphic(1, _threadlen, 0xff999999);
			
			if (!_drilling) {
				if (!_moving) {
					_player.stand();
				}
				
				if (_fishing) {
					_player.fish();
				} else {
					_player.unfish();
				}
			} else {
				var player_axis:Number = _player.x() + 22.5;
				for (var i:int = 0; i < _iceblocks.members.length; i++ ) {
					var itr_ice:IceBlocks = _iceblocks.members[i];
					if (itr_ice.alive) {
						var ice_axis:Number = itr_ice.x + 20;
						if (Math.abs(player_axis - ice_axis) <= POS_TOL*1.5) {
							itr_ice.health -= 1;
							if (itr_ice.health <= 0) {
								itr_ice.kill();
							}
						}
					}
				}
			}
			
			// updating camera position
			_camera_icon.y = 4 * _player._bait.y - 1180;
			if (_camera_icon.y >= 460) {
				_camera_icon.y = 460;
			}
		}
		
		private function on_hole():Boolean {
			var player_axis:Number = _player.x() + 22.5;
			for (var i:int = 0; i < _iceblocks.members.length; i++ ) {
				var itr_ice:IceBlocks = _iceblocks.members[i];
				if (!itr_ice.alive) {
					var ice_axis:Number = itr_ice.x + 20;
					if (Math.abs(player_axis - ice_axis) <= POS_TOL) {
						return true;
					}
				}
			}
			return false;
		}
		
		private function intro_event(case_no:Number):void {
			switch(case_no) {
				case 1:
					say(1, new FlxPoint(_player.x() + 50, _player.y() - 120));
					break;
				case 2:
					hide_dialog();
					break;
				case 3:
					_player.drill();
					break;
				case 4:
					_player.stand();
					say(2, new FlxPoint(_player.x() + 50, _player.y() - 120));
					break;
				case 5:
					hide_dialog();
					if (!_shaked) {
						var explosion:Explosion = new Explosion(120, 300, 0);
						explosion.explode();
						_explosions.add(explosion);
						_shaked = true;
						_iceblocks.members[3].kill();
					}
					break;
				case 6:
					_player.look_away( -1);
					break;
				case 7:
					if (_player.x() >= 118) {
						_player.walk( -1);
					} else {
						_player.stand();
					}
					break;
				case 8:
					if (_player.x() != 118) {
						_player.set_pos(118, _player.y());
					}
					_player.well_well();
					say(3, new FlxPoint(_player.x() + 50, _player.y() - 120));
				default:
					break;
			}
		}
		
		private function say(diag_no:Number, pos:FlxPoint):void {
			_dialogs.clear();
			switch(diag_no) {
				case 1:
					var diag1:FlxSprite = new FlxSprite(pos.x, pos.y, Resource.IMPORT_DIALOG1);
					_dialogs.add(diag1);
					break;
				case 2:
					var diag2:FlxSprite = new FlxSprite(pos.x, pos.y, Resource.IMPORT_DIALOG2);
					_dialogs.add(diag2);
					break;
				case 3:
					var diag3:FlxSprite = new FlxSprite(pos.x, pos.y, Resource.IMPORT_DIALOG3);
					_dialogs.add(diag3);
					break;
				default:
					break;
			}
		}
		
		private function hide_dialog():void {
			say(0, new FlxPoint());
		}
		
		private function create_iceblocks():void {
			for (var i:int = 0; i < 16; i++ ) {
				var ice_block:FlxSprite = new IceBlocks();
				ice_block.set_position(i * 40, 330);
				_iceblocks.add(ice_block);
			}
		}
	}

}