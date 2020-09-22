<?php
require 'vendor/autoload.php';

use \Firebase\JWT\JWT;

function getLink()
{
  $link = mysqli_connect('localhost', 'root', '', 'ligno_purchase') or die('connection failed!');
  return $link;
}

//---------------------------------------------------------------------------------------------
  Flight::route('GET /spp', function () {
    $q = "SELECT spp.*, user.name, user.dept FROM spp
          INNER JOIN user ON spp.user_id = user.user_id
          WHERE po_id IS NULL
    ";
    runQuery($q);
  });
  Flight::route('GET /spp_byid/@id', function ($id) {
    $q = "SELECT * FROM spp where spp_id = $id";
    runQuery2($q);
  });
  
  Flight::route('GET /po', function () {
    $q = "SELECT po.*, spp.price, usr.name  FROM po
          INNER JOIN spp on po.po_id = spp.po_id 
          INNER JOIN `user` usr on usr.user_id = po.user_id";
    runQuery($q);
  });
  Flight::route('GET /po_byid/@id', function ($id) {
    $q = "SELECT * FROM po where po_id = $id";
    runQuery2($q);
  });

  Flight::route('GET /spp_history/@spp_id', function ($spp_id) {
    $q = "SELECT * FROM spp_history where spp_id = $spp_id
          ORDER BY history_id DESC";
    runQuery($q);
  });
//---------------------------------------------------------------------------------------------
  Flight::route('POST /new_spp', function () {
    $data = Flight::request()->getBody();
    $data = (array) json_decode($data);

    runQuery3('POST', 'spp', $data, '');
  });
  Flight::route('POST /new_po', function () {
    $data = Flight::request()->getBody();
    $data = (array) json_decode($data);

    runQuery3('POST', 'po', $data, '');
  });
///
  Flight::route('PUT /spp_byid/@spp_id', function ($spp_id) {
    $data = Flight::request()->getBody();
    $data = (array) json_decode($data);

    runQuery3('PUT', 'spp', $data, 'spp_id', $spp_id);
  });


/// Run Query
  //Get Array
  function runQuery($q)
  {
    $link = getLink();
    $res = mysqli_query($link, $q) or die(mysqli_error($link));
    $arr = array();
    while ($row = mysqli_fetch_assoc($res)) {
      $arr[] = $row;
    }

    Flight::json($arr);
  }
  //Get only 1 value/array
  function runQuery2($q)
  {
    $link = getLink();
    $res = mysqli_query($link, $q) or die(mysqli_error($link));
    $arr = array();
    while ($row = mysqli_fetch_assoc($res)) {
      $arr[] = $row;
    }
    Flight::json($arr[0]);
  }
  //update and post
  function runQuery3($method, $table, $input = [], $col = '', $val = '')
  {
    if ($input == null) {
      $input = [];
    }

    $link = getLink();

    $columns = array_keys($input);
    $values = array_values($input);

    $set = '';
    for ($i = 0; $i < count($columns); $i++) {
      $set .= ($i > 0 ? ',' : '') . '`' . $columns[$i] . '`=';
      $set .= ($values[$i] === null ? 'NULL' : '"' . $values[$i] . '"');
    }
    $sql = '';
    switch ($method) {
      case 'PUT':
        $sql = "update `$table` set $set" . ($val ? " where `$col`='$val'" : '');
        break;
      case 'POST':
        $sql = "insert into `$table` set $set";
        break;
    }
    $result = mysqli_query($link, $sql);
    if (!$result) {
      http_response_code(404);
      die(mysqli_error($link));
    }
    if ($method == 'POST') {
      echo mysqli_insert_id($link);
    } else {
      echo mysqli_affected_rows($link);
    }
  }
/// End Run Query



/// Login 
  Flight::route('POST /login', function () {
    $user = Flight::request()->data;
    $username = $user->username;
    $password = $user->password;

    $link = getLink();
    $q = "select user_id, name, username from user where username = '$username' and password = '$password'";
    $res = mysqli_query($link, $q) or die(mysqli_error($link));

    $arr = array();
    while ($row = mysqli_fetch_assoc($res)) {
      $arr[] = $row;
    }

    if (count($arr) == 1) {
      $issuedat_claim = time();
      $notbefore_claim = $issuedat_claim + 0;
      $expire_claim = $issuedat_claim + 144000;
      $token = array(
        "iss" => "ligno_purchase",
        "iat" => $issuedat_claim,
        "nbf" => $notbefore_claim,
        "exp" => $expire_claim,
        "data" => array(
          "user_id" => $arr[0]['user_id'],
          "username" => $username,
        )
      );
      $jwt = JWT::encode($token, Flight::get('secret'));
      echo $jwt;
    } else {
      Flight::halt(401, 'not authorized!');
    }
  });
/// End Login

function checkJWT()
{
  try {
    $authHeader = $_SERVER['HTTP_AUTHORIZATION'];
    $jwt = explode(" ", $authHeader)[1];
    return JWT::decode($jwt, Flight::get('secret'), array('HS256'));
  } catch (Exception $e) {
    Flight::halt(401, 'not authorized!');
  }
}

Flight::route('OPTIONS *', function () {
});
Flight::route('/', function () {
  echo 'halo dunia!';
});

// get current user data
Flight::route('GET /user/info', function () {
  Flight::json(checkJWT()->data);
});
Flight::set('/', 'Halo Dunia');
Flight::set('secret', 'thesupersecret123');
Flight::start();








