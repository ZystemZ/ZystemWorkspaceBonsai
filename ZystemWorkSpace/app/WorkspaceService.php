<?php
declare(strict_types=1);
final class WorkspaceService {
    public function __construct(private readonly array $config) {}
    public function root(): string { $root=realpath($this->config['workspace']); if($root===false||!is_dir($root))throw new RuntimeException('Workspace indisponível.'); return rtrim($root,DIRECTORY_SEPARATOR); }
    public function safe(string $relative,bool $mustExist=false): string {
        $relative=trim(str_replace(['\\','/'],DIRECTORY_SEPARATOR,$relative));
        if(strtolower($relative)==='workspace')$relative='arquivos';
        if($relative===''||str_contains($relative,"\0")||$relative[0]===DIRECTORY_SEPARATOR||preg_match('/(^|[\\\\\/])\.\.([\\\\\/]|$)/',$relative))throw new InvalidArgumentException('Caminho inválido ou fora da workspace.');
        $root=$this->root();$candidate=$root.DIRECTORY_SEPARATOR.$relative;$resolved=realpath($candidate);
        if($resolved===false){if($mustExist)throw new RuntimeException('Arquivo não encontrado.');$tail=[basename($candidate)];$parentPath=dirname($candidate);while($parentPath!==$root&&!is_dir($parentPath)){array_unshift($tail,basename($parentPath));$next=dirname($parentPath);if($next===$parentPath)break;$parentPath=$next;}$parent=realpath($parentPath);if($parent===false)throw new RuntimeException('Pasta pai indisponível.');$resolved=$parent.DIRECTORY_SEPARATOR.implode(DIRECTORY_SEPARATOR,$tail);}
        $normalized=strtolower(str_replace('\\','/',$resolved));$rootNormalized=strtolower(str_replace('\\','/',$root));$base=$rootNormalized.'/';
        if($normalized!==$rootNormalized&&!str_starts_with($normalized,$base))throw new RuntimeException('Caminho fora da workspace bloqueado.');
        $name=strtolower(basename($resolved));if(in_array($name,['.env','credentials.json','config.php'],true)||preg_match('/(token|secret|password|private\.key|\.pem$)/i',$name))throw new RuntimeException('Arquivo sensível bloqueado.');
        return $resolved;
    }
    public function list(string $relative='.'): array { $dir=$this->safe($relative,true);if(!is_dir($dir))throw new RuntimeException('Pasta não encontrada.');$out=[];foreach(scandir($dir)?:[] as $item){if($item==='.'||$item==='..')continue;try{$path=$this->safe(trim($relative,'./').($relative==='.'?'':'/').$item);}catch(Throwable){continue;}$out[]=['name'=>$item,'type'=>is_dir($path)?'directory':'file','size'=>is_file($path)?filesize($path):null];}return $out; }
}
?>
