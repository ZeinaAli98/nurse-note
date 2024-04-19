<?php 

include "../connect.php";

$id_caringtype           = filterRequest("id_caringtype");
$name_caringtype         = filterRequest("name_caringtype");
$description_caringtype  = filterRequest("description_caringtype");


 $stm= $connect-> prepare("UPDATE `caringtype` SET `name_caringtype`=?,`description_caringtype`=? WHERE id_caringtype=? ");
 $stm-> execute(array($name_caringtype,$description_caringtype,$id_caringtype,));


 $count = $stm-> rowCount();
 if($count>0){

    echo json_encode(array("status"=> "success"));
 }else{

    echo json_encode(array("status"=> "fail"));
 }


?>