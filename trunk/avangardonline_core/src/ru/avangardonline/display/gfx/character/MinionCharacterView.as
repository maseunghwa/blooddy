////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2009 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package ru.avangardonline.display.gfx.character {

	import by.blooddy.core.display.StageObserver;
	import by.blooddy.core.display.resource.ResourceDefinition;
	
	import flash.events.Event;
	
	import ru.avangardonline.data.character.MinionCharacterData;
	import ru.avangardonline.events.data.character.MinionCharacterDataEvent;
	
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					25.08.2009 12:40:03
	 */
	public class MinionCharacterView extends CharacterView {

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * Constructor
		 */
		public function MinionCharacterView(data:MinionCharacterData) {
			super( data );
			this._data = data;
			var observer:StageObserver = new StageObserver( this );
			observer.registerEventListener( data, MinionCharacterDataEvent.LIVE_CHANGE, this.handler_liveChange );
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private var _data:MinionCharacterData;

		//--------------------------------------------------------------------------
		//
		//  Overriden protected methods
		//
		//--------------------------------------------------------------------------

		protected override function render(event:Event=null):Boolean {
			if ( !super.render( event ) ) return false;
			
			return true;
		}

		protected override function clear(event:Event=null):Boolean {
			if ( !super.clear( event ) ) return false;
			return true;
		}

		/**
		 * @private
		 */
		protected override function getAnimationDefinition():ResourceDefinition {
			return new ResourceDefinition( 'lib/display/character/c' + '1' + '.swf', 'x' );
		}

		protected override function getAnimationKey():String {
			return null;
		}

		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private function handler_liveChange(event:MinionCharacterDataEvent):void {
		}

	}

}