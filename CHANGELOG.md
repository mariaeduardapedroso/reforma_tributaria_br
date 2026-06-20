# Changelog

Todas as mudanças notáveis desta gem são documentadas aqui.
O formato segue [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/)
e o versionamento segue [SemVer](https://semver.org/lang/pt-BR/).

## [0.1.0] - 2026-06-20

### Adicionado
- Módulo `ReformaTributariaBr::Cnpj`: validação, cálculo de dígito verificador,
  normalização, formatação e geração de CNPJ alfanumérico (módulo 11 com
  conversão ASCII−48). Retrocompatível com o CNPJ numérico atual.
- Módulo `ReformaTributariaBr::Tributos`: cálculo configurável de CBS, IBS e IS.
- Configuração global de alíquotas via `ReformaTributariaBr.configure`.
- Integração opcional com Rails: validador `validates :campo, cnpj: true`
  (`ActiveModel::EachValidator`) + Railtie, carregados automaticamente quando o
  Rails está presente.
