


<?php 

include "../connect.php";


 $id_rooms = isset($_POST['id_caring']) ? $_POST['id_caring'] : null;

 
 $stm = $connect->prepare("SELECT caring.*, caringtype.name_caringtype , patients.name_patient FROM caring JOIN caringtype ON caring.id_caringtype = caringtype.id_caringtype JOIN patients ON caring.ID_patient= patients.id_patient");
 $stm-> execute();
 $data= $stm-> fetchAll(PDO::FETCH_ASSOC);
 $count = $stm-> rowCount();
 if($count>0){

    echo json_encode(array("status"=> "success","data"=> $data));
 }else{

    echo json_encode(array("status"=> "fail"));
 }


?>