////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2009 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package ru.avangardonline.database.character {

	import by.blooddy.core.database.Data;
	
	import ru.avangardonline.database.battle.world.BattleWorldElementData;

	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 9
	 * @langversion				3.0
	 * @created					05.08.2009 22:12:56
	 */
	public class CharacterData extends BattleWorldElementData {

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * Constructor
		 */
		public function CharacterData(id:uint) {
			super( id );
		}

		//--------------------------------------------------------------------------
		//
		//  Overriden proeprties
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private var _rotation:Number;

		public override function get rotation():Number {
			if ( this.coord.moving || isNaN( _rotation ) ) {
				return this.coord.direction;
			}
			return this._rotation;
		}

		//--------------------------------------------------------------------------
		//
		//  Proeprties
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  group
		//----------------------------------

		/**
		 * @private
		 */
		private var _group:uint = 0;

		public function get group():uint {
			return this._group;
		}

		/**
		 * @private
		 */
		public function set group(value:uint):void {
			if ( this._group == value ) return;
			this._group = value;
			switch ( value ) {
				case 1:		this._rotation = 180;			break;
				case 2:		this._rotation = 0;				break;
				default:	this._rotation = Number.NaN;	break;
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Overriden methods
		//
		//--------------------------------------------------------------------------

		public override function toLocaleString():String {
			return super.formatToString( 'id', 'group' );
		}

		public override function clone():Data {
			var result:CharacterData = new CharacterData( super.id );
			result.copyFrom( this );
			return result;
		}

		public override function copyFrom(data:Data):void {
			var target:CharacterData = data as CharacterData;
			if ( !target ) throw new ArgumentError();
			super.copyFrom( target );
			this.group = target._group;
		}

	}

}