/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.controller 
{
    import com.imrahil.bbapps.cleverinstant.constants.ApplicationConstants;
    import com.imrahil.bbapps.cleverinstant.model.vo.LoginCredentialsVO;
    import com.imrahil.bbapps.cleverinstant.utils.LogUtil;
    
    import flash.net.SharedObject;
    
    import mx.logging.ILogger;
    
    import org.robotlegs.mvcs.SignalCommand;

    public final class SaveLoginDetailsCommand extends SignalCommand 
    {
        /** PARAMETERS **/
        [Inject]
        public var loginCredentials:LoginCredentialsVO;

        /** INJECTIONS **/

        /** variables **/
        private var logger:ILogger;
        
        /** 
         * CONSTRUCTOR 
         */		
        public function SaveLoginDetailsCommand()
        {
            super();
            
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }

        /**
         * Method handle the logic for <code>SaveLoginDetailsCommand</code>
         */        
        override public function execute():void    
        {
            logger.debug(": execute");

            var sessionSO:SharedObject = SharedObject.getLocal(ApplicationConstants.CLEVERIM_SO_NAME);
            sessionSO.data.username = loginCredentials.username;
            sessionSO.data.password = loginCredentials.password; 
            sessionSO.data.server = loginCredentials.server;
            sessionSO.data.serverPort = loginCredentials.serverPort;
            
            sessionSO.flush();
        }
    }
}
