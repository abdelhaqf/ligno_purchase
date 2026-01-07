<?php
$date = "";
if($_POST["folder"]=="userfile/"){
    $date = date("Ymd") ."_";
}
if (move_uploaded_file($_FILES["file"]["tmp_name"], "../data/".$_POST["folder"].$date. $_FILES['file']['name'])) {

    echo "done";
    http_response_code(200);
    exit;
} else {
    http_response_code(404);
    echo "failed";
}