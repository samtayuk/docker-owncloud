<?php
$CONFIG = array (
  'datadirectory' => '/data',
  #'memcache.local' => '\OC\Memcache\APCu',
  'redis' => array (
    'host' => 'redis',
    'port' => 6379,
    'timeout' => 0,
    'dbindex' => 0,
  ),
);