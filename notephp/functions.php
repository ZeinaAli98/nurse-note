<?php
define( 'Mb',1048576);

function filterRequest($requestname){

    return htmlspecialchars(strip_tags($_POST[$requestname]));
}

function imageUplaod($imageRequest){

    global $messageError;
$imagename = rand(1000,10000).$_FILES[$imageRequest]['name'];
$imagetemp = $_FILES[$imageRequest]['tmp_name'];
$imagesize = $_FILES[$imageRequest]['size'];
$allowEx = array("jpg", "png", "gif", "mp3", "pdf");
$strToArray= explode( ".",$imagename);
$ext=end($strToArray);
$ext=strtolower($ext);
if(!empty($imagename) && !in_array($ext,$allowEx,)){

    $messageError []=" error EX";

}
if($imagesize > 2* Mb){
    $messageError []=" error Size";

}
if(empty($messageError)){
    move_uploaded_file($imagetemp, "../upload/".$imagename);
    return $imagename;

}
else{
    return "fail";
    echo"<pre>";
    print_r($messageError);
    echo"</pre>";
}


}

function deleteImage($dir,$imagename){

    if(file_exists($dir . "/" . $imagename)){
        unlink($dir . "/" . $imagename);
    }
}

?>