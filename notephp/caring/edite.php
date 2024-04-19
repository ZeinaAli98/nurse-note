<?php

include "../connect.php";

$id_caring = filterRequest("id_caring");
$ID_caringtype = filterRequest("ID_caringtype");
$ID_patient = filterRequest("ID_patient");
$time = filterRequest("time");
$description_caring = filterRequest("description_caring");
$isStopped            = filterRequest("isStopped");
$room_patient        = filterRequest("room_patient");

if (isset($id_caring, $ID_caringtype, $ID_patient, $time, $description_caring)) {
    $stm = $connect->prepare(" UPDATE caring SET `ID_caringtype`=? ,`ID_patient`=? , `time` =?, `description_caring`=?, `isStopped`=?,`room_patient`=? WHERE `id_caring`=? 
       
    ");

    $stm->execute(array(
        $ID_caringtype ,
        $ID_patient,
        $time,
        $description_caring,
        $isStopped,
        $room_patient,
        $id_caring
    ));

    $count = $stm->rowCount();

    if ($count > 0) {
        echo json_encode(array("status" => "success"));
    } else {
        echo json_encode(array("status" => "fail"));
    }
} else {
    echo json_encode(array("status" => "fail", "message" => "Missing required parameters"));
}

?>


