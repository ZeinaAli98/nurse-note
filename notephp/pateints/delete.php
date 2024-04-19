<?php 

include "../connect.php";


 $id_patient         = filterRequest("id_patient ");



 $stm= $connect-> prepare("DELETE FROM patient WHERE $id_patient   =? ");
 $stm-> execute(array($id_patient  ));
 

 $count = $stm-> rowCount();
 if($count>0){

    echo json_encode(array("status"=> "success"));
 }else{

    echo json_encode(array("status"=> "fail"));
 }


?>