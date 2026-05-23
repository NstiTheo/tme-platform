# TME — Theo Mind Educacional

Tecnologia, ensino e evolução em uma única plataforma.

A TME é uma base MVC própria em PHP para uma plataforma educacional moderna que mistura LMS, EAD, sistema escolar, comunidade acadêmica, gamificação, marketplace e gestão educacional.

## Tecnologias

- PHP 8+
- MySQL
- PDO com prepared statements
- HTML5, CSS3 e JavaScript puro
- MVC próprio, sem Laravel
- Sessões PHP para autenticação
- Estrutura reservada para módulos e integrações futuras em Python/IA

## Funcionalidades da primeira entrega

- Home pública e páginas institucionais: Sobre, Cursos, Eventos, Biblioteca, Comunidade, Login e Cadastro.
- Cadastro de aluno ou professor com status inicial `pendente`.
- Login permitido apenas para contas `aprovado`.
- Dashboards separados para aluno, professor, supervisor, administrador, secretaria e financeiro.
- Aprovação e recusa de contas por administrador ou supervisor.
- Tema claro/escuro e cor principal personalizável por usuário.
- Roles, permissões, instituições, cursos, turmas, atividades, comunidade, eventos, certificados, gamificação, financeiro, notificações e logs modelados no banco.
- Estrutura preparada para importações futuras do INEP e e-MEC.

## Módulo administrativo de cursos

O admin/supervisor acessa `Administração > Cursos admin` para gerenciar o catálogo acadêmico.

Recursos disponíveis:

- CRUD de cursos com título, descrição, categoria, nível, carga horária, preço, status, professor responsável e imagem opcional.
- Filtros de listagem por status, categoria e professor.
- Arquivamento de curso em vez de exclusão definitiva.
- CRUD de módulos vinculados ao curso.
- CRUD de aulas vinculadas ao curso e opcionalmente a um módulo.
- Campos de aula: título, descrição, tipo, vídeo/link, conteúdo textual, ordem, duração e status.
- Cadastro de materiais por aula, com PDF, imagem, link externo, arquivo, livro, apostila ou vídeo.
- Uploads salvos em `public/uploads/course-images` e `public/uploads/materials`.
- Logs em `logs` para criação, edição, remoção e arquivamento.
- CSRF, sessão, middleware de autenticação e proteção por role `administrador/supervisor`.

Alunos aprovados acessam `Meus cursos` para ver cursos publicados, detalhes do curso, módulos, aulas e materiais ativos.

Para bancos existentes, aplique a migration:

```bash
mysql -u root -p < database/migrations/2026_05_23_admin_courses_module.sql
```

## Estrutura

```text
tme-platform/
├── app/
│   ├── controllers/
│   ├── core/
│   ├── helpers/
│   ├── middleware/
│   ├── models/
│   ├── services/
│   └── views/
├── assets/
│   ├── css/
│   ├── js/
│   ├── img/
│   └── icons/
├── config/
├── database/
│   ├── migrations/
│   ├── seeds/
│   └── tme_initial.sql
├── modules/
├── ai/python/
├── public/
│   ├── index.php
│   └── uploads/
├── storage/
├── .env.example
├── .gitignore
└── README.md
```

## Instalação local

1. Copie `.env.example` para `.env`.
2. Ajuste as credenciais do MySQL no `.env`.
3. Crie/importe o banco usando `database/tme_initial.sql`.
4. Aponte o servidor web para a pasta `public/` ou acesse a aplicação pelo caminho `/public`.

Exemplo de `.env` para XAMPP:

```env
APP_URL=http://localhost/tme-plataform/public
APP_DEBUG=true
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=tme_platform
DB_USERNAME=root
DB_PASSWORD=
```

## Importar banco de dados

Pelo phpMyAdmin:

1. Abra `http://localhost/phpmyadmin`.
2. Vá em Importar.
3. Selecione `database/tme_initial.sql`.
4. Execute a importação.

Pelo terminal:

```bash
mysql -u root -p < database/tme_initial.sql
```

O SQL cria o banco `tme_platform`, as tabelas iniciais e um administrador demo.

Credenciais iniciais:

- E-mail: `admin@tme.local`
- Senha: `password`

Troque essa senha no primeiro uso em ambiente real.

## Rodar no XAMPP

1. Coloque a pasta do projeto dentro de `htdocs`.
2. Inicie Apache e MySQL no painel do XAMPP.
3. Importe `database/tme_initial.sql`.
4. Configure `.env`.
5. Acesse `http://localhost/tme-plataform/public`.

Para um ambiente mais limpo, crie um VirtualHost apontando o `DocumentRoot` para `public/`.

## Fluxo inicial

1. Usuário acessa Home e entra em Cadastro.
2. Cadastro aceita apenas `aluno` ou `professor`.
3. A conta é gravada como `pendente`.
4. Administrador ou supervisor acessa `Aprovações`.
5. Conta aprovada pode fazer login.
6. Após login, o usuário vai para o dashboard do próprio perfil.

## Segurança aplicada

- Senhas com `password_hash` e verificação com `password_verify`.
- Login com sessão e `session_regenerate_id`.
- Middleware de autenticação e middleware por role.
- PDO configurado com exceptions, fetch associativo e prepared statements.
- CSRF token nos formulários principais.
- Validação básica de cadastro.
- `.env` fora do versionamento.
- Arquivos internos ficam fora da pasta pública e possuem proteção contra acesso direto.

## Módulos planejados

- Cursos, aulas, módulos, materiais e progresso.
- Turmas, disciplinas, vínculos e calendário.
- Atividades, entregas, correções, notas e feedback.
- Simulados, banco de questões, tempo limite e correção automática futura.
- Biblioteca digital com materiais públicos, privados e favoritos.
- Eventos com certificados.
- Gamificação com XP, níveis, conquistas, badges, ranking e moedas internas.
- Certificados com código único, validação pública e QR Code futuro.
- Comunidade acadêmica com posts, comentários, projetos, portfólio e moderação.
- Chat por turma, grupos e mensagens privadas futuras.
- Financeiro com planos, assinaturas, mensalidades, histórico e marketplace 20%/80%.
- IA futura para tutor inteligente, correções, resumos, quizzes, recomendação, desempenho e plágio.

## Versionamento e auto-sync GitHub

O projeto está preparado para sincronização automática com o repositório:

- Remote: `https://github.com/NstiTheo/tme-platform.git`
- Branch de trabalho: `dev`
- Auto commit: ativado pelo script `tools/git-auto-sync.ps1`
- Auto push: ativado para `origin/dev`

Configurar o Git local, validar o projeto e iniciar o monitor em segundo plano:

```powershell
.\tools\setup-git-auto-sync.ps1 -StartWatcher
```

Executar uma sincronização única, útil antes de fechar o editor:

```powershell
.\tools\git-auto-sync.ps1 -Once
```

Manter o monitor aberto no terminal atual:

```powershell
.\tools\git-auto-sync.ps1
```

Antes de cada commit/push automático, a automação:

- valida sintaxe PHP com o PHP CLI do XAMPP;
- valida JavaScript com `node --check`, quando Node.js estiver instalado;
- bloqueia marcadores de conflito Git;
- verifica a estrutura MVC principal;
- confirma que `.env` continua fora do versionamento;
- cria backup local de arquivos críticos alterados em `.automation/backups/`;
- grava logs em `.automation/logs/git-auto-sync.log`;
- não usa `force push` e não sobrescreve remote já configurado com outra URL.

Arquivos estruturais novos ou mudanças de arquitetura devem vir acompanhados de atualização no README.
