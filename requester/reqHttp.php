<?php
require_once "HTTP/Request.php";

$dataDir = 'data/';
$revisionsStore = $dataDir . 'revisions.json';
$catStore = $dataDir . 'problems.json';  
$apiBase = 'http://rosettacode.org/mw/api.php?';

$queryCats =
  array(
	'action' => 'query',
	'list' => 'categorymembers',
	'cmtitle' => 'Category:Ada',
	'cmlimit' => '7',
	'format' => 'json'
	);

function makeRequest($base, $params, $localStore) {
  $request =& new HTTP_Request($base);
  $request->setMethod(HTTP_REQUEST_METHOD_GET);
  foreach ($params as $name => $value) {
    $request->addQueryString($name, $value);
  }

  if (PEAR::isError($request->sendRequest())) {
    $response = "Request was malformed!";
  } else {
    $response = $request->getResponseBody();
  }

  file_put_contents($localStore, $response);
}

function requestAllCategories() {

}

function requestAllRevisions() {
  $apiBase = 'http://rosettacode.org/mw/api.php?';
  $dataDir = 'data/';
  $revisionsStore = $dataDir . 'revisions.json';
  $catNames = $dataDir . 'problems.txt';

  $queryRevisions = 
    array(
	  'action' => 'query',
	  'prop' => 'revisions',
	  'rvprop' => 'content',
	  'rvlimit' => '1',
	  'rvdir' => 'older',
	  'generator' => 'search',
	  // 'gsrsearch' => 'Apply a callback to an array',
	  'gsrlimit' => '1',
	  'rvexpandtemplates' => '1',
	  //	'rvparse' => '1',
	  'format' => 'json'
	  );

  $cats = file($catNames);
  foreach( $cats as $catIdx => $cat ) {
    echo "Querying for $cat";
    $queryRevs = array_merge($queryRevisions, array('gsrsearch' => "$cat"));

    // attempt to sanitize filenames. Consider using md5() instead.
    $cat = preg_replace('/\s/', '_', trim($cat));
    $cat = preg_replace('/\//', '-', $cat);
    $cat = preg_replace('/\"/', '+', $cat);
    $catStore = $dataDir . "raw/" . "$cat" . ".json";
    // echo " would write to $catStore \n";
    makeRequest($apiBase, $queryRevs, $catStore);
  }

  //  makeRequest($apiBase, $queryRevisions, $revisionsStore);
}

 makeRequest($apiBase, $queryCats, $catStore);
 requestAllRevisions();

?>