////////////////////////////////////////////////////////////////////////////////
//
//  © 2007 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.core.managers {

	/**
	 * Класс у когорого есть ссылка на манагер ресурсов.
	 * 
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 9
	 * @langversion				3.0
	 * 
	 * @keyword					resourcemanagerowner, resourcemanager, resource, manager
	 */
	public interface IResourceManagerOwner {

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  resourseManager
		//----------------------------------

	    /**
	     * Ссылка на манагер ресурсов.
	     * 
		 * @keyword					resourcemanagerowner.resoursemanager, resoursemanager
	     */
		function get resourceManager():ResourceManager;

	}

}