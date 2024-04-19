<?php 

include "../connect.php";


 $name_patient        = filterRequest("name_patient");



 $stm= $connect-> prepare("INSERT INTO `patients`(`name_patient`) VALUES (?)");
 $stm-> execute(array($name_patient));


 $count = $stm-> rowCount();
 if($count>0){

    echo json_encode(array("status"=> "success"));
 }else{

    echo json_encode(array("status"=> "fail"));
 }


?>