<?php
  require_once 'Exceptionizer.php';
  error_reporting(E_WARNING);
  $exceptionizer = new PHP_Exceptionizer();

function is_hex($hex) {
  // regex is for weenies
  $hex = strtolower(trim(ltrim($hex,"0")));
  if (empty($hex)) { $hex = 0; };
  $dec = hexdec($hex);
  return ($hex == dechex($dec));
} 

function transfer_encoding_chunked_decode($in) {
    $out = '';
    while($in != '') {
        $lf_pos = strpos($in, "\012");
        if($lf_pos === false) {
            $out .= $in;
            break;
        }
        $chunk_hex = trim(substr($in, 0, $lf_pos));
        $sc_pos = strpos($chunk_hex, ';');
        if($sc_pos !== false)
            $chunk_hex = substr($chunk_hex, 0, $sc_pos);
        if($chunk_hex == '') {
            $out .= substr($in, 0, $lf_pos);
            $in = substr($in, $lf_pos + 1);
            continue;
        }
        $chunk_len = hexdec($chunk_hex);
        if($chunk_len) {
            $out .= substr($in, $lf_pos + 1, $chunk_len);
            $in = substr($in, $lf_pos + 2 + $chunk_len);
        } else {
            $in = '';
        }
    }
    return $out;
}


function make_request($Url, $Method="GET", $Referer, $PostData, &$host, &$port) {
  global $login;
  $URI= parse_url($Url);
  $PostData = replace_all($PostData, '[{<', '>}]', '');

  switch ($URI['scheme']) {
    case 'https':
      $URI['scheme'] = 'ssl';
      $URI['port'] = 443;
      $host = $URI['scheme'] . '://' . $URI['host'];
      break;
    case 'http':
    default:
      $URI['scheme'] = '';
      $URI['port'] = 80;   
      $host = $URI['host'];
  }
  $cookiehost = $URI['host'];
  if ($login) $cookiehost = $login.'_'.$cookiehost;

  if ($URI['port']) $port = $URI['port'];

  // generate headers in array.
  $Header   = array();
  $Path = $URI['path'];
  if ($URI['query']) $Path .= '?' . $URI['query'];
  if ($Method == 'GET' and $PostData) {
    $Path = $URI['path'] .'?' . $PostData;
  } 
  $Header[] = $Method . ' ' . $Path . ' HTTP/1.1';
  if ($URI['port'] == 443) {
    $Header[] = 'Host: ' . $URI['host'];
    $Header[] = 'User-Agent: User-Agent=Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.6) Gecko/2009011913 Firefox/3.0.6 (.NET CLR 3.5.30729)';
    $Header[] = 'Accept: text/html';
    $Header[] = 'Accept-Language: ru,en-us;q=0.7,en;q=0.3';
    $Header[] = 'Accept-Encoding: gzip,deflate';
    $Header[] = 'Accept-Charset:  windows-1251,utf-8;q=0.7,*;q=0.7';
    $Header[] = 'Keep-Alive: 300';
    $Header[] = 'Referer: '.$Referer;
    $Header[] = 'Connection: Close';
  } else {
    $Header[] = 'Host: ' . $host . ':' . $port;
    $Header[] = 'User-Agent: User-Agent=Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.6) Gecko/2009011913 Firefox/3.0.6 (.NET CLR 3.5.30729)';
    $Header[] = 'Accept: text/html';
    $Header[] = 'Accept-Language: ru,en-us;q=0.7,en;q=0.3';
    $Header[] = 'Accept-Encoding: gzip,deflate';
    $Header[] = 'Accept-Charset:  utf-8;q=0.7,*;q=0.7';
    $Header[] = 'Keep-Alive: 300';
    $Header[] = 'Proxy-Connection: keep-alive';
    $Header[] = 'Referer: '.$Referer;
    $Header[] = 'Connection: Close';
  }
  if (file_exists("cookies/$cookiehost.txt")) {
    $Header[] = "Cookie: " . str_replace("\r\n", '; ', urldecode(file_get_contents("cookies/$cookiehost.txt")));
  }
  
  if (($Method == 'POST') and $PostData) {
    $Header[] = "Content-Type: application/x-www-form-urlencoded"; 
    $Header[] = 'Content-Length: ' . strlen($PostData);
  }

  return (implode("\r\n",$Header) . "\r\n\r\n" . $PostData);
}    

function run_request($Request, &$Response) {
  list(, $host) = explode('Host: ', $Request, 2);
  list($host, ) = explode("\r\n", $host, 2);
  list($host, $port) = explode(':', $host, 2);
  $open = fsockopen($host, $port);
  fputs($open, $Request);
  while (!feof($open)) {
    $Result .= fgets($open, 4096);
  }
  fclose($open);

  list($Response, $Html) = @explode("\r\n\r\n", $Result, 2);

  if (preg_match("/transfer\-encoding\: chunked/i", $Response)) {
      $Html = http_chunked_decode($Html);
  }

  if (preg_match("/Content\-Encoding\: gzip/i", $Response)) {
   $Response = preg_replace("/Content\-Encoding: gzip\s+/isU", "", $Response);
   $Html = gzinflate(substr($Html, 10));
  }

  return ($Html);
}

function extract_statusline_code($Response) {
  list(,$Code,) = explode(' ', $Response, 3);
  return ($Code);
}

function extract_content_length($Response) {
  list(, $ContentLength) = explode('Content-Length: ', $Response, 2);
  list($ContentLength, ) = explode("\r\n", $ContentLength, 2);
  return ($ContentLength);
}

function extract_location($Response) {
  list(, $Location) = explode('Location: ', $Response, 2);
  list($Location, ) = explode("\r\n", $Location, 2);
  return ($Location);
}

function fget_response($handle) {
  while (!feof($handle)) {
    $dump = fgets($handle);
    if ($dump == "\r\n") {
      return ($Response);
    }
    $Response .= $dump;
  }
  return ($Response);
}

function fget_content($handle, $ContentLength) {
  while ($ContentLength) {
    $Portion = min(4096, $ContentLength);
    $ContentLength -= $Portion;
    $Result .= fread($handle, $Portion);
  }
  return ($Result);
}

function update_cookies($Url, $Response) {
  global $login;
  $URI= parse_url($Url);
  $cookiehost = $URI['host'];
  if ($login) $cookiehost = $login.'_'.$cookiehost;
  $FCookArr = array();
  if (file_exists("cookies/$cookiehost.txt")) {
    $CookiesArr = explode("\r\n", file_get_contents("cookies/$cookiehost.txt"));
    foreach ($CookiesArr as $Cookie) {
      list($name, $value) = explode('=', $Cookie);
      $FCookArr[$name] = $value;
    }
  }
  $NewCook = extract_tags($Response, 'Set-Cookie: ', "\r\n");
  if ($NewCook != null) {
    $NewCook = str_ireplace('Set-Cookie: ', '', $NewCook);
    $NewCookArr = explode("\r\n", trim($NewCook));
    foreach ($NewCookArr as $NewCook) {
      list($Cookie,) = explode(';', $NewCook,2);
      list($name, $value) = explode('=', $Cookie);
      $FCookArr[$name] = $value;
    }
    $Cookies = array();
    foreach ($FCookArr as $key => $value) {
      $Cookies[] = $key.'='.$value; 
    }
    file_put_contents("cookies/$cookiehost.txt", implode("\r\n", $Cookies));
  }
}

function download_page($Url, $Method="GET", $Referer="", $PostData="") {
  do {
    $Request = make_request($Url, $Method, $Referer, $PostData, $host, $port);
    if ($open) {fclose($open);}
    $open = fsockopen($host, $port, $errno, $errst, 30);
    fputs($open, $Request);
    $StatusLine = fgets($open);
    $Response = $StatusLine . fget_response($open);
    $StatusCode = extract_statusline_code($Response);
    switch ($StatusCode) {
      case 303:
        $Method = 'GET';
      case 301:
      case 302:
        $Referer = $Url; 
        $Url = extract_location($Response);
        $PostData = '';
    }
  } while (($StatusCode != 200) and ($StatusCode < 400));
  while (!feof($open)) {
    $buffer = fgets($open, 4096);
    if ($buffer === false) break;
    $Html .= $buffer;
  }
  fclose($open);

  update_cookies($Url, $Response);
  
  if (preg_match("/transfer\-encoding\: chunked/i", $Response)) {
    $Html = transfer_encoding_chunked_decode($Html);
  }

  if (preg_match("/Content\-Encoding\: gzip/i", $Response)) {
   $Response = preg_replace("/Content\-Encoding: gzip\s+/isU", "", $Response);
   $Html = gzinflate(substr($Html, 10));
  }

  return $Html;
} 

function download($Url, $Method="GET", $Referer="", $PostHash=null, $ResponseFileName=null) {
  $PostData = array();
  if ($PostHash) {
    foreach ($PostHash as $key => $value) $PostData[] = $key.'='.$value;
  }
  try {
    do {
      $Request = make_request($Url, $Method, $Referer, implode('&', $PostData), $host, $port);
      if ($open) {fclose($open);}
      $open = fsockopen($host, $port, $errno, $errst, 30);
      fputs($open, $Request);
      $StatusLine = fgets($open);
      $Response = $StatusLine . fget_response($open);
      if ($ResponseFileName) file_put_contents($ResponseFileName, $Response);
      $StatusCode = extract_statusline_code($Response);
      switch ($StatusCode) {
        case 303:
          $Method = 'GET';
        case 301:
        case 302:
          $Referer = $Url; 
          $Url = extract_location($Response);
          $PostData = array();
      }
    } while (($StatusCode != 200) and ($StatusCode < 400));
    while (!feof($open)) {
      $buffer = fgets($open, 4096);
      if ($buffer === false) break;
      $Html .= $buffer;
    }
    fclose($open);
  } catch (E_NOTICE $e) {
      echo "Notice raised: " . $e->getMessage();
  }

  update_cookies($Url, $Response);
  
  if (preg_match("/transfer\-encoding\: chunked/i", $Response)) {
    $Html = transfer_encoding_chunked_decode($Html);
  }

  if (preg_match("/Content\-Encoding\: gzip/i", $Response)) {
   $Response = preg_replace("/Content\-Encoding: gzip\s+/isU", "", $Response);
   $Html = gzinflate(substr($Html, 10));
  }

  return $Html;
}

function is_email_exists($email){
  list($prefix, $domain) = split("@", $email);
  if(function_exists("getmxrr") && getmxrr($domain, $mxhosts)){
    return true;
  }
  elseif (@fsockopen($domain, 25, $errno, $errstr, 5)){
    return true;
  }
  else{
    return false;
  }
}


function send_mail($from, $to, $subject, $message, $attach_filename=null) {
  //create a boundary string. It must be unique
  //so we use the MD5 algorithm to generate a random hash
  $random_hash = md5(date('r', time()));
  //define the headers we want passed. Note that they are separated with \r\n
  $headers[] = "From: $from\r\nReply-To: $from";
  //define the body of the message.

  
  if ($attach_filename) {
    $headers[] = "Content-Type: multipart/mixed; boundary=\"PHP-mixed-".$random_hash."\"";
    $email[] = "--PHP-mixed-$random_hash";
    $email[] = "Content-Type: multipart/alternative; boundary=\"PHP-alt-$random_hash\"";
    $email[] = null;
    $email[] = "--PHP-alt-$random_hash";
    $email[] = "Content-Type: text/plain; charset=\"iso-8859-1\"";
    $email[] = "Content-Transfer-Encoding: 7bit";
    $email[] = null;
    $email[] = $message;
    $email[] = null;
    $email[] = "--PHP-alt-$random_hash";
    $email[] = "Content-Type: text/html; charset=\"iso-8859-1\"";
    $email[] = "Content-Transfer-Encoding: 7bit";
    $email[] = null;
    $email[] = $message;
    $email[] = null;
    $email[] = "--PHP-alt-$random_hash--";
    $email[] = null;
    //read the atachment file contents into a string,
    //encode it with MIME base64,
    //and split it into smaller chunks
    $attach = basename($attach_filename);
    $attachment = chunk_split(base64_encode(file_get_contents($attach_filename)));
    $email[] = "--PHP-mixed-$random_hash";
    $email[] = "Content-Type: application/zip; name=\"$attach\"";
    $email[] = "Content-Transfer-Encoding: base64";
    $email[] = "Content-Disposition: attachment";
    $email[] = null;
    $email[] = $attachment;
    $email[] = null;
    $email[] = "--PHP-mixed-$random_hash--";
  } elseif (preg_match("|</.+?>|imsU", $message)) {
    $headers[] = "Content-Type: multipart/alternative; boundary=\"PHP-alt-$random_hash\"";
    $email[] = "--PHP-alt-$random_hash";
    $email[] = "Content-Type: text/plain; charset=\"iso-8859-1\"";
    $email[] = "Content-Transfer-Encoding: 7bit";
    $email[] = null;
    $email[] = $message;
    $email[] = null;
    $email[] = "--PHP-alt-$random_hash";
    $email[] = "Content-Type: text/html; charset=\"iso-8859-1\"";
    $email[] = "Content-Transfer-Encoding: 7bit";
    $email[] = null;
    $email[] = $message;
    $email[] = null;
    $email[] = "--PHP-alt-$random_hash--";
  } else {
    $email[] = "--PHP-alt-$random_hash";
    $email[] = "Content-Type: text/plain; charset=\"iso-8859-1\"";
    $email[] = "Content-Transfer-Encoding: 7bit";
    $email[] = null;
    $email[] = $message;
    $email[] = null;
    $email[] = "--PHP-alt-$random_hash--";
  }
  //send the email
  $body = implode("\r\n", $email);
  return @mail($to, $subject, $body, implode("\r\n", $headers));
}
?>