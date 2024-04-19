<?php 

include "../connect.php";


 $id_rooms = isset($_POST['id_rooms']) ? $_POST['id_rooms'] : null;

 
 $stm= $connect-> prepare("SELECT * From rooms");
 $stm-> execute();
 $data= $stm-> fetchAll(PDO::FETCH_ASSOC);
 $count = $stm-> rowCount();
 if($count>0){

    echo json_encode(array("status"=> "success","data"=> $data));
 }else{

    echo json_encode(array("status"=> "fail"));
 }


?>