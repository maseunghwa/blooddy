package by.blooddy.core.net {

	import by.blooddy.core.events.net.LoaderEvent;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	//--------------------------------------
	//  Events
	//--------------------------------------

	[Event( name="loaderEnabled", type="by.blooddy.core.events.net.LoaderEvent" )]
	[Event( name="loaderDisabled", type="by.blooddy.core.events.net.LoaderEvent" )]

	public class LoaderListener extends LoaderDispatcher {

		public function LoaderListener(target:IEventDispatcher) {
			super();
			this._target = target;
			target.addEventListener( LoaderEvent.LOADER_INIT, this.handler_loaderInit );
			super.addEventListener( Event.COMPLETE, this.handler_complete, false, int.MAX_VALUE, true );
		}

		private var _target:IEventDispatcher;

		public function get target():IEventDispatcher {
			return this._target;
		}

		private var _running:Boolean = false;

		public function get running():Boolean {
			return this._running;
		}
		
		public function close():void {
			if (this._target) {
				this._target.removeEventListener(LoaderEvent.LOADER_INIT, this.handler_loaderInit);
				this._target = null;
			}
			
			while (super.loadersTotal) super.removeLoaderListener(super.getLoaderAt(0));
		}

		private function handler_loaderInit(event:LoaderEvent):void {
			var loaded:Boolean = super.loaded;
			super.addLoaderListener( event.loader );
			if ( loaded && !super.loaded ) {
				this._running = true;
				super.$dispatchEvent( new LoaderEvent( LoaderEvent.LOADER_ENABLED, false, false, this ) );
			}
		}

		/**
		 * @private
		 */
		private function handler_complete(event:Event):void {
			this._running = false;
			super.$dispatchEvent( new LoaderEvent( LoaderEvent.LOADER_DISABLED, false, false, this ) );
		}

	}

}