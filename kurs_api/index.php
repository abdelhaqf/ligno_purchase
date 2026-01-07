<?php
include('simple_html_dom.php');


$json = ['Jsondata' => []];

// BCA
$html = file_get_html('https://www.bca.co.id/id/informasi/kurs');
$ret = $html->find("tr[code='USD']")[0];
$buy = str_replace('.', '', $ret->children(3)->children(0)->innertext);
$buy = str_replace(',', '.', $buy);
$buy = (float) trim($buy);

$sell = str_replace('.', '', $ret->children(4)->children(0)->innertext);
$sell = str_replace(',', '.', $sell);
$sell = (float) trim($sell);

$mid = ($sell + $buy) / 2.0;

$ret = $html->find('.refresh-date')[0]->innertext;

$json['Jsondata']['bcarate'] = $mid;
$json['Jsondata']['date3'] = $ret;


// BI
$html = file_get_html('https://www.bi.go.id/id/statistik/informasi-kurs/transaksi-bi/Default.aspx');

$textRight = $html->find('.text-right');
$cnt = 0;
$low = 0;
$high = 0;
foreach ($html->find('.text-right') as $element) {
  if (strcmp(trim($element->innertext), "USD") == 0) {
    $A = $textRight[$cnt + 2]->innertext;
    $A = str_replace('.', '', $A);
    $A = str_replace(',', '.', $A);
    $low = (float) $A;

    $B = $textRight[$cnt + 3]->innertext;
    $B = str_replace('.', '', $B);
    $B = str_replace(',', '.', $B);
    $high = (float) $B;
  }
  $cnt++;
}
$rate =  ($low + $high) / 2;


$html = file_get_html('https://www.bi.go.id/id/statistik/informasi-kurs/transaksi-bi/Default.aspx');
$date = $html->find('.search-box-wrapper')[0]->children(0)->innertext;
$date = trim($date);

$json['Jsondata']['birate'] = $rate; //(double)$rate;
$json['Jsondata']['date2'] = $date; //$date;

// bea cukai
$html = file_get_html('https://fiskal.kemenkeu.go.id/informasi-publik/kurs-pajak');
$rate = $html->find('.ml-5')[0]->innertext;
$rate = str_replace('.', '', $rate);


$date = $html->find('.text-muted', 0)->children(0)->innertext;
$pos = strpos($date, ':');
$pos2 = strpos($date, '-');
$date = substr($date, $pos + 2, $pos2 - $pos - 2);

$json['Jsondata']['menkeurate'] = (float)$rate;
$json['Jsondata']['date1'] = $date;

echo json_encode($json);
