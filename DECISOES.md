# Decisões do projeto 

Cada decisão tinha mais de um caminho. Abaixo: o que foi escolhido, as alternativas e a frase para explicar.

| # | Decisão | Alternativas | Por que escolhi  |
|---|---|---|---|
| 1 | **Modelo reduzido**: 19 tabelas (a versão inicial tinha 33) | Manter as 33 | "Reduzi o escopo ao núcleo da loja (catálogo, compra, biblioteca, avaliação, amizade, conquista) tava muito grande o banco de dados e eu teria dificuldade para entender" |
| 2 | **Só as regras complexas necessárias** | Muitos triggers | "O que CHECK, UNIQUE e FK resolvem, deixei com eles; trigger só onde a regra olha outras tabelas." |
| 3 | **MER no Visual Paradigm** (notação de Chen) | Diagrama gerado por script | "Usei a ferramenta indicada pelo professor, com a notação de Chen vista em aula." |
| 4 | **Fora do escopo**: eventos/torneios, grupos, fórum, denúncia e suspensão. **Dentro**: conquista e amizade | Manter tudo / cortar tudo | "Cortei os mais complexos e fiquei com o essencial: amizade e conquista (N:N)." |
| 5 | **DLC simples** | Cortar a DLC | "Toda loja de jogos tem DLC; modelei do jeito mais simples: uma tabela ligada ao jogo base." |
| 6 | **2 triggers**: R4 (compra só conclui com pagamento confirmado) e R8 (reembolso: 14 dias, menos de 2 h, jogo não finalizado) | Nenhum trigger / vários | "Só essas duas regras precisam consultar outras tabelas; o CHECK enxerga apenas a própria linha." |
| 7 | **Operadora de pagamento como coluna** com CHECK de lista fixa | Tabela própria | "A operadora só tem nome; se passasse a ter dados próprios (taxa, contato), viraria uma tabela separada." |
| 8 | **Promoção N:N** (tabela `promocao_jogo`) | Promoção ligada a um só jogo (1:N) | "O mesmo desconto vale para vários jogos; cadastro a promoção uma vez, sem repetir nome, datas e porcentagem." |
| 9 | **R19 só com campos** (`classificacao_indicativa` no jogo, `data_nascimento` no usuário) | Tabela de autorização do responsável | "removi a parte de verificação por documento do responsável seriam muitos transtornos" |
| 10 | **Status da DLC (`guardada`/`ativada`) guardado no `item_compra`**, atualizado por UPDATE | Calcular por consulta / tabela extra | "O estado fica visível na própria compra; a mudança é um UPDATE dentro de uma transação (consulta 9), sem trigger extra." |
| 11 | **R6 e R11 por FK composta** (`avaliacao` e `conquista_usuario` apontam para `biblioteca (id_usuario, id_jogo)`) | Trigger / só no aplicativo | "O banco confere o par usuário-jogo sozinho; assim fiquei só com os 2 triggers que realmente precisavam." |
| 12 | **RESTRICT** ao remover da biblioteca um jogo com avaliação/conquista | CASCADE (apagar junto) | "Conquistas e avaliações não se perdem; para tirar o jogo da biblioteca, primeiro é preciso tratá-las (basicamente você não perde as conquistas)." |


- **Preço pago e repasse guardados no item da compra** (preço congelado no momento da compra, repasse = preço pago × (100 − taxa)/100 do desenvolvedor).
- **R1 (desenvolvedor aprovado) e R2 (jogo com ao menos um gênero)** ficam como regra de processo, sem trigger (limitação declarada abaixo).

## Limitações 

- A R4 bloqueia a **mudança** para `concluida` sem pagamento, mas um INSERT direto de compra já `concluida` não é bloqueado (o trigger é só de UPDATE).
- Reembolso aprovado não remove o item da compra nem estorna o repasse (dúvida 5 dos requisitos).
- R1, R2 e R19 não são verificadas pelo banco, só modeladas.
