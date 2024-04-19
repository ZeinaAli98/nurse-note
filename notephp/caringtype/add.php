<?php 

include "../connect.php";


 $name_caringtype         = filterRequest("name_caringtype");
 $description_caringtype  = filterRequest("description_caringtype");


 $stm= $connect-> prepare("INSERT INTO `caringtype`(`name_caringtype`,`description_caringtype`) VALUES (?,?)");
 $stm-> execute(array($name_caringtype,$description_caringtype));


 $count = $stm-> rowCount();
 if($count>0){

    echo json_encode(array("status"=> "success"));
 }else{

    echo json_encode(array("status"=> "fail"));
 }


?>