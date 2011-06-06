/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.signals
{
    import com.imrahil.bbapps.cleverinstant.model.vo.LoginCredentialsVO;
    
    import org.osflash.signals.Signal;

    public class SaveLoginDetailsSignal extends Signal
    {
        public function SaveLoginDetailsSignal()
        {
            super(LoginCredentialsVO);
        }
    }
}
