<?php
declare(strict_types=1);
final class UserStorage {
    public static function home(array $config,int $userId): string { if($userId===0){if(session_status()!==PHP_SESSION_ACTIVE)session_start();$base=$config['storage'].DIRECTORY_SEPARATOR.'temporary'.DIRECTORY_SEPARATOR.session_id();}else{$base=$config['storage'].DIRECTORY_SEPARATOR.'users'.DIRECTORY_SEPARATOR.'id'.str_pad((string)$userId,5,'0',STR_PAD_LEFT);} foreach(['arquivos','projetos','uploads'] as $dir) if(!is_dir($base.DIRECTORY_SEPARATOR.$dir))@mkdir($base.DIRECTORY_SEPARATOR.$dir,0775,true); return $base; }
}
?>
