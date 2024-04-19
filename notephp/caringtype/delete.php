<?php 

include "../connect.php";


 $id_caringtype         = filterRequest("id_caringtype");



 $stm= $connect-> prepare("DELETE FROM caringtype WHERE $id_caringtype =? ");
 $stm-> execute(array($id_caringtype));
 

 $count = $stm-> rowCount();
 if($count>0){

    echo json_encode(array("status"=> "success"));
 }else{

    echo json_encode(array("status"=> "fail"));
 }


?>