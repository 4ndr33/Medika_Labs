<?php

namespace UserFrosting;

    // This is the path to initialize.php, your site's gateway to the rest of the UF codebase!  Make sure that it is correct!
    $init_path = "userfrosting/initialize.php";

    // This if-block just checks that the path for initialize.php is correct.  Remove this once you know what you're doing.
    if (!file_exists($init_path)){
        echo "<h2>We can't seem to find our way to initialize.php!  Please check the require_once statement at the top of index.php, and make sure it contains the correct path to initialize.php.</h2><br>";
    }

    require_once($init_path);

    use UserFrosting as UF;
   
    // Front page
    $app->get('/', function () use ($app) {
        // This if-block detects if mod_rewrite is enabled.
        // This is just an anti-noob device, remove it if you know how to read the docs and/or breathe through your nose.
        if (isset($_SERVER['SERVER_TYPE']) && ($_SERVER['SERVER_TYPE'] == "Apache") && !isset($_SERVER['HTTP_MOD_REWRITE'])) {
            $app->render('errors/bad-config.twig');
            exit;
        }
    
        // Check that we can connect to the DB.  Again, you can remove this if you know what you're doing.
        if (!UF\Database::testConnection()){
            // In case the error is because someone is trying to reinstall with new db info while still logged in, log them out
            session_destroy();
            // TODO: log out from remember me as well.
            $controller = new UF\AccountController($app);
            return $controller->pageDatabaseError();
        }
    
        // Forward to installation if not complete
        // TODO: Is there any way to detect that installation was complete, but the DB is malfunctioning?
        if (!isset($app->site->install_status) || $app->site->install_status == "pending"){
            $app->redirect($app->urlFor('uri_install'));
        }
        
        // Forward to the user's landing page (if logged in), otherwise take them to the home page
        // This is probably where you, the developer, would start making changes if you need to change the default behavior.
        if ($app->user->isGuest()){
            $controller = new UF\AccountController($app);
            $controller->pageHome();
        // If this is the first the root user is logging in, take them to site settings
        } else if ($app->user->id == $app->config('user_id_master') && $app->site->install_status == "new"){
            $app->site->install_status = "complete";
            $app->site->store();
            $app->alerts->addMessage("success", "Congratulations, you've successfully logged in for the first time.  Please take a moment to customize your site settings.");
            $app->redirect($app->urlFor('uri_settings'));  
        } else {
            $app->redirect($app->user->landing_page);        
        }
    })->name('uri_home');

    /********** FEATURE PAGES **********/
    
    $app->get('/dashboard/?', function () use ($app) {    
        // Access-controlled page
        if (!$app->user->checkAccess('uri_dashboard')){
            $app->notFound();
        }
        
        $type=1;
        if ($app->user->checkAccess('uri_tickets'))
        {
            $type=2;
        }
        include("userfrosting/models/database/Analytics.php");

        $target_ticket = Tickets_Worklog::where('user_id', $app->user->id)->get();
        
        $app->render('dashboard.twig', [
            "analytic_servicetype" => $analytic_servicetype ,
            "analytic_servicelevel" => $analytic_servicelevel ,
            "analytic_venue" => $analytic_venue ,
            "total" => $total ,
            "open_ticket" => $open_ticket ,
            "tickets" => isset($target_ticket) ? $target_ticket->toArray() : []
            //"save_type" => 'add' ,
            //'validators' => $app->jsValidator->rules()
        ]);
        //$app->render('dashboard.twig', []);          
    });


    /* Route for Account Groups page  */
    $app->get('/account/groups/?', function () use ($app) {
        // Access-controlled page
        if (!$app->user->checkAccess('uri_account-groups')){
            $app->notFound();
        }

        $app->render('account-groups.twig', [
            'groups' => $app->user->getGroups()
        ]);
    });
    
    
     /* Group Titles Page */ 
     $app->get('/groups/titles/?', function () use ($app) {    
          $controller = new UF\GroupController($app);
          return $controller->pageGroupTitles();
        });
          
     $app->post('/groups/titles/?', function () use ($app) {    
          $controller = new UF\GroupController($app);
          return $controller->updateGroupTitles();
        });        

    $app->get('/zerg/?', function () use ($app) {    
        // Access-controlled page
        if (!$app->user->checkAccess('uri_zerg')){
            $app->notFound();
        }
        
        $app->render('users/zerg.twig'); 
    });   
     
     /* Pricing Page */ 
	$app->get('/pricing/?', function () use ($app) {
        
        // Access-controlled page
        if (!$app->user->checkAccess('uri_pricing')){
            $app->notFound();
        }
        $app->render('pricing.twig');
    });  
    

/**
 * Renders the contact form.
 */
$app->get('/contact/?', function () use ($app) {
	// Access-controlled page
    if (!$app->user->checkAccess('uri_account-groups')){
		$app->notFound();
    }
    $schema = new \Fortress\RequestSchema($app->config('schema.path') . "/forms/contact.json");
    $app->jsValidator->setSchema($schema);
    
    $app->render('contact.twig', [
		"save_type" => 'add' ,
        'validators' => $app->jsValidator->rules()
    ]);
});


$app->post('/update-ticket/?', function () use ($app) {    
    
    // POST: name, siteaddress, email, [phone], message, spiderbro
    $post = $app->request->post();
    
    // Get the alert message stream
    $ms = $app->alerts; 
    
    // Check the honeypot. 'spiderbro' is not a real field, it is hidden on the main page and must be submitted with its default value for this to be processed.
    if (!$post['spiderbro'] || $post['spiderbro'] != "http://"){
        error_log("Possible spam received:" . print_r($app->request->post(), true));
        $ms->addMessage("danger", "Aww hellllls no!");
        $app->halt(500);     // Don't let on about why the request failed ;-)
    }
    // Load the request schema
    $requestSchema = new \Fortress\RequestSchema($app->config('schema.path') . "/forms/contact.json");
               
    // Set up Fortress to process the request
    $rf = new \Fortress\HTTPRequestFortress($ms, $requestSchema, $post);
    
    // Sanitize data
    $rf->sanitize();
            
    // Validate, and halt on validation errors.        
    //if (!$rf->validate())
       //$app->halt(400);
    
    // Get the filtered data
    $data = $rf->data();   
    
    if($post['save_type']=="edit")
	{
	    if(isset($data["name"]))
		{
			$data["sitecontact"]=$data["name"];
			unset($data["name"]);
		}
		if(isset($data["message"]))
		{
			$data["notes"]=$data["message"];
			unset($data["message"]);
		}
		$target_ticket = Tickets::find($post['ticket_id']);

		if($target_ticket)
		{
            $empty_slots=0;
            
            
            
                
            if(($target_ticket->admin_file_name_1=="") || ($target_ticket->admin_file_name_1=="-"))
            {
                $empty_slots=$empty_slots+1;
                $no_empty_slots[$empty_slots-1]=1;
                $empty_slots_filled[$empty_slots-1]=0;
                $empty_slots_deleted[$empty_slots-1]=0;
            }
            else
            {
                if(isset($post["delete_file_1"]))
                {
                    $empty_slots=$empty_slots+1;
                    $no_empty_slots[$empty_slots-1]=1;
                    $empty_slots_filled[$empty_slots-1]=0;
                    $empty_slots_deleted[$empty_slots-1]=1;
                }
                
            }
            
            if(($target_ticket->admin_file_name_2=="") || ($target_ticket->admin_file_name_2=="-"))
            {
                $empty_slots=$empty_slots+1;
                $no_empty_slots[$empty_slots-1]=2;    
                $empty_slots_filled[$empty_slots-1]=0;
                $empty_slots_deleted[$empty_slots-1]=0;
            }
            else
            {
                if(isset($post["delete_file_2"]))
                {
                    $empty_slots=$empty_slots+1;
                    $no_empty_slots[$empty_slots-1]=2;
                    $empty_slots_filled[$empty_slots-1]=0;
                    $empty_slots_deleted[$empty_slots-1]=1;
                }
            }
            
            if(($target_ticket->admin_file_name_3=="") || ($target_ticket->admin_file_name_3=="-"))
            {
                $empty_slots=$empty_slots+1;
                $no_empty_slots[$empty_slots-1]=3;
                $empty_slots_filled[$empty_slots-1]=0;
                $empty_slots_deleted[$empty_slots-1]=0;
            }
            else
            {
                if(isset($post["delete_file_3"]))
                {
                    $empty_slots=$empty_slots+1;
                    $no_empty_slots[$empty_slots-1]=3;
                    $empty_slots_filled[$empty_slots-1]=0;
                    $empty_slots_deleted[$empty_slots-1]=1;
                }
            }
            
            if(($target_ticket->admin_file_name_4=="") || ($target_ticket->admin_file_name_4=="-"))
            {
                $empty_slots=$empty_slots+1;
                $no_empty_slots[$empty_slots-1]=4;
                $empty_slots_filled[$empty_slots-1]=0;
                $empty_slots_deleted[$empty_slots-1]=0;
            }
            else
            {
                if(isset($post["delete_file_4"]))
                {
                    $empty_slots=$empty_slots+1;
                    $no_empty_slots[$empty_slots-1]=4;
                    $empty_slots_filled[$empty_slots-1]=0;
                    $empty_slots_deleted[$empty_slots-1]=1;
                }
            }
            
            if(($target_ticket->admin_file_name_5=="") || ($target_ticket->admin_file_name_5=="-"))
            {
                $empty_slots=$empty_slots+1;
                $no_empty_slots[$empty_slots-1]=5;
                $empty_slots_filled[$empty_slots-1]=0;
                $empty_slots_deleted[$empty_slots-1]=0;
            }
            else
            {
                if(isset($post["delete_file_5"]))
                {
                    $empty_slots=$empty_slots+1;
                    $no_empty_slots[$empty_slots-1]=5;
                    $empty_slots_filled[$empty_slots-1]=0;
                    $empty_slots_deleted[$empty_slots-1]=1;
                }
            }
            
            if(($target_ticket->admin_file_name_6=="") || ($target_ticket->admin_file_name_6=="-"))
            {
                $empty_slots=$empty_slots+1;
                $no_empty_slots[$empty_slots-1]=6;
                $empty_slots_filled[$empty_slots-1]=0;
                $empty_slots_deleted[$empty_slots-1]=0;
            }
            else
            {
                if(isset($post["delete_file_6"]))
                {
                    $empty_slots=$empty_slots+1;
                    $no_empty_slots[$empty_slots-1]=6;
                    $empty_slots_filled[$empty_slots-1]=0;
                    $empty_slots_deleted[$empty_slots-1]=1;
                }
            }
            
            
            if(($target_ticket->admin_file_name_7=="") || ($target_ticket->admin_file_name_7=="-"))
            {
                $empty_slots=$empty_slots+1;
                $no_empty_slots[$empty_slots-1]=7;
                $empty_slots_filled[$empty_slots-1]=0;
                $empty_slots_deleted[$empty_slots-1]=0;
            }
            else
            {
                if(isset($post["delete_file_7"]))
                {
                    $empty_slots=$empty_slots+1;
                    $no_empty_slots[$empty_slots-1]=7;
                    $empty_slots_filled[$empty_slots-1]=0;
                    $empty_slots_deleted[$empty_slots-1]=1;
                }
            }
            
            if(($target_ticket->admin_file_name_8=="") || ($target_ticket->admin_file_name_8=="-"))
            {
                $empty_slots=$empty_slots+1;
                $no_empty_slots[$empty_slots-1]=8;
                $empty_slots_filled[$empty_slots-1]=0;
                $empty_slots_deleted[$empty_slots-1]=0;
            }
            else
            {
                if(isset($post["delete_file_8"]))
                {
                    $empty_slots=$empty_slots+1;
                    $no_empty_slots[$empty_slots-1]=8;
                    $empty_slots_filled[$empty_slots-1]=0;
                    $empty_slots_deleted[$empty_slots-1]=1;
                }
            }
            
            for($i2=1;$i2<=8;$i2++)
            {
                $data["admin_file_name_".$i2]="-";
                $data["admin_file_".$i2]="-";
            }
            if($empty_slots>0)
            {
                if (isset($_FILES['files'])) 
                {
                    $myFile = $_FILES['files'];
                    $fileCount = count($myFile["name"]);
                    $target_dir = "uploads/";
                    $temp_upload_count=0;
                    $temp_file_name="";
                    $temp_No_file=0;
                    if($fileCount>$empty_slots)
                    {
                        $fileCount=$empty_slots;
                    }
                    
                    for ($i = 0; $i < $fileCount; $i++) 
                    {

                        //$temp_No_file=$temp_No_file+1;
                        $temp_No_file=$no_empty_slots[$i];
                        $temp_file_name="admfls-".$target_ticket->id."-".$app->user->id."-".$temp_No_file;

                        $target_file = $target_dir . basename($myFile["name"][$i]);
                        $target_file2 = $target_dir . $temp_file_name;
                        $uploadOk = 1;
                        $imageFileType = pathinfo($target_file,PATHINFO_EXTENSION);
                        // Check if image file is a actual image or fake image
                        if(isset($_POST["submit"])) {
                            $uploadOk = 1;
                            //$check = getimagesize($myFile["tmp_name"][$i]);
                            //if($check !== false) {
                                //echo "File is an image - " . $check["mime"] . ".";
                            //    $uploadOk = 1;
                            //} else {
                                //echo "File is not an image.";
                            //    $uploadOk = -1;
                            //}
                        }
                        $target_file2 = $target_dir . $temp_file_name.".".$imageFileType;
                        // Check if file already exists
                        if (file_exists($target_file2)) {
                            //echo "Sorry, file already exists.";
                            //$uploadOk = -2;
                            //$i=$i-1;
                        }
                        if($uploadOk==1)
                        {
                            // Check file size
                            // 500000 10mb
                            if ($myFile["size"][$i] >10485760 ) {
                                //echo "Sorry, your file is too large.";
                                $uploadOk = -3;
                            }
                            // Allow certain file formats
                            if($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "jpeg") 
                            {
                                //echo "Sorry, only JPG, JPEG, PNG files are allowed.";
                                //$uploadOk = -4;
                            }
                            // Check if $uploadOk is set to 0 by an error
                            if ($uploadOk <= -1) {
                                //echo "Sorry, your file was not uploaded.";
                            // if everything is ok, try to upload file
                            } else {
                                //if (move_uploaded_file($myFile["tmp_name"][$i], $target_file)) {
                                if (move_uploaded_file($myFile["tmp_name"][$i], $target_file2)) {
                                    //echo "The file ". basename( $myFile["name"][$i]). " has been uploaded.";
                                    $temp_upload_count=$temp_upload_count+1;
                                    
                                    $empty_slots_filled[$temp_upload_count-1]=1;
                                    

                                    
                                    $data["admin_file_name_".$no_empty_slots[$temp_upload_count-1]]=basename($myFile["name"][$i]);
                                    $data["admin_file_".$no_empty_slots[$temp_upload_count-1]]=$target_file2;

                                    if($temp_upload_count==8)
                                    {
                                        break;
                                    }
                                } else {
                                    //echo "Sorry, there was an error uploading your file.";
                                    $uploadOk = -5;
                                }
                            }    
                        }


                    }
                }
            }
            
            
            if($target_ticket->sitecontact!=$data["sitecontact"])
            {
                $worklog['ticket_id']=$target_ticket->id;
                $worklog['user_id']=$target_ticket->user_id;
                $worklog['time_stamp']=date("j/n/y H:i");
                $worklog['log_content']="site contact updated to ".$data["sitecontact"]." by ".$app->user->user_name;
                $tickets_worklog = new Tickets_Worklog($worklog);
                // Save user again after creating events
                $tickets_worklog->save();    
            }
            
            if($target_ticket->siteaddress!=$data["siteaddress"])
            {
                $worklog['ticket_id']=$target_ticket->id;
                $worklog['user_id']=$target_ticket->user_id;
                $worklog['time_stamp']=date("j/n/y H:i");
                $worklog['log_content']="site address updated to ".$data["siteaddress"]." by ".$app->user->user_name;
                $tickets_worklog = new Tickets_Worklog($worklog);
                // Save user again after creating events
                $tickets_worklog->save();    
            }
            
            if($target_ticket->email!=$data["email"])
            {
                $worklog['ticket_id']=$target_ticket->id;
                $worklog['user_id']=$target_ticket->user_id;
                $worklog['time_stamp']=date("j/n/y H:i");
                $worklog['log_content']="email updated to ".$data["email"]." by".$app->user->user_name;
                $tickets_worklog = new Tickets_Worklog($worklog);
                // Save user again after creating events
                $tickets_worklog->save();    
            }
            if($target_ticket->phone!=$data["phone"])
            {
                $worklog['ticket_id']=$target_ticket->id;
                $worklog['user_id']=$target_ticket->user_id;
                $worklog['time_stamp']=date("j/n/y H:i");
                $worklog['log_content']="phone updated to ".$data["phone"]." by ".$app->user->user_name;
                $tickets_worklog = new Tickets_Worklog($worklog);
                // Save user again after creating events
                $tickets_worklog->save();    
            }
            if($target_ticket->servicelevel!=$data["servicelevel"])
            {
                $worklog['ticket_id']=$target_ticket->id;
                $worklog['user_id']=$target_ticket->user_id;
                $worklog['time_stamp']=date("j/n/y H:i");
                $worklog['log_content']="service level updated to ".$data["servicelevel"]." by ".$app->user->user_name;
                $tickets_worklog = new Tickets_Worklog($worklog);
                // Save user again after creating events
                $tickets_worklog->save();    
            }
            if($target_ticket->servicetype!=$data["servicetype"])
            {
                $worklog['ticket_id']=$target_ticket->id;
                $worklog['time_stamp']=date("j/n/y H:i");
                $worklog['log_content']="service type updated to ".$data["servicetype"]." by ".$app->user->user_name;
                $tickets_worklog = new Tickets_Worklog($worklog);
                // Save user again after creating events
                $tickets_worklog->save();    
            }
            if($target_ticket->notes!=$data["notes"])
            {
                $worklog['ticket_id']=$target_ticket->id;
                $worklog['user_id']=$target_ticket->user_id;
                $worklog['time_stamp']=date("j/n/y H:i");
                $worklog['log_content']="message updated by ".$app->user->user_name.":".$data["notes"];
                $tickets_worklog = new Tickets_Worklog($worklog);
                // Save user again after creating events
                $tickets_worklog->save();    
            }
            if($target_ticket->admin_note!=$post["admin_note"])
            {
                $worklog['ticket_id']=$target_ticket->id;
                $worklog['user_id']=$target_ticket->user_id;
                $worklog['time_stamp']=date("j/n/y H:i");
                $worklog['log_content']="admin note updated by ".$app->user->user_name .":".$post["admin_note"];
                $tickets_worklog = new Tickets_Worklog($worklog);
                // Save user again after creating events
                $tickets_worklog->save();    
            }
             
            
            
            if($target_ticket->status!=$post["status"])
            {
                $worklog['ticket_id']=$target_ticket->id;
                $worklog['user_id']=$target_ticket->user_id;
                $worklog['time_stamp']=date("j/n/y H:i");
                $worklog['log_content']="status updated to ".$post["status"]." by ".$app->user->user_name;
                $tickets_worklog = new Tickets_Worklog($worklog);
                // Save user again after creating events
                $tickets_worklog->save();    
            }
            
			$target_ticket->sitecontact = $data["sitecontact"];
			$target_ticket->siteaddress = $data["siteaddress"];
			$target_ticket->email = $data["email"];
			$target_ticket->phone = $data["phone"];
			$target_ticket->servicelevel = $data["servicelevel"];
			$target_ticket->servicetype = $data["servicetype"];
			$target_ticket->notes = $data["notes"];
            $target_ticket->admin_note = $post["admin_note"];
            $target_ticket->status = $post["status"];
            
            if($empty_slots>0)
            {
                for($i=0;$i<=$empty_slots-1;$i++)
                {
                    if($empty_slots_deleted[$i]==1)
                    {
                        if($no_empty_slots[$i]==1)
                        {
                             
                            
                            $worklog['ticket_id']=$target_ticket->id;
                            $worklog['user_id']=$target_ticket->user_id;
                            $worklog['time_stamp']=date("j/n/y H:i");
                            $worklog['log_content']="admin file ".$target_ticket->admin_file_name_1 ." deleted by ".$app->user->user_name;
                            $tickets_worklog = new Tickets_Worklog($worklog);
                            // Save user again after creating events
                            $tickets_worklog->save();    
                            
                            $target_ticket->admin_file_name_1="-";
                            $target_ticket->admin_file_1="-";   
                            
                        }
                        else if($no_empty_slots[$i]==2)
                        {
                            
                            
                            $worklog['ticket_id']=$target_ticket->id;
                            $worklog['user_id']=$target_ticket->user_id;
                            $worklog['time_stamp']=date("j/n/y H:i");
                            $worklog['log_content']="admin file ".$target_ticket->admin_file_name_2 ." deleted by ".$app->user->user_name;
                            $tickets_worklog = new Tickets_Worklog($worklog);
                            // Save user again after creating events
                            $tickets_worklog->save();    
                            
                            $target_ticket->admin_file_name_2="-";
                            $target_ticket->admin_file_2="-";    
                        }
                        else if($no_empty_slots[$i]==3)
                        {
                            
                            
                            $worklog['ticket_id']=$target_ticket->id;
                            $worklog['user_id']=$target_ticket->user_id;
                            $worklog['time_stamp']=date("j/n/y H:i");
                            $worklog['log_content']="admin file ".$target_ticket->admin_file_name_3 ." deleted by ".$app->user->user_name;
                            $tickets_worklog = new Tickets_Worklog($worklog);
                            // Save user again after creating events
                            $tickets_worklog->save();    
                            
                            $target_ticket->admin_file_name_3="-";
                            $target_ticket->admin_file_3="-";  
                        }
                        else if($no_empty_slots[$i]==4)
                        {
                            
                            
                            $worklog['ticket_id']=$target_ticket->id;
                            $worklog['user_id']=$target_ticket->user_id;
                            $worklog['time_stamp']=date("j/n/y H:i");
                            $worklog['log_content']="admin file ".$target_ticket->admin_file_name_4 ." deleted by ".$app->user->user_name;
                            $tickets_worklog = new Tickets_Worklog($worklog);
                            // Save user again after creating events
                            $tickets_worklog->save();    
                            
                            $target_ticket->admin_file_name_4="-";
                            $target_ticket->admin_file_4="-"; 
                        }
                        else if($no_empty_slots[$i]==5)
                        {
                            
                            
                            $worklog['ticket_id']=$target_ticket->id;
                            $worklog['user_id']=$target_ticket->user_id;
                            $worklog['time_stamp']=date("j/n/y H:i");
                            $worklog['log_content']="admin file ".$target_ticket->admin_file_name_5 ." deleted by ".$app->user->user_name;
                            $tickets_worklog = new Tickets_Worklog($worklog);
                            // Save user again after creating events
                            $tickets_worklog->save();    
                            
                            $target_ticket->admin_file_name_5="-";
                            $target_ticket->admin_file_5="-"; 
                        }
                        else if($no_empty_slots[$i]==6)
                        {
                             
                            
                            $worklog['ticket_id']=$target_ticket->id;
                            $worklog['user_id']=$target_ticket->user_id;
                            $worklog['time_stamp']=date("j/n/y H:i");
                            $worklog['log_content']="admin file ".$target_ticket->admin_file_name_6 ." deleted by ".$app->user->user_name;
                            $tickets_worklog = new Tickets_Worklog($worklog);
                            // Save user again after creating events
                            $tickets_worklog->save();    
                            
                            $target_ticket->admin_file_name_6="-";
                            $target_ticket->admin_file_6="-"; 
                        }
                        else if($no_empty_slots[$i]==7)
                        {
                            
                            
                            $worklog['ticket_id']=$target_ticket->id;
                            $worklog['user_id']=$target_ticket->user_id;
                            $worklog['time_stamp']=date("j/n/y H:i");
                            $worklog['log_content']="admin file ".$target_ticket->admin_file_name_7 ." deleted by ".$app->user->user_name;
                            $tickets_worklog = new Tickets_Worklog($worklog);
                            // Save user again after creating events
                            $tickets_worklog->save();    
                            
                            $target_ticket->admin_file_name_7="-";
                            $target_ticket->admin_file_7="-";  
                        }
                        else if($no_empty_slots[$i]==8)
                        {
                            
                            
                            $worklog['ticket_id']=$target_ticket->id;
                            $worklog['user_id']=$target_ticket->user_id;
                            $worklog['time_stamp']=date("j/n/y H:i");
                            $worklog['log_content']="admin file ".$target_ticket->admin_file_name_8 ." deleted by ".$app->user->user_name;
                            $tickets_worklog = new Tickets_Worklog($worklog);
                            // Save user again after creating events
                            $tickets_worklog->save();   
                            
                            $target_ticket->admin_file_name_8="-";
                            $target_ticket->admin_file_8="-"; 
                        }
                        
                    }
                    if($empty_slots_filled[$i]==1)
                    {
                        if($no_empty_slots[$i]==1)
                        {
                            $target_ticket->admin_file_name_1=$data["admin_file_name_1"];
                            $target_ticket->admin_file_1=$data["admin_file_1"];   
                            
                            
                            $worklog['ticket_id']=$target_ticket->id;
                            $worklog['user_id']=$target_ticket->user_id;
                            $worklog['time_stamp']=date("j/n/y H:i");
                            $worklog['log_content']="admin file ".$target_ticket->admin_file_name_1 ." uploaded by ".$app->user->user_name;
                            $tickets_worklog = new Tickets_Worklog($worklog);
                            // Save user again after creating events
                            $tickets_worklog->save();    
                        }
                        else if($no_empty_slots[$i]==2)
                        {
                            $target_ticket->admin_file_name_2=$data["admin_file_name_2"];
                            $target_ticket->admin_file_2=$data["admin_file_2"];    
                            
                            $worklog['ticket_id']=$target_ticket->id;
                            $worklog['user_id']=$target_ticket->user_id;
                            $worklog['time_stamp']=date("j/n/y H:i");
                            $worklog['log_content']="admin file ".$target_ticket->admin_file_name_2 ." uploaded by ".$app->user->user_name;
                            $tickets_worklog = new Tickets_Worklog($worklog);
                            // Save user again after creating events
                            $tickets_worklog->save();   
                        }
                        else if($no_empty_slots[$i]==3)
                        {
                            $target_ticket->admin_file_name_3=$data["admin_file_name_3"];
                            $target_ticket->admin_file_3=$data["admin_file_3"];   
                            
                            $worklog['ticket_id']=$target_ticket->id;
                            $worklog['user_id']=$target_ticket->user_id;
                            $worklog['time_stamp']=date("j/n/y H:i");
                            $worklog['log_content']="admin file ".$target_ticket->admin_file_name_3 ." uploaded by ".$app->user->user_name;
                            $tickets_worklog = new Tickets_Worklog($worklog);
                            // Save user again after creating events
                            $tickets_worklog->save();   
                        }
                        else if($no_empty_slots[$i]==4)
                        {
                            $target_ticket->admin_file_name_4=$data["admin_file_name_4"];
                            $target_ticket->admin_file_4=$data["admin_file_4"];  
                            
                            $worklog['ticket_id']=$target_ticket->id;
                            $worklog['user_id']=$target_ticket->user_id;
                            $worklog['time_stamp']=date("j/n/y H:i");
                            $worklog['log_content']="admin file ".$target_ticket->admin_file_name_4 ." uploaded by ".$app->user->user_name;
                            $tickets_worklog = new Tickets_Worklog($worklog);
                            // Save user again after creating events
                            $tickets_worklog->save();   
                        }
                        else if($no_empty_slots[$i]==5)
                        {
                            $target_ticket->admin_file_name_5=$data["admin_file_name_5"];
                            $target_ticket->admin_file_5=$data["admin_file_5"];
                            
                            $worklog['ticket_id']=$target_ticket->id;
                            $worklog['user_id']=$target_ticket->user_id;
                            $worklog['time_stamp']=date("j/n/y H:i");
                            $worklog['log_content']="admin file ".$target_ticket->admin_file_name_5 ." uploaded by ".$app->user->user_name;
                            $tickets_worklog = new Tickets_Worklog($worklog);
                            // Save user again after creating events
                            $tickets_worklog->save();   
                        }
                        else if($no_empty_slots[$i]==6)
                        {
                            $target_ticket->admin_file_name_6=$data["admin_file_name_6"];
                            $target_ticket->admin_file_6=$data["admin_file_6"];
                            
                            $worklog['ticket_id']=$target_ticket->id;
                            $worklog['user_id']=$target_ticket->user_id;
                            $worklog['time_stamp']=date("j/n/y H:i");
                            $worklog['log_content']="admin file ".$target_ticket->admin_file_name_6 ." uploaded by ".$app->user->user_name;
                            $tickets_worklog = new Tickets_Worklog($worklog);
                            // Save user again after creating events
                            $tickets_worklog->save();   
                        }
                        else if($no_empty_slots[$i]==7)
                        {
                            $target_ticket->admin_file_name_7=$data["admin_file_name_7"];
                            $target_ticket->admin_file_7=$data["admin_file_7"];    
                            
                            $worklog['ticket_id']=$target_ticket->id;
                            $worklog['user_id']=$target_ticket->user_id;
                            $worklog['time_stamp']=date("j/n/y H:i");
                            $worklog['log_content']="admin file ".$target_ticket->admin_file_name_7 ." uploaded by ".$app->user->user_name;
                            $tickets_worklog = new Tickets_Worklog($worklog);
                            // Save user again after creating events
                            $tickets_worklog->save();   
                        }
                        else if($no_empty_slots[$i]==8)
                        {
                            $target_ticket->admin_file_name_8=$data["admin_file_name_8"];
                            $target_ticket->admin_file_8=$data["admin_file_8"];    
                            
                            $worklog['ticket_id']=$target_ticket->id;
                            $worklog['user_id']=$target_ticket->user_id;
                            $worklog['time_stamp']=date("j/n/y H:i");
                            $worklog['log_content']="admin file ".$target_ticket->admin_file_name_8 ." uploaded by ".$app->user->user_name;
                            $tickets_worklog = new Tickets_Worklog($worklog);
                            // Save user again after creating events
                            $tickets_worklog->save();   
                            
                        }
                        
                    }
                        

                }
            }
            
            
			$target_ticket->save();
			$app->alerts->addMessage("success", "the ticket has been successfully updated!");
		}
        
        $controller = new UF\UserController($app);
        return $controller->formTicketEdit($post['ticket_id']);
        /*
        //$app->alerts->addMessage("success", "Your ticket has been successfully logged!");
        if (!$app->user->checkAccess('uri_account-groups')){
            $app->notFound();
        }
        $schema = new \Fortress\RequestSchema($app->config('schema.path') . "/forms/contact.json");
        $app->jsValidator->setSchema($schema);

        $app->render('contact.twig', [
            "save_type" => 'add' ,
            'validators' => $app->jsValidator->rules()
        ]);
        */
	}
    
    
    
});



$app->post('/contact/?', function () use ($app) {    
    
    // POST: name, siteaddress, email, [phone], message, spiderbro
    $post = $app->request->post();
    
    // Get the alert message stream
    $ms = $app->alerts; 
    
    // Check the honeypot. 'spiderbro' is not a real field, it is hidden on the main page and must be submitted with its default value for this to be processed.
    if (!$post['spiderbro'] || $post['spiderbro'] != "http://"){
        error_log("Possible spam received:" . print_r($app->request->post(), true));
        $ms->addMessage("danger", "Aww hellllls no!");
        $app->halt(500);     // Don't let on about why the request failed ;-)
    }
    // Load the request schema
    $requestSchema = new \Fortress\RequestSchema($app->config('schema.path') . "/forms/contact.json");
               
    // Set up Fortress to process the request
    $rf = new \Fortress\HTTPRequestFortress($ms, $requestSchema, $post);
    
    // Sanitize data
    $rf->sanitize();
            
    // Validate, and halt on validation errors.        
    if (!$rf->validate())
    {
       $app->jsValidator->setSchema($requestSchema);
       $app->render('contact.twig', [
           "save_type" => 'add' ,
           "ticket" => $rf->data(),
           'validators' => $app->jsValidator->rules()
       ]);
       //$app->halt(400); 
    }
       
    else
    {
       
        // Get the filtered data
        $data = $rf->data();   

        if($post['save_type']=="add")
        {



            // Set up and send email
            $twig = $app->view()->getEnvironment();
            $template = $twig->loadTemplate("mail/contact-config.twig"); 
            $notification = new \UserFrosting\Notification($template);


            $notification->from(
                $app->config('email')['admin'],
                'ProServ Ticket Requests',
                $data['email'],
                $data['name']
            );


            $notification->addEmailRecipient('enquiries@ptsg.com.au', 'Ticket Requests', ["data" => $data]);
            if(isset($data["name"]))
            {
                $data["sitecontact"]=$data["name"];
                unset($data["name"]);
            }
            if(isset($data["message"]))
            {
                $data["notes"]=$data["message"];
                unset($data["message"]);
            }
            for($i2=1;$i2<=8;$i2++)
            {
                $data["user_photos_name_".$i2]="-";
                $data["user_photos_".$i2]="-";
            }



            if (isset($_FILES['files'])) 
            {
                $myFile = $_FILES['files'];
                $fileCount = count($myFile["name"]);
                $target_dir = "uploads/";
                $temp_upload_count=0;
                $temp_file_name="";
                $temp_No_file=0;
                for ($i = 0; $i < $fileCount; $i++) 
                {

                    $temp_No_file=$temp_No_file+1;
                    $temp_file_name="".$app->user->id."-".$temp_No_file;

                    $target_file = $target_dir . basename($myFile["name"][$i]);
                    $target_file2 = $target_dir . $temp_file_name;
                    $uploadOk = 1;
                    $imageFileType = pathinfo($target_file,PATHINFO_EXTENSION);
                    // Check if image file is a actual image or fake image
                    if(isset($_POST["submit"])) {
                        $check = getimagesize($myFile["tmp_name"][$i]);
                        if($check !== false) {
                            //echo "File is an image - " . $check["mime"] . ".";
                            $uploadOk = 1;
                        } else {
                            //echo "File is not an image.";
                            $uploadOk = -1;
                        }
                    }
                    $target_file2 = $target_dir . $temp_file_name.".".$imageFileType;
                    // Check if file already exists
                    if (file_exists($target_file2)) {
                        //echo "Sorry, file already exists.";
                        $uploadOk = -2;
                        $i=$i-1;
                    }
                    if($uploadOk==1)
                    {
                        // Check file size
                        //500000  1mb
                        if ($myFile["size"][$i] > 1048576) {
                            //echo "Sorry, your file is too large.";
                            $uploadOk = -3;
                        }
                        // Allow certain file formats
                        if($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "jpeg") 
                        {
                            //echo "Sorry, only JPG, JPEG, PNG files are allowed.";
                            $uploadOk = -4;
                        }
                        // Check if $uploadOk is set to 0 by an error
                        if ($uploadOk <= -1) {
                            //echo "Sorry, your file was not uploaded.";
                        // if everything is ok, try to upload file
                        } else {
                            //if (move_uploaded_file($myFile["tmp_name"][$i], $target_file)) {
                            if (move_uploaded_file($myFile["tmp_name"][$i], $target_file2)) {
                                //echo "The file ". basename( $myFile["name"][$i]). " has been uploaded.";
                                $temp_upload_count=$temp_upload_count+1;
                                $data["user_photos_name_".$temp_upload_count]=basename($myFile["name"][$i]);
                                $data["user_photos_".$temp_upload_count]=$target_file2;

                                if($temp_upload_count==8)
                                {
                                    break;
                                }
                            } else {
                                //echo "Sorry, there was an error uploading your file.";
                                $uploadOk = -5;
                            }
                        }    
                    }


                }
            }

            $data["user_id"]=$app->user->id;
            $data["status"]="Awaiting response";
            //$app->alerts->addMessage("success", "Your ticket has been successfully logged!".$tempNamaArray);

            // Create the user
            $tickets = new Tickets($data);
            // Save user again after creating events
            $tickets->save();
            
            $worklog['ticket_id']=$tickets->id;
            $worklog['user_id']=$tickets->user_id;
            $worklog['time_stamp']=date("j/n/y H:i");
            $worklog['log_content']="created";
            
            $tickets_worklog = new Tickets_Worklog($worklog);
            // Save user again after creating events
            $tickets_worklog->save();
            //.

            try {
                $notification->send();
                $app->alerts->addMessage("success", "Your ticket has been successfully logged!");
            } catch (\phpmailerException $e){
                $app->alerts->addMessage("warning", "Your request was received, but we're having trouble with our mail servers at the moment.  Please call <a href='tel:+61418983629'>0418 983 629</a> to log your ticket.");
                error_log('Mailer Error: ' . $e->errorMessage());
                $app->halt(500);
            }
            /**/

            //$app->alerts->addMessage("success", "Your ticket has been successfully logged!");
            if (!$app->user->checkAccess('uri_account-groups')){
                $app->notFound();
            }
            $schema = new \Fortress\RequestSchema($app->config('schema.path') . "/forms/contact.json");
            $app->jsValidator->setSchema($schema);

            $app->render('contact.twig', [
                "save_type" => 'add' ,
                'validators' => $app->jsValidator->rules()
            ]);

        }


    }
    
    
});


/*
 * Processes the contact form submission.
 */
$app->post('/contactBENER/?', function () use ($app) {    
    
    $app->halt(500);
    $app->redirect($app->site->uri['public']."/contact3/"); 
    echo("ada foto");
    // POST: name, siteaddress, email, [phone], message, spiderbro
    $post = $app->request->post();
    
    // Get the alert message stream
    $ms = $app->alerts; 
    
    // Check the honeypot. 'spiderbro' is not a real field, it is hidden on the main page and must be submitted with its default value for this to be processed.
    if (!$post['spiderbro'] || $post['spiderbro'] != "http://"){
        error_log("Possible spam received:" . print_r($app->request->post(), true));
        $ms->addMessage("danger", "Aww hellllls no!");
        $app->halt(500);     // Don't let on about why the request failed ;-)
    }  
            
    // Load the request schema
    $requestSchema = new \Fortress\RequestSchema($app->config('schema.path') . "/forms/contact.json");
               
    // Set up Fortress to process the request
    $rf = new \Fortress\HTTPRequestFortress($ms, $requestSchema, $post);
    
    // Sanitize data
    $rf->sanitize();
            
    // Validate, and halt on validation errors.        
    if (!$rf->validate())
        $app->halt(400);
    
    // Get the filtered data
    $data = $rf->data();   
		
    if($post['save_type']=="add")
	{
	
	
		
		// Set up and send email
		$twig = $app->view()->getEnvironment();
		$template = $twig->loadTemplate("mail/contact-config.twig"); 
		$notification = new \UserFrosting\Notification($template);
		
	  
		$notification->from(
			$app->config('email')['admin'],
			'ProServ Ticket Requests',
			$data['email'],
			$data['name']
		);
	  
		
		$notification->addEmailRecipient('enquiries@ptsg.com.au', 'Ticket Requests', ["data" => $data]);
		if(isset($data["name"]))
		{
			$data["sitecontact"]=$data["name"];
			unset($data["name"]);
		}
		if(isset($data["message"]))
		{
			$data["notes"]=$data["message"];
			unset($data["message"]);
		}
		
        if (isset($_FILES['files'])) 
        {
            $myFile = $_FILES['files'];
            $fileCount = count($myFile["name"]);
            $target_dir = "uploads/";
            $temp_upload_count=0;
            for ($i = 0; $i < $fileCount; $i++) 
            {
                
                $target_file = $target_dir . basename($myFile["name"][$i]);
                $uploadOk = 1;
                $imageFileType = pathinfo($target_file,PATHINFO_EXTENSION);
                // Check if image file is a actual image or fake image
                if(isset($_POST["submit"])) {
                    $check = getimagesize($myFile["tmp_name"][$i]);
                    if($check !== false) {
                        //echo "File is an image - " . $check["mime"] . ".";
                        $uploadOk = 1;
                    } else {
                        //echo "File is not an image.";
                        $uploadOk = -1;
                    }
                }
                // Check if file already exists
                if (file_exists($target_file)) {
                    //echo "Sorry, file already exists.";
                    $uploadOk = -2;
                }
                // Check file size
                if ($myFile["size"][$i] > 500000) {
                    //echo "Sorry, your file is too large.";
                    $uploadOk = -3;
                }
                // Allow certain file formats
                if($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "jpeg") 
                {
                    //echo "Sorry, only JPG, JPEG, PNG files are allowed.";
                    $uploadOk = -4;
                }
                // Check if $uploadOk is set to 0 by an error
                if ($uploadOk == 0) {
                    //echo "Sorry, your file was not uploaded.";
                // if everything is ok, try to upload file
                } else {
                    if (move_uploaded_file($myFile["tmp_name"][$i], $target_file)) {
                        //echo "The file ". basename( $myFile["name"][$i]). " has been uploaded.";
                        $temp_upload_count=$temp_upload_count+1;
                        
                        if($temp_upload_count==8)
                        {
                            break;
                        }
                    } else {
                        //echo "Sorry, there was an error uploading your file.";
                        $uploadOk = -5;
                    }
                }
               /*
                    <p>File #<?= $i+1 ?>:</p>
                    <p>
                        Name: <?= $myFile["name"][$i] ?><br>
                        Temporary file: <?= $myFile["tmp_name"][$i] ?><br>
                        Type: <?= $myFile["type"][$i] ?><br>
                        Size: <?= $myFile["size"][$i] ?><br>
                        Error: <?= $myFile["error"][$i] ?><br>
                    </p>
                    */
                
            }
            echo("ada foto");
            $app->alerts->addMessage("success", "ada foto");
            $app->halt(400);
        }
        else
        {
            echo("tidak ada foto");
            $app->alerts->addMessage("success", "tidak ada foto");
            $app->halt(400);
        }
        
		/**/
		
		$data["user_id"]=$app->user->id;
		$data["status"]="waiting for respond";
		//$app->alerts->addMessage("success", "Your ticket has been successfully logged!".$tempNamaArray);
		
		// Create the user
		$tickets = new Tickets($data);
		// Save user again after creating events
		$tickets->save();
		
		try {
			$notification->send();
			$app->alerts->addMessage("success", "Your ticket has been successfully logged!");
		} catch (\phpmailerException $e){
			$app->alerts->addMessage("warning", "Your request was received, but we're having trouble with our mail servers at the moment.  Please call <a href='tel:+61418983629'>0418 983 629</a> to log your ticket.");
			error_log('Mailer Error: ' . $e->errorMessage());
			$app->halt(500);
		}
		$app->alerts->addMessage("success", "Your ticket has been successfully logged!");
	}
	else
	{
		if(isset($data["name"]))
		{
			$data["sitecontact"]=$data["name"];
			unset($data["name"]);
		}
		if(isset($data["message"]))
		{
			$data["notes"]=$data["message"];
			unset($data["message"]);
		}
		$target_ticket = Tickets::find($post['ticket_id']);

		if($target_ticket)
		{
			$target_ticket->sitecontact = $data["sitecontact"];
			$target_ticket->siteaddress = $data["siteaddress"];
			$target_ticket->email = $data["email"];
			$target_ticket->phone = $data["phone"];
			$target_ticket->servicelevel = $data["servicelevel"];
			$target_ticket->servicetype = $data["servicetype"];
			$target_ticket->notes = $data["notes"];
			$target_ticket->save();
			$app->alerts->addMessage("success", "the ticket has been successfully updated!");
		}
		
		
		
	}
	
	/**/
});
    

/**
 * Renders the analytics form.
 */
$app->get('/analytics/?', function () use ($app) {
	// Access-controlled page
    if (!$app->user->checkAccess('uri_view-chart')){
		$app->notFound();
    }
    //$schema = new \Fortress\RequestSchema($app->config('schema.path') . "/forms/contact.json");
    //$app->jsValidator->setSchema($schema);
    $type=1;
    if ($app->user->checkAccess('uri_tickets'))
    {
        $type=2;
    }
    include("userfrosting/models/database/Analytics.php");
    
    $app->render('analytics.twig', [
        "analytic_servicetype" => $analytic_servicetype ,
        "analytic_servicelevel" => $analytic_servicelevel ,
        "analytic_venue" => $analytic_venue ,
        "total" => $total ,
        "open_ticket" => $open_ticket ,
		//"save_type" => 'add' ,
        //'validators' => $app->jsValidator->rules()
    ]);
});
    
       
    /********** ACCOUNT MANAGEMENT INTERFACE **********/
    
    $app->get('/account/:action/?', function ($action) use ($app) {    
        // Forward to installation if not complete
        if (!isset($app->site->install_status) || $app->site->install_status == "pending"){
            $app->redirect($app->urlFor('uri_install'));
        }
    
        $get = $app->request->get();
        
        $controller = new UF\AccountController($app);
    
        $twig = $app->view()->getEnvironment();   
        $loader = $twig->getLoader();
          
        switch ($action) {
            case "login":               return $controller->pageLogin();
            case "logout":              return $controller->logout(true); 
            case "register":            return $controller->pageRegister();         
            case "resend-activation":   return $controller->pageResendActivation();
            case "forgot-password":     return $controller->pageForgotPassword();
            case "activate":            return $controller->activate();
            case "set-password":        return $controller->pageSetPassword(true); 
            case "reset-password":      if (isset($get['confirm']) && $get['confirm'] == "true")
                                            return $controller->pageSetPassword(false);
                                        else
                                            return $controller->denyResetPassword();
            case "captcha":             return $controller->captcha();
            case "settings":            return $controller->pageAccountSettings();
            default:                    return $controller->page404();   
        }
    });

    $app->post('/account/:action/?', function ($action) use ($app) {            
        $controller = new UF\AccountController($app);
    
        switch ($action) {
            case "login":               return $controller->login();     
            case "register":            return $controller->register();
            case "resend-activation":   return $controller->resendActivation();
            case "forgot-password":     return $controller->forgotPassword();
            case "set-password":        return $controller->setPassword(true);
            case "reset-password":      return $controller->setPassword(false);            
            case "settings":            return $controller->accountSettings();
            default:                    $app->notFound();
        }
    });    
    
    /********** USER MANAGEMENT INTERFACE **********/
    
    // List users
    $app->get('/users/?', function () use ($app) {
        $controller = new UF\UserController($app);
        return $controller->pageUsers();
    })->name('uri_users');    

    // List users in a particular primary group
    $app->get('/users/:primary_group/?', function ($primary_group) use ($app) {
        $controller = new UF\UserController($app);
        return $controller->pageUsers($primary_group);
    });
    
    // User info form (update)
    $app->get('/forms/users/u/:user_id/?', function ($user_id) use ($app) {
        $controller = new UF\UserController($app);
        return $controller->formUserEdit($user_id);
    });  

    // User edit password form
    $app->get('/forms/users/u/:user_id/password/?', function ($user_id) use ($app) {
        $controller = new UF\UserController($app);
        $get = $app->request->get();        
        return $controller->formUserEditPassword($user_id);
    });
    
    // User creation form
    $app->get('/forms/users/?', function () use ($app) {
        $controller = new UF\UserController($app);
        return $controller->formUserCreate();
    });
    
    // User info page
    $app->get('/users/u/:user_id/?', function ($user_id) use ($app) {
        $controller = new UF\UserController($app);
        return $controller->pageUser($user_id);
    });       

    // Create user
    $app->post('/users/?', function () use ($app) {
        $controller = new UF\UserController($app);
        return $controller->createUser();
    });
    
    // Update user info
    $app->post('/users/u/:user_id/?', function ($user_id) use ($app) {
        $controller = new UF\UserController($app);
        return $controller->updateUser($user_id);
    });       
    
    // Delete user
    $app->post('/users/u/:user_id/delete/?', function ($user_id) use ($app) {
        $controller = new UF\UserController($app);
        return $controller->deleteUser($user_id);
    });
    
    /********** GROUP MANAGEMENT INTERFACE **********/
    
    // List groups
    $app->get('/groups/?', function () use ($app) {
        $controller = new UF\GroupController($app);
        return $controller->pageGroups();
    }); 
    
    // List auth rules for a group
    $app->get('/groups/g/:group_id/auth?', function ($group_id) use ($app) {
        $controller = new UF\GroupController($app);
        return $controller->pageGroupAuthorization($group_id);
    })->name('uri_authorization');  
    
    // Group info form (update)
    $app->get('/forms/groups/g/:group_id/?', function ($group_id) use ($app) {
        $controller = new UF\GroupController($app);
        return $controller->formGroupEdit($group_id);
    });

    // Group creation form
    $app->get('/forms/groups/?', function () use ($app) {
        $controller = new UF\GroupController($app);
        return $controller->formGroupCreate();
    });    
    
    // Create group
    $app->post('/groups/?', function () use ($app) {
        $controller = new UF\GroupController($app);
        return $controller->createGroup();
    });
    
    // Update group info
    $app->post('/groups/g/:group_id/?', function ($group_id) use ($app) {
        $controller = new UF\GroupController($app);
        return $controller->updateGroup($group_id);
    });       

    // Delete group
    $app->post('/groups/g/:group_id/delete/?', function ($group_id) use ($app) {
        $controller = new UF\GroupController($app);
        return $controller->deleteGroup($group_id);
    });
	
	
	
	$app->get('/ticket-history/?', function () use ($app) {
        $controller = new UF\UserController($app);
        return $controller->pageTickets();
    })->name('uri_users');    
	
    // Delete user
    $app->post('/tickets/u/:user_id/delete/?', function ($user_id) use ($app) {
        $controller = new UF\UserController($app);
        return $controller->deleteTicket($user_id);
    });
	
	// User info form (update)
    $app->get('/forms/ticket/u/:user_id/?', function ($user_id) use ($app) {
        $controller = new UF\UserController($app);
        return $controller->formTicketEdit($user_id);
		//$controller = new UF\AdminController($app);
        //return $controller->pageCreateCoupon();
    });

    // User info form (update)
    $app->get('/forms/ticket/u/:user_id/info/?', function ($user_id) use ($app) {
        $controller = new UF\UserController($app);
        return $controller->formTicketInfo($user_id);
		//$controller = new UF\AdminController($app);
        //return $controller->pageCreateCoupon();
    });

    // ticket worklog form (update)
    $app->get('/forms/ticket/u/:user_id/worklog/?', function ($user_id) use ($app) {
        $controller = new UF\UserController($app);
        return $controller->formTicketWorklog($user_id);
		//$controller = new UF\AdminController($app);
        //return $controller->pageCreateCoupon();
    });
	
    /********** GROUP AUTH RULES INTERFACE **********/
    
    // Group auth creation form
    $app->get('/forms/groups/g/:group_id/auth/?', function ($group_id) use ($app) {
        $controller = new UF\AuthController($app);
        return $controller->formAuthCreate($group_id, "group");
    });      
    
    // Group auth update form
    $app->get('/forms/groups/auth/a/:rule_id/?', function ($rule_id) use ($app) {
        $controller = new UF\AuthController($app);
        $get = $app->request->get();        
        return $controller->formAuthEdit($rule_id);
    });    

    // Group auth create
    $app->post('/groups/g/:group_id/auth/?', function ($group_id) use ($app) {
        $controller = new UF\AuthController($app);
        return $controller->createAuthRule($group_id, "group");
    });     

    // Group auth update
    $app->post('/groups/auth/a/:rule_id?', function ($rule_id) use ($app) {
        $controller = new UF\AuthController($app);
        return $controller->updateAuthRule($rule_id, "group");
    });
    
    // Group auth delete
    $app->post('/auth/a/:rule_id/delete/?', function ($rule_id) use ($app) {
        $controller = new UF\AuthController($app);
        $get = $app->request->get();        
        return $controller->deleteAuthRule($rule_id);
    });  
        
    /************ ADMIN TOOLS *************/
    
    $app->get('/config/settings/?', function () use ($app) {
        $controller = new UF\AdminController($app);
        return $controller->pageSiteSettings();
    })->name('uri_settings');     
    
    $app->post('/config/settings/?', function () use ($app) {
        $controller = new UF\AdminController($app);
        return $controller->siteSettings();        
    });
    
    // Build the minified, concatenated CSS and JS
    $app->get('/config/build', function() use ($app){
        // Access-controlled page
        if (!$app->user->checkAccess('uri_minify')){
            $app->notFound();
        }
        
        $app->schema->build(true);
        $app->alerts->addMessageTranslated("success", "MINIFICATION_SUCCESS");
        $app->redirect($app->urlFor('uri_settings'));
    });    
    
    // Slim info page
    $app->get('/sliminfo/?', function () use ($app) {
        // Access-controlled page
        if (!$app->user->checkAccess('uri_slim_info')){
            $app->notFound();
        }
        echo "<pre>";
        print_r($app->environment());
        echo "</pre>";
    });

    // PHP info page
    $app->get('/phpinfo/?', function () use ($app) {
        // Access-controlled page
        if (!$app->user->checkAccess('uri_php_info')){
            $app->notFound();
        }    
        echo "<pre>";
        print_r(phpinfo());
        echo "</pre>";
    });

    // Error log page
    $app->get('/errorlog/?', function () use ($app) {
        // Access-controlled page
        if (!$app->user->checkAccess('uri_error_log')){
            $app->notFound();
        }
        $log = UF\SiteSettings::getLog();
        echo "<pre>";
        echo implode("<br>",$log['messages']);
        echo "</pre>";
    });      
       
    /************ INSTALLER *************/

    $app->get('/install/?', function () use ($app) {
        $controller = new UF\InstallController($app);
        if (isset($app->site->install_status)){
            // If tables have been created, move on to master account setup
            if ($app->site->install_status == "pending"){
                $app->redirect($app->site->uri['public'] . "/install/master");
            } else {
                // Everything is set up, so go to the home page!
                $app->redirect($app->urlFor('uri_home'));
            }
        } else {
            return $controller->pageSetupDB();
        }
    })->name('uri_install');
    
    $app->get('/install/master/?', function () use ($app) {
        $controller = new UF\InstallController($app);
        if (isset($app->site->install_status) && ($app->site->install_status == "pending")){
            return $controller->pageSetupMasterAccount();
        } else {
            $app->redirect($app->urlFor('uri_install'));
        }
    });

    $app->post('/install/:action/?', function ($action) use ($app) {
        $controller = new UF\InstallController($app);
        switch ($action) {
            case "master":            return $controller->setupMasterAccount();      
            default:                  $app->notFound();
        }   
    });
    
    /************ API *************/
    
    $app->get('/api/users/?', function () use ($app) {
        $controller = new UF\ApiController($app);
        $controller->listUsers();
    });
    
    
    /************ MISCELLANEOUS UTILITY ROUTES *************/
    
    // Generic confirmation dialog
    $app->get('/forms/confirm/?', function () use ($app) {
        $get = $app->request->get();
        
        // Load the request schema
        $requestSchema = new \Fortress\RequestSchema($app->config('schema.path') . "/forms/confirm-modal.json");
        
        // Get the alert message stream
        $ms = $app->alerts;         
        
        // Remove csrf_token
        unset($get['csrf_token']);
        
        // Set up Fortress to process the request
        $rf = new \Fortress\HTTPRequestFortress($ms, $requestSchema, $get);                    
    
        // Sanitize
        $rf->sanitize();
    
        // Validate, and halt on validation errors.
        if (!$rf->validate()) {
            $app->halt(400);
        }           
        
        $data = $rf->data();
        
        $app->render('components/common/confirm-modal.twig', $data);   
    }); 
    
    // Alert stream
    $app->get('/alerts/?', function () use ($app) {
        $controller = new UF\BaseController($app);
        $controller->alerts();
    });
    
    // JS Config
    $app->get($app->config('uri')['js-relative'] . '/config.js', function () use ($app) {
        $controller = new UF\BaseController($app);
        $controller->configJS();
    });
    
    // Theme CSS
    $app->get($app->config('uri')['css-relative'] . '/theme.css', function () use ($app) {
        $controller = new UF\BaseController($app);
        $controller->themeCSS();
    });
    
    // Not found page (404)
    $app->notFound(function () use ($app) {
        if ($app->request->isGet()) {
            $controller = new UF\BaseController($app);
            $controller->page404();
        } else {
            $app->alerts->addMessageTranslated("danger", "SERVER_ERROR");
        }
    });
    
    $app->run();
