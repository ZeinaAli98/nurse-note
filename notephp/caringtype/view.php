<?php 

include "../connect.php";


 $id_caringtype = isset($_POST['id_caringtype']) ? $_POST['id_caringtype'] : null;

 
 $stm= $connect-> prepare("SELECT * From caringtype");
 $stm-> execute();
 $data= $stm-> fetchAll(PDO::FETCH_ASSOC);
 $count = $stm-> rowCount();
 if($count>0){

    echo json_encode(array("status"=> "success","data"=> $data));
 }else{

    echo json_encode(array("status"=> "fail"));
 }


?>