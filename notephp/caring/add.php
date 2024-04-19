<?php
include "../connect.php";

$time = filterRequest("time");
$description_caring = filterRequest("description_caring");
$ID_patient = filterRequest("ID_patient"); // Assuming you have the ID of the patient
$ID_caringtype = filterRequest("ID_caringtype"); 
$room_patient        = filterRequest("room_patient");
$isStopped           = filterRequest("isStopped");// Assuming you have the ID of the caring type

$stm = $connect->prepare("INSERT INTO `caring` (`time`, `description_caring`, `ID_patient`, `ID_caringtype`,`room_patient`,`isStopped`) VALUES (?, ?, ?, ?,?,?)");
$stm->execute(array($time, $description_caring, $ID_patient, $ID_caringtype,$room_patient,$isStopped ));

$count = $stm->rowCount();
if ($count > 0) {
    echo json_encode(array("status" => "success"));
} else {
    echo json_encode(array("status" => "fail"));
}
?>