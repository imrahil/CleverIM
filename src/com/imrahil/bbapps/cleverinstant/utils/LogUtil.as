/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.utils
{
    import flash.utils.getQualifiedClassName;
    
    import mx.logging.ILogger;
    import mx.logging.Log;
    
    public class LogUtil
    {
        public function LogUtil()
        {
        }
        
        /**
         * Get a logger for
         */
        public static function getLogger(obj:Object):ILogger
        {
            return Log.getLogger(getQualifiedClassName(obj).replace("::", "."));
        }
    }
}
