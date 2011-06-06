package com.imrahil.bbapps.cleverinstant.utils
{
    import mx.collections.ArrayCollection;
    
    import org.igniterealtime.xiff.core.IXMPPConnection;
    import org.igniterealtime.xiff.im.Roster;
    
    public class CustomRoster extends Roster
    {
        public function CustomRoster(aConnection:IXMPPConnection=null)
        {
            super(aConnection);
        }
        
        public function get groups():Object
        {
            return _groups;
        }
    }
}