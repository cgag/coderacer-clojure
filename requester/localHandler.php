<?php
$response = file_get_contents('localCopy.json');
$response = json_decode($response);

$cats = $response->query->categorymembers;
foreach ($cats as $cat) {
  $i = $cat->title;
  echo "$i\n";
}
?>