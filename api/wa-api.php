<?php

define('WA_API_URL', 'https://api.dripsender.id/send');
define('WA_TOKEN', 'a8eba897-4d1e-4ed8-a96b-e22c8f405578');

function sendWAMessage($phone, $text)
{
  $ch = curl_init(WA_API_URL);
  curl_setopt_array($ch, [
    CURLOPT_POST => true,
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_HTTPHEADER => ['Content-Type: application/json'],
    CURLOPT_POSTFIELDS => json_encode([
      'api_key' => WA_TOKEN,
      'phone'   => $phone,
      'text'    => $text,
    ]),
  ]);

  $response = curl_exec($ch);
  $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
  $curlError = curl_error($ch);
  curl_close($ch);

  if ($curlError) {
    return ['success' => false, 'error' => $curlError];
  }

  if ($httpCode !== 200) {
    return ['success' => false, 'error' => "Received status code $httpCode"];
  }

  return ['success' => true, 'body' => json_decode($response, true)];
}
