<?php
  include('simple_html_dom.php');
  

  $json = ['Jsondata' => []];
  
  // BCA
  $html = file_get_html('https://www.bca.co.id/individu/sarana/kurs-dan-suku-bunga/kurs-dan-kalkulator');
  $ret = $html->find('td');
  $buy = str_replace('.','',$ret[1]->innertext);
  $buy = str_replace(',','.',$buy);
  $sell = str_replace('.','',$ret[2]->innertext);
  $sell = str_replace(',','.',$sell);
  $mid = $buy + ($sell - $buy)/2.0;
  
  $ret = $html->find('.darkblue')[0]->children(1);

  $json['Jsondata']['bcarate'] = $mid;
  $json['Jsondata']['date3'] = substr(substr($ret->innertext, 12),0,-12 );


  // BI
  $html = file_get_html('https://www.bi.go.id/id/default.aspx');
  $rate = $html->find('.text-right')[0]->children(0)->innertext;
  $rate = str_replace("Rp ","",$rate);
  $rate = str_replace(',','',$rate);
  $rate = trim($rate);
  //$rate = explode(" ",$rate);

  $html = file_get_html('https://www.bi.go.id/id/statistik/informasi-kurs/transaksi-bi/Default.aspx');
  $date = $html->find('.search-box-wrapper')[0]->children(0)->innertext;
  $date = trim($date);
  //$date = strlen($date);
  //$date = explode(" ",$date);

  $json['Jsondata']['birate'] = $rate;//(double)$rate;
  $json['Jsondata']['date2'] = $date;//$date;

  // bea cukai
  $html = file_get_html('https://fiskal.kemenkeu.go.id/informasi-publik/kurs-pajak');
  $rate = $html->find('.ml-5')[0]->innertext;
  // $pos = strpos($rate, '<');
  // $pos = strlen($rate);
  // $rate = substr($rate,0, $pos);
  // $rate = substr($rate,0, -4);
  //  //$rate = str_replace('.','',$rate);
  $rate = str_replace('.','',$rate);
  
  
  $date = $html->find('.text-muted',0)->children(0)->innertext;
  $pos = strpos($date, ':');
  $pos2 = strpos($date, '-');
  $date = substr($date, $pos+2,$pos2-$pos-2);

  $json['Jsondata']['menkeurate'] = (double)$rate;
  $json['Jsondata']['date1'] = $date;


  echo json_encode($json);
?>