# Desafio Fretadão

Este projeto é a minha solução para o desafio proposto pela empresa Fretadão, consite em um site no qual são cadastrados perfils do github e se é feito um *web scraping* na página deste perfil e são coletadas uma série de informações.

## Tecnologias Utilizadas

Esse projeto foi desenvolvido usando o framework [Ruby on Rails](https://rubyonrails.org/) na versão ```6.0.3```, com o  [Ruby](https://www.ruby-lang.org/en/) na versão ``` 2.7``` e o banco de dados [PostgreSQL](https://www.postgresql.org/) na versão ```9.6```. Além disso também foi usando [Bootstrap 4](https://getbootstrap.com/) para facilitar a estilização do *front-end* ao projeto e algumas *gems* para solucionar problemas especificos:

### Web Scraping
Para realizar o *web scraping* foi utilizada a *gem* [Nokogiri](https://nokogiri.org/), ela foi escolhida por sua facilidade de uso e boa documentação.

### Encurtamentor de URL
Para o encurtamento de URLs foi escolhido usar o serviço  [Bitly](https://bitly.com/), pois ele é um serviço conhecido, o que aumenta a sensação de segurança do usuário ao clicar nos links encurtados, possui uma API aberta e bem documentada. Para facilitar a comunicação com a API do Bitly foi usada uma *gem* chamada [bitly](https://rubygems.org/gems/bitly/versions/0.10.4) ela foi escolhida simplismente pela facilidade de uso. A decisão de utilizar o serviço do Bitly trouxe uma consequencia negativa para o projeto que é a necesside de ser inserido um *token* de acesso do serviço para que a aplicação funcione.

## Subindo o Ambiente

Prerrequisitos;
 - [Docker](https://www.docker.com/) versão 17.12.0+
 - [Docker Compose](https://docs.docker.com/compose/) testado na versão  1.24.0

Primeiro é necessario criar o arquivo ```dev-env``` onde ficam as variáveis de ambiente da aplicação, ele pode ser criado a partir de um template copiando o arquivo ```sample-env```:
```bash
cp sample-env dev-env
```
Agora é necessario adquirir o *token* de acesso de um usuário para isso [cadatre-se](https://bitly.com/a/sign_up) ou [acesse sua conta](https://bitly.com/a/sign_in) e siga esse [tutorial](https://support.bitly.com/hc/en-us/articles/230647907-How-do-I-generate-an-OAuth-access-token-for-the-Bitly-API-) para adquirir o *token*.

Com o *token* abra o arquivo dev-env e adicone o *token* na variável ```BITLY_TOKEN```.

Agora rode o comando:
```bash
docker-compose up
```

E o seu servidor deve estar rodando no ```localhost:3000```.

Obs: Não se foi testada uma instalação manual do projeto, porém caso as dependencias sejam instaladas similarmente ao descrito no ```Dockerfile``` e sejam execultados os comando do script ```start.sh``` é provavel que o projeto funcione. 

### Rodando testes
Os testes deste projeto foram criados usando a ferramenta MiniTest e podem ser execultados com o comando:
```bash
docker-compose exec challenge_web rails test
```

Também foi configurada uma folha de estilo utilizando a *gem* [Rubocop](https://github.com/rubocop-hq/rubocop) que pode ser execultada com o comando:

```bash
docker-compose exec challenge_web rubocop
```

## Solução

### Gerenciar Perfis
Para gerenciar os perfis cadastrados foi criada uma *model* de perfil e páginas de listagem , de criação de perfil, de edição de perfil e de exibição de perfil, bem como um botão para deleção de perfil na página de exibição.

Para que um pefil seja criado são necessarios dois campos o **nome**  do perfil e a **url do perfil** no github, esse são os únicos campos diretamente editaveis pelo usuário as outras informções do perfil são geradas pelo webscrapper e pelo encurtamento de url.

### WebScrapper
Como dito previamente o *web screping* é feito com o auxílio da *gem* Nokogiri, ele é realizado pela classe WebScrepper que em seu criador faz uma requisição para a página do github e possui métodos que disponibilizam as informações do perfil requisitado.

O web scrapin é realizado sempre que um perfil é criado. Caso ocorra algum erro enquato as informações são parseadas é levantado um erro do tipo WebScrapingError.

#### Re-escanear
Na página de exibição do pefil existe um botão ```Extract github info``` que realiza o re-escaneamento da página com o mesmo método usado quando um usuário é criado

### Encurtamento de URL
Como dito previamente o encurtamento de URL é feito com auxilio da plataforma Bitly e somente é realizado quando existe uma mudança no atributo ```github_url```.

### Pesquisa
Foi adicionada uma barra de pesquisa na navbar que permite que o usuário busque perfis por parte do nome, usuário do github, localização ou organização. Qualquer perfil que pelo menos um dos campos combine com a palavra inserida é exibido na lista de perfis.

## Limitações
A aplicação possui a limitação de necessitar do *token* de um usuário da plataforma Bitly para funcionar, outra limitação é que devido ao github requerir o *login* para o acesso ao e-mail de um perfil a aplicação não esta coletando essa informação.

## Pontos de Melhoria
Um ponto que necessita melhoria na aplicação é a generalização do WebScrapper da forma que ele esta implementado ele esta interligado com a página de perfil e preciso fazer o webscraping de outra página similar como a de repositori ou de organização pouca coisa seria reaproveitada.