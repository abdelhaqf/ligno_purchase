<?php
require 'vendor/autoload.php';

use \Firebase\JWT\JWT;

function getLink()
{
  // $is_local = true;
  // $link = mysqli_connect('localhost', 'lignosof_root', 'lignosc313', 'lignosof_lignoapp_purchase', 3307) or die('connection failed!');
  // if ($is_local) {
  // } else {
  $link = mysqli_connect('localhost', 'root', '', 'ligno_purchase') or die('connection failed!');
  // }
  return $link;
}

//---------------------------------------------------------------------------------------------

Flight::route('GET /list/user', function () {
  $q = "SELECT user_id,user_id as value,concat(dept , ' - ' , name) as label FROM user 
  ORDER BY dept, name";
  runQuery($q);
});
Flight::route('GET /current_user/@username', function ($username) {

  $q = "SELECT * FROM user WHERE username like '$username'";
  runQuery2($q);
});

Flight::route('GET /spp_byuserid/@id', function ($id) {

  $query = Flight::request()->query;

  $current = $query->current;
  $limit = $query->limit;
  $offset = ($current - 1) * $limit;

  $w_search = "";
  if ($query->search != "") {
    $w_search = "AND spp.item LIKE '%$query->search%'";
  }

  $w_date = "";
  if ($query->date) {
    $w_date = "AND DATE(create_at) = '$query->date'";
  } else if ($query->from && $query->to) {
    $w_date = "AND DATE(create_at) BETWEEN '$query->from' AND '$query->to'";
  }

  $q = "SELECT spp.*, user.name, user.dept, user.manager_id, hnd.name as 'handler_name',
          (SELECT COUNT(spp.spp_id)
          FROM spp
          INNER JOIN user ON spp.user_id = user.user_id
          LEFT JOIN user hnd on hnd.user_id = spp.handle_by
          WHERE (spp.user_id = $id OR spp.cc = $id) $w_search $w_date
          ) AS total_count
        FROM spp
        INNER JOIN user ON spp.user_id = user.user_id
        LEFT JOIN user hnd on hnd.user_id = spp.handle_by
        WHERE (spp.user_id = $id OR spp.cc = $id) $w_search $w_date
        ORDER BY spp.spp_id DESC
        LIMIT $limit OFFSET $offset
    ";
  runQuery($q);
});

Flight::route('GET /dept', function () {
  $q = "SELECT DISTINCT dept FROM user";
  runQuery($q);
});

Flight::route('GET /spp_byuserid/@id/@filter', function ($id, $filter) {
  $q = "SELECT spp.*, user.name, user.dept, user.manager_id, hnd.name as 'handler_name'
  FROM spp
  INNER JOIN user ON spp.user_id = user.user_id
  LEFT JOIN user hnd on hnd.user_id = spp.handle_by
  WHERE spp.user_id = $id OR spp.cc = $id
  HAVING CONCAT(YEAR(create_at),'-',MONTH(create_at)) LIKE '%$filter%'
  ORDER BY spp.spp_id DESC
  ";
  runQuery($q);
});

Flight::route('GET /spp/list/@id', function ($id) {

  $query = Flight::request()->query;

  $current = $query->current;
  $limit = $query->limit;
  $offset = ($current - 1) * $limit;

  $w_search = "";
  if ($query->search != "") {
    $w_search = "AND spp.item LIKE '%$query->search%'";
  }

  $w_date = "";
  if ($query->date) {
    $w_date = "AND DATE(create_at) = '$query->date'";
  } else if ($query->from && $query->to) {
    $w_date = "AND DATE(create_at) BETWEEN '$query->from' AND '$query->to'";
  }

  $q = "SELECT spp.*, user.name, user.dept, user.manager_id, hnd.name as 'handler_name',
          (SELECT COUNT(spp.spp_id)
          FROM spp
          INNER JOIN user ON spp.user_id = user.user_id
          LEFT JOIN user hnd on hnd.user_id = spp.handle_by
          WHERE (spp.user_id = $id OR spp.cc = $id) $w_search $w_date
          ) AS total_count
        FROM spp
        INNER JOIN user ON spp.user_id = user.user_id
        LEFT JOIN user hnd on hnd.user_id = spp.handle_by
        WHERE (spp.user_id = $id OR spp.cc = $id) $w_search $w_date
        ORDER BY spp.spp_id DESC
        LIMIT $limit OFFSET $offset
    ";
  runQuery($q);
});

Flight::route('GET /spp-approval', function () {
  $query = Flight::request()->query;

  $w_search = "";
  if ($query->search) $w_search = "AND spp.item LIKE '%{$query['search']}%'";

  $w_dept = "";
  if ($query->dept != '') $w_dept = "AND user.dept LIKE '%{$query['dept']}%'";

  $sort = "";
  if ($query->sort) {
    $sort = "ORDER BY {$query['sort']}";
  }

  $q = "SELECT spp.*, user.name, user.dept, user.manager_id, hnd.name as 'handler_name' FROM spp
          INNER JOIN user ON spp.user_id = user.user_id
          LEFT JOIN user hnd on hnd.user_id = spp.handle_by
          WHERE 1=1 $w_search $w_dept
          $sort
    ";
  runQuery($q);
});
// Flight::route('GET /spp_approved/@id/@ispurch/@order', function ($id, $ispurch, $order) {
//   $q = "SELECT spp.*, user.name, user.dept, user.manager_id, hnd.name as 'handler_name' FROM spp
//           INNER JOIN user ON spp.user_id = user.user_id
//           LEFT JOIN user hnd on hnd.user_id = spp.handle_by
//           WHERE spp.po_id is null 
//                 AND (spp.handle_by = $id OR $ispurch = 1)
//                 AND spp.purch_manager_cancel = 0 AND spp.manager_approve = 1 AND spp.purch_manager_approve = 1 
          
//           ORDER BY spp.$order
//     ";
//   runQuery($q);
// });
Flight::route('GET /spp_approved/@id/@ispurch', function ($id, $ispurch) {
  $query = Flight::request()->query;

  $w_search = "";
  if ($query->search) $w_search = "AND spp.item LIKE '%{$query['search']}%'";

  $w_dept = "";
  if ($query->dept != '') $w_dept = "AND user.dept LIKE '%{$query['dept']}%'";

  $sort = "";
  if ($query->sort) {
    $sort = "ORDER BY {$query['sort']}";
  }

  $q = "SELECT spp.*, user.name, user.dept, user.manager_id, hnd.name as 'handler_name' FROM spp
          INNER JOIN user ON spp.user_id = user.user_id
          LEFT JOIN user hnd on hnd.user_id = spp.handle_by
          WHERE spp.po_id is null 
                AND (spp.handle_by = $id OR $ispurch = 1)
                AND spp.purch_manager_cancel = 0 AND spp.manager_approve = 1 AND spp.purch_manager_approve = 1 
                $w_search $w_dept
                
          $sort
    ";
  runQuery($q);
});
Flight::route('GET /spp_byid/@id', function ($id) {
  $q = "SELECT * FROM spp where spp_id = $id";
  runQuery2($q);
});

Flight::route('POST /po', function () {
  $is_purch_manager = checkJWT()->data->is_purch_manager;
  $user_id = checkJWT()->data->user_id;

  $data = Flight::request()->data;
  $is_rcv = $data["is_rcv"];
  $vendor = $data["vendor"];
  $category = $data["cat"];
  $kategori = $data["kategori"];
  $search = $data["search"];
  $date = $data["date"];
  $current = $data["current"];
  $limit =  $data["limit"];
  $offset = ($current - 1) * $limit;

  $w_search = "";
  if ($search) $w_search = "AND po_id LIKE '%$search%'";

  if ($date != null){
    $w_search = $w_search . " AND po_date LIKE '%$date%'";
  } 

  $w_src = "";
  if ($is_rcv != "null") {
    $w_src = "AND is_received LIKE '%$is_rcv%'";
  }

  $w_cat = "";
  if ($category != "") {
    if (urldecode($category) == "BELUM DIKATEGORIKAN") {
      $w_cat = "AND cost_category = ''";
    } else {
      $w_cat = "AND cost_category IN (";
      $cat = explode(",", $category);

      for ($i = 0; $i < count($cat); $i++) {
        $w_cat = $w_cat . "'" . urldecode($cat[$i]) . "'";
        if ($i < count($cat) - 1) {
          $w_cat = $w_cat . ", ";
        }
      }

      $w_cat = $w_cat . ")";
    }
  }

  $w_vendor = "";
  if ($vendor != "") {
    $w_vendor = "AND vendor = '$vendor'";
  }

  $w_kategori = "";
  if ($kategori != "") {
    if ($kategori == "BELUM DIKATEGORIKAN") {
      $w_kategori = "AND kategori = ''";
    } else {
      $w_kategori = "AND kategori = '$kategori'";
    }
  }

  $q = " SELECT * , (SELECT COUNT(*)
          FROM (
                SELECT po.po_id, po.user_id, po.vendor, po.po_date,spp.cost_category, po.create_at, 
                spp.currency,spp.kategori, spp.est_arrival, usr.name AS 'handler_name', 
                        CASE WHEN SUM(spp.is_received) = 2 * COUNT(spp.is_received) THEN 'fully received'
                        WHEN SUM(spp.is_received) = 0 THEN 'not received' 
                        WHEN SUM(spp.is_received) >= 4000 THEN 'closed'
                        WHEN SUM(spp.is_received) >= 300 THEN 'suspended' 
                        ELSE 'half received' END as 'is_received',
                        spp.item, 
                        COUNT(DISTINCT CASE WHEN spp.sync IS NOT NULL THEN spp.sync END) AS synced
                        FROM po INNER JOIN spp on po.po_id = spp.po_id 
                        INNER JOIN `user` usr on usr.user_id = po.user_id
                        GROUP BY po.po_id, po.user_id, po.po_date, usr.name, po.vendor, spp.currency) tb1
            WHERE 1 = 1 $w_src $w_cat $w_vendor $w_kategori $w_search) AS total_count 
            
            FROM (
                  SELECT po.po_id, po.user_id, po.vendor, po.po_date,spp.cost_category, po.create_at, 
                  SUM(spp.price) AS 'total_price', 
                  spp.currency,spp.kategori, spp.est_arrival, usr.name AS 'handler_name', 
                          CASE WHEN SUM(spp.is_received) = 2 * COUNT(spp.is_received) THEN 'fully received'
                          WHEN SUM(spp.is_received) = 0 THEN 'not received' 
                          WHEN SUM(spp.is_received) >= 4000 THEN 'closed'
                          WHEN SUM(spp.is_received) >= 300 THEN 'suspended' 
                          ELSE 'half received' END as 'is_received',
                          COUNT(spp.spp_id) AS 'spp_count', spp.item, 
                          COUNT(DISTINCT CASE WHEN spp.sync IS NOT NULL THEN spp.sync END) AS synced
                          FROM po INNER JOIN spp on po.po_id = spp.po_id 
                          INNER JOIN `user` usr on usr.user_id = po.user_id
                          GROUP BY po.po_id, po.user_id, po.po_date, usr.name, po.vendor, spp.currency) tb1
              WHERE 1 = 1 $w_src $w_cat $w_vendor $w_kategori $w_search
              LIMIT $limit OFFSET $offset
            
            ";
  
  //  echo $q;
  // runQuery($q);

  $po["poList"] = getRows($q);
  // $po = getRows($q);
  
  // var_dump($id);

  $q = "SELECT COUNT(*) AS not_count
        FROM (SELECT po.po_id, po.user_id, po.vendor, po.po_date,spp.cost_category, po.create_at, 
                spp.currency,spp.kategori, spp.est_arrival, usr.name AS 'handler_name', 
                CASE WHEN SUM(spp.is_received) = 2 * COUNT(spp.is_received) THEN 'fully received'
                WHEN SUM(spp.is_received) = 0 THEN 'not received' 
                WHEN SUM(spp.is_received) >= 4000 THEN 'closed'
                WHEN SUM(spp.is_received) >= 300 THEN 'suspended' 
                ELSE 'half received' END as 'is_received',
                spp.item, 
                COUNT(DISTINCT CASE WHEN spp.sync IS NOT NULL THEN spp.sync END) AS synced
                FROM po INNER JOIN spp on po.po_id = spp.po_id 
                INNER JOIN `user` usr on usr.user_id = po.user_id
                GROUP BY po.po_id, po.user_id, po.po_date, usr.name, po.vendor, spp.currency) tb1
        WHERE is_received = 'not received'";
  $po["not_count"] = getRows($q)[0]['not_count'];

  $q = "SELECT COUNT(*) AS suspended_count
        FROM (SELECT po.po_id, po.user_id, po.vendor, po.po_date,spp.cost_category, po.create_at, 
                spp.currency,spp.kategori, spp.est_arrival, usr.name AS 'handler_name', 
                CASE WHEN SUM(spp.is_received) = 2 * COUNT(spp.is_received) THEN 'fully received'
                WHEN SUM(spp.is_received) = 0 THEN 'not received' 
                WHEN SUM(spp.is_received) >= 4000 THEN 'closed'
                WHEN SUM(spp.is_received) >= 300 THEN 'suspended' 
                ELSE 'half received' END as 'is_received',
                spp.item, 
                COUNT(DISTINCT CASE WHEN spp.sync IS NOT NULL THEN spp.sync END) AS synced
                FROM po INNER JOIN spp on po.po_id = spp.po_id 
                INNER JOIN `user` usr on usr.user_id = po.user_id
                GROUP BY po.po_id, po.user_id, po.po_date, usr.name, po.vendor, spp.currency) tb1
        WHERE is_received = 'suspended'";
  $po["suspended_count"] = getRows($q)[0]['suspended_count'];
  
  $q = "SELECT COUNT(*) AS half_count
    FROM (SELECT po.po_id, po.user_id, po.vendor, po.po_date,spp.cost_category, po.create_at, 
            spp.currency,spp.kategori, spp.est_arrival, usr.name AS 'handler_name', 
            CASE WHEN SUM(spp.is_received) = 2 * COUNT(spp.is_received) THEN 'fully received'
            WHEN SUM(spp.is_received) = 0 THEN 'not received' 
            WHEN SUM(spp.is_received) >= 4000 THEN 'closed'
            WHEN SUM(spp.is_received) >= 300 THEN 'suspended' 
            ELSE 'half received' END as 'is_received',
            spp.item, 
            COUNT(DISTINCT CASE WHEN spp.sync IS NOT NULL THEN spp.sync END) AS synced
            FROM po INNER JOIN spp on po.po_id = spp.po_id 
            INNER JOIN `user` usr on usr.user_id = po.user_id
            GROUP BY po.po_id, po.user_id, po.po_date, usr.name, po.vendor, spp.currency) tb1
    WHERE is_received = 'half received'";
  $po["half_count"] = getRows($q)[0]['half_count'];

  Flight::json($po);
  
});
Flight::route('GET /po_byid/@id', function ($id) {
  $q = "SELECT * FROM po where po_id = $id";
  runQuery2($q);
});
Flight::route('POST /podetail_byid', function () {
  $input = Flight::request()->getBody();
  $input = (array) json_decode($input);

  $po_id = $input["po_id"];


  $q = "SELECT spp.spp_id, spp.price, spp.currency, spp.create_at, spp.item, spp.qty, spp.unit, spp.cost_category,
                spp.est_arrival, spp.is_received, spp.coa, spp.note, spp.sync, po.po_id, po.vendor, po.po_date, 
                usr.name, hnd.name as 'handler_name' FROM po
          INNER JOIN spp on po.po_id = spp.po_id 
          INNER JOIN `user` usr on usr.user_id = spp.user_id
          INNER JOIN `user` hnd on hnd.user_id = spp.handle_by
          WHERE po.po_id = '$po_id'";
  runQuery($q);
});

Flight::route('PUT /sync_formula/po', function () {
  $link = getLink();
  $date1 = new DateTime();
  $data = Flight::request()->data;
  $q = "UPDATE spp SET sync = NOW() WHERE spp_id='{$data['id_spp']}'";
  mysqli_query($link, $q) or die(mysqli_error($link));
  $date2 = new DateTime();
  log_query($link, $q, $date1, $date2);
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

Flight::route('GET /list_vendor', function () {
  $q = "SELECT DISTINCT vendor as 'value', vendor as 'label' FROM po
          WHERE po_id IS NOT NULL AND vendor <> ''
          ORDER BY vendor ASC";
  runQuery($q);
});

Flight::route('GET /list_user', function () {
  $q = "SELECT DISTINCT `user_id` as 'value', `name` as 'label' FROM user
          WHERE is_purchasing = 1
          ORDER BY name ASC";
  runQuery($q);
});

Flight::route('GET /pricelist/@item/@vendor', function ($item, $vendor) {
  $whereClause = "";
  if ($item != "null" && $vendor != "null") {
    $whereClause = "WHERE spp.item like '%$item%' AND po.vendor like '%$vendor%'";
  } else if ($item != "null") {
    $whereClause = "WHERE spp.item like '%$item%' ";
  } else if ($vendor != "null") {
    $whereClause = "WHERE  po.vendor like '%$vendor%'";
  } else {
    $whereClause = "WHERE 0 = 1";
  }
  $q = "SELECT item, price, currency, unit, spp.po_id, po.po_date, qty, vendor 
          FROM spp INNER JOIN po ON po.po_id = spp.po_id
          $whereClause
          ";
  runQuery($q);
});

Flight::route('POST /pricelist/new', function () {
  $link = getLink();
  $date1 = new DateTime();
  $data = Flight::request()->data;
  $item = $data['item'];
  $vendor = $data['vendor'];
  $search = $data['search'];
  $date = $data['date'];

  $ofset = ((int) $data['current'] - 1) * 25;

  $whereClause = "";
  if ($item != "null" && $vendor != "null") {
    $whereClause = "WHERE spp.item like '%$item%' AND po.vendor like '%$vendor%'";
  } else if ($item != "null") {
    $whereClause = "WHERE spp.item like '%$item%' ";
  } else if ($vendor != "null") {
    $whereClause = "WHERE  po.vendor like '%$vendor%'";
  }

  if ($search) $whereClause = $whereClause . "AND spp.po_id LIKE '%$search%'";

  if ($date != null){
    $whereClause = $whereClause . " AND po.po_date LIKE '%$date%'";
  } 

  $q = "SELECT item, price, currency, unit, spp.po_id, po.po_date, qty, vendor 
  FROM spp INNER JOIN po ON po.po_id = spp.po_id
  $whereClause 
  ORDER BY po.po_date DESC LIMIT 25 OFFSET $ofset
  ";
  $res = mysqli_query($link, $q) or die(mysqli_error($link));
  $data = [];
  while ($row = mysqli_fetch_assoc($res)) {
    $data[] = $row;
  }

  $q = "SELECT COUNT(item) AS total
  FROM spp INNER JOIN po ON po.po_id = spp.po_id
  $whereClause ORDER BY po.po_date";
  $res = mysqli_query($link, $q) or die(mysqli_error($link));
  $count = mysqli_fetch_assoc($res);

  $ret = array("items" => $data, "count" => $count['total']);
  $date2 = new DateTime();
  log_query($link, $q, $date1, $date2);
  Flight::json($ret);
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
  $link = getLink();
  $res = mysqli_query($link, $q) or die(mysqli_error($link));
  $arr = array();
  while ($row = mysqli_fetch_assoc($res)) {
    $arr[] = $row;
  }
  Flight::json($arr[0]);
});


Flight::route('GET /list_month_user', function () {

  $id = checkJWT()->data->user_id;
  $q = "SELECT DISTINCT CONCAT( YEAR(create_at),'-',MONTH(create_at)) AS 'value',  CONCAT(MONTHNAME(create_at), ' ', YEAR(create_at)) AS 'label', 
  YEAR(create_at) AS 'year', MONTH(create_at) AS 'month'
  FROM spp 
  WHERE user_id = $id OR cc = $id
  ORDER BY year DESC, month DESC";
  runQuery($q);
});

Flight::route('GET /list_month_po', function () {
  $is_purch_manager = checkJWT()->data->is_purch_manager;
  $user_id = checkJWT()->data->user_id;
  $q = " SELECT DISTINCT CONCAT( YEAR(create_at),'-',MONTH(create_at)) AS 'value',  CONCAT(MONTHNAME(create_at), ' ', YEAR(create_at)) AS 'label', 
          YEAR(create_at) AS 'year', MONTH(create_at) AS 'month'
          FROM po
          ORDER BY year, month DESC
            ";
  runQuery($q);
});
Flight::route('GET /list_year', function () {
  $q = " SELECT CONCAT( YEAR(create_at),'-',MONTH(create_at)) AS 'value',  CONCAT(MONTHNAME(create_at), ' ', YEAR(create_at)) AS 'label', 
          YEAR(create_at) AS 'year', MONTH(create_at) AS 'month'
          FROM spp
          GROUP BY value, label, 'year', 'month'
          ORDER BY year, month DESC
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

Flight::route('GET /spp/detail/@id', function ($id) {
  $q = "SELECT spp.*, user.name, user.dept, user.manager_id, hnd.name as 'handler_name'
  FROM spp
  INNER JOIN user ON spp.user_id = user.user_id
  LEFT JOIN user hnd on hnd.user_id = spp.handle_by
  WHERE spp.spp_id = $id";
  $spp = getRows($q)[0];

  $q = "SELECT * 
  FROM spp_history 
  WHERE spp_id = $id
  ORDER BY history_id DESC";
  $spp["history"] = getRows($q);

  Flight::json($spp);
});

Flight::route('GET /po/detail', function () {
  // echo $id;
  // echo mysqli_insert_id($id);
  // $id = urldecode($id);
  $query = Flight::request()->query;

  $id = $query->id;

  $q = "SELECT * 
        FROM (SELECT po.po_id, po.user_id, po.vendor, po.po_date,spp.cost_category, po.create_at, 
            spp.currency,spp.kategori, spp.est_arrival, usr.name AS 'handler_name', 
            CASE WHEN SUM(spp.is_received) = 2 * COUNT(spp.is_received) THEN 'fully received'
            WHEN SUM(spp.is_received) = 0 THEN 'not received' 
            WHEN SUM(spp.is_received) >= 4000 THEN 'closed'
            WHEN SUM(spp.is_received) >= 300 THEN 'suspended' 
            ELSE 'half received' END as 'is_received',
            spp.item, 
            COUNT(DISTINCT CASE WHEN spp.sync IS NOT NULL THEN spp.sync END) AS synced
            FROM po INNER JOIN spp on po.po_id = spp.po_id 
            INNER JOIN `user` usr on usr.user_id = po.user_id
            GROUP BY po.po_id, po.user_id, po.po_date, usr.name, po.vendor, spp.currency) tb1
        WHERE po_id = '$id'";
  $po = getRows($q)[0];
  // $po = getRows($q);
  
  // var_dump($id);

  try {
    $q = "SELECT spp.*, user.name
    FROM spp 
    INNER JOIN user ON spp.user_id = user.user_id
    WHERE po_id = '$id'";
    $po["spp"] = getRows($q);
  } catch (Exception $e) {
      // Code to handle the exception
      echo 'Caught exception: ',  $e->getMessage(), "\n";
  }
  
  Flight::json($po);
});


Flight::route('GET /yearly_summary', function () {
  $q = "SELECT SUM(col1) 'count_spp', SUM(col2) 'on_process', SUM(col3) 'value_idr', SUM(col4) 'value_usd' FROM (
              SELECT COUNT(spp_id) AS 'col1',0 AS 'col2',0 AS 'col3',0 AS 'col4'  FROM `spp`
              WHERE YEAR(create_at) = YEAR(CURRENT_DATE)
              AND manager_approve <> -1 AND purch_manager_approve <> -1 AND purch_manager_cancel <> -1
              UNION
              SELECT 0 AS 'col1',COUNT(spp_id) AS 'col2',0 AS 'col3',0 AS 'col4' FROM `spp`
              WHERE YEAR(create_at) = YEAR(CURRENT_DATE)
              AND manager_approve <> -1 AND purch_manager_approve <> -1 AND purch_manager_cancel <> -1
              AND po_id IS NULL
              UNION
              SELECT 0 AS 'col1',0 AS 'col2', IFNULL(SUM(price),0) AS 'col3',0 AS 'col4' FROM `spp`
              WHERE YEAR(create_at) = YEAR(CURRENT_DATE)
              AND currency LIKE 'IDR'
              UNION
              SELECT 0 AS 'col1',0 AS 'col2',0 AS 'col3', COUNT(price) AS 'col4' FROM `spp`
              WHERE YEAR(create_at) = YEAR(CURRENT_DATE)
              AND currency LIKE 'USD') tb1
              ";
  runQuery2($q);
});
Flight::route('GET /monthly_summary', function () {
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
            SELECT 0 AS 'col1',0 AS 'col2', IFNULL(SUM(price),0) AS 'col3',0 AS 'col4' FROM `spp`
            WHERE MONTH(create_at) = MONTH(CURRENT_DATE)
            AND currency LIKE 'IDR'
            UNION
            SELECT 0 AS 'col1',0 AS 'col2',0 AS 'col3', COUNT(price) AS 'col4' FROM `spp`
            WHERE MONTH(create_at) = MONTH(CURRENT_DATE)
            AND currency LIKE 'USD') tb1
            ";
  runQuery2($q);
});
Flight::route('GET /yearly_data_report', function () {
  $q = " SELECT IFNULL(SUM(price),0) AS 'price', currency, po.vendor FROM `spp` 
		       INNER JOIN po ON po.po_id = spp.po_id
           WHERE spp.po_id IS NOT NULL
           AND YEAR(spp.create_at) = YEAR(CURRENT_DATE)
           GROUP BY currency, po.vendor
           ORDER BY price DESC
            ";
  runQuery($q);
});
Flight::route('GET /yearly_total_price', function () {
  $q = " SELECT IFNULL(SUM(price),0) AS 'total' FROM `spp` 
           WHERE po_id IS NOT NULL
           AND YEAR(spp.create_at) = YEAR(CURRENT_DATE)
            ";
  runQuery2($q);
});
Flight::route('GET /MONTHLY_data_report', function () {
  $q = " SELECT IFNULL(SUM(price),0) AS 'price', currency, po.vendor FROM `spp` 
		       INNER JOIN po ON po.po_id = spp.po_id
           WHERE spp.po_id IS NOT NULL
           AND MONTH(spp.create_at) = MONTH(CURRENT_DATE)
           AND YEAR(spp.create_at) = YEAR(CURRENT_DATE)
           GROUP BY currency, po.vendor
           ORDER BY price DESC
            ";
  runQuery($q);
});
Flight::route('GET /MONTHLY_total_price', function () {
  $q = " SELECT IFNULL(SUM(price),0) AS 'total' FROM `spp` 
           WHERE po_id IS NOT NULL
           AND MONTH(spp.create_at) = MONTH(CURRENT_DATE)
           AND YEAR(spp.create_at) = YEAR(CURRENT_DATE)
            ";
  runQuery2($q);
});


Flight::route('GET /yearly_dept_report', function () {
  $q = " SELECT IFNULL(SUM(price),0) AS 'price', currency, 
            CASE WHEN spp.cost_category = '' THEN 'belum dikategorikan' 
            ELSE  spp.cost_category END AS 'cost_category'
         FROM `spp` 
		       INNER JOIN po ON po.po_id = spp.po_id
           WHERE spp.po_id IS NOT NULL
           AND YEAR(spp.create_at) = YEAR(CURRENT_DATE)
           GROUP BY currency, spp.cost_category
           ORDER BY price DESC
            ";
  runQuery($q);
});

Flight::route('GET /yearly_kat_report', function () {
  $q = " SELECT IFNULL(SUM(price),0) AS 'price', currency, 
            CASE WHEN spp.kategori = '' THEN 'belum dikategorikan' 
            ELSE  spp.kategori END AS 'kategori'
         FROM `spp` 
		       INNER JOIN po ON po.po_id = spp.po_id
           WHERE spp.po_id IS NOT NULL
           AND YEAR(spp.create_at) = YEAR(CURRENT_DATE)
           GROUP BY currency, spp.kategori
           ORDER BY price DESC
            ";
  runQuery($q);
});

Flight::route('GET /MONTHLY_dept_report', function () {
  $q = " SELECT IFNULL(SUM(price),0) AS 'price', currency, 
            CASE WHEN spp.cost_category = '' THEN 'belum dikategorikan' 
            ELSE  spp.cost_category END AS 'cost_category'
         FROM `spp` 
		       INNER JOIN po ON po.po_id = spp.po_id
           WHERE spp.po_id IS NOT NULL
           AND MONTH(spp.create_at) = MONTH(CURRENT_DATE)
           AND YEAR(spp.create_at) = YEAR(CURRENT_DATE)
           GROUP BY currency, cost_category
           ORDER BY price DESC
            ";
  runQuery($q);
});

Flight::route('GET /MONTHLY_kat_report', function () {
  $q = " SELECT IFNULL(SUM(price),0) AS 'price', currency, 
            CASE WHEN spp.kategori = '' THEN 'belum dikategorikan' 
            ELSE  spp.kategori END AS 'kategori'
         FROM `spp` 
		       INNER JOIN po ON po.po_id = spp.po_id
           WHERE spp.po_id IS NOT NULL
           AND MONTH(spp.create_at) = MONTH(CURRENT_DATE)
           AND YEAR(spp.create_at) = YEAR(CURRENT_DATE)
           GROUP BY currency, kategori
           ORDER BY price DESC
            ";
  runQuery($q);
});





Flight::route('GET /count_notif/@id', function ($id) {
  $q = " SELECT COUNT(*) AS count FROM notifikasi WHERE to_id = $id 
         AND `is_read` = 'N' AND to_id <> from_id ";
  runQuery2($q);
});
Flight::route('GET /notifikasi/@id', function ($id) {
  $q = " SELECT n.* , user.name
         FROM notifikasi n
         INNER JOIN user ON user.user_id = n.from_id
         WHERE to_id = $id 
         ORDER BY notif_id DESC
         LIMIT 20
         ";
  runQuery($q);
});

Flight::route('PUT /notifikasi/@notif_id', function ($notif_id) {
  $data = Flight::request()->getBody();
  $data = (array) json_decode($data);

  runQuery3('PUT', 'notifikasi', $data, 'notif_id', $notif_id);
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

Flight::route('PUT /spp/konfirmasi', function () {
  $data = Flight::request()->data;

  $q = "UPDATE spp SET is_received = {$data['is_received']} WHERE spp_id = {$data['spp_id']}";

  runQuery($q);
});

Flight::route('PUT /update_spp/@spp_id', function ($spp_id) {
  $data = Flight::request()->getBody();
  $data = (array) json_decode($data);

  runQuery3('PUT', 'spp', $data, 'spp_id', $spp_id);
});
Flight::route('POST /notifikasi', function () {
  $data = Flight::request()->getBody();
  $data = (array) json_decode($data);

  runQuery3('POST', 'notifikasi', $data, '');
});

Flight::route('POST /print/getdata', function () {
  $link = getLink();
  $date1 = new DateTime();
  $data = Flight::request()->data;

  $ret = [];
  $q = "";

  for ($i = 0; $i < count($data); $i++) {
    $q = "SELECT spp.*, user.name, user.dept, user.manager_id, hnd.name as 'handler_name' 
    FROM spp
    INNER JOIN user 
    ON spp.user_id = user.user_id
    LEFT JOIN user hnd on hnd.user_id = spp.handle_by
    WHERE spp_id = '{$data[$i]}'";
    $res = mysqli_query($link, $q) or die(mysqli_error($link));

    $ret[] = mysqli_fetch_assoc($res);
  }
  $date2 = new DateTime();
  log_query($link, $q, $date1, $date2);
  Flight::json($ret);
});

/// Run Query
function getDiff($time1, $time2)
{
  $dateTime1 = new DateTime($time1);
  $dateTime2 = new DateTime($time2);

  $interval = $dateTime1->diff($dateTime2);
  $totalSeconds = ($interval->days * 24 * 60 * 60) +
    ($interval->h * 60 * 60) +
    ($interval->i * 60) +
    $interval->s;
  $microsecondsDiff = $totalSeconds * 1000000 + ($dateTime2->format('u') - $dateTime1->format('u'));
  $millisecondsDiff = $microsecondsDiff / 1000;
  return $millisecondsDiff;
}

function log_query($link, $q, $time1, $time2)
{
  $microseconds1 = $time1->format('u');
  $milliseconds1 = substr($microseconds1, 0, 3);
  $formattedDate1 = $time1->format('Y-m-d H:i:s') . '.' . $milliseconds1;

  $microseconds2 = $time2->format('u');
  $milliseconds2 = substr($microseconds2, 0, 3);
  $formattedDate2 = $time2->format('Y-m-d H:i:s') . '.' . $milliseconds2;

  $diff = getDiff($formattedDate1, $formattedDate2);
  $the_q = mysqli_real_escape_string($link, $q);

  $q_log = "INSERT INTO query_log 
  SET query = '$the_q',
  start_time = '$formattedDate1',
  end_time = '$formattedDate2',
  diff = '$diff'";
  mysqli_query($link, $q_log) or die(mysqli_error($link));
}
//Get Array
function getRows($q)
{
  $date1 = new DateTime();

  $link = getLink();
  $res = mysqli_query($link, $q) or die(mysqli_error($link));

  $arr = array();
  while ($row = mysqli_fetch_assoc($res)) {
    $arr[] = $row;
  }

  $date2 = new DateTime();
  log_query($link, $q, $date1, $date2);

  return $arr;
}

function runQuery($q)
{
  $date1 = new DateTime();

  $link = getLink();
  $res = mysqli_query($link, $q) or die(mysqli_error($link));

  $arr = array();
  while ($row = mysqli_fetch_assoc($res)) {
    $arr[] = $row;
  }

  $date2 = new DateTime();
  log_query($link, $q, $date1, $date2);


  Flight::json($arr);
}

//Get only 1 value/array
function runQuery2($q)
{
  $link = getLink();
  $date1 = new DateTime();
  $res = mysqli_query($link, $q) or die(mysqli_error($link));
  $arr = array();
  while ($row = mysqli_fetch_assoc($res)) {
    $arr[] = $row;
  }
  $date2 = new DateTime();
  log_query($link, $q, $date1, $date2);
  Flight::json($arr[0]);
}
//update and post
function runQuery3($method, $table, $input = [], $col = '', $val = '')
{
  if ($input == null) {
    $input = [];
  }

  $link = getLink();
  $date1 = new DateTime();
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

  $date2 = new DateTime();

  if (!$result) {
    http_response_code(404);
    die(mysqli_error($link));
  }
  if ($method == 'POST') {
    echo mysqli_insert_id($link);
  } else {
    echo mysqli_affected_rows($link);
  }
  log_query($link, $sql, $date1, $date2);
}
/// End Run Query



/// Login 
Flight::route('POST /login', function () {
  $date1 = new DateTime();

  $user = Flight::request()->data;
  $username = $user->username;
  $password = $user->password;

  $link = getLink();
  $q = "select user_id, name, username, is_manager, manager_id, is_purchasing, is_purch_manager, dept from user where username = '$username' and password = '$password'";

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
        "name" => $arr[0]['name'],
        "manager_id" => $arr[0]['manager_id'],
        "is_manager" => $arr[0]['is_manager'],
        "is_purchasing" => $arr[0]['is_purchasing'],
        "is_purch_manager" => $arr[0]['is_purch_manager'],
        "dept" => $arr[0]['dept'],
      )
    );
    $jwt = JWT::encode($token, Flight::get('secret'));
    $date2 = new DateTime();
    log_query($link, $q, $date1, $date2);
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
