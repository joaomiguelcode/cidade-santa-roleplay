# Cidade Santa Roleplay

Servidor FiveM Roleplay - Base Cidade Santa.

## Requisitos

- [FXServer Artifacts](https://runtime.fivem.net/artifacts/fivem/build_server_windows/master/)
- MySQL / MariaDB (ex: XAMPP, HeidiSQL)

## Instalação e Configuração

1. Baixe os artefatos mais recentes do FXServer e coloque na pasta `artifacts/`.
2. Importe o banco de dados `database.sql` no seu MySQL/MariaDB.
3. Abra o arquivo `server.cfg` e configure suas credenciais:
   - `mysql_connection_string`: dados de conexão do seu banco de dados
   - `sv_licenseKey`: sua chave do [Cfx.re Keymaster](https://portal.cfx.re/)
   - `steam_webApiKey`: sua chave de API da [Steam](https://steamcommunity.com/dev/apikey)
   - `sv_tebexSecret`: chave secreta da sua loja Tebex (se aplicável)
4. Execute o `start.bat` para iniciar o servidor.
