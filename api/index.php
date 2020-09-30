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
    $q = "SELECT po.po_id, po.vendor, po.po_date, SUM(spp.price) AS 'total_price', usr.name, 
              CASE WHEN SUM(spp.is_received) = 2 * COUNT(spp.is_received) THEN 'fully received'
              WHEN SUM(spp.is_received) = 0 THEN 'not received' ELSE 'half received' END as 'is_received'  
          FROM po INNER JOIN spp on po.po_id = spp.po_id 
          INNER JOIN `user` usr on usr.user_id = po.user_id
          GROUP BY po.po_id, po.po_date, usr.name, po.vendor";
    runQuery($q);
  });
  Flight::route('GET /po_byid/@id', function ($id) {
    $q = "SELECT * FROM po where po_id = $id";
    runQuery2($q);
  });
  Flight::route('POST /podetail_byid', function () {
    $input = Flight::request()->getBody();
    $input = (array) json_decode($input);

    $po_id = $input["po_id"];


    $q = "SELECT spp.spp_id, spp.price, spp.currency, spp.create_at, spp.is_received, spp.note, po.po_id, po.vendor, po.po_date, usr.name, hnd.name as 'handle_by' FROM po
          INNER JOIN spp on po.po_id = spp.po_id 
          INNER JOIN `user` usr on usr.user_id = po.user_id
          INNER JOIN `user` hnd on hnd.user_id = spp.handle_by
          WHERE po.po_id = '$po_id'"; //PO/2020/LSC/09
    runQuery($q);
  });

  Flight::route('GET /spp_history/@spp_id', function ($spp_id) {
    $q = "SELECT * FROM spp_history where spp_id = $spp_id
          ORDER BY history_id DESC";
    runQuery($q);
  });
  
  Flight::route('GET /list_item', function () {
    $q = "SELECT DISTINCT item as 'value', item as 'label' FROM spp
          WHERE po_id IS NOT NULL
          ORDER BY item ASC";
    runQuery($q);
  });

  
  Flight::route('GET /pricelist/@item', function ($item) {
    $q = "SELECT item, price, unit, spp.po_id, po.po_date, qty, vendor 
          FROM spp INNER JOIN po ON po.po_id = spp.po_id
          WHERE spp.item like '%$item%'
          ";
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
  Flight::route('PUT /update_spp/@spp_id', function ($spp_id) {
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
    $q = "select user_id, name, username,dept from user where username = '$username' and password = '$password'";
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
          "dept" => $arr[0]['dept'],
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








