////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2009 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package ru.avangardonline.database.battle.actions {

	import by.blooddy.core.commands.Command;

	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					11.08.2009 21:03:12
	 */
	public class BattleWorldElementActionData extends BattleActionData {

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * Constructor
		 */
		public function BattleWorldElementActionData() {
			super();
		}

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  elementID
		//----------------------------------

		/**
		 * @private
		 */
		private var _elementID:uint;

		public function get elementID():uint {
			return this._elementID;
		}

		/**
		 * @private
		 */
		public function set elementID(value:uint):void {
			if ( this._elementID === value ) return;
			this._elementID = value;
		}

		//--------------------------------------------------------------------------
		//
		//  Protected methods
		//
		//--------------------------------------------------------------------------

		protected final function getCommand(command:Command):Command {
			return	new Command(
						'forWorldElement',
						new Array( this._elementID, command )
					);
		}

	}

}