<?php

function parseCategories($inFile) {
  $response = file_get_contents($inFile);
  $response = json_decode($response);
  
  $cats = $response->query->categorymembers;
  foreach ($cats as $cat) {
    $i = $cat->title;
    echo "$i\n";
  }
}

function parseRevisions($inFile) {
  $loaded = file_get_contents($inFile);
  $response = json_decode($loaded);
  $pages = (array)$response->query->pages;
  $result = array_shift( $pages ); // this element in the JSON tree is a pageID, which changes, so we skip it here
  $result = (array)$result->revisions; 
  $result = (array)array_shift($result);
  $result = array_shift($result);

  $result = preg_match_all('/\<lang\s*\w*\>.*?\<\/lang\>/s', $result, $results);

  foreach ($results[0] as $lang) {
    $result = preg_match('/\<lang\s*(\w*)\>(.*?)\<\/lang\>/s', $lang, $code);
    if ( sizeof($code) )
      // echo "language: $code[1] \n $code[2]\n";
      file_put_contents("data/$code[1]", $code[2]);
  }
}

 parseRevisions('localRev.json');

// store code samples in text files by language and problem
?>