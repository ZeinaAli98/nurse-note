<?php 

include "../connect.php";


 $id_rooms        = filterRequest("id_rooms");
 $image_rooms     = filterRequest("image_rooms");

 $stm = $connect->prepare("DELETE FROM rooms WHERE id_rooms= ?");
 $stm->execute(array($id_rooms));
 

 $count = $stm-> rowCount();
 if($count>0){
    deleteImage("../upload",$image_rooms);
    echo json_encode(array("status"=> "success"));
 }else{

    echo json_encode(array("status"=> "fail"));
 }


?>