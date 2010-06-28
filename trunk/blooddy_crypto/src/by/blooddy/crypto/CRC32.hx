////////////////////////////////////////////////////////////////////////////////
//
//  © 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto;

import by.blooddy.system.Memory;
import flash.utils.ByteArray;

/**
 * @author	BlooDHounD
 * @version	2.0
 */
class CRC32 {

	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------

	public static function hash(bytes:ByteArray):UInt {
		return TMP.hash( bytes );
	}

}

/**
 * @private
 */
private class TMP {

	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------

	/**
	 * @private
	 */
	private static inline var Z0:UInt = 256 * 4;

	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------

	public static inline function hash(bytes:ByteArray):UInt {

		var len:UInt = bytes.length;
		if ( len > 0 ) {

			len += Z0;
			
			var mem:ByteArray = Memory.memory;

			var tmp:ByteArray = new ByteArray();
			tmp.length = Z0;

			Memory.memory = tmp;

			var c:UInt;
			var j:UInt;
			var i:UInt = 0;
			do {
				c = i;
				j = 0;
				do {
					if ( c & 1 == 1 ) {
						c = 0xEDB88320 ^ ( c >>> 1 );
					} else {
						c >>>= 1;
					}
				} while ( ++j < 8 );
				Memory.setI32( i << 2, c );
			} while ( ++i < 256 );

			c = 0xFFFFFFFF;

			tmp.position = Z0;
			tmp.length = len;
			tmp.writeBytes( bytes );

			i = Z0;
			do {
				c = Memory.getI32( ( ( c ^ Memory.getByte( i ) & 0xFF ) << 2 ) ) ^ ( c >>> 8 );
			} while ( ++i < len );

			Memory.memory = mem;

			tmp.clear();

			return c ^ 0xFFFFFFFF;

		} else {
			
			return 0;
			
		}
	}

}