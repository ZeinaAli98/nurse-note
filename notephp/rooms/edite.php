
<?php 

include "../connect.php";

$id_rooms              = filterRequest("id_rooms");
$number_rooms          = filterRequest("number_rooms");
$image_rooms           = imageUplaod("image_rooms");


$stm= $connect-> prepare("UPDATE `rooms` SET `number_rooms`=?,`image_rooms`=? WHERE id_rooms =? ");
$stm-> execute(array($number_rooms  ,$image_rooms  ,$id_rooms ));
 if(isset($_FILES['image_rooms'])){

   deleteImage("../upload",$image_rooms);
   $image_rooms =imageUplaod("image_rooms");

 }

 $count = $stm-> rowCount();
 if($count>0){

    echo json_encode(array("status"=> "success"));
 }else{

    echo json_encode(array("status"=> "fail"));
 }


?>