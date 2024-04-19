<?php 

include "../connect.php";


 $number_rooms       = filterRequest("number_rooms");
 $image_rooms        = imageUplaod("image_rooms");
 

 if ( $image_rooms !='fail'){

 $stm= $connect-> prepare("INSERT INTO `rooms` (`number_rooms`,`image_rooms`) VALUES (?,?)");
 $stm-> execute(array($number_rooms , $image_rooms));


 $count = $stm-> rowCount();
 if($count>0){

    echo json_encode(array("status"=> "success"));
 }else{

    echo json_encode(array("status"=> "fail"));
 }


 }



?>