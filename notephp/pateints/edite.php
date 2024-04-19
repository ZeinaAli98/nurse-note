
<?php 

include "../connect.php";

$id_patient           = filterRequest("id_patient ");
$name_patient         = filterRequest("name_patient");



 $stm= $connect-> prepare("UPDATE `patient` SET `name_patient`=?,`isStopped`=? ,`room_patient`=? WHERE id_patient =? ");
 $stm-> execute(array($name_patient  ,$isStopped,$room_patient ,$id_patient ));


 $count = $stm-> rowCount();
 if($count>0){

    echo json_encode(array("status"=> "success"));
 }else{

    echo json_encode(array("status"=> "fail"));
 }


?>