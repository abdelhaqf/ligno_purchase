<?php
require 'vendor/autoload.php';

use \Firebase\JWT\JWT;

function getLink()
{
  $link = mysqli_connect('localhost', 'root', '', 'ligno_purchase') or die('connection failed!');
  return $link;
}

//---------------------------------------------------------------------------------------------

  Flight::route('GET /current_user/@username', function ($username) {

    $q = "SELECT * FROM user WHERE username like '$username'";
    runQuery2($q);
  });

  Flight::route('GET /spp_byuserid/@id', function ($id) {
    $q = "SELECT spp.*, user.name, user.dept, user.manager_id, hnd.name as 'handler_name' FROM spp
          INNER JOIN user ON spp.user_id = user.user_id
          LEFT JOIN user hnd on hnd.user_id = spp.handle_by
          WHERE spp.user_id = $id
          ORDER BY spp.spp_id DESC
    ";
    runQuery($q);
  });
  Flight::route('GET /spp-approval', function () {
    $q = "SELECT spp.*, user.name, user.dept, user.manager_id, hnd.name as 'handler_name' FROM spp
          INNER JOIN user ON spp.user_id = user.user_id
          LEFT JOIN user hnd on hnd.user_id = spp.handle_by
    ";
    runQuery($q);
  });
  Flight::route('GET /spp_approved/@id/@ispurch', function ($id, $ispurch) {
    $q = "SELECT spp.*, user.name, user.dept, user.manager_id, hnd.name as 'handler_name' FROM spp
          INNER JOIN user ON spp.user_id = user.user_id
          LEFT JOIN user hnd on hnd.user_id = spp.handle_by
          WHERE spp.po_id is null 
                AND (spp.handle_by = $id OR $ispurch = 1)
                AND spp.purch_manager_cancel = 0 AND spp.manager_approve = 1 AND spp.purch_manager_approve = 1 
          ORDER BY spp.spp_id DESC
    ";
    runQuery($q);
  });
  Flight::route('GET /spp_byid/@id', function ($id) {
    $q = "SELECT * FROM spp where spp_id = $id";
    runQuery2($q);
  });
  
  Flight::route('GET /po', function () {
    $q = "SELECT po.po_id, po.user_id, po.vendor, po.po_date, SUM(spp.price) AS 'total_price', spp.currency, usr.name AS 'handler_name', 
              CASE WHEN SUM(spp.is_received) = 2 * COUNT(spp.is_received) THEN 'fully received'
              WHEN SUM(spp.is_received) = 0 THEN 'not received' ELSE 'half received' END as 'is_received'  
          FROM po INNER JOIN spp on po.po_id = spp.po_id 
          INNER JOIN `user` usr on usr.user_id = po.user_id
          GROUP BY po.po_id, po.user_id, po.po_date, usr.name, po.vendor, spp.currency";
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


    $q = "SELECT spp.spp_id, spp.price, spp.currency, spp.create_at, spp.item, spp.qty, spp.unit, 
                spp.est_arrival, spp.is_received, spp.coa, spp.note, po.po_id, po.vendor, po.po_date, 
                usr.name, hnd.name as 'handler_name' FROM po
          INNER JOIN spp on po.po_id = spp.po_id 
          INNER JOIN `user` usr on usr.user_id = spp.user_id
          INNER JOIN `user` hnd on hnd.user_id = spp.handle_by
          WHERE po.po_id = '$po_id'";
    runQuery($q);
  });

  Flight::route('GET /spp_history/@spp_id', function ($spp_id) {
    $q = "SELECT * FROM spp_history where spp_id = $spp_id
          ORDER BY history_id ASC";
    runQuery($q);
  });
  
  Flight::route('GET /list_item', function () {
    $q = "SELECT DISTINCT item as 'value', item as 'label' FROM spp
          WHERE po_id IS NOT NULL
          ORDER BY item ASC";
    runQuery($q);
  });
  Flight::route('GET /list_user', function () {
    $q = "SELECT DISTINCT `user_id` as 'value', `name` as 'label' FROM user
          WHERE is_purchasing = 1
          ORDER BY name ASC";
    runQuery($q);
  });

  Flight::route('GET /pricelist/@item', function ($item) {
    $q = "SELECT item, price, currency, unit, spp.po_id, po.po_date, qty, vendor 
          FROM spp INNER JOIN po ON po.po_id = spp.po_id
          WHERE spp.item like '%$item%'
          ";
    runQuery($q);
  });

  Flight::route('GET /count_data/@userid/@ispurch', function ($userid, $ispurch) {
    $q = "SELECT SUM(col1) 'count_spp', SUM(col2) 'count_approve', SUM(col3) 'count_approvePM', SUM(col4) 'count_po' FROM (

            SELECT COUNT(spp_id) AS 'col1',0 AS 'col2',0 AS 'col3',0 AS 'col4'  FROM `spp` 
            WHERE spp.po_id is null 
                AND (spp.handle_by = $userid OR $ispurch = 1)
                AND spp.purch_manager_cancel = 0 AND spp.manager_approve = 1 AND spp.purch_manager_approve = 1
                UNION
            SELECT 0 AS 'col1',COUNT(spp_id) AS 'col2',0 AS 'col3',0 AS 'col4' FROM `spp` 
            INNER JOIN user ON user.user_id = spp.user_id
            WHERE manager_approve = 0 AND user.manager_id = $userid
                UNION
            SELECT 0 AS 'col1',0 AS 'col2',COUNT(spp_id) AS 'col3',0 AS 'col4' FROM `spp` 
            INNER JOIN user ON user.user_id = spp.user_id
            WHERE purch_manager_approve = 0 AND manager_approve = 1
            AND $userid IN (SELECT user_id FROM user WHERE is_purch_manager = 1) 
                UNION
            SELECT 0 AS 'col1',0 AS 'col2',0 AS 'col3',COUNT(DISTINCT po.po_id) AS 'col4' FROM `po` 
            INNER JOIN spp ON spp.po_id = po.po_id
            WHERE spp.is_received <> 2
            AND ($userid IN (SELECT user_id FROM user WHERE is_purch_manager = 1) OR po.user_id = $userid) 
              ) tb";
    runQuery2($q);
  });


  Flight::route('GET /summary', function () {
    $q = "SELECT SUM(col1) 'count_spp', SUM(col2) 'on_process', SUM(col3) 'value_idr', SUM(col4) 'value_usd' FROM (
            SELECT COUNT(spp_id) AS 'col1',0 AS 'col2',0 AS 'col3',0 AS 'col4'  FROM `spp`
            WHERE MONTH(create_at) = MONTH(CURRENT_DATE)
            AND manager_approve <> -1 AND purch_manager_approve <> -1 AND purch_manager_cancel <> -1
            UNION
            SELECT 0 AS 'col1',COUNT(spp_id) AS 'col2',0 AS 'col3',0 AS 'col4' FROM `spp`
            WHERE MONTH(create_at) = MONTH(CURRENT_DATE)
            AND manager_approve <> -1 AND purch_manager_approve <> -1 AND purch_manager_cancel <> -1
            AND po_id IS NULL
            UNION
            SELECT 0 AS 'col1',0 AS 'col2', SUM(price) AS 'col3',0 AS 'col4' FROM `spp`
            WHERE MONTH(create_at) = MONTH(CURRENT_DATE)
            AND currency LIKE 'IDR'
            UNION
            SELECT 0 AS 'col1',0 AS 'col2',0 AS 'col3', COUNT(price) AS 'col4' FROM `spp`
            WHERE MONTH(create_at) = MONTH(CURRENT_DATE)
            AND currency LIKE 'USD') tb1
            ";
    runQuery2($q);
  });
  
  Flight::route('GET /list_month', function () {
    $q = "SELECT CONCAT( YEAR(create_at),'-',MONTH(create_at)) AS 'value',  CONCAT(MONTHNAME(create_at), ' ', YEAR(create_at)) AS 'label' FROM spp
          GROUP BY value, label
            ";
    runQuery($q);
  });

  Flight::route('GET /daily_summary/@from/@to', function ($dateFrom, $dateTo) {
    $q = "SELECT * FROM spp
          WHERE create_at BETWEEN '$dateFrom' AND '$dateTo'
            ";
    runQuery($q);
  });
  Flight::route('GET /monthly_summary/@from/@to', function ($dateFrom, $dateTo) {
    $q = "SELECT 
            COUNT(spp_id) AS 'total_spp',
            CONCAT(MONTHNAME(create_at), ' ', YEAR(create_at)) AS 'month_name', 
            SUM(price) AS 'total_purchase'  FROM spp 
          WHERE create_at BETWEEN '$dateFrom' AND '$dateTo'
          AND currency = 'IDR'
          AND manager_approve <> -1 AND purch_manager_approve <> -1 AND purch_manager_cancel <> -1
          GROUP BY month_name
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
  Flight::route('POST /new_history', function () {
    $data = Flight::request()->getBody();
    $data = (array) json_decode($data);

    runQuery3('POST', 'spp_history', $data, '');
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
    $q = "select user_id, name, username, is_manager, is_purchasing, is_purch_manager, dept from user where username = '$username' and password = '$password'";

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
          "is_manager" => $arr[0]['is_manager'],
          "is_purchasing" => $arr[0]['is_purchasing'],
          "is_purch_manager" => $arr[0]['is_purch_manager'],
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








