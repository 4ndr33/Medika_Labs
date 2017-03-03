<?php
/*
$servername = "localhost";
$username = 'root';
$password = '';
$dbname = 'frostingdb';
*/


$servername = "localhost";
$username = 'frostuser';
$password = 'MWL8wbsr';
$dbname = 'frostingdb';


$user_info="User does not exist";

$admin_user_info="";

$submitbutton="";


$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    //die("Connection failed: " . $conn->connect_error);
}
else
{
	if(isset($_GET['e']))
	{
		if(strlen($_GET['e'])>0)
		{
			$sql = "select user_admin_id, primary_group_id from uf_user where user_name='".$_GET['e']."'";
			$result = $conn->query($sql);

			if ($result->num_rows > 0) {
				// output data of each row
				while($row = $result->fetch_assoc()) {
					//echo "id: " . $row["id"]. " - Name: " . $row["firstname"]. " " . $row["lastname"]. "<br>";
					$user_admin_id=(int)($row["user_admin_id"]);
					$primary_group_id=(int)($row["primary_group_id"]);
					$available=0;
					if($primary_group_id==1)
					{
						if($user_admin_id==0)
						{
							$available=1;
						}
					}
					if($available==0)
					{
						$user_info="User is not available";
						$admin_user_info="";
					}
					else if($available==1)
					{
						$user_info="User is available";
						$admin_user_info="User does not exist";
						if(isset($_GET['e2']))
						{
							if((int)($_GET['e2'])==1)
							{
								$submitbutton="<div class='form-group text-center'>";
								$submitbutton .="<button type='submit' class='btn btn-success text-center'>Offer Provider Admin Position</button>";
								$submitbutton .="</div>";
							}
							else if((int)($_GET['e2'])==2)
							{
								if(isset($_GET['e3']))
								{
									$sql2 = "select user_admin_id, primary_group_id from uf_user where user_name='".$_GET['e3']."'";
									$result2 = $conn->query($sql2);

									if ($result2->num_rows > 0) {
										while($row2 = $result2->fetch_assoc()) {
											$user_admin_id2=(int)($row2["user_admin_id"]);
											$primary_group_id2=(int)($row2["primary_group_id"]);
											if($primary_group_id2==6)
											{
												$admin_user_info="Provider Admin is available";
												$submitbutton="<div class='form-group text-center'>";
												$submitbutton .="<button type='submit' class='btn btn-success text-center'>Offer Provider User Position</button>";
												$submitbutton .="</div>";
											}
											else
											{
												$admin_user_info="User is not a Provider Admin";
											}
										}
										
									}
								}
								
							}
							else if((int)($_GET['e2'])==3)
							{
								$submitbutton="<div class='form-group text-center'>";
								$submitbutton .="<button type='submit' class='btn btn-success text-center'>Offer User Admin Position</button>";
								$submitbutton .="</div>";
							}
							else if((int)($_GET['e2'])==4)
							{
                                if(isset($_GET['e3']))
								{
									$sql2 = "select user_admin_id, primary_group_id from uf_user where user_name='".$_GET['e3']."'";
									$result2 = $conn->query($sql2);

									if ($result2->num_rows > 0) {
										while($row2 = $result2->fetch_assoc()) {
											$user_admin_id2=(int)($row2["user_admin_id"]);
											$primary_group_id2=(int)($row2["primary_group_id"]);
											if($primary_group_id2==9)
											{
												$admin_user_info="User Admin is available";
												$submitbutton="<div class='form-group text-center'>";
                                                $submitbutton .="<button type='submit' class='btn btn-success text-center'>Offer Client User Position</button>";
                                                $submitbutton .="</div>";
											}
											else
											{
												$admin_user_info="User is not a User Admin";
											}
										}
										
									}
								}
								
							}
						}
						
						
					}
					
					
				}
			} else {
				//echo "0 results";
			}
		}
	}
    $conn->close(); 
}


if(isset($_GET['e']))
{
    if(strlen($_GET['e'])>0)
    {
        if(isset($_GET['e3']))
        {
            if(strlen($_GET['e3'])>0)
            {
                if($_GET['e']==$_GET['e3'])
                {
                    $user_info="User and the admin must be different";
                    $admin_user_info="User and the admin must be different";
                    $submitbutton="";
                }
            }
        }
    }
}
if(isset($_GET['e1']))
{
	if((int)($_GET['e1'])==1)
	{
		echo("$user_info");
	}
	else if((int)($_GET['e1'])==2)
	{
		echo("$submitbutton");
	}
	else if((int)($_GET['e1'])==3)
	{
		echo("$admin_user_info");
	}
}





?>