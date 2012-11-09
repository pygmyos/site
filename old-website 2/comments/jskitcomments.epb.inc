<?php
function jskitcomments_generate_epb() {
  global $base_url;
  $epb = '{}';
  $key = variable_get('jskitcomments_epb_secret', '');
  $id_format = variable_get('jskitcomments_epb_id_format', $base_url.'/@id/');

  global $user;
  if ($user->uid != 0) {
    $id = $user->uid;
    $name = $user->name;
    $formatted_id = str_replace('@id', $id, $id_format);
    $profile = '{Name:"' . $name . '",id:"' . $formatted_id . '",role:"user"}';
    $mac = substr(hash_hmac("md5", $profile, $key), 0, 16);
    $epb = '{version:"1.0",mac:"'.$mac.'",profile:'.$profile.'}';
  }
  drupal_set_header('Content-Type: text/javascript; charset=utf-8');
  echo $epb;
}