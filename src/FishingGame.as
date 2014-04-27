package  
{
	import core.Player;
	import org.flixel.*;
	import flash.display.*;
	import particles.IceBlocks;
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
		
		public var _player:Player = new Player();
		public var _fishing:Boolean = false, _moving:Boolean = false, _drilling:Boolean = false;
		public var _threadlen:Number = 10;
		
		public var _intro:Boolean = true, _in_game:Boolean = false, _end_game:Boolean = false, _win:Boolean = false;
		public var _init:Boolean = false, _shaked:Boolean = false;
		public var _ct:Number = 0;
		
		public var _score:uint = 0;
		public var _score_board:FlxText;
		public var _instrction:FlxText;
		
		public override function create():void {
			super.create();
			
			// background
			_bg.loadGraphic(Resource.IMPORT_BG);
			_bg.set_position(0, 0);
			this.add(_bg);
			
			// ice blocks
			create_iceblocks();
			this.add(_iceblocks);
			
			// player
			_player.set_pos(350, 255);
			this.add(_player);
			this.add(_dialogs);
			
			// camera
			_camera_icon.width = 1;
			_camera_icon.height = 1;
			_camera_icon.set_position(Util.WID / 2, Util.HEI / 2);
			_camera_icon.fill(0xFF66CCFF);
			_camera_icon.visible = false;	// turn on for debug
			this.add(_camera_icon);
			FlxG.camera.follow(_camera_icon);
			
			// score board
			_score_board = new FlxText(20, 20, 160, "");
			_score_board.text = "Weight: " + _score + " lb";
			_score_board.color = 0x000000;
			this.add(_score_board);
			
			// instruction
			_instrction = new FlxText(80, 160, 320, "");
			_instrction.text = "Instruction:\n" + 
							   "Press Down Arrow Key to fish, Up to pull the thread back.\n" +
							   "When not fishing, you may drill holes on ice by pressing Down,\n" + 
							   "but it won't be effective. Try to find a more effective way!\n" +
							   "But be sure not to make too many holes, or the icecap may break\n" +
							   "And you'll fall into river!";
			_instrction.color = 0xFF0000;
			_instrction.visible = false;
			this.add(_instrction);
		}
		
		public override function update():void {
			super.update();
			_ct++;
			if (_intro) {
				if (!_init) {
					FlxG.flash(0x00000000);
					_init = true;
					return;
				} else {
					var timer:Array = [120, 640, 660, 960, 1320, 1440, 1560, 1800, 2100, 2160];
					for (var k:int = 0; k < timer.length; k++ ) {
						timer[k] /= 10;
					}
					for (var j:int = 0; j < timer.length - 1; j++ ) {
						if (_ct >= timer[j] && _ct < timer[j + 1]) {
							intro_event(j+1);
						}
					}
					if (_ct >= timer[timer.length - 1]) {
						// going into game
						_intro = false;
						_in_game = true;
						_dialogs.clear();
						_player.stand();
						_ct = 0;
					}
				}
			} else if (_in_game) {
				update_control();
				_instrction.visible = true;
				if (_ct >= 600 && _instrction.alpha >= 0) {
					_instrction.alpha -= 0.02;
				}
			} else if (_end_game) {
				
			}
			
			for (var i:int = 0; i < _iceblocks.members.length; i++ ) {
				_iceblocks.members[i].update_iceblock();
			}
		}
		
		private function update_control():void {
			_moving = false;
			_drilling = false;
			if (FlxG.keys.pressed("LEFT")) {
				_moving = true;
				if (!_fishing && _player.x() >= 0 && _player.x() <= 595) {
					_player.walk( -2);
				}
			} else if (FlxG.keys.pressed("RIGHT")) {
				_moving = true;
				if (!_fishing && _player.x() >= 0 && _player.x() <= 595) {
					_player.walk(2);
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
						if (Math.abs(player_axis - ice_axis) <= POS_TOL) {
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
			
			// judge end game
			if (_iceblocks.countDead() >= 14) {
				// ice cap breaks
				_end_game = true;
				_win = false;
			} else if (_score >= 40) {
				_end_game = true;
				_win = true;
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
						FlxG.camera.shake(0.02, 0.2);
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