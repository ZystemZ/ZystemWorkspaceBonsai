<?php
declare(strict_types=1);require_once __DIR__.'/HttpClient.php';
final class LlmProvider {
    public function __construct(private readonly array $config){}
    public function models():array{$data=$this->request('/models','GET');return array_values(array_filter(array_map(fn($m)=>(string)($m['id']??''),$data['data']??[])));}
    public function chat(array $messages,array $tools=[]):array{$model=$this->config['llm']['model'];if($model==='')$model=$this->models()[0]??'';if($model==='')throw new RuntimeException('Nenhum modelo configurado ou disponível em '.$this->config['llm']['base_url']);$payload=['model'=>$model,'messages'=>$messages,'temperature'=>0.15,'max_tokens'=>2048,'stream'=>false];if($tools){foreach($tools as &$tool){if(isset($tool['function']['parameters']['properties'])&&$tool['function']['parameters']['properties']===[])$tool['function']['parameters']['properties']=(object)[];}unset($tool);$payload['tools']=$tools;$payload['tool_choice']='auto';}$data=$this->request('/chat/completions','POST',$payload);return $data['choices'][0]['message']??throw new RuntimeException('Resposta inválida do provedor.');}
    private function request(string $path,string $method,?array $payload=null):array{$base=rtrim((string)$this->config['llm']['base_url'],'/');if(!filter_var($base,FILTER_VALIDATE_URL))throw new InvalidArgumentException('URL do provedor LLM inválida.');$headers=[];if(($this->config['llm']['api_key']??'')!=='')$headers[]='Authorization: Bearer '.$this->config['llm']['api_key'];return HttpClient::json($base.'/'.$path,ltrim($method),$payload,$headers,(int)($this->config['llm']['timeout']??180));}
}
?>
