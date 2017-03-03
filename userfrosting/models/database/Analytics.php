<?php

$analytic_servicetype[0]['value']="";
$analytic_servicetype[0]['type']="";


$analytic_servicelevel[0]['value']="";
$analytic_servicelevel[0]['label']="";
$analytic_servicelevel[0]['span']="";

$analytic_venue[0]['value']="";
$analytic_venue[0]['label']="";
$analytic_venue[0]['span']="";


$total=0;
$open_ticket=0;

$servername = "localhost";
$username = $app->config('db')['db_user'];
$password = $app->config('db')['db_pass'];
$dbname = $app->config('db')['db_name'];
/*
$type=2;
if(isset($_GET["t"]))
{
    $type=(int)($_GET["t"]);
}
*/
// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);
// Check connection
if ($conn->connect_error) {
    //die("Connection failed: " . $conn->connect_error);
}
else
{
    if($type==2)
    {
        $sql = "select count(status) as num from uf_tickets where status!='Complete'";    
    }
    else
    {
        $sql = "select count(status) as num from uf_tickets where status!='Complete' and user_id='".$app->user->id."'";
    }

    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        // output data of each row
        while($row = $result->fetch_assoc()) {
            //echo "id: " . $row["id"]. " - Name: " . $row["firstname"]. " " . $row["lastname"]. "<br>";
            $open_ticket=(int)($row["num"]);
        }
    } else {
        //echo "0 results";
    }
    
    $service_type[0]="Not Sure";
    $service_type[1]="Electrical";
    $service_type[2]="Telecommunications";
    $service_type[3]="Plumbing";
    $service_type[4]="Glazing";
    $service_type[5]="Plastering";
    $service_type[6]="Painting";
    $service_type[7]="Other";
    
    $service_type_count[0]=0;
    $service_type_count[1]=0;
    $service_type_count[2]=0;
    $service_type_count[3]=0;
    $service_type_count[4]=0;
    $service_type_count[5]=0;
    $service_type_count[6]=0;
    $service_type_count[7]=0;
    $service_type_total=0;
    for($i2=0;$i2<=7;$i2++)
    {
        //    
        if($type==2)
        {
            $sql = "select count(servicetype) as num from uf_tickets where servicetype='".$service_type[$i2]."'";    
        }
        else
        {
            $sql = "select count(servicetype) as num from uf_tickets where servicetype='".$service_type[$i2]."' and user_id='".$app->user->id."'";
        }
        
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
            // output data of each row
            while($row = $result->fetch_assoc()) {
                //echo "id: " . $row["id"]. " - Name: " . $row["firstname"]. " " . $row["lastname"]. "<br>";
                $service_type_count[$i2]=(int)($row["num"]);
                $service_type_total=$service_type_total+$service_type_count[$i2];
            }
        } else {
            //echo "0 results";
        }
    }
   $total=$service_type_total;
    $service_type_rank[0]=0;
    $service_type_rank[1]=0;
    $service_type_rank[2]=0;
    $service_type_rank[3]=0;
    
    $last_highest=0;
    $point_last_highest=0;
    for($i2=0;$i2<=3;$i2++)
    {
        $last_highest=0;
        $point_last_highest=0;    
        for($i3=0;$i3<=7;$i3++)
        {
            if($last_highest==0)
            {
                if($i2==0)
                {
                    $point_last_highest=$service_type_count[$i3];
                    $last_highest=$i3+1;    
                }
                else if($i2>=1)
                {
                    $listed=0;
                    for($i4=0;$i4<=($i2-1);$i4++)
                    {
                        if($i3==($service_type_rank[$i4]-1))
                        {
                            $listed=1;
                            break;
                        }
                    }
                    if($listed==0)
                    {
                        $point_last_highest=$service_type_count[$i3];
                        $last_highest=$i3+1;  
                    }
                }
            }
            else
            {
                if($point_last_highest<$service_type_count[$i3])
                {
                    if($i2==0)
                    {
                        $point_last_highest=$service_type_count[$i3];
                        $last_highest=$i3+1;    
                    }
                    else if($i2>=1)
                    {
                        $listed=0;
                        for($i4=0;$i4<=($i2-1);$i4++)
                        {
                            if($i3==($service_type_rank[$i4]-1))
                            {
                                $listed=1;
                                break;
                            }
                        }
                        if($listed==0)
                        {
                            $point_last_highest=$service_type_count[$i3];
                            $last_highest=$i3+1;  
                        }
                    }
                    
                }
            }
        }
        if($last_highest>0)
        {
            $service_type_rank[$i2]=$last_highest;
            if($service_type_total>0)
            {
                $analytic_servicetype[$i2]['value']=round(($service_type_count[$last_highest-1]/$service_type_total)*100);    
            }
            else
            {
                $analytic_servicetype[$i2]['value']=0;
            }
            
            $analytic_servicetype[$i2]['type']=$service_type[$last_highest-1];
        }
    }
    
    
    
    $service_level[0]="Priority Service";
    $service_level[1]="Off-Peak Service";
    
    $service_level1[0]="Priority";
    $service_level1[1]="Off-Peak";
    
    $service_level_count[0]=0;
    $service_level_count[1]=0;
    $service_level_total=$service_type_total;
    
    
    for($i2=0;$i2<=1;$i2++)
    {
        if($type==2)
        {
            $sql = "select count(servicelevel) as num from uf_tickets where servicelevel='".$service_level1[$i2]."'"; 
        }
        else
        {
            $sql = "select count(servicelevel) as num from uf_tickets where servicelevel='".$service_level1[$i2]."' and user_id='".$app->user->id."'";
        }
        
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
            // output data of each row
            while($row = $result->fetch_assoc()) {
                //echo "id: " . $row["id"]. " - Name: " . $row["firstname"]. " " . $row["lastname"]. "<br>";
                $service_level_count[$i2]=(int)($row["num"]);
            }
        } else {
            //echo "0 results";
        }
    }
    
    $service_level_rank[0]=0;
    $service_level_rank[1]=0;
    
    $last_highest=0;
    $point_last_highest=0;
    for($i2=0;$i2<=1;$i2++)
    {
        $last_highest=0;
        $point_last_highest=0;    
        for($i3=0;$i3<=1;$i3++)
        {
            if($last_highest==0)
            {
                if($i2==0)
                {
                    $point_last_highest=$service_level_count[$i3];
                    $last_highest=$i3+1;    
                }
                else if($i2>=1)
                {
                    $listed=0;
                    for($i4=0;$i4<=($i2-1);$i4++)
                    {
                        if($i3==($service_level_rank[$i4]-1))
                        {
                            $listed=1;
                            break;
                        }
                    }
                    if($listed==0)
                    {
                        $point_last_highest=$service_level_count[$i3];
                        $last_highest=$i3+1;  
                    }
                }
            }
            else
            {
                if($point_last_highest<$service_level_count[$i3])
                {
                    if($i2==0)
                    {
                        $point_last_highest=$service_level_count[$i3];
                        $last_highest=$i3+1;    
                    }
                    else if($i2>=1)
                    {
                        $listed=0;
                        for($i4=0;$i4<=($i2-1);$i4++)
                        {
                            if($i3==($service_level_rank[$i4]-1))
                            {
                                $listed=1;
                                break;
                            }
                        }
                        if($listed==0)
                        {
                            $point_last_highest=$service_level_count[$i3];
                            $last_highest=$i3+1;  
                        }
                    }
                    
                }
            }
        }
        if($last_highest>0)
        {
            $service_level_rank[$i2]=$last_highest;
            if($service_level_total>0)
            {
                $analytic_servicelevel[$i2]['value']=round(($service_level_count[$last_highest-1]/$service_level_total)*100);    
            }
            else
            {
                $analytic_servicelevel[$i2]['value']=0;
            }
            
            $analytic_servicelevel[$i2]['label']=$service_level[$last_highest-1];
            $analytic_servicelevel[$i2]['span']="rcorners".$last_highest;
            
        }
    }
    
    $venue_count_all=0;
    
    $venue_total=$service_type_total;
    
    
        if($type==2)
        {
            $sql = "select siteaddress from uf_tickets";   
        }
        else
        {
            $sql = "select siteaddress from uf_tickets where user_id='".$app->user->id."'";
        }
        
        $result = $conn->query($sql);

        if ($result->num_rows > 0) {
            // output data of each row
            while($row = $result->fetch_assoc()) {
                //echo "id: " . $row["id"]. " - Name: " . $row["firstname"]. " " . $row["lastname"]. "<br>";
                if($venue_count_all==0)
                {
                    $venue_count_all=$venue_count_all+1;
                    $venue[$venue_count_all-1]=$row["siteaddress"];
                    $venue_count[$venue_count_all-1]=1;
                    //$venue_count[$venue_count_all-1]=0;
                    //$venue2a .=$row["siteaddress"];
                }
                else if($venue_count_all>=1)
                {
                    
                    $venue_listed=0;
                    for($i3=0;$i3<=($venue_count_all-1);$i3++)
                    {
                        if($venue[$i3]==$row["siteaddress"])
                        {
                            //$venue2=$venue2+1;    
                            $venue_count[$i3]=$venue_count[$i3]+1;
                            $venue_listed=1;
                            //$venue2a .=$row["siteaddress"];
                            break;
                        }
                    }
                    if($venue_listed==0)
                    {
                        $venue_count_all=$venue_count_all+1;
                        $venue[$venue_count_all-1]=$row["siteaddress"];
                        $venue_count[$venue_count_all-1]=1;    
                    }
                }
            }
        } else {
            //echo "0 results";
        }
    
    $venue_rank[0]=0;
    $venue_rank[1]=0;
    $venue_rank[2]=0;
    $venue_rank[3]=0;
    $venue_rank[4]=0;
    
    $last_highest=0;
    $point_last_highest=0;
    if($venue_count_all>0)
    {
        for($i2=0;$i2<=4;$i2++)
        {
            $last_highest=0;
            $point_last_highest=0;    
            for($i3=0;$i3<=($venue_count_all-1);$i3++)
            {
                if($last_highest==0)
                {
                    if($i2==0)
                    {
                        $point_last_highest=$venue_count[$i3];
                        $last_highest=$i3+1;    
                    }
                    else if($i2>=1)
                    {
                        $listed=0;
                        for($i4=0;$i4<=($i2-1);$i4++)
                        {
                            if($i3==($venue_rank[$i4]-1))
                            {
                                $listed=1;
                                break;
                            }
                        }
                        if($listed==0)
                        {
                            $point_last_highest=$venue_count[$i3];
                            $last_highest=$i3+1;  
                        }
                    }
                }
                else
                {
                    if($point_last_highest<$venue_count[$i3])
                    {
                        if($i2==0)
                        {
                            $point_last_highest=$venue_count[$i3];
                            $last_highest=$i3+1;    
                        }
                        else if($i2>=1)
                        {
                            $listed=0;
                            for($i4=0;$i4<=($i2-1);$i4++)
                            {
                                if($i3==($venue_rank[$i4]-1))
                                {
                                    $listed=1;
                                    break;
                                }
                            }
                            if($listed==0)
                            {
                                $point_last_highest=$venue_count[$i3];
                                $last_highest=$i3+1;  
                            }
                        }

                    }
                }
            }
            if($last_highest>0)
            {
                $venue_rank[$i2]=$last_highest;
                if($venue_total>0)
                {
                    $analytic_venue[$i2]['value']=round(($venue_count[$last_highest-1]/$venue_total)*100); 
                    //$analytic_venue[$i2]['value']=$venue_count[$last_highest-1]; 
                }
                else
                {
                    $analytic_venue[$i2]['value']=0;
                }

                $analytic_venue[$i2]['label']=$venue[$last_highest-1];
                //$analytic_venue[$i2]['label']=$venue2a;
                
                $analytic_venue[$i2]['span']="rcorners".($i2+1);

            }
        }
    }
    else if($venue_count_all==0)
    {
        
        $analytic_venue[0]['value']=100;
        

        $analytic_venue[0]['label']="venue";
        
        $analytic_venue[0]['span']="rcorners1";
    }
    
    $no_content_chart=0;
    
    for($ii=6;$ii>=0;$ii--)
    {
        if($ii>0)
        {
            $day=$ii*-1;
            $str_date=strtotime("$day Day");    
        }
        else
        {
            $str_date=strtotime("now");    
        }
        $date_now=date("Y-m-d",$str_date);
        $no_content_chart=$no_content_chart+1;
        $logs_chart_content[$no_content_chart-1]['period']=$date_now;
        $logs_chart_content[$no_content_chart-1]['tickets']=0;
            
    }
    
    $start_date=strtotime("-6 Day");  
    
    if($type==2)
    {
        $sql = "select date_created from uf_tickets where date_created>=$start_date";
    }
    else
    {
        $sql = "select date_created from uf_tickets where user_id='".$app->user->id."' and date_created>=$start_date";
        
    }

    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        // output data of each row
        while($row = $result->fetch_assoc()) {
            $date_now=date("Y-m-d",$row["date_created"]);
            if($no_content_chart>=1)
            {
                $idx_content_chart_date_group=-1;

                for($i1=0;$i1<=($no_content_chart-1);$i1++)
                {
                    if($logs_chart_content[$i1]['period']==$date_now)
                    {
                        $idx_content_chart_date_group=$i1;
                        break;
                    }
                }

                if($idx_content_chart_date_group>=0)
                {
                    $logs_chart_content[$idx_content_chart_date_group]['tickets']=$logs_chart_content[$idx_content_chart_date_group]['tickets']+1;
                }
            }
        }
    } else {
        //echo "0 results";
    }

    
    $conn->close(); 
}

	


//$logs_chart_content_json=json_encode($logs_chart_content);

//$_GET['chart_period']