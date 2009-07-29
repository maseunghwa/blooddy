////////////////////////////////////////////////////////////////////////////////
//
//  © 2007 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.core.managers {

	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 9
	 * @langversion				3.0
	 * 
	 * @keyword					dragmanager, drag
	 */
	public final class DragManager {

		private static const _dragInfo:DragInfo = DragInfo.$instance;

		public static function get dragInfo():DragInfo {
			return _dragInfo;
		}

		public static function doDrag(dragSource:DisplayObject, rescale:Boolean=false, offset:Point=null, bounds:Rectangle=null):void {
			_dragInfo.$doDrag( dragSource, rescale, offset, bounds );
		}

	}

}