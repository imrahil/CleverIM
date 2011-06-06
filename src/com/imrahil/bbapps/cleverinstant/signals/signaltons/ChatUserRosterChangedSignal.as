/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.signals.signaltons
{
    import org.osflash.signals.Signal;
    
    import qnx.ui.data.SectionDataProvider;

    public class ChatUserRosterChangedSignal extends Signal
    {
        public function ChatUserRosterChangedSignal()
        {
            super(SectionDataProvider);
        }
    }
}
