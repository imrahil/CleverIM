/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.signals
{
    import com.imrahil.bbapps.cleverinstant.utils.CustomRoster;
    
    import org.osflash.signals.Signal;

    public class ChatUserRosterLoadedSignal extends Signal
    {
        public function ChatUserRosterLoadedSignal()
        {
            super(CustomRoster);
        }
    }
}
