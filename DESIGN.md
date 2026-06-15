# Jogo das Operações — Documento de Design

## Visão geral
Jogo educativo (web) para crianças (~6–10 anos) praticarem as 4 operações
matemáticas. A criança arrasta o **operador correto** (+, −, ×, ÷) para
dentro de cada conta de modo a tornar a igualdade verdadeira, e confere o
resultado clicando em "Executar".

- **Plataforma:** Navegador (Godot 4 → export HTML5)
- **Engine:** Godot 4.x (GDScript)
- **Público:** crianças em alfabetização matemática
- **Idioma:** Português

## Mecânica principal
1. A tela mostra uma lista de contas com o operador faltando:
   - `5 [ ] 3 = 8`
   - `9 [ ] 1 = 10`
   - `7 [ ] 3 = 4`  (resolvido com −:  7 − 3 = 4)
   - `4 [ ] 3 = 12` (não tem solução simples — serve de "pegadinha")
   - `5 [ ] 4 = 11` (sem solução exata — exemplo de erro)
   - `12 [ ] 6 = 2` (resolvido com ÷: 12 ÷ 6 = 2)
2. Painel lateral "Operações" com 4 peças arrastáveis: + − × ÷
3. A criança arrasta uma peça para o espaço de cada conta (drag & drop).
4. Botão **"Executar"**: avalia cada conta com o operador escolhido.
5. Cada linha recebe um selo:
   - **"correto"** (verde) se `a OP b == resultado`
   - **"errada"** (vermelho) caso contrário
6. Botão **"Tentar novamente"** reinicia a tentativa.

## Regras de avaliação
- Uma conta `a [OP] b = r` está correta se aplicar OP a `a` e `b` dá exatamente `r`.
- Divisão só vale se for exata (sem resto).
- Conta sem peça encaixada conta como "errada" (ou pede para completar).

## Conteúdo das contas
- **Fase 1:** lista fixa (as 6 contas acima) — fácil de testar.
- **Fase 2:** geração aleatória — sorteia `a`, `b` e um operador alvo,
  calcula `r`, e apresenta a conta com o operador escondido. Garante que
  toda conta gerada tenha pelo menos uma solução válida.

## Telas
- **Tela de jogo:** lista de contas + painel de operadores + botão Executar.
- **Estado de resultado:** mesma tela, com selos correto/errada + "Tentar novamente".
  (Não precisa ser uma cena separada; é o mesmo layout mudando de estado.)

## Roadmap de implementação
1. Setup do projeto Godot + layout estático da tela.
2. Drag & drop dos operadores para os espaços.
3. Lógica de "Executar" e feedback visual (correto/errada).
4. Contas fixas → geração aleatória.
5. Polimento: cores, sons, animação, pontuação/níveis.
6. Export HTML5 e publicação.

## Ideias futuras (fora do escopo inicial)
- Pontuação e estrelas por acerto.
- Níveis com dificuldade crescente (números maiores, mais contas).
- Sons de acerto/erro e personagem mascote.
- Modo "só uma operação" (treinar só multiplicação, etc.).
