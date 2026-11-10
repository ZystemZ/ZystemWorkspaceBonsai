<?php
declare(strict_types=1);
final class HttpClient {
    public static function text(string $url,array $headers=[],int $timeout=15):string {
        if(function_exists('curl_init')){$ch=curl_init($url);curl_setopt_array($ch,[CURLOPT_RETURNTRANSFER=>true,CURLOPT_FOLLOWLOCATION=>false,CURLOPT_CONNECTTIMEOUT=>8,CURLOPT_TIMEOUT=>$timeout,CURLOPT_HTTPHEADER=>$headers]);$raw=curl_exec($ch);$error=curl_error($ch);$status=(int)curl_getinfo($ch,CURLINFO_HTTP_CODE);curl_close($ch);if($raw===false||$status>=400)throw new RuntimeException('Falha HTTP '.$status.': '.($error?:'resposta inválida'));return (string)$raw;}
        $opts=['http'=>['method'=>'GET','header'=>implode("\r\n",$headers), 'timeout'=>$timeout,'ignore_errors'=>true]];$raw=@file_get_contents($url,false,stream_context_create($opts));if($raw===false)throw new RuntimeException('Falha ao conectar ao endpoint de busca.');return (string)$raw;
    }
    public static function json(string $url,string $method='GET',?array $payload=null,array $headers=[],int $timeout=15):array {
        $method=strtoupper($method);$headers=array_merge(['Accept: application/json'],$headers);
        if(function_exists('curl_init')){
            $ch=curl_init($url);$all=['Content-Type: application/json',...$headers];curl_setopt_array($ch,[CURLOPT_RETURNTRANSFER=>true,CURLOPT_CUSTOMREQUEST=>$method,CURLOPT_CONNECTTIMEOUT=>8,CURLOPT_TIMEOUT=>$timeout,CURLOPT_HTTPHEADER=>$all,CURLOPT_FOLLOWLOCATION=>false]);if($payload!==null)curl_setopt($ch,CURLOPT_POSTFIELDS,json_encode($payload,JSON_UNESCAPED_UNICODE|JSON_THROW_ON_ERROR));$raw=curl_exec($ch);$error=curl_error($ch);$status=(int)curl_getinfo($ch,CURLINFO_HTTP_CODE);curl_close($ch);if($raw===false)throw new RuntimeException('Falha ao conectar: '.$error);return self::decode($raw,$status);}
        $headerText=implode("\r\n",$headers)."\r\nContent-Type: application/json\r\n";$opts=['http'=>['method'=>$method,'header'=>$headerText,'content'=>$payload===null?'':json_encode($payload,JSON_UNESCAPED_UNICODE|JSON_THROW_ON_ERROR),'timeout'=>$timeout,'ignore_errors'=>true]];$context=stream_context_create($opts);$raw=@file_get_contents($url,false,$context);$status=0;foreach(($http_response_header??[]) as $line)if(preg_match('/^HTTP\/\S+\s+(\d+)/',$line,$m))$status=(int)$m[1];if($raw===false)throw new RuntimeException('Falha ao conectar ao endpoint. Verifique allow_url_fopen e a URL.');return self::decode($raw,$status);
    }
    private static function decode(string $raw,int $status):array{$data=json_decode($raw,true);if($status>=400||!is_array($data))throw new RuntimeException('Endpoint HTTP '.$status.': '.substr($raw,0,500));return $data;}
}
?>
