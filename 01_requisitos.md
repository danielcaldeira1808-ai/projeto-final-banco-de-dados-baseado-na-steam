# 1. Levantamento e Análise de Requisitos (Atividade 01)

## 1.1 Descrição do domínio
Plataforma digital de distribuição e comunidade de jogos online, nos moldes da Steam. Desenvolvedores e estúdios, após cadastro e aprovação da administração, publicam jogos. Jogadores criam conta, compram jogos e DLCs, formam uma biblioteca, avaliam o que jogaram, conquistam medalhas e fazem amizades. Jogos têm preço (podendo ser zero), classificação indicativa, gêneros e tags (ex.: co-op, pixel art), versões e DLCs, e podem entrar em promoções com datas de início e fim. A compra só se conclui após a confirmação do pagamento por uma operadora; a plataforma retém uma taxa e repassa o restante ao desenvolvedor. O reembolso é permitido em até 14 dias, com menos de 2 horas de jogo e jogo não finalizado.

## 1.2 Stakeholders e responsabilidades
| Stakeholder | Responsabilidade |
|---|---|
| Jogador | Compra, joga, avalia, conquista, faz amizades, pede reembolso |
| Desenvolvedor/Estúdio | Publica jogos, versões e DLCs; recebe o repasse das vendas |
| Administrador da plataforma | Aprova desenvolvedores e jogos; define promoções e taxa |
| Operadora de pagamento | Processa e confirma os pagamentos |
| Suporte ao cliente | Analisa e decide os pedidos de reembolso |

## 1.3 Necessidades por stakeholder
- **Jogador:** encontrar jogos por gênero/tag, comprar com segurança, ter biblioteca, avaliar, reaver o dinheiro em caso de arrependimento.
- **Desenvolvedor:** publicar e atualizar jogos, saber quanto vendeu e quanto vai receber.
- **Administrador:** controlar o catálogo (aprovação) e as promoções.
- **Operadora:** receber a cobrança e devolver o status do pagamento.
- **Suporte:** consultar compra, tempo de jogo e prazo para decidir reembolsos.

## 1.4 Categorias
Usuários · desenvolvedores · jogos · gêneros e tags · versões · DLCs · promoções · biblioteca · compras e itens · pagamentos · reembolsos · avaliações · conquistas · amizades · notificações.

## 1.5 Regras de negócio (15) — numeração do cenário validado
| Regra | Descrição | Como o banco trata |
|---|---|---|
| R1 | Todo jogo é publicado por desenvolvedor cadastrado e aprovado pela administração | FK `jogo→desenvolvedor` + `status_aprovacao` (aprovação é processo) |
| R2 | Um jogo pertence a um ou mais gêneros/tags | Tabela `jogo_genero_tag` (N:N) |
| R3 | Um usuário só tem o mesmo jogo uma vez na biblioteca | `UNIQUE (id_usuario, id_jogo)` |
| R4 | A compra só conclui após a confirmação do pagamento | **Trigger** `trg_r4_compra_so_com_pagamento` |
| R5 | DLC só ativa com o jogo base; senão fica guardada na conta | `item_compra.status_dlc` (`guardada`/`ativada`) + UPDATE (consulta 9) |
| R6 | Só avalia quem jogou (comprou ou testou) | FK composta `avaliacao→biblioteca` (origem `compra` ou `teste`) |
| R7 | No máximo uma avaliação por jogo, editável | `UNIQUE (id_usuario, id_jogo)` + `data_edicao` |
| R8 | Reembolso até 14 dias, menos de 2 h e jogo não finalizado | **Trigger** `trg_r8_reembolso_regras` |
| R9 | Promoção com início e fim; desconto até 100% | `CHECK (desconto_pct BETWEEN 1 AND 100)` e `CHECK (data_fim > data_inicio)` |
| R10 | Preço nunca negativo; gratuito = 0 | `CHECK (preco_centavos >= 0)` |
| R11 | Conquista só para quem possui o jogo | FK composta `conquista_usuario→biblioteca` |
| R12 | Ninguém é amigo de si mesmo; amizade exige que 2 usuários queiram a amizade | `CHECK (id_solicitante <> id_destinatario)` + `status = 'aceita'` |
| R17 | Nova versão notifica quem possui o jogo | Tabela `notificacao` + consulta 10 |
| R18 | Desenvolvedor recebe a venda menos a taxa da plataforma | `taxa_plataforma_pct` + `repasse_desenvolvedor_centavos` no item |
| R19 | Classificação indicativa maior que a idade bloqueia a compra (salvo autorização) | Campos `classificacao_indicativa` e `data_nascimento`; verificação fora do banco |

**Fora do escopo (decisão do projeto):** R13 e R14 (denúncia e suspensão), R15 e R16 (eventos/torneios), R20 (grupos).

## 1.6 Estimativas de volume e frequência (hipóteses de projeto)
50 mil usuários · 2 mil jogos · 300 desenvolvedores · ~200 compras/dia (pico de promoções: 10×) · ~5 avaliações por 100 jogadores/mês · reembolsos: ~3% das compras.

## 1.7 Casos de uso críticos
1. **Comprar um jogo:** usuário escolhe jogo (e promoção vigente) → compra `pendente` → pagamento confirmado pela operadora → compra `concluida` → jogo entra na biblioteca → repasse calculado.
2. **Solicitar reembolso:** usuário pede em até 14 dias → sistema confere tempo de jogo e finalização → suporte aprova ou nega.

## 1.8 Restrições legais, privacidade e segurança
LGPD (dados pessoais do usuário: e-mail, data de nascimento) · Código de Defesa do Consumidor (direito de arrependimento (reembolso)) · Classificação Indicativa · dados de pagamento tratados pela operadora, não armazenados.

## 1.9 Dúvidas para o cliente esclarecer
1. O tempo de jogo de um *tester* conta para a avaliação (R6)? (Modelado: sim, origem `teste`.)
2. O limite de 2 horas (R8) é por jogo ou somado? Reembolso de DLC segue só os 14 dias? (Modelado: por jogo; DLC só 14 dias.)
3. Quem verifica o documento do responsável (R19) e vale para um jogo ou para uma faixa?
4. A taxa da plataforma (R18) é fixa por estúdio ou varia por faixa de receita? (Modelado: por estúdio, congelada no item.)
5. Reembolso aprovado estorna automaticamente o repasse já feito ao desenvolvedor?
 
## 1.9 Referências das fontes utilizadas
> 

1. Valve Corporation. **Steam — Política de reembolso** (página oficial). https://store.steampowered.com/steam_refunds — acessado em 09/10/2026. *Base da regra R8 (14 dias e menos de 2 horas de jogo) e do tratamento de DLC.*
2. Valve Corporation. **Loja Steam** (páginas de jogos: gêneros, tags, DLCs, versões, avaliações, conquistas, amizades). https://store.steampowered.com — acessado em 09/10/2026. *Sistema real observado como referência do domínio.*
3. Universidade Federal de Santa Catarina, CIN 8003. **Atividades Práticas 01 a 07 e Diretrizes do Projeto Final (Partes 1, 2 e 3)**, prof. Moisés Lima Dutra (Moodle, 2026). *Método de requisitos, modelagem conceitual, lógica e física.*
4. **Cenário e regras de negócio do projeto** elaboradas por mim e validadas pelo professor.
5. Brasil. **Lei nº 13.709/2018 (LGPD)** e **Lei nº 8.078/1990 (Código de Defesa do Consumidor)**, texto no site do Planalto — acessado em 09/10/2026. *Restrições legais do item 1.8.*
6. **Ferramenta de apoio:** assistente de IA (Claude, Anthropic, visual paradigm) utilizado como ferramenta de auxilio, discutir alternativas e revisar os documentos. As decisões de modelagem foram tomadas por mim o visual paradigm usei o modo IA do próprio aplicativo para fazer o MER finalizado.
