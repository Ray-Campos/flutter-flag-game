# Flag Game 

Um aplicativo interativo desenvolvido em Flutter com o objetivo de testar e aprimorar os conhecimentos dos jogadores sobre as bandeiras de países de todo o mundo. O projeto possui foco em uma arquitetura limpa, gerenciamento de estado eficiente e execução offline.

## Funcionalidades

*   **Modos de Jogo:** Opção de jogar com países do mundo todo (Aleatório) ou filtrar por continentes específicos.
*   **Configuração de Tempo:** O jogador pode escolher a duração da partida (30 segundos, 60 segundos, 3 minutos ou 5 minutos).
*   **Feedback Visual:** Indicação imediata de acerto (verde) ou erro (vermelho) ao selecionar uma opção.
*   **Modo Offline:** Todas as imagens de bandeiras e dados dos países são armazenados localmente, eliminando a necessidade de conexão com a internet durante o jogo.

## Estrutura do Projeto

O código-fonte está modularizado para facilitar a manutenção e escalabilidade. A pasta `lib/` está dividida da seguinte forma:

*   **`models/`**: Contém as classes de dados (`country.dart` e `question.dart`). Representam as entidades básicas do aplicativo.
*   **`data/`**: Contém o `country_repository.dart`, responsável por carregar o arquivo estático JSON, realizar o parse dos dados e filtrar a lista de países disponíveis.
*   **`providers/`**: Contém o `game_state.dart`. É o "motor" do jogo. Utiliza o pacote Provider para gerenciar o cronômetro, a pontuação, o sorteio de perguntas e o estado geral da partida.
*   **`screens/`**: Contém a interface do usuário (UI).
    *   `main_menu_screen.dart`: Tela inicial para seleção de opções.
    *   `game_screen.dart`: Tela principal onde o jogo acontece (exibe a bandeira, opções e timer).
    *   `result_screen.dart`: Tela final com as estatísticas da partida.
*   **`assets/`** *(na raiz do projeto)*: Guarda o arquivo `countries.json` (em `assets/data/`) e as imagens das bandeiras (em `assets/flags/`).

## Como o Jogo Funciona

1.  Ao abrir o aplicativo, o Flutter carrega o banco de dados local (`countries.json`) diretamente para a memória através do repositório.
2.  No Menu Principal, o jogador define suas preferências e inicia a partida. O `GameState` (Provider) recebe essas configurações.
3.  O `GameState` inicia o cronômetro e sorteia uma bandeira correta e três opções erradas da lista de países disponíveis, enviando esses dados para a `GameScreen`.
4.  O jogador interage com os botões. A interface exibe as cores de feedback e aguarda 1 segundo antes de solicitar ao provedor a próxima pergunta.
5.  Quando o tempo chega a zero, o Provider sinaliza o fim do jogo e a tela navega automaticamente para os Resultados Finais, exibindo a pontuação e a precisão do jogador.

## Como Executar o Projeto

**Pré-requisitos:**
*   [Flutter SDK](https://docs.flutter.dev/install/manual) instalado na sua máquina.
*   Um emulador configurado (Android/iOS) ou o Google Chrome para rodar na web.

**Passo a passo:**

1. Faça o clone deste repositório:
   ```bash
   git clone https://github.com/Ray-Campos/flutter-flag-game.git
   ```
2. Acesse a pasta do projeto:
   ```bash
   cd flutter-flag-game
   ```
3. Baixe as dependências do Flutter:
   ```bash
   flutter pub get
   ```
4. Execute o aplicativo:
   ```bash
   flutter run
   ```

*(Certifique-se de que os assets em `assets/flags` e `assets/data/countries.json` foram gerados/adicionados corretamente antes de executar).*