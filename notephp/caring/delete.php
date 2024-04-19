<?php 

include "../connect.php";


 $id_caring         = filterRequest("id_caring");



 $stm= $connect-> prepare("DELETE FROM caring  WHERE id_caring =? ");
 $stm-> execute(array($id_caring ));
 

 $count = $stm-> rowCount();
 if($count>0){

    echo json_encode(array("status"=> "success"));
 }else{

    echo json_encode(array("status"=> "fail"));
 }


?>