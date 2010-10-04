////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.image {

	import flash.utils.ByteArray;

	[ExcludeClass]
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					09.06.2010 3:07:56
	 */
	public final class JPEGTable {

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static const _quantTables:Object = new Object();

		/**
		 * @private
		 */
		private static const _table:ByteArray = new ByteArray();

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		/**
		 *	     0:	   0:	0							[1]{1}
		 *			   1:	YTable						[1]{64}
		 *			  64:	0							[1]{1}
		 *			  65:	UVTable						[1]{64}
		 *			 130:	fdtbl_Y						[8]{64}
		 *			 642:	fdtbl_UV					[8]{64}
		 *
		 *	  1154:    0:	ZigZag						[1]{64}
		 *
		 *	  1218:    0:	0							[1]{1}
		 *			   1:	std_dc_luminance_nrcodes	[1]{16}
		 *			  17:	std_dc_luminance_values		[1]{12}
		 *			  29:	0							[1]{1}
		 *			  30:	std_ac_luminance_nrcodes	[1]{16}
		 *			  47:	std_ac_luminance_values		[1]{162}
		 *			 208:	0							[1]{1}
		 *			 209:	std_dc_chrominance_nrcodes	[1]{16}
		 *			 225:	std_dc_chrominance_values	[1]{12}
		 *			 237:	0							[1]{1}
		 *			 238:	std_ac_chrominance_nrcodes	[1]{16}
		 *			 254:	std_ac_chrominance_values	[1]{162}
		 *			 416:	YDC_HT						[1,2]{12}
		 *			 452:	YAC_HT						[1,2]{251}
		 *			1205:	UVDC_HT						[1,2]{12}
		 *			1241:	UVAC_HT						[1,2]{251}
		 *
		 *	  3212:	   0:	cat							[1,2]{65534}
		 *
		 *	199817:
		 */
		public static function getTable(quality:uint=60):ByteArray {
			if ( quality > 100 ) Error.throwError( RangeError, 2006, 'quality' );
			var quantTable:ByteArray = _quantTables[ quality ];
			if ( !quantTable ) {
				quantTable = JPEGTableHelper.createQuantTable( quality );
				if ( _table.length <= 0 ) {
					var tmp:ByteArray;
					tmp = JPEGTableHelper.createZigZagTable();		_table.writeBytes( tmp );	tmp.clear();
					tmp = JPEGTableHelper.createHuffmanTable();		_table.writeBytes( tmp );	tmp.clear();
					tmp = JPEGTableHelper.createCategoryTable();	_table.writeBytes( tmp );	tmp.clear();
				}
			}
			var result:ByteArray = new ByteArray();
			result.writeBytes( quantTable );
			result.writeBytes( _table );
			result.position = 0;
			return result;
		}

	}
	
}