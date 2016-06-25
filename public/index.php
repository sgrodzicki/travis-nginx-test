<?php

if (isset($_SERVER['APPLICATION_ENVIRONMENT'])) {
    echo $_SERVER['APPLICATION_ENVIRONMENT'] . PHP_EOL;
} else {
    echo 'NONE' . PHP_EOL;
}

echo phpversion() . PHP_EOL;
