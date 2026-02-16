### zero-vulnerabilidades

Projeto didático para demonstrar, na prática, como a escolha da imagem base e do processo de build impacta:
- Tamanho da imagem Docker
- Superfície de ataque
- Quantidade de vulnerabilidades (via Trivy)

A aplicação em Go exibe “Zero vulnerabilidades” e o hostname, centralizados na tela.

#### Estrutura do projeto

- `src/`
  - `main.go`
  - `go.mod`
- `Dockerfile.standard` (imagem “standard”, maior e com mais pacotes)
- `Dockerfile.distroless` (runtime distroless/static, mais enxuta)
- `Dockerfile.wolfi` (Chainguard/Wolfi/static, mais enxuta e atualizada)
- `scout-style.sh` (resumo de scan no estilo “docker scout quickview” usando Trivy)

#### Pré-requisitos

- Docker
- Trivy
- `jq` (para o script de resumo)

Instalação no Debian/Kali/Ubuntu:

sudo apt update
sudo apt install -y jq

Instalação do Trivy (uma opção simples via pacote; ajuste conforme sua distro):

sudo apt update
sudo apt install -y trivy

Se o pacote não existir/estiver antigo, consulte a documentação do Trivy para o método oficial na sua distro.

#### Build das 3 imagens

Na raiz do projeto:

docker build -f Dockerfile.standard   -t imagem-01:standard   .
docker build -f Dockerfile.distroless -t imagem-02:distroless .
docker build -f Dockerfile.wolfi      -t imagem-03:wolfi      .

Ou tudo em sequência:

docker build -f Dockerfile.standard   -t imagem-01:standard   . && \
docker build -f Dockerfile.distroless -t imagem-02:distroless . && \
docker build -f Dockerfile.wolfi      -t imagem-03:wolfi      .

#### Executar a aplicação

Exemplo com a imagem standard:

docker run --rm -p 8080:8080 imagem-01:standard

Acesse:
- http://localhost:8080

#### Scan de vulnerabilidades com Trivy

Scan simples:

trivy image imagem-01:standard
trivy image imagem-02:distroless
trivy image imagem-03:wolfi

Apenas HIGH e CRITICAL:

trivy image --scanners vuln --severity HIGH,CRITICAL imagem-01:standard
trivy image --scanners vuln --severity HIGH,CRITICAL imagem-02:distroless
trivy image --scanners vuln --severity HIGH,CRITICAL imagem-03:wolfi

#### Resumo estilo “docker scout quickview” (via Trivy)

Rodar:

chmod +x scout-style.sh
./scout-style.sh

#### Observações importantes

- Imagens “static” podem não ter pacotes de SO; isso muda como alguns números aparecem.
- Mesmo com base “zero CVE”, o binário/app pode carregar vulnerabilidades do runtime/stdlib dependendo da versão usada no build.

#### Troubleshooting

- Erro `unknown instruction: EOF`:
  - Remova a linha `EOF` colada acidentalmente dentro do Dockerfile.
