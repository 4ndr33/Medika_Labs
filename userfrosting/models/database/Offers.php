<?php

namespace UserFrosting;

use \Illuminate\Database\Capsule\Manager as Capsule;

/**
 * Offers Class
 *
 * Represents a Offers object as stored in the database.
 *
 * @package UserFrosting
 * @author Alex Weissman
 * @see http://www.userfrosting.com/tutorials/lesson-3-data-model/
 *
 * @property int id
 * @property string sitecontact
 * @property string siteaddress
 * @property string email
 * @property int phone
 * @property string servicelevel
 * @property string servicetype
 * @property string notes
 * @property int user_id
 * @property string status
 */
class Offers extends UFModel {
    
    /**
     * @var string The id of the table for the current model.
     */ 
    protected static $_table_id = "offers";    
    
    
    /**
     * Create a new User object.
     *
     */
    public function __construct($properties = []) {    
        // Set default locale, if not specified
        
        parent::__construct($properties);
    }
    
    
    /**
     * Store the User to the database, along with any group associations and new events, updating as necessary.
     *
     */
    public function save(array $options = []){       
        // Update the user record itself
        $result = parent::save($options);
        
        
        return $result;
    }
    
    /**
     * Delete this user from the database, along with any linked groups and authorization rules
     *
     * @return bool true if the deletion was successful, false otherwise.
     */
    public function delete(){        
        
        // Delete the user        
        $result = parent::delete();
        
        return $result;
    }
    
}
