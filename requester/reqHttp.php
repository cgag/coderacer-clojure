<?php
require_once "HTTP/Request.php";

$apiBase = 'http://rosettacode.org/mw/api.php?';
$queryRevisions = 
  array(
	'action' => 'query',
	'prop' => 'revisions',
	'rvprop' => 'content',
	'rvlimit' => '1',
	'rvdir' => 'older',
	'generator' => 'search',
	'gsrsearch' => 'Apply%20a%20callback%20to%20an%20array',
	'gsrlimit' => '1',
	'rvsection' => '18',
	'format' => 'json'
	);

$queryCats =
  array(
	'action' => 'query',
	'list' => 'categorymembers',
	'cmtitle' => 'Category:Ada',
	'cmlimit' => '100',
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


makeRequest($apiBase, $queryCats, 'localCopy.json');

?>